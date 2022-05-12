//
//  TemEmpInfoVC.swift
//  PinPle
//
//  Created by WRY_010 on 15/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TemEmpInfoVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var textEName: UITextField!
    @IBOutlet weak var textJoinDt: UITextField!
    @IBOutlet weak var textAnl: UITextField!
    @IBOutlet weak var textUseAnlDay: UITextField!
    @IBOutlet weak var textUseAnlHour: UITextField!
    @IBOutlet weak var textAddAnlDay: UITextField!
    @IBOutlet weak var textAddAnlHour: UITextField!
    @IBOutlet weak var textSpot: UITextField!
    @IBOutlet weak var textPhone: UITextField!
    @IBOutlet weak var textExtNember: UITextField!
    @IBOutlet weak var textTem: UITextField!
    @IBOutlet weak var btnExt: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lblMemo: UILabel!
    
    @IBOutlet weak var vwLine2: UIView!
    @IBOutlet weak var vwLine3: UIView!
    @IBOutlet weak var vwLine4: UIView!
    @IBOutlet weak var vwLine5: UIView!
    @IBOutlet weak var vwLine7: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let device = DeviceInfo()
    let jsonClass = JsonClass()
    var dateFormatter = DateFormatter()
    var dateFormatter2 = DateFormatter()
    let useAnlPicker = UIPickerView()
    let addAnlPicker = UIPickerView()
    
    var EmpInfoList: EmpInfoList!
    
    
    var inputDate = ""
    var showDate = ""
    
    var temflag = false
    var temsid = 0
    var ttmsid = 0
    
    var dayTemp1 = 0
    var dayTemp2 = 0
    var hourTmep1 = 0
    var hourTmep2 = 0
    var minTemp1 = 0
    var minTemp2 = 0
    
    var pickerDay: [String] = []
    var pickerHour: [String] = []
    
    var btnflag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.layer.cornerRadius = 6
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textUseAnlDay.inputView = useAnlPicker
        textUseAnlHour.inputView = useAnlPicker
        textAddAnlDay.inputView = addAnlPicker
        textAddAnlHour.inputView = addAnlPicker
        useAnlPicker.delegate = self
        addAnlPicker.delegate = self
        
        textEName.delegate = self
        textJoinDt.delegate = self
        textUseAnlDay.delegate = self
        textUseAnlHour.delegate = self
        textAddAnlDay.delegate = self
        textAddAnlHour.delegate = self
        textSpot.delegate = self
        textPhone.delegate = self
        textExtNember.delegate = self
        textTem.delegate = self
        
        addToolBar(textFields: [textJoinDt, textUseAnlDay, textAddAnlDay, textSpot, textExtNember])
        addToolBar(textFields: [textJoinDt, textUseAnlHour, textAddAnlHour, textSpot, textExtNember])
        
        textEName.isEnabled = false
        textTem.isEnabled = false
        textPhone.isEnabled = false
        
        textView.delegate = self
        addToolBar(textView: textView)
        textView.layer.cornerRadius = 6
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.init(hexString: "#DADADA").cgColor
        
        pickerLabel(useAnlPicker)
        pickerLabel(addAnlPicker)
        
        for i in 0...99 {
            if i < 10 {
                pickerDay.append("0" + String(i))
            }else {
                pickerDay.append(String(i))
            }
        }
        for j in 0...7 {
            pickerHour.append("0" + String(j))
        }
        let name = SelEmpInfo.name
        let spot = SelEmpInfo.spot
        
        var nameStr = name
        if spot != "" {
            nameStr += "(" + spot + ")"
        }
        lblNavigationTitle.text = nameStr
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if btnflag {
            textTem.text = ""
            btnExt.isHidden = true
        }
        valueSetting()
        countAnl()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidDisappear(animated)
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpCmtList") as! TemEmpCmtList
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    func pickerLabel(_ picker: UIPickerView) {
        var x: CGFloat!
        let device = deviceHeight()
        switch device {
        case 2, 4:
            x = picker.bounds.width - 10
        case 3:
            x = picker.bounds.width + 15
        default:
            x = picker.bounds.width - 10 // 그외 기종에서 앱 종료 현상이 발생하여 추가
        }
        let lblDay = UILabel(frame: CGRect(x: 0,y: 0, width: 10,height: 10))
        lblDay.font = UIFont(name: "Helvetica Neue", size: 23)
        lblDay.text = "일"
        lblDay.sizeToFit()
        lblDay.frame = CGRect(x: picker.bounds.width / 3 + lblDay.bounds.width,
                              y: picker.bounds.height / 2 - (lblDay.bounds.height / 2),
                              width: lblDay.bounds.width,
                              height: lblDay.bounds.height)
        picker.addSubview(lblDay)
        
        let lblHour = UILabel(frame: CGRect(x: 0,y: 0, width: 10,height: 10))
        lblHour.font = UIFont(name: "Helvetica Neue", size: 23)
        lblHour.text = "시간"
        lblHour.sizeToFit()
        lblHour.frame = CGRect(x: x,
                               y: picker.bounds.height / 2 - (lblHour.bounds.height / 2),
                               width: lblHour.bounds.width,
                               height: lblHour.bounds.height)
        picker.addSubview(lblHour)
    }
    func countAnl() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(입사일기준 연차계산 - 분단위 환산)
         Return  - 연차(분단위환산 - 하루 8시간)
         Parameter
         JOINDT        입사일자(형식 : 2018-05-05).. URL 인코딩
         get_anualmin
         */
        let joindt = textJoinDt.text!.replacingOccurrences(of: ".", with: "-").urlEncoding()
        NetworkManager.shared().GetAnualmin(joindt: joindt) { (isSuccess, resultCode) in
            if (isSuccess) {
                if resultCode >= 0 {
                    self.textAnl.text = String(resultCode / (8*60))
                }else {
                    self.toast("잠시 후, 다시 시도해 주세요.")
                }
            }else {
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(직원 정보)
         Return  - 직원 정보
         Parameter
         EMPSID        직원번호
         */
        NetworkManager.shared().GetEmpInfo(empsid: SelEmpInfo.sid) { (isSucces, resData) in
            if (isSucces) {
                guard let serverData = resData else { return }
                self.EmpInfoList = serverData
                if serverData.enname == "" {
                    self.textEName.text = "없음"
                }else {
                     self.textEName.text = self.EmpInfoList.enname
                }
               
                self.textJoinDt.text = self.EmpInfoList.joindt.replacingOccurrences(of: "-", with: ".")
                self.countAnl()
                self.dayTemp1 = Int(self.timeStr(self.EmpInfoList.usemin)[0])!
                self.hourTmep1 = Int(self.timeStr(self.EmpInfoList.usemin)[1])!
                self.minTemp1 = self.minSave(self.EmpInfoList.usemin)
                
                self.dayTemp2 = Int(self.timeStr(self.EmpInfoList.addmin)[0])!
                self.hourTmep2 = Int(self.timeStr(self.EmpInfoList.addmin)[1])!
                self.minTemp2 = self.minSave(self.EmpInfoList.addmin)
                
                self.useAnlPicker.selectRow(self.dayTemp1, inComponent: 0, animated: false)
                self.useAnlPicker.selectRow(self.hourTmep1, inComponent: 1, animated: false)
                
                self.addAnlPicker.selectRow(self.dayTemp2, inComponent: 0, animated: false)
                self.addAnlPicker.selectRow(self.hourTmep2, inComponent: 1, animated: false)
                
                self.textUseAnlDay.text = self.timeStr(self.EmpInfoList.usemin)[0]
                self.textUseAnlHour.text = self.timeStr(self.EmpInfoList.usemin)[1]
                self.textAddAnlDay.text = self.timeStr(self.EmpInfoList.addmin)[0]
                self.textAddAnlHour.text = self.timeStr(self.EmpInfoList.addmin)[1]
                
                self.textSpot.text = self.EmpInfoList.spot
                self.textPhone.text = self.EmpInfoList.phonenum
                self.textExtNember.text = self.EmpInfoList.phone
                self.textTem.text = self.EmpInfoList.tname
                
                if self.EmpInfoList.memo == "" {
                    self.lblMemo.isHidden = false
                }else {
                    self.lblMemo.isHidden = true
                    self.textView.text = self.EmpInfoList.memo
                }
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    @IBAction func popUseAnlShow(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpInfoUsePopUp") as! TemEmpInfoPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func popAddAnlShow(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpInfoAddPopUp") as! TemEmpInfoPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(직원정보 수정)
         Return  - 성공:1, 실패:0
         Parameter
         EMPSID        직원번호
         SPOT        직급(직책).. URL 인코딩 ..변경 안한경우 기존정보 그대로 전달
         PN            전화번호... URL 인코딩 ..변경 안한경우 기존정보 그대로 전달
         MM            메모.. URL 인코딩 ..변경 안한경우 기존정보 그대로 전달
         JNDT        입사일(형식 : 2018-05-05).. URL 인코딩 ..변경 안한경우 기존정보 그대로 전달
         USE            사용한 연차(분환산 - 1일 8시간) 2일 4시간 = (2*8*60) + (4*60) = 1200 ..변경 안한경우 기존정보 그대로 전달
         ADD            추가된 연차(분환산 - 1일 8시간) 2일 4시간 = (2*8*60) + (4*60) = 1200 ..변경 안한경우 기존정보 그대로 전달
         */
        let spot = httpRequest.urlEncode(textSpot.text!)
        let phone = httpRequest.urlEncode(textExtNember.text!)
        let memo = httpRequest.urlEncode(textView.text!)
        let joindt = httpRequest.urlEncode(textJoinDt.text!)
        let usemin = strTime(dayTemp1, hourTmep1, minTemp1)
        let addmin = strTime(dayTemp2, hourTmep2, minTemp2)
        
        if textJoinDt.text != "" {
            NetworkManager.shared().UdtEmpinfo(empsid: SelEmpInfo.sid, spot: spot, phone: phone, memo: memo, joindt: joindt, usemin: usemin, addmin: addmin) { (isSucces, resultCode) in
                if (isSucces) {
                    if resultCode == 1 {
                        self.toast("정상 처리 되었습니다.")
                        let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpCmtList") as! TemEmpCmtList
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    }else {
                        self.customAlertView("잠시 후, 다시 시도해 주세요.")
                    }
                }else {
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
        }else {
            self.customAlertView("입사일은 필수 입력입니다.")
        }
    }
    
    @IBAction func exceptEmp(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpInfoTrmPopUp") as! TemEmpInfoTrmPopUp
        vc.EmpInfoList = EmpInfoList
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func datePicker(_ sender: UITextField) {
        inputDate = textJoinDt.text!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let goDatePickerView = UIDatePicker()
        goDatePickerView.datePickerMode = UIDatePicker.Mode.date
        goDatePickerView.locale = Locale(identifier: "ko_kr")
        if #available(iOS 13.4, *) {
            goDatePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        sender.inputView = goDatePickerView
        
        if inputDate != "" {
            let date = dateFormatter.date(from: inputDate)
            goDatePickerView.date = date!
        }       
        
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        textJoinDt.becomeFirstResponder()
        
    }
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        dateFormatter2.dateFormat = "yyyy.MM.dd"
        showDate = dateFormatter2.string(from: sender.date)
        inputDate = dateFormatter.string(from: sender.date)
        if showDate == "" {
            showDate = dateFormatter2.string(from: Date())
        }
        
        textJoinDt.text = showDate
        countAnl()
        
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    
    @IBAction func rtrPrc(_ sender: UIBarButtonItem) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "TemRtrPrcVC") as! TemRtrPrcVC
        vc.empsid = EmpInfoList.empsid
        vc.joindt = EmpInfoList.joindt
        vc.temname = EmpInfoList.tname
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}

extension TemEmpInfoVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case textJoinDt:
            vwLine2.backgroundColor = UIColor.init(hexString: "#043856");
        case textUseAnlHour, textUseAnlDay:
            vwLine3.backgroundColor = UIColor.init(hexString: "#043856");
        case textAddAnlHour, textAddAnlDay:
            vwLine4.backgroundColor = UIColor.init(hexString: "#043856");
        case textSpot:
            vwLine5.backgroundColor = UIColor.init(hexString: "#043856");
        case textExtNember:
            vwLine7.backgroundColor = UIColor.init(hexString: "#043856");
        default:
            break;
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case textJoinDt:
            vwLine2.backgroundColor = UIColor.init(hexString: "#DADADA");
        case textUseAnlHour, textUseAnlDay:
            vwLine3.backgroundColor = UIColor.init(hexString: "#DADADA");
        case textAddAnlHour, textAddAnlDay:
            vwLine4.backgroundColor = UIColor.init(hexString: "#DADADA");
        case textSpot:
            vwLine5.backgroundColor = UIColor.init(hexString: "#DADADA");
        case textExtNember:
            vwLine7.backgroundColor = UIColor.init(hexString: "#DADADA");
        default:
            break;
        }
    }
    
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        print(textField)
    //
    //        if textField == textJoinDt {
    //            textField.resignFirstResponder()
    //            textUseAnlDay.becomeFirstResponder()
    //        } else if textField == textUseAnlDay {
    //            textField.resignFirstResponder()
    //            textAddAnlDay.becomeFirstResponder()
    //        } else if textField == textAddAnlDay {
    //            textField.resignFirstResponder()
    //            textSpot.becomeFirstResponder()
    //        }else  if textField == textSpot {
    //            textField.resignFirstResponder()
    //            textExtNember.becomeFirstResponder()
    //        } else if textField == textExtNember {
    //            textField.resignFirstResponder()
    //            textField.becomeFirstResponder()
    //        }else if textField == textField {
    //            textField.resignFirstResponder()
    //        }
    //        return true
    //    }
    
}
extension TemEmpInfoVC: UITextViewDelegate {
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
        print("textView.text.count = ", textView.text.count)
        if textView.text.count > 100 {
            //            textView.text.removeLast()
            //            let alert = UIAlertController(title: "알림", message: "팀(부서)에 대한 설명은 100자 이내로 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            //            let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
            //            alert.addAction(okAction)
            //            self.present(alert, animated: false, completion: nil)
            self.customAlertView("팀(부서)에 대한 설명은 \n 100자 이내로 입력하세요.")
        }
        if(text == "\n") {
            view.endEditing(true)
            return false
        }else {
            return true
        }
    }
    
}
extension TemEmpInfoVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return pickerDay.count
        }
        return pickerHour.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return pickerDay[row]
        }
        return pickerHour[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == useAnlPicker {
            if component == 0 {
                dayTemp1 = row
                textUseAnlDay.text = pickerDay[row]
            }else {
                hourTmep1 = row
                textUseAnlHour.text = pickerHour[row]
            }
        }else {
            if component == 0 {
                dayTemp2 = row
                textAddAnlDay.text = pickerDay[row]
            }else {
                hourTmep2 = row
                textAddAnlHour.text = pickerHour[row]
            }
        }
        
        
    }
}
