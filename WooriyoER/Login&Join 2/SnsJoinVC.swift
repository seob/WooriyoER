//
//  SnsJoinViewController.swift
//  PinPle
//
//  Created by WRY_010 on 19/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import NaverThirdPartyLogin

class SnsJoinVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textPhone: UITextField!
    @IBOutlet weak var textBirth: UITextField!
    @IBOutlet weak var btnLunar: UIButton!
    @IBOutlet weak var btnMan: UIButton!
    @IBOutlet weak var btnWoman: UIButton!
    @IBOutlet weak var signScrollView: UIScrollView!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    var device = DeviceInfo()
    
    let prefs = UserDefaults.standard
    var dateFormatter = DateFormatter()
    var textDateFormatter = DateFormatter()
    
    var showDate = ""
    var inputDate = ""
    var ori_birth = ""
    
    var email: String = ""
    var tokenid: String = ""
    var name: String = ""
    var gender: Int = 0
    var brith: String = ""
    var lunar: Int = 0
    var phone: String = ""
    var osvs: String = ""
    var appvs: String = ""
    var md : String = ""
    
    var genderFlag: Int = 0
    var lunarFlag: Int = 0
    
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        textEmail.delegate = self
        textName.delegate = self
        textPhone.delegate = self
        textBirth.delegate = self
        
        btnMan.setImage(UIImage(named: "er_checkbox"), for: .selected)
        btnMan.setImage(UIImage(named: "icon_nonecheck"), for: .normal)
        btnWoman.setImage(UIImage(named: "er_checkbox"), for: .selected)
        btnWoman.setImage(UIImage(named: "icon_nonecheck"), for: .normal)
        btnLunar.setImage(UIImage(named: "er_checkbox"), for: .selected)
        btnLunar.setImage(UIImage(named: "icon_nonecheck"), for: .normal)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    //음력 설정 양력0, 음력 1
    @IBAction func btn_lunar(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            lunarFlag = 1
        }else{
            lunarFlag = 0
        }
        prefs.setValue(lunarFlag, forKey: "lunarFlag")
    }
    //성별 설정 남자 0, 여자 1
    @IBAction func manClick(_ sender: UIButton) {
        genderFlag = 0
        btnMan.isSelected = true
        btnWoman.isSelected = false
        prefs.setValue(genderFlag, forKey: "genderFlag")
    }
    @IBAction func womanClick(_ sender: UIButton) {
        genderFlag = 1
        btnMan.isSelected = false
        btnWoman.isSelected = true
        prefs.setValue(genderFlag, forKey: "genderFlag")
    }
    //회원가입 버튼 클릭
    @IBAction func signClick(_ sender: UIButton) {
        if valueCheck(){
            name = ((httpRequest.urlEncode(textName.text!)).data(using: .utf8)?.base64EncodedString())!
            gender = genderFlag
            brith = ((textBirth.text!).data(using: .utf8)?.base64EncodedString())!
            lunar = lunarFlag
            phone = ((textPhone.text!).data(using: .utf8)?.base64EncodedString())!
            
            let loginType = self.prefs.value(forKey: "loginType") as! String
            var url = ""
            
            switch loginType {
            case "google":
                url = urlClass.reg_mbr4google(email: email, gid: self.tokenid, name: name, gender: gender, birth: brith, lunar: lunar, phone: phone, osvs: osvs, appvs: appvs, md: md);
            case "naver":
                url = urlClass.reg_mbr4naver(email: email, nid: self.tokenid, name: name, gender: gender, birth: brith, lunar: lunar, phone: phone, osvs: osvs, appvs: appvs, md: md);
            case "kakao":
                url = urlClass.reg_mbr4kakao(email: email, kid: self.tokenid, name: name, gender: gender, birth: brith, lunar: lunar, phone: phone, osvs: osvs, appvs: appvs, md: md);
            default:
                print("로그인 실패")
            }
            httpRequest.get(urlStr: url) { (success, jsonData) in
                if success {
                    print(url)
                    print(jsonData)
                    let result = jsonData["result"] as! Int
                    
                    switch result {
                    case 0:
                        self.alertView("가입실패");
                    case -1:
                        self.viewMoveAlert("이미가입된 아이디와 연동됩니다.");
                    default:
                        self.prefs.setValue(self.email, forKey: "m_email");
                        self.prefs.setValue(self.textEmail.text!, forKey: "email");
                        self.prefs.setValue(self.textName.text!, forKey: "name");
                        self.prefs.setValue(self.gender, forKey: "genderFlag");
                        self.prefs.setValue(self.showDate, forKey: "birth");
                        self.prefs.setValue(self.lunar, forKey: "lunarFlag");
                        self.prefs.setValue(self.textPhone.text!, forKey: "phone");
                        self.prefs.setValue("email", forKey: "loginType");
                        self.prefs.setValue(result, forKey: "mbrsid");
                        self.viewMoveAlert("가입을 축하합니다.");
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
    }
    @objc func keyboardWillShow(_ notification:Notification){
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.signScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 150
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
    func valueSetting() {
        let email = prefs.value(forKey: "email") as! String
        let id = prefs.value(forKey: "id") as! String
        let name = prefs.value(forKey: "name") as! String
        let gender = prefs.value(forKey: "gender") as! Int
        
        osvs = device.OSVS
        appvs = device.APPVS
        md = device.MD
        
        textEmail.text = email
        textName.text = name
        
        switch gender {
        case 0:
            self.btnMan.isSelected = true;
        case 1:
            self.btnWoman.isSelected = true;
        default:
            break;
        }
        self.email = ((email).data(using: .utf8)?.base64EncodedString())!
        tokenid = id
    }
    //텍스트 체크
    func valueCheck() -> Bool{
        let name = textName.text!
        let phone = textPhone.text!
        let birth = textBirth.text!
        
        if name == "" {
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
            if phone == ""{
                alertView("휴대폰 번호를 입력해 주세요.", textPhone)
                return false
            }else {
                alertView("핸드폰번호 형식에 맞지않습니다, 다시 입력해 주세요.", textPhone)
                textPhone.text = ""
                return false
            }
        }
        return true
    }
    
    //알림창 - 텍스트 필드 이동
   
    //알림창 - 회사등록 뷰 이동
    func viewMoveAlert(_ value: String) {
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
            if textField == textName {
                textField.resignFirstResponder()
                textPhone.becomeFirstResponder()
            }else if textField == textPhone {
                textField.resignFirstResponder()
                textBirth.becomeFirstResponder()
            }
        }else if textField == textBirth {
            textField.resignFirstResponder()
        }
        return true
    }
}
