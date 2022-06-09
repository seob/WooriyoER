//
//  CmtTimeSetVC.swift
//  PinPle
//
//  Created by WRY_010 on 16/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmtTimeSetVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var textEndDate: UITextField!
    @IBOutlet weak var textStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    @IBOutlet weak var btnLongSave: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var vwBtn: UIStackView!
    @IBOutlet weak var btnShortSave: UIButton!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var lblLeave: UILabel!
    @IBOutlet weak var vwAdd: UIView!
    
    @IBOutlet weak var vwCmtHistory: CustomView!
    
    @IBOutlet weak var lblStartcmtarea: UILabel!
    @IBOutlet weak var lblEndcmtarea: UILabel!
    
    @IBOutlet weak var textMemo: UITextView! 
    @IBOutlet weak var lbltextlimit: UILabel!
    @IBOutlet weak var lblMemo: UILabel!

    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let device = DeviceInfo()
    let jsonClass = JsonClass()
    var dateFormatter = DateFormatter()
    
    var inputData = ""
    var endDate = ""
    var startTime = ""
    var endTime = ""
    
    var selsid = 0
    var selempsid = 0
    var seldt = ""
    var selstartdt = ""
    var selenddt = ""
    var seltype = 0
    
    var txtFlag = 0
    var startcmtarea = ""
    var endcmtarea = ""
    var empInfo = EmplyInfoDetailList() //직원 월별 출퇴근기록 + 연차정보(남은연차, 입사일자)
    var strMemo: String = "" //메모 2021.07.26 추가
    var keyHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnLongSave.isHidden = false;
        self.vwAdd.isHidden = false;
        self.vwBtn.isHidden = false;
        EnterpriseColor.nonLblBtn(btnLongSave)
        EnterpriseColor.nonLblBtn(btnShortSave)
        print(seltype)
        
        addToolBar(textFields: [textEndDate, textStartTime, txtEndTime])

        addToolBar(textView: textMemo)
        
        textMemo.delegate = self
        textMemo.layer.cornerRadius = 6
        textMemo.layer.borderWidth = 1
        textMemo.layer.borderColor = UIColor.init(hexString: "#EDEDF2").cgColor
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        self.addKeyboardNotifications()
    }
    
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications(){
    // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    @objc func keyboardWillShow(_ noti: NSNotification) { 
        
        let keyboardHeight = (noti.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
              self.view.window?.frame.origin.y = -1 * keyboardHeight!
              self.view.layoutIfNeeded()
            })
 
    }
    
    @objc func keyboardWillHide(_ noti: NSNotification) {
         
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
          self.view.window?.frame.origin.y = 0
          self.view.layoutIfNeeded()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
 
        valueSetting()
        if (startcmtarea == "" && endcmtarea == "" ){
            vwCmtHistory.isHidden = true
        }else{
            vwCmtHistory.isHidden = false
            lblStartcmtarea.text = "\(startcmtarea)"
            lblEndcmtarea.isHidden = true
            if endcmtarea != "" {
                lblEndcmtarea.isHidden = false
                lblEndcmtarea.text = "\(endcmtarea)"
            }
        }
        
        if strMemo != "" {
            lblMemo.isHidden = true
        }else{
            lblMemo.isHidden = false
        }
        textMemo.text = "\(strMemo)"
        let textLength = textMemo.text.count
        lbltextlimit.text = "(\(textLength)/100)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotifications()
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func valueSetting() {
        //근무타입(0.데이터 없음 1.정상출근 2.지각 3.조퇴 4.야근 5.휴일근로 6.출장 7.외출 8.연차 9.결근)
        var titleStr = "" 
        switch seltype {
        case 0:
            titleStr = "근로시간 수정"
            self.btnLongSave.isHidden = false
            self.vwAdd.isHidden = true
            self.vwBtn.isHidden = true
        case 1:
            titleStr = "근로시간 수정"
            self.btnLongSave.isHidden = true
        case 2:
            titleStr = "지각시간 수정"
            self.btnLongSave.isHidden = true
        case 3:
            titleStr = "근로시간 수정"
            self.lblWork.text = "시작"
            self.lblLeave.text = "종료"
            self.btnLongSave.isHidden = true
        case 4:
            titleStr = "근로시간 수정"
            self.lblWork.text = "시작"
            self.lblLeave.text = "종료"
            self.btnLongSave.isHidden = false
        case 5:
            titleStr = "근로시간 수정"
            self.lblWork.text = "시작"
            self.lblLeave.text = "종료"
            self.btnLongSave.isHidden = false
        case 6:
            titleStr = "근로시간 수정"
            self.lblWork.text = "시작"
            self.lblLeave.text = "종료"
            self.btnLongSave.isHidden = false
        case 7:
            titleStr = "외출시간 수정"
            self.lblWork.text = "시작"
            self.lblLeave.text = "종료"
            self.btnLongSave.isHidden = false
        case 8:
            titleStr = "연차시간 수정"
            self.lblWork.text = "시작"
            self.lblLeave.text = "종료"
            self.btnLongSave.isHidden = false
        case 9:
            titleStr = "근로시간 수정"
            self.btnLongSave.isHidden = false
        default:
           break
        }
        
        
        if selsid == 0 {
            lblStartDate.text = seldt
            textEndDate.text = seldt
            
            let startTmpArr = CompanyInfo.starttm.components(separatedBy: ":")
            let endTmpArr = CompanyInfo.endtm.components(separatedBy: ":")

            textStartTime.text = "\(startTmpArr[0]):\(startTmpArr[1])"
            txtEndTime.text = "\(endTmpArr[0]):\(endTmpArr[1])"
            
        }else {
            lblStartDate.text = selstartdt.components(separatedBy: " ")[0].replacingOccurrences(of: "-", with: ".")
            let endTmpArr = CompanyInfo.endtm.components(separatedBy: ":")
            
            if selenddt.strinTrim() == "" {
                textEndDate.text = seldt
                txtEndTime.text = "\(endTmpArr[0]):\(endTmpArr[1])"
                 
            }else{
                textEndDate.text = selenddt.components(separatedBy: " ")[0].replacingOccurrences(of: "-", with: ".")
                txtEndTime.text = selenddt.components(separatedBy: " ")[1]
            }
            
            textStartTime.text = selstartdt.components(separatedBy: " ")[1]
            
        }
 
        
        lblNavigationTitle.text = titleStr
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    
    // 근무시간 등록 & 수정
    @IBAction func btnSave(_ sender: UIButton) {
        //        var url = ""
        let sdt = httpRequest.urlEncode(lblStartDate.text!.replacingOccurrences(of: ".", with: "-") + " " + textStartTime.text!.replacingOccurrences(of: ".", with: "-"))
        let edt = httpRequest.urlEncode(textEndDate.text!.replacingOccurrences(of: ".", with: "-") + " " + txtEndTime.text!.replacingOccurrences(of: ".", with: "-"))
        
        if selsid == 0 {
            //관리자가 직원 근무기록 직접 입력 - 정상근무로 등록됨
            if textEndDate.text == "00:00" || txtEndTime.text == "00:00" {

                self.toast("출근 퇴근이 모두 입력시 수정 가능합니다.")
            }else{
                let memo = textMemo.text ?? ""
                NetworkManager.shared().Ins_cmtmgr(empsid: selempsid, sdt: sdt, edt: edt , memo: memo.urlEncoding()) { (isSuccess, resCode) in
                    if(isSuccess){
                        DispatchQueue.main.async {
                            switch resCode {
                            case -1:
                                self.customAlertView("시간이 중복 됩니다.\n 다시 확인해주세요")
                            case 0:
                                self.customAlertView("출근 퇴근이 모두 입력 시\n 수정 가능합니다.")
                            case 1:
                                self.toast("직원정보가 수정되었습니다.")
                                NotificationCenter.default.post(name: .reloadCmpEmpList, object: nil)
                                self.dismiss(animated: true, completion: nil)
                            default:
                                break;
                            }
                        }
 
                    }else{
                        self.customAlertView("다시 시도해 주세요.")
                    }
                }
            }
            
        }else{
            //관리자가 직원 근무기록 직접 수정
            /***************************************************
             출근 시간 or 퇴근 시간 하나라도 없을경우 예외처리
             ***************************************************/
            if textEndDate.text == "00:00" || txtEndTime.text == "00:00" {
                self.toast("출근 퇴근이 모두 입력시 수정 가능합니다.")
            }else{
                let memo = textMemo.text ?? ""
                NetworkManager.shared().Udt_cmtmgr(cmtsid: selsid, empsid: selempsid, sdt: sdt, edt: edt, memo: memo.urlEncoding()) { (isSuccess, resCode) in
                    if(isSuccess){
                        DispatchQueue.main.async {
                            switch resCode {
                            case -1:
                                self.customAlertView("시간이 중복 됩니다.\n 다시 확인해주세요")
                            case 0:
                                self.customAlertView("출근 퇴근이 모두 입력 시\n 수정 가능합니다.")
                            case 1:
                                self.toast("직원정보가 수정되었습니다.")
                                NotificationCenter.default.post(name: .reloadCmpEmpList, object: nil)
                                self.dismiss(animated: true, completion: nil)
                            default:
                                break;
                            }
                        }
                    }else{
                        self.customAlertView("다시 시도해 주세요.")
                    }
                }
            }
        }
        
    }
    //근로 시간 추가
    @IBAction func btnCmtAdd(_ sender: UIButton) {
        print("----------touch!!!----------")
        seltype = 0
        selsid = 0
        lblNavigationTitle.text = "근로시간 추가"
        self.btnLongSave.isHidden = false
        self.vwAdd.isHidden = true
        self.vwBtn.isHidden = true
        
        lblStartDate.text = seldt
        textEndDate.text = seldt
        
        let startTmpArr = CompanyInfo.starttm.components(separatedBy: ":")
        let endTmpArr = CompanyInfo.endtm.components(separatedBy: ":")
        
        textStartTime.text = "\(startTmpArr[0]):\(startTmpArr[1])"
        txtEndTime.text = "\(endTmpArr[0]):\(endTmpArr[1])"
    }
    
    //근무기록 삭제
    @IBAction func btnDelete(_ sender: UIButton) {
        
        if seltype == 9 {
            self.customAlertView("결근은 삭제할 수 없습니다.")
        }else {
            // 관리자가 직원 근무기록 직접 삭제.. Type 9.결근은 삭제불가..앱에서 막아야됨
            NetworkManager.shared().Del_cmtmgr(cmtsid: selsid, empsid: selempsid) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode > 0 {
                        self.toast("정상적으로 삭제되었습니다.")
                        NotificationCenter.default.post(name: .reloadCmpEmpList, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.customAlertView("정상적으로 삭제되지 않았습니다.")
                    }
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
        }
        
        
    }
    
    @IBAction func datePicker(_ sender: UITextField) {
        let goDatePickerView = UIDatePicker()
        if #available(iOS 13.4, *) {
            goDatePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        var loc: Locale?
        
        endDate = textEndDate.text!
        startTime = textStartTime.text!
        endTime = txtEndTime.text!
        
        if sender == textEndDate {
            print("txtEndDate")
            goDatePickerView.datePickerMode = UIDatePicker.Mode.date
            dateFormatter.dateFormat = "yyyy-MM-dd"
            loc = Locale(identifier: "ko_kr")
            inputData = endDate.replacingOccurrences(of: "-", with: ".")
            txtFlag = 0
        }else if sender == textStartTime {
            print("txtStartTime")
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            //            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = startTime
            txtFlag = 1
        }else if sender == txtEndTime {
            print("txtEndTime")
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            //            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = endTime
            txtFlag = 2
        }
        
        goDatePickerView.locale = loc
        
        sender.inputView = goDatePickerView
        
        print("inputData = ", inputData)
        if inputData != "" {
            let date = dateFormatter.date(from: inputData)
            goDatePickerView.date = date!
        }
        if txtFlag == 0 {
            let timeInterval: TimeInterval = 24*60*60
            goDatePickerView.minimumDate = dateFormatter.date(from: lblStartDate.text!)
            goDatePickerView.maximumDate = NSDate(timeInterval: timeInterval, since: dateFormatter.date(from: lblStartDate.text!)!) as Date
        }else if txtFlag == 2 && lblStartDate.text == textEndDate.text {
            goDatePickerView.minimumDate = dateFormatter.date(from: startTime)
        }
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        switch txtFlag {
        case 0:
            self.textEndDate.becomeFirstResponder();
        case 1:
            self.textStartTime.becomeFirstResponder();
        case 2:
            self.txtEndTime.becomeFirstResponder();
        default:
            break;
        }
    }
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        switch txtFlag {
        case 0:
            self.endDate = dateFormatter.string(from: sender.date);
            self.textEndDate.text = self.endDate.replacingOccurrences(of: "-", with: ".");
            self.txtEndTime.text = "00:00"
        case 1:
            self.startTime = dateFormatter.string(from: sender.date);
            self.textStartTime.text = self.startTime;
        case 2:
            self.endTime = dateFormatter.string(from: sender.date);            
            self.txtEndTime.text = self.endTime;
        default:
            break;
        }
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
     }
}


// MARK: - UITextViewDelegate
extension CmtTimeSetVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        lblMemo.isHidden = true
        textView.layer.borderColor = UIColor.init(hexString: "#043856").cgColor
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            lblMemo.isHidden = false
        }
        textView.layer.borderColor = UIColor.init(hexString: "#DADADA").cgColor
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textLength = textView.text.count
        lbltextlimit.text = "(\(textLength)/100)"
        if textView.text.count > 99 {
            textView.text.removeLast()
            let alert = UIAlertController(title: "알림", message: "메모는 100자 이내로 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: false, completion: nil)
        }
        if(text == "\n") {
            view.endEditing(true)
            return false
        }else {
            return true
        }
    }
    
}
