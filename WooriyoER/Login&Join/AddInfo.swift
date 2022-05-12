//
//  AddInfo.swift
//  PinPle
//
//  Created by WRY_010 on 2019/12/10.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AddInfo: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblBirth: UILabel!
    @IBOutlet weak var textEnname: UITextField!
    @IBOutlet weak var textBcem: UITextField!
    @IBOutlet weak var textEmpNum: UITextField!
    
    @IBOutlet weak var textBirth: UITextField!
    @IBOutlet weak var btnLunar: UIButton!
    @IBOutlet weak var btnMan: UIButton!
    @IBOutlet weak var btnWoman: UIButton!
    
    @IBOutlet weak var vwLine0: UIView!
    @IBOutlet weak var vwLine1: UIView!
    @IBOutlet weak var vwLine2: UIView!
    @IBOutlet weak var vwLine3: UIView!
    
    @IBOutlet weak var lblEnname: UILabel!
    @IBOutlet weak var lblBcem: UILabel!
    @IBOutlet weak var lblEmpNum: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnNext: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var dateFormatter = DateFormatter()
    var textDateFormatter = DateFormatter()
    
    var profileImg = UIImage(named: "logo_pre")!
    var flag = false
    var fontSize: CGFloat = 0.0
    
    var loginType = ""
    var email: String = ""//앱에 저장된 email(id)
    var pass: String = "" //앱에 저장된 pass
    
    var gender: Int = 1
    var birth: String = ""
    var lunar: Int = 0
    
    var showDate: String = ""
    var inputDate: String = ""
    var ori_birth: String = ""
    
    // MARK: - IndicatorSetting
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    fileprivate func IndicatorSetting() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        prefs.setValue(2, forKey: "stage")
        btnNext.layer.cornerRadius = 6
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
                
//        lblBirth.isHidden = true
        lblEnname.isHidden = true
        lblBcem.isHidden = true
        lblEmpNum.isHidden = true
        
//        textBirth.delegate = self
        textEnname.delegate = self
        textBcem.delegate = self
        textEmpNum.delegate = self
        
        textEnname.keyboardType = .default
        textBcem.keyboardType = .emailAddress
        textEmpNum.keyboardType = .phonePad
        
//        btnMan.setImage(checkImg, for: .selected)
//        btnMan.setImage(uncheckImg, for: .normal)
//        btnWoman.setImage(checkImg, for: .selected)
//        btnWoman.setImage(uncheckImg, for: .normal)
//        btnLunar.setImage(checkImg, for: .selected)
//        btnLunar.setImage(uncheckImg, for: .normal)
        
        imgProfile.makeRounded()
        addToolBar(textFields: [textEnname, textBcem, textEmpNum])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        lblName.text = userInfo.name
        lblEmail.text = userInfo.email
        textEnname.text = userInfo.enname
        textBcem.text = userInfo.bcemail
        textEmpNum.text = userInfo.empnum
        birth = userInfo.birth
//        inputDate = userInfo.birth
        inputDate = "1900-01-01"
        gender = userInfo.gender
        lunar = userInfo.lunar
        
//        if birth == "1900-01-01" {
//            textBirth.text = ""
//        }else {
//            textBirth.text = birth.replacingOccurrences(of: "-", with: ".")
//        }
        
//        if textBirth.text != "" {
//            lblBirth.isHidden = false
//        }
        if textEnname.text != "" {
            lblEnname.isHidden = false
        }
        if textBcem.text != "" {
            lblBcem.isHidden = false
        }
        if textEmpNum.text != "" {
            lblEmpNum.isHidden = false
        }
        
//        if gender == 0 {
//            btnMan.isSelected = true
//            btnWoman.isSelected = false
//        }else {
//            btnMan.isSelected = false
//            btnWoman.isSelected = true
//        }
        
