//
//  joinViewController.swift
//  PinPle
//
//  Created by WRY_010 on 12/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit


class JoinVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPass: UITextField!
    @IBOutlet weak var textPassCk: UITextField!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textPhone: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var btnPass: UIButton!
    @IBOutlet weak var btnPassCk: UIButton!
         
    var email: String = ""
    var pass: String = ""
    var name: String = ""
    var phone: String = ""
    var osvs: String = ""
    var appvs: String = ""
    var md : String = ""
    
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
    
    //MARK: - view override
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnJoin)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
 
        addToolBar(textFields: [textEmail, textName, textPass, textPassCk])
        
        //delegate
        textEmail.delegate = self
        textName.delegate = self
        textPassCk.delegate = self
        textPass.delegate = self 

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 50
        self.scrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    // MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    // MARK: - @IBAction
    // MARK: 비밀번호 보이기
    @IBAction func passShow(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if sender == btnPass {
                textPass.isSecureTextEntry = false
            }else {
                textPassCk.isSecureTextEntry = false
            }
        }else {
            if sender == btnPass {
                textPass.isSecureTextEntry = true
            }else {
                textPassCk.isSecureTextEntry = true
            }
        }
    }
    
    // MARK: 회원가입 버튼 클릭
    @IBAction func signClick(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(Email 회원가입)
         Return  - 정상회원가입시:회원번호, 가입실패:0, 이미가입:-1, 구글로그인계정:-2, 네이버로그인계정:-3 카카오로그인계정:-4
         Parameter
         EM        아이디(Email) - Base64 인코딩(E-mail)
         PW        비밀번호 - SHA1 암호화
         NM        이름 - Base64 인코딩
         PN        핸드폰번호(11) - Base64 인코딩
         MD        단말모델 - Base64 인코딩
         OSVS    OS버전(예:17)
         APPVS    어플버전
         */
        if valueCheck() {
            email = textEmail.text!.base64Encoding()
            pass = textPass.text!.sha1()
            name = textName.text!.urlBase64Encoding()
//            phone = textPhone.text!.base64Encoding()
            phone = "00000000000".base64Encoding()
            
            IndicatorSetting()
            NetworkManager.shared().checkRegMbr(type: 5, id: "", email: email, name: name, pass: pass, gender: 0, birth: "", lunar: 0, phone: phone, mode: 1, osvs: deviceInfo.OSVS, appvs: deviceInfo.APPVS, md: deviceInfo.MD) { (isSuccess, resCode) in
                if(isSuccess){
                    switch resCode {
                    case 0:
                        self.customAlertView("가입실패");
                    case -1:
                        let value = "이미 등록된 계정이 존재합니다.\n 해당계정을 통해 로그인하세요."
                        let alert = UIAlertController(title: "알림", message: "\(value)", preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                            let vc = LoginSignSB.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true, completion: nil)
                        })
                        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                        alert.addAction(cancelAction)
                        alert.addAction(okAction)
                        self.present(alert, animated: false, completion: nil)
                    case -2:
                        let value = "구글 계정이 존재합니다.\n 구글계정을 통해 로그인하세요."
                        let alert = UIAlertController(title: "알림", message: "\(value)", preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                            self.SE_LoginVC()
                        })
                        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                        alert.addAction(cancelAction)
                        alert.addAction(okAction)
                        self.present(alert, animated: false, completion: nil)
                    case -3:
                        let value = "네이버 계정이 존재합니다.\n 네이버계정을 통해 로그인하세요."
                        let alert = UIAlertController(title: "알림", message: "\(value)", preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                            self.SE_LoginVC()
                        })
                        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                        alert.addAction(cancelAction)
                        alert.addAction(okAction)
                        self.present(alert, animated: false, completion: nil)
                    case -4:
                        let value = "카카오 계정이 존재합니다.\n 카카오계정을 통해 로그인하세요."
                        let alert = UIAlertController(title: "알림", message: "\(value)", preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                            self.SE_LoginVC()
                        })
                        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                        alert.addAction(cancelAction)
                        alert.addAction(okAction)
                        self.present(alert, animated: false, completion: nil)
                    case -5:
                        let value = "애플 계정이 존재합니다.\n 애플계정을 통해 로그인하세요."
                        let alert = UIAlertController(title: "알림", message: "\(value)", preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                            self.SE_LoginVC()
                        })
                        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                        alert.addAction(cancelAction)
                        alert.addAction(okAction)
                        self.present(alert, animated: false, completion: nil)
                    default:
                        prefs.setValue(self.email, forKey: "login_email");
                        prefs.setValue(self.pass, forKey: "login_pass");
                        prefs.setValue(self.textEmail.text!, forKey: "join_email");
                        prefs.setValue(self.textName.text!, forKey: "join_name");
                        prefs.setValue("00000000000", forKey: "join_phone");
                        prefs.setValue("email", forKey: "loginType");
                        userInfo.mbrsid = resCode
                        
                        let vc = LoginSignSB.instantiateViewController(withIdentifier: "SelMgrEmp") as! SelMgrEmp
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
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
    
    // MARK: - @func
    // MARK:텍스트 체크
    func valueCheck() -> Bool {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let email = textEmail.text ?? ""
        let pass = textPass.text ?? ""
        let passCk = textPassCk.text ?? ""
        let name = textName.text ?? ""
//        let phone =  textPhone.text ?? ""
        
        if email == "" {
            customAlertView("이메일을 입력해 주세요.", textEmail)
            return false
        }
        else if name == "" {
            customAlertView("이름을 입력해 주세요.", textName)
            return false
        }
//        else if phone == "" {
//            customAlertView("핸드폰번호를 입력해 주세요.", textPhone)
//            textPhone.text = ""
//            return false
//        }
        else if pass == "" {
            customAlertView("비밀번호를 입력해 주세요.", textPass)
            textPass.text = ""
            return false
        }else if passCk == "" {
            customAlertView("비밀번호 확인을 입력해 주세요.", textPassCk)
            textPassCk.text = ""
            return false
        }
        
        
        return true
    }
}
// MARK: - extension UITextFieldDelegate
extension JoinVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textEmail {
            textField.resignFirstResponder()
            textName.becomeFirstResponder()
        }else  if textField == textName {
            textField.resignFirstResponder()
//            textPhone.becomeFirstResponder()
        }
