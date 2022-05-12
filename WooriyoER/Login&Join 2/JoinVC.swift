//
//  joinViewController.swift
//  PinPle
//
//  Created by WRY_010 on 12/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit


class JoinVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPass: UITextField!
    @IBOutlet weak var textPassCk: UITextField!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textBirth: UITextField!
    @IBOutlet weak var textPhone: UITextField!
    @IBOutlet weak var btnLunar: UIButton!
    @IBOutlet weak var btnMan: UIButton!
    @IBOutlet weak var btnWoman: UIButton!
    @IBOutlet weak var signScrollView: UIScrollView!
    
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    let device = DeviceInfo()
    
    let prefs = UserDefaults.standard
    var dateFormatter = DateFormatter()
    var textDateFormatter = DateFormatter()
    
    var showDate = ""
    var inputDate = ""
    var ori_birth = ""
    
    var email: String = ""
    var pass: String = ""
    var name: String = ""
    var gender: Int = 0
    var birth: String = ""
    var lunar: Int = 0
    var phone: String = ""
    var osvs: String = ""
    var appvs: String = ""
    var md : String = ""
    
    var genderFlag: Int = 0
    var lunarFlag: Int = 0
    
    var keyboardHeight: CGFloat?
    var selTextField: UITextField?
    
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        osvs = device.OSVS
        appvs = device.APPVS
        md = device.MD
        
        textEmail.delegate = self
        textName.delegate = self
        textPassCk.delegate = self
        textPass.delegate = self
        textPhone.delegate = self
        textBirth.delegate = self
        
        btnMan.setImage(UIImage(named: "er_checkbox"), for: .selected)
        btnMan.setImage(UIImage(named: "icon_nonecheck"), for: .normal)
        btnWoman.setImage(UIImage(named: "er_checkbox"), for: .selected)
        btnWoman.setImage(UIImage(named: "icon_nonecheck"), for: .normal)
        btnLunar.setImage(UIImage(named: "er_checkbox"), for: .selected)
        btnLunar.setImage(UIImage(named: "icon_nonecheck"), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //화면 터치시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: @IBAction
    @IBAction func emailCheck(_ sender: UIButton) {
        /*
         2019-10-29
         Pinpl Android SmartPhone APP으로부터 요청받은 데이터 처리(이메일 중복확인)
         Return  - 0:중복없음 1.중복  2.구글로그인계정  3.네이버로그인계정  4.카카오로그인계정
         Parameter
         EM        이메일 - Base64 인코딩
         */
        var flag = true
        if textEmail.text! == "" {
            alertView("이메일을 입력해 주세요.", textEmail)
            flag = false
        }else if !textEmail.text!.validate("email") {
            alertView("이메일 형식이 아닙니다.\n 다시 입력해 주세요.", textEmail)
            textEmail.text = ""
            flag = false
        }
        
        if flag {
            email = ((textEmail.text!).data(using: .utf8)?.base64EncodedString())!
            let url = urlClass.check_email(email: email)
            let jsonTemp: Data = jsonClass.weather_request(setUrl: url)!
            if let jsonData:NSDictionary = jsonClass.json_parseData(jsonTemp) {
                print(url)
                print(jsonData)
                
                let result = jsonData["result"] as! Int
                switch result {
                case 0:
                    self.alertView("사용가능한 이메일입니다.", self.textName);
                case 1:
                    self.alertView("이미 가입된 이메일입니다.", self.textEmail);
                case 2:
                    self.alertView("구글가입 이메일입니다.");
                case 3:
                    self.alertView("네이버가입 이메일입니다.");
                case 4:
                    self.alertView("카카오가입 이메일입니다.");
                default:
                    break;
                }
            }
        }
    }
    //음력 설정
    @IBAction func btn_lunar(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            lunarFlag = 1
        }else{
            lunarFlag = 0
        }
        prefs.setValue(lunarFlag, forKey: "lunarFlag")
    }
    //성별 남자
    @IBAction func manClick(_ sender: UIButton) {
        genderFlag = 0
        btnMan.isSelected = true
        btnWoman.isSelected = false
        prefs.setValue(genderFlag, forKey: "genderFlag")
    }
    //성별 여자
    @IBAction func womanClick(_ sender: UIButton) {
        genderFlag = 1
        btnMan.isSelected = false
        btnWoman.isSelected = true
        prefs.setValue(genderFlag, forKey: "genderFlag")
    }
    //회원가입 버튼 클릭
    @IBAction func signClick(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(Email 회원가입)
         Return  - 정상회원가입시:회원번호, 가입실패:0, 이미가입:-1, 구글로그인계정:-2, 네이버로그인계정:-3 카카오로그인계정:-4
         Parameter
         EM        아이디(Email) - Base64 인코딩(E-mail)
         PW        비밀번호 - SHA1 암호화
         NM        이름 - Base64 인코딩
         GD        성별 - 0.남성 1.여성
         BI        생년월일 - Base64 인코딩
         LN        생년 음양 구분 - 0.양력 1.음력
         PN        핸드폰번호(11) - Base64 인코딩
         MD        단말모델 - Base64 인코딩
         OSVS    OS버전(예:17)
         APPVS    어플버전
         */
        if valueCheck() {
            email = ((textEmail.text!).data(using: .utf8)?.base64EncodedString())!
            pass = textPass.text!.sha1()
            name = ((httpRequest.urlEncode(textName.text!)).data(using: .utf8)?.base64EncodedString())!
            gender = genderFlag
            birth = ((inputDate).data(using: .utf8)?.base64EncodedString())!
            lunar = lunarFlag
            phone = ((textPhone.text!).data(using: .utf8)?.base64EncodedString())!
            
            let url: String = urlClass.reg_mbr(email: email, pass: pass, name: name, gender: gender, birth: birth, lunar: lunar, phone: phone, osvs: osvs, appvs: appvs, md: md)
            httpRequest.get(urlStr: url) { (success, jsonData) in
                if success {
                    print(url)
                    print(jsonData)
                    let result = jsonData["result"] as! Int
                    
                    switch result {
                    case 0:
                        self.alertView("가입실패");
                    case -1:
                        self.alertView("이미가입된 이메일입니다.\n 로그인화면으로 이동합니다.", self.textEmail)
                    case -2:
                        self.LoginViewMoveAlert("구글로그인계정");
                    case -3:
                        self.LoginViewMoveAlert("네이버로그인계정");
                    case -4:
                        self.LoginViewMoveAlert("카카오로그인계정");
                    default:
                        self.CmpViewMoveAlert("가입성공");
                        self.prefs.setValue(self.email, forKey: "m_email");
                        self.prefs.setValue(self.pass, forKey: "m_pass");
                        self.prefs.setValue(self.textEmail.text!, forKey: "email");
                        self.prefs.setValue(self.textName.text!, forKey: "name");
                        self.prefs.setValue(self.gender, forKey: "genderFlag");
                        self.prefs.setValue(self.showDate, forKey: "birth");
                        self.prefs.setValue(self.lunar, forKey: "lunarFlag");
                        self.prefs.setValue(self.textPhone.text!, forKey: "phone");
                        self.prefs.setValue("email", forKey: "loginType");
                        self.prefs.setValue(result, forKey: "mbrsid");
                    }
                }
            }
        }
    }
    //생년월일 데이트픽커
    @IBAction func datePicker(_ sender: UITextField) {
        dateFormatter.dateFormat = "yyyyMMdd"
        let goDatePickerView = UIDatePicker()
        goDatePickerView.datePickerMode = UIDatePicker.Mode.date
        let loc = Locale(identifier: "ko_kr")
        goDatePickerView.locale = loc
        
        let today = Date()
        let maxDate = dateFormatter.string(from: today)
        goDatePickerView.maximumDate = dateFormatter.date(from: maxDate)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "확인", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        sender.inputView = goDatePickerView
        sender.inputAccessoryView = toolBar
        
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        textBirth.becomeFirstResponder()
        
    }
    @IBAction func phoneKeyboard(_ sender: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "확인", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.phoneHidden))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        sender.inputAccessoryView = toolBar
    }
    
    //MARK: @objc
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        textDateFormatter.dateFormat = "yyyy.MM.dd"
        inputDate = dateFormatter.string(from: sender.date)
        showDate = textDateFormatter.string(from: sender.date)
        prefs.setValue(showDate, forKey: "birth")
    }
    @objc func donePicker(sender: UIBarButtonItem) {
        textBirth.text = showDate
        textBirth.resignFirstResponder()
        textPhone.becomeFirstResponder()
    }
    @objc func phoneHidden(sender: UIBarButtonItem) {
        textPhone.resignFirstResponder()
        textPass.becomeFirstResponder()
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.signScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.signScrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.signScrollView.contentInset = contentInset
    }
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: func
    //텍스트 체크
    func valueCheck() -> Bool{
        let email = textEmail.text!
        let pass = textPass.text!
        let passCk = textPassCk.text!
        let name = textName.text!
        let phone = textPhone.text!
        let birth = textBirth.text!
        
        if email == "" {
            alertView("이메일을 입력해 주세요.", textEmail)
            return false
        }else if !email.validate("email") {
            alertView("이메일 형식이 아닙니다.\n 다시 입력해 주세요.", textEmail)
            textEmail.text = ""
            return false
        }else if name == "" {
            alertView("이름을 입력해 주세요.", textName)
            return false
        }else if !name.validate("name") {
            alertView("이름은 한글만 가능합니다.", textName)
            textName.text = ""
            return false
        }else if birth == "" {
            alertView("생년월일을 입력해 주세요.", textBirth)
            return false
        }else if !phone.validate("phone") {
            if phone == "" {
                alertView("휴대폰 번호를 입력해 주세요.", textPhone)
                return false
            }else {
                alertView("핸드폰번호 형식에 맞지않습니다, 다시 입력해 주세요.", textPhone)
                textPhone.text = ""
                return false
            }
        }else if pass.count < 8 || pass.count > 16 {
            alertView("비밀번호는 8자리 이상 16자리 이하로 입력해 주세요.", textPass)
            textPass.text = ""
            return false
        }else if pass != passCk {
            alertView("비밀번호가 다릅니다.\n 다시 입력해 주세요.", textPassCk)
            textPassCk.text = ""
            return false
        }
        return true
    }
   
    //알림창
   
    //알림창
    func LoginViewMoveAlert(_ value: String) {
        let alert = UIAlertController(title: "알림", message: "\(value)", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {action in
            guard let uservc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC" ) as? LoginVC else { return }
            uservc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.present(uservc, animated: true, completion: nil)
        })
        alert.addAction(okAction)
        self.present(alert, animated: false, completion: nil)
    }
    //알림창
    func CmpViewMoveAlert(_ value: String) {
        let alert = UIAlertController(title: "알림", message: "\(value)", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {action in
            let storyboard = UIStoryboard(name: "CmpCrt", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            self.present(viewController, animated: true, completion: nil)
        })
        alert.addAction(okAction)
        self.present(alert, animated: false, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    //키보드 자동 포커스 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField)
        if textField.returnKeyType == .next {
            if textField == textEmail {
                textField.resignFirstResponder()
                textName.becomeFirstResponder()
            }else  if textField == textName {
                textField.resignFirstResponder()
                textBirth.becomeFirstResponder()
            }else if textField == textBirth {
                textField.resignFirstResponder()
                textPhone.becomeFirstResponder()
            }else if textField == textPhone {
                textField.resignFirstResponder()
                textPass.becomeFirstResponder()
            }else if textField == textPass {
                textField.resignFirstResponder()
                textPassCk.becomeFirstResponder()
            }
        }else if textField == textPassCk {
            textField.resignFirstResponder()
        }
        return true
    }
}