//        if lunar == 0 {
//            btnLunar.isSelected = false
//        }else {
//            btnLunar.isSelected = true
//        }
        
        if userInfo.profimg != "" {
            if userInfo.profimg.urlTrim() != "img_photo_default.png" {
                profileImg = self.urlImage(url: userInfo.profimg)
            }
        }
        imgProfile.image = profileImg
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidDisappear(animated)
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @IBAction func barBack(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelMgrEmp") as! SelMgrEmp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
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
    
    //MARK: @IBAction
    @IBAction func btnNext(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(회원 추가정보 입력)
         Parameter
         MBRSID        회원번호
         GD        성별 - 0.남성 1.여성 - 필수
         BI        생년월일 - Base64 인코딩 - 필수
         LN        생년 음양 구분 - 0.양력 1.음력 - 필수
         ENNM        영문이름 - Base64 인코딩 ..입력안한경우 안넘기거나, "" 넘김
         BCEM        명함 이메일 - Base64 인코딩 ..입력안한경우 안넘기거나, "" 넘김
         EMPNUM        사원번호 - Base64 인코딩 ..입력안한경우 안넘기거나, "" 넘김
         */
        let mbrsid = userInfo.mbrsid
//        let birth = inputDate.base64Encoding()
         
        let birth = inputDate.base64Encoding()
        let enname = textEnname.text!.base64Encoding()
        let bcem = textBcem.text!.base64Encoding()
        let empnum = textEmpNum.text!.base64Encoding()
        print("\n---------- [ birth = \(birth) ] ----------\n")
        let url: String = urlClass.set_mbr_addinfo(mbrsid: mbrsid, gender: gender, birth: birth, lunar: lunar, enname: enname, bcem: bcem, empnum: empnum)
        httpRequest.get(urlStr: url) { (success, jsonData) in
            if success {
                print(url)
                print(jsonData)
                
                userInfo.gender = self.gender
                userInfo.lunar = self.lunar
                userInfo.birth = self.inputDate
                userInfo.enname = self.textEnname.text!
                userInfo.bcemail = self.textBcem.text!
                userInfo.empnum = self.textEmpNum.text!
                
                let sb = UIStoryboard.init(name: "CmpCrt", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "CmpVC") as! CmpVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    @IBAction func profileImageClick(_ sender: UIButton) {
        userInfo.lunar = self.lunar
        userInfo.gender = self.gender
        userInfo.birth = self.inputDate
        userInfo.enname = self.textEnname.text!
        userInfo.bcemail = self.textBcem.text!
        userInfo.empnum = self.textEmpNum.text!
        
        var vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileRegVC") as! ProfileRegVC
        if SE_flag {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "SE_ProfileRegVC") as! ProfileRegVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.profileImg = profileImg
        self.present(vc, animated: false, completion: nil)
    }
    //MARK: func
    //음력 설정
    @IBAction func btn_lunar(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            lunar = 1
        }else{
            lunar = 0
        }
    }
    //성별 남자
    @IBAction func manClick(_ sender: UIButton) {
        gender = 0
        btnMan.isSelected = true
        btnWoman.isSelected = false
    }
    //성별 여자
    @IBAction func womanClick(_ sender: UIButton) {
        gender = 1
        btnMan.isSelected = false
        btnWoman.isSelected = true
    }
    //생년월일 데이트픽커
    @IBAction func datePicker(_ sender: UITextField) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let goDatePickerView = UIDatePicker()
        goDatePickerView.datePickerMode = UIDatePicker.Mode.date
        goDatePickerView.locale = Locale(identifier: "ko_kr")
        if #available(iOS 13.4, *) {
            goDatePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        let today = Date()
        let maxDate = dateFormatter.string(from: today)
        goDatePickerView.maximumDate = dateFormatter.date(from: maxDate)
        
        if sender.text != "" {
            print(sender.text!)
            goDatePickerView.date = dateFormatter.date(from: sender.text!)!
        }else {
            let base = dateFormatter.string(from: today)
            let arr = base.components(separatedBy: "-")
            goDatePickerView.date = dateFormatter.date(from: "1996-" + arr[1] + "-" + arr[2])!
            textBirth.text = "1996." + arr[1] + "." + arr[2]
        }
        
        sender.inputView = goDatePickerView
        
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        textBirth.becomeFirstResponder()
    }
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        textDateFormatter.dateFormat = "yyyy.MM.dd"
        inputDate = dateFormatter.string(from: sender.date)
        showDate = textDateFormatter.string(from: sender.date)
        textBirth.text = showDate
    }
    
}
// MARK: - extension UITextFieldDelegate
extension AddInfo: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textEnname {
            textField.resignFirstResponder()
            textBcem.becomeFirstResponder()
        }else if textField == textBcem {
            textField.resignFirstResponder()
            textEmpNum.becomeFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == textBirth {
//            lblBirth.isHidden = false
//            vwLine0.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
//        }else
        if textField == textEnname {
            lblEnname.isHidden = false
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }else if textField == textBcem {
            lblBcem.isHidden = false
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }else {
            lblEmpNum.isHidden = false
            vwLine3.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == textBirth {
//            if textField.text == "" {
//                lblBirth.isHidden = true
//            }
//            vwLine0.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
//        }else
            if textField == textEnname {
            if textField.text == "" {
                lblEnname.isHidden = true
            }else if !textField.text!.validate("enname") {
                self.customAlertView("영어만 입력 가능합니다.", textEnname)
            }
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }else if textField == textBcem {
            if textField.text == "" {
                lblBcem.isHidden = true
            }else if !textField.text!.validate("email") {
                self.customAlertView("이메일 형식에 맞게 입력하세요.", textBcem)
            }
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }else {
            if textField.text == "" {
                lblEmpNum.isHidden = true
            }
            vwLine3.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }
    }
}