//        }else if textField == textPhone {
//            textField.resignFirstResponder()
//            textPass.becomeFirstResponder()
//        }
        else if textField == textPass {
            textField.resignFirstResponder()
            textPassCk.becomeFirstResponder()
        }else if textField == textPassCk {
            textField.resignFirstResponder()
            self.signClick(btnJoin)
        }
        
 
        return true
    }
    
  
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text! != "" {
            if textField == textEmail {
                if !textField.text!.validate("email") {
                    self.customAlertView("이메일 형식이 아닙니다.\n 다시 입력해 주세요.", textField)
                    textField.text = ""
                }
            }else if textField == textName {
                if !textField.text!.validate("koeng") {
                    customAlertView("이름은 한글 또는 영문만 가능합니다.", textField)
                    textField.text = ""
                }
            }
//            else if textField == textPhone {
//                if !textField.text!.validate("phone") {
//                    customAlertView("핸드폰번호 형식에 맞지않습니다.\n 다시 입력해 주세요.", textField)
//                    textField.text = ""
//                }
//            }
            else if textField == textPass {
                if textField.text!.count < 6 && textField.text! != "" {
                    customAlertView("비밀번호는 6자리 이상으로 입력해 주세요.", textField)
                    textField.text = ""
                }
            }else if textField == textPassCk {
                if textPass.text != textPassCk.text {
                    customAlertView("비밀번호가 다릅니다.\n 다시 입력해 주세요.", textField)
                    textField.text = ""
                }
            }
            
 
        }
        
    }
}
