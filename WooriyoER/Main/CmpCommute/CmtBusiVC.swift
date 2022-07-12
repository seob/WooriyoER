//
//  CmtBusiVC.swift
//  WooriyoER
//
//  Created by design on 2022/07/07.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit

class CmtBusiVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var textEndDate: UITextField!
    @IBOutlet weak var textStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    @IBOutlet weak var vwBtn: UIStackView!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var lblLeave: UILabel!
    @IBOutlet weak var textMemo: UITextView!
    @IBOutlet weak var lbltextlimit: UILabel!
    @IBOutlet weak var lblMemo: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var saveButtonView: UIView!
    let httpRequest = HTTPRequest()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnAdd)
        setUi()
    }
    
    fileprivate func setUi(){
        addToolBar(textView: textMemo)
        
        textMemo.delegate = self
        textMemo.layer.cornerRadius = 6
        textMemo.layer.borderWidth = 1
        textMemo.layer.borderColor = UIColor.init(hexString: "#EDEDF2").cgColor
        
        lblStartDate.text = seldt
        textEndDate.text = seldt
        
        
        let startTmpArr = CompanyInfo.starttm.components(separatedBy: ":")
        let endTmpArr = CompanyInfo.endtm.components(separatedBy: ":")

        textStartTime.text = "\(startTmpArr[0]):\(startTmpArr[1])"
        txtEndTime.text = "\(endTmpArr[0]):\(endTmpArr[1])"
        
        if seltype == 6 {
            lblNavigationTitle.text = "출장시간 추가"
        }else{
            lblNavigationTitle.text = "근로시간 추가"
        }
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        let startDt = lblStartDate.text ?? ""
        let endDt = textEndDate.text ?? ""
        
        let startTm = textStartTime.text ?? ""
        let endTm = txtEndTime.text ?? ""
        
        let usemin = getDiffNew(startDt, endDt, startTm, endTm)
        
        
        if endDt == "00:00" || endTm == "00:00" {
            
            self.toast("출근 퇴근이 모두 입력시 수정 가능합니다.")
        }else{
//            let sdt = httpRequest.urlEncode(lblStartDate.text!.replacingOccurrences(of: ".", with: "-") + " " + textStartTime.text!.replacingOccurrences(of: ".", with: "-"))
//            let edt = httpRequest.urlEncode(textEndDate.text!.replacingOccurrences(of: ".", with: "-") + " " + txtEndTime.text!.replacingOccurrences(of: ".", with: "-"))
            
            var nWorkMin = 0
            if CompanyInfo.schdl == 0 {
                // 근무일정 사용하지 않은 경우
                nWorkMin = usemin
            }else{
                //근무일정 사용할 경우
                if CompanyInfo.brktime == 1 { // 휴게시간 사용 시 5시간이상일 경우 1시간 차감
                    if usemin >= 300 {
                        nWorkMin = usemin - 60
                    }else{
                        nWorkMin = usemin
                    }
                }else{ // 휴게시간 미사용 시
                    nWorkMin = usemin
                }
            }
            
             
            let sdt = startDt.replacingOccurrences(of: ".", with: "-") + " " + startTm.replacingOccurrences(of: ".", with: "-")
            let edt = endDt.replacingOccurrences(of: ".", with: "-") + " " + endTm.replacingOccurrences(of: ".", with: "-")
            
            let memo = textMemo.text ?? ""
            print("\n---------- [ sdt : \(sdt) , edt :\(edt)] ----------\n")
            NetworkManager.shared().Ins_cmtmgrNew(empsid: selempsid, sdt: sdt.urlEncoding(), edt: edt.urlEncoding() , memo: memo.urlEncoding(), ntype: seltype, usemin: nWorkMin) { (isSuccess, resCode) in
                DispatchQueue.main.async {
                    if(isSuccess){
                        switch resCode {
                        case -1:
                            self.customAlertView("시간이 중복 됩니다.\n 다시 확인해주세요")
                        case 0:
                            self.customAlertView("출근 퇴근이 모두 입력 시\n 수정 가능합니다.")
                        case 1:
                            self.toast("등록되었습니다.")
                            NotificationCenter.default.post(name: .reloadCmpEmpList, object: nil)
                            var vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpCmtList") as! EmpCmtList
                            if SE_flag {
                                vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_EmpCmtList") as! EmpCmtList
                            }else{
                                vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpCmtList") as! EmpCmtList
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overCurrentContext
                            self.present(vc, animated: true, completion: nil)
                        default:
                            break;
                        }
                        
                    }else{
                        self.customAlertView("다시 시도해 주세요.")
                    }
                }
            }
        }
    }
    
}


extension CmtBusiVC {
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
    
}


// MARK: - UITextViewDelegate
extension CmtBusiVC: UITextViewDelegate {
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
