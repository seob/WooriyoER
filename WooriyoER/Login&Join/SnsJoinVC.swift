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

class SnsJoinVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textPhone: UITextField!
    @IBOutlet weak var signScrollView: UIScrollView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var btnSignup: UIButton!
    
    var dateFormatter = DateFormatter()
    var textDateFormatter = DateFormatter()
    
    var showDate: String = ""
    var inputDate: String = ""
    var ori_birth: String = ""
    
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
    
    // MARK: - IndicatorSetting
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    // MARK: - view override
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignup.layer.cornerRadius = 6
        textEmail.delegate = self
        textName.delegate = self
        
        addToolBar(textFields: [textEmail, textName,textPhone])
        
        // sns로그인시 이메일 수정못하게 막기 seob
        if let loginType = prefs.value(forKey: "loginType") as? String {
            
            if loginType == "kakao" {
                //카카오톡 회원가입시 이메일이 선택이므로 이메일이 없으면 입력가능하게 변경
                if let email = prefs.value(forKey: "join_email") as? String {
                    if email != "" {
                        print("\n---------- [ 이메일이 있다  ] ----------\n")
                        textEmail.isEnabled = false
                    }
                }else{
                    print("\n---------- [ 이메일이 없다  ] ----------\n")
                    textEmail.isEnabled = true
                }
            }else if loginType == "apple" {
                if isReviewStatus > 0 {
                    nameView.isHidden = true
                }
            }
            else{
                textEmail.isEnabled = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.signScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 50
        self.signScrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.signScrollView.contentInset = contentInset
    }
    
    // MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        self.SE_LoginVC()
    }
    // MARK: - @IBAction
    // MARK: 회원가입 버튼 클릭
    @IBAction func signClick(_ sender: UIButton) {
        if valueCheck() {
            signAction()
        }
    }
    
    func signAction() {
        name = textName.text!.urlBase64Encoding()
//        phone = textPhone.text!.base64Encoding()
        phone = "00000000000".base64Encoding()
        email = textEmail.text!.base64Encoding()
        
        let loginType = prefs.value(forKey: "loginType") as! String
        var SnsloginType = 0
        switch loginType {
        case "naver":
            SnsloginType = 1
        case "google":
            SnsloginType = 2
        case "kakao":
            SnsloginType = 3
        case "apple":
            SnsloginType = 4
        default:
            SnsloginType = 5
            print("로그인 실패")
        }
        IndicatorSetting()
        NetworkManager.shared().checkRegMbr(type: SnsloginType, id: self.tokenid, email: email, name: name, pass: "", gender: gender, birth: brith, lunar: lunar, phone: phone, mode: 1, osvs: osvs, appvs: appvs, md: md) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode > 0 {
                    print("\n---------- [ sns회원가입 완료 ] ----------\n")
                    prefs.setValue(self.email, forKey: "login_email")
                    
                    userInfo.email = self.textEmail.text!
                    userInfo.name = self.textName.text!
                    userInfo.phonenum = self.textPhone.text ?? "00000000000"
                    userInfo.mbrsid = resCode
                    
                    let vc = LoginSignSB.instantiateViewController(withIdentifier: "SelMgrEmp") as! SelMgrEmp
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                }else if resCode == 0 {
                    print("\n---------- [ 가입 실패  ] ----------\n")
                    self.customAlertView("가입 실패하였습니다.\n 다시 시도해 주세요.")
                }else{
                    print("\n---------- [ 회원정보 업데이트  ] ----------\n")
                    self.menberCheck()
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
        }
    }
    
    // MARK: - @func
    // MARK: 뷰 값 세팅
    func valueSetting() {
        let email = prefs.value(forKey: "join_email") as? String ?? "" // nil 체크
        let loginType = prefs.value(forKey: "loginType") as? String ?? ""
        var id = ""
        if(loginType == "apple"){
            id = (prefs.value(forKey: "fid") as? String ?? "").base64Encoding()
        }else{
            id = (prefs.value(forKey: "id") as? String ?? "").base64Encoding()
        }
        
        if isReviewStatus > 0 {
            if(loginType == "apple"){
                let strName = email.components(separatedBy: "@")
                prefs.setValue(strName[0], forKey: "join_name")
                textName.text = "\(strName[0])"
            }else{
                let name = prefs.value(forKey: "join_name") as? String ?? "" // nil 체크
                textName.text = name
            }
        }else{
            let name = prefs.value(forKey: "join_name") as? String ?? "" // nil 체크
            textName.text = name
        }
 
 
         
        textEmail.text = email
        
        
        self.email = email.base64Encoding()
        tokenid = id
    }
    // MARK: 텍스트 체크
    func valueCheck() -> Bool{
        let name = textName.text ?? ""
        let phone = textPhone.text ?? ""
        let email = textEmail.text ?? ""
        if isReviewStatus > 0 {
            if email == "" {
                customAlertView("이메일을 입력해 주세요.", textEmail)
                return false
            }else if !email.validate("email") {
                customAlertView("이메일 형식이 아닙니다.\n 다시 입력해 주세요.", textEmail)
                textEmail.text = ""
                return false
            }else if name == "" {
                customAlertView("이름을 입력해 주세요.", textName)
                textName.text = ""
                return false
            }
        }else{
            if email == "" {
                customAlertView("이메일을 입력해 주세요.", textEmail)
                return false
            }else if !email.validate("email") {
                customAlertView("이메일 형식이 아닙니다.\n 다시 입력해 주세요.", textEmail)
                textEmail.text = ""
                return false
            }else if name == "" {
                customAlertView("이름을 입력해 주세요.", textName)
                textName.text = ""
                return false
            }else if !name.validate("koeng") {
                customAlertView("이름은 한글 또는 영문만 가능합니다.", textName)
                textName.text = ""
                return false
            }
        }
 
//        else if phone == "" {
//            customAlertView("핸드폰번호를 입력해 주세요.", textPhone)
//            textPhone.text = ""
//            return false
//        }
//        }else if !phone.validate("phone") {
//            customAlertView("핸드폰번호 형식에 맞지않습니다, 다시 입력해 주세요.", textPhone)
//            textPhone.text = ""
//            return false
//        }
        return true
    }
    // MARK: 회원 체크
    func menberCheck() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let id = (prefs.value(forKey: "id") as? String ?? "").base64Encoding()
        let loginType = prefs.value(forKey: "loginType") as? String ?? ""
        let fid = (prefs.value(forKey: "fid") as? String ?? "").base64Encoding()
        var SnsloginType = 0
        switch loginType {
        case "google":
            SnsloginType = 2
            print("google Login");
        case "naver":
            SnsloginType = 1
            print("naver Login");
        case "kakao":
            SnsloginType = 3
            print("kakao Login");
        case "apple":
            SnsloginType = 4
            print("apple login")
        default:
            SnsloginType = 5
            print("로그인 실패");
            break;
        }
        
        IndicatorSetting()
        NetworkManager.shared().checkMbr(type: SnsloginType, id: id, fid:fid ,email: "", pass: "", mode: 1, osvs: deviceInfo.OSVS, appvs: deviceInfo.APPVS, md: deviceInfo.MD) { (isSuccess, resData) in
            
            if(isSuccess){
                guard let serverData = resData else {  return }
                userInfo = serverData
                
                let mbrsid = serverData.mbrsid
                let author = serverData.author
                let cmpsid = serverData.cmpsid
                let joindt = serverData.joindt
                 
                
                if mbrsid > 0 {
                    self.setPushId(mbrsid: mbrsid)
                    
                    if author == 5 {
                        let alert = UIAlertController.init(title: "알림", message: "이미 \(userInfo.cmpname)에 소속되있는 근로자이므로 회사생성이 불가능합니다.\n 근로자 앱으로 이동합니다.", preferredStyle: .alert)
                        let okAction = UIAlertAction.init(title: "확인", style: .default, handler: { action in
                            let scheme = "WooriyoEE://"
                            let url = URL(string: scheme)!
                            print("-------------------[UIApplication.shared.canOpenURL(url)=\(UIApplication.shared.canOpenURL(url))]-------------------")
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }else {
                                UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/apple-store/id1624398964")!, options: [:], completionHandler: nil)
                            }
                        })
                        let cancel = UIAlertAction.init(title: "종료", style: .cancel, handler: { action in
                            if SE_flag {
                                let vc = LoginSignSB.instantiateViewController(withIdentifier: "SE_LoginVC") as! LoginVC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: false, completion: nil)
                            }else {
                                let vc = LoginSignSB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: false, completion: nil)
                            }
                        })
                        alert.addAction(cancel)
                        alert.addAction(okAction)
                        
                        self.present(alert, animated: true, completion: nil)
                    }else {
                        self.viewMove(joindt: joindt, cmpsid: cmpsid)
                    }
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
        }
    }
}
// MARK: - extension UITextFieldDelegate
extension SnsJoinVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textName {
            textField.resignFirstResponder()
         //   textPhone.becomeFirstResponder()
        }
//        else if textField == textPhone {
//            textField.resignFirstResponder()
//            signAction()
//        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text! != "" {
            if textField == textName {
                if !textField.text!.validate("koeng") {
                    customAlertView("이름은 한글 또는 영문만 가능합니다.", textField)
                    textField.text = ""
                }
            }
//            else if textField == textPhone {
//                if !textField.text!.validate("phone") {
//                    customAlertView("핸드폰번호 형식에 맞지않습니다, 다시 입력해 주세요.", textField)
//                    textField.text = ""
//                }
//            }
        }
        
    }
}
