//
//  CmtAnualAddVC.swift
//  WooriyoER
//
//  Created by design on 2022/07/07.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit

class CmtAnualAddVC: UIViewController {

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
    @IBOutlet weak var btnAddSmall: UIButton!
    @IBOutlet weak var saveButtonView: UIView!
    
    @IBOutlet weak var textUseAnlHour: UITextField!
    @IBOutlet weak var textUseAnlMin: UITextField!
    
    @IBOutlet weak var lblType: UILabel!
    let useAnlPicker = UIPickerView()
    var hourTmep1 = 0
    var minTemp1 = 0
    var pickerHour: [String] = []
    var pickerMin: [String] = []
    var pickStart: String = ""
    var pickEnd: String = ""
    
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
    
    var oriGoDate: String = ""
    var oriLeaveDate: String = ""
    var oriGoTime: String = ""
    var oriLeaveTime: String = ""
    var starttm: String = ""
    var endtm: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnAdd)
        EnterpriseColor.nonLblBtn(btnAddSmall)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reloadAddAnual, object: nil)
        setUi()
    }
    
    // MARK: reloadTableData
    @objc func reloadTableData(_ notification: Notification) {
        lblType.text = anlTuple[anlType]
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
        
        starttm = "\(startTmpArr[0]):\(startTmpArr[1])"
        endtm = "\(endTmpArr[0]):\(endTmpArr[1])"
        
        textUseAnlHour.inputView = useAnlPicker
        textUseAnlMin.inputView = useAnlPicker
        pickerLabel(useAnlPicker)
        useAnlPicker.delegate = self
        for j in 0...1000 {
            if j < 10 {
                pickerHour.append("0" + String(j))
            }else{
                pickerHour.append(String(j))
            }
            
        }
        for m in 0...59 {
            if m < 10 {
                pickerMin.append("0" + String(m))
            }else {
                pickerMin.append(String(m))
            }
        }
        
        calc()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblType.text = anlTuple[anlType]
    }
    
    func pickerLabel(_ picker: UIPickerView) {
        var x: CGFloat!
        let device = deviceHeight()
        switch device {
        case 2, 4:
            x = picker.bounds.width - 10 //x 375
        case 3, 5:
            x = picker.bounds.width + 20 //max 414
        default:
            x = picker.bounds.width - 10 // 그외 기종에서 앱 종료 현상이 발생하여 추가
        }
        
        let lblHour = UILabel(frame: CGRect(x: 0,y: 0, width: 10,height: 10))
        lblHour.font = UIFont(name: "Helvetica Neue", size: 23)
        lblHour.text = "시간"
        lblHour.sizeToFit()
        switch device {
        case 2, 4 :
            lblHour.frame = CGRect(x: picker.bounds.width / 2 + 50,
                                   y: picker.bounds.height / 2 - (lblHour.bounds.height / 2),
                                   width: lblHour.bounds.width,
                                   height: lblHour.bounds.height)
            picker.addSubview(lblHour)
            
            let lblMin = UILabel(frame: CGRect(x: 0,y: 0, width: 10,height: 10))
            lblMin.font = UIFont(name: "Helvetica Neue", size: 23)
            lblMin.text = "분"
            lblMin.sizeToFit()
            lblMin.frame = CGRect(x: picker.bounds.width + 20,
                                  y: picker.bounds.height / 2 - (lblHour.bounds.height / 2),
                                  width: lblHour.bounds.width,
                                  height: lblHour.bounds.height)
            picker.addSubview(lblMin)
            
        case 3,5:
            lblHour.frame = CGRect(x: picker.bounds.width / 2 + 70,
                                   y: picker.bounds.height / 2 - (lblHour.bounds.height / 2),
                                   width: lblHour.bounds.width,
                                   height: lblHour.bounds.height)
            picker.addSubview(lblHour)
            
            let lblMin = UILabel(frame: CGRect(x: 0,y: 0, width: 10,height: 10))
            lblMin.font = UIFont(name: "Helvetica Neue", size: 23)
            lblMin.text = "분"
            lblMin.sizeToFit()
            lblMin.frame = CGRect(x: picker.bounds.width + 50,
                                  y: picker.bounds.height / 2 - (lblHour.bounds.height / 2),
                                  width: lblHour.bounds.width,
                                  height: lblHour.bounds.height)
            picker.addSubview(lblMin)
        default :
            lblHour.frame = CGRect(x: picker.bounds.width / 2 + 50,
                                   y: picker.bounds.height / 2 - (lblHour.bounds.height / 2),
                                   width: lblHour.bounds.width,
                                   height: lblHour.bounds.height)
            picker.addSubview(lblHour)
            
            let lblMin = UILabel(frame: CGRect(x: 0,y: 0, width: 10,height: 10))
            lblMin.font = UIFont(name: "Helvetica Neue", size: 23)
            lblMin.text = "분"
            lblMin.sizeToFit()
            lblMin.frame = CGRect(x: picker.bounds.width + 20,
                                  y: picker.bounds.height / 2 - (lblHour.bounds.height / 2),
                                  width: lblHour.bounds.width,
                                  height: lblHour.bounds.height)
            picker.addSubview(lblMin)
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
        
        let sdt = startDt.replacingOccurrences(of: ".", with: "-") + " " + startTm.replacingOccurrences(of: ".", with: "-")
        let edt = endDt.replacingOccurrences(of: ".", with: "-") + " " + endTm.replacingOccurrences(of: ".", with: "-")
        let memo = textMemo.text ?? ""
        
        print("\n---------- [ seltype : \(seltype) ] ----------\n")
        
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
        
        NetworkManager.shared().Ins_cmtmgrNew(empsid: selempsid, sdt: sdt.urlEncoding(), edt: edt.urlEncoding() , memo: memo.urlEncoding(), ntype: anlType , usemin: nWorkMin) { (isSuccess, resCode) in
            if(isSuccess){
                DispatchQueue.main.async {
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
                }

            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    
    @IBAction func btnSelectedType(_ sender: UIButton) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "AnlAprPopUp") as! AnlAprPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
     }
}

extension CmtAnualAddVC {
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
        calc()
    }
    
    fileprivate func calc(){
        oriGoDate = lblStartDate.text  ?? ""
        oriLeaveDate = textEndDate.text ?? ""
        oriGoTime = textStartTime.text ?? ""
        oriLeaveTime = txtEndTime.text ?? ""
        
        let nTmpWorkMin = getDiffNew(oriGoDate, oriLeaveDate, oriGoTime, oriLeaveTime)
        
        print("\n---------- [ nTmpWorkMin : \(nTmpWorkMin) ] ----------\n")

        let calUsemin = getMinTohmNew(nTmpWorkMin)
        if calUsemin.1 == 0 {
            textUseAnlHour.text = "\(calUsemin.0)"
            textUseAnlMin.text = "00"
        }else{
            if calUsemin.1 < 10 {
                textUseAnlHour.text = "\(calUsemin.0)"
                textUseAnlMin.text = "0\(calUsemin.1)"
            }else{
                textUseAnlHour.text = "\(calUsemin.0)"
                textUseAnlMin.text = "\(calUsemin.1)"
            }
        }
    }
 
}


// MARK: - UITextViewDelegate
extension CmtAnualAddVC: UITextViewDelegate {
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


// MARK: - UIPickerViewDelegate
extension CmtAnualAddVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return pickerHour.count
        }else{
            return pickerMin.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return pickerHour[row]
        }else{
            return pickerMin[row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let str = textUseAnlHour.text ?? ""
        if component == 0 {
            hourTmep1 = row
            
            textUseAnlHour.text = pickerHour[row]
        }else {
            minTemp1 = row
            textUseAnlMin.text =  pickerMin[row]
        }
        
    }
}
