//
//  EmailLoginViewController.swift
//  PinPle
//
//  Created by WRY_010 on 12/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class EmailLoginVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPw: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
          
    @IBOutlet weak var loginView_Review: UIView!
    @IBOutlet weak var login_Test: UIView!
    var email: String = ""//자동로그인 email(id)
    var pass: String = "" //자동로그인 pass
    var isMster: Int = 0
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
    
    //MARK: - view ovarride
    override func viewDidLoad() {
        print("\n-----------------[UIViewController : \(self) ]---------------------\n")
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidLoad()
        btnLogin.layer.cornerRadius = 6
        textEmail.delegate = self
        textPw.delegate = self
        textPw.isSecureTextEntry = true
        
        addToolBar(textFields: [textEmail, textPw])
        if isReviewStatus > 0 {
            // 리뷰기간
            loginView_Review.isHidden = true
            login_Test.isHidden = false
        }else{
            // 상용
            loginView_Review.isHidden = false
            login_Test.isHidden = true
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidAppear(animated)
        if prefs.value(forKey: "search_email") != nil {
            textEmail.text = (prefs.value(forKey: "search_email") as! String)
            prefs.removeObject(forKey: "search_email")
        }
    }
    // MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
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
    }
    // MARK: - @IBAction
    // MARK: - 비밀번호 보이기
    @IBAction func passShow(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            textPw.isSecureTextEntry = false
        }else {
            textPw.isSecureTextEntry = true
        }
    }
    // MARK: 회원가입 버튼
    @IBAction func joinClick(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "JoinVC") as! JoinVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    // MARK: 아이디 찾기
    @IBAction func searchIdClick(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchId") as! SearchId
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    // MARK: 비밀번호 찾기
    @IBAction func searchPass(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchPass") as! SearchPass
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    // MARK: 로그인 버튼
    @IBAction func loginClick(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        if textEmail.text!.validate("email") {
            if isMster > 0 {
                masterCheck()
            }else{
                menberCheck()
            }
            
        }else{
            self.customAlertView("이메일과 비밀번호를 올바르게 입력해주세요.")
            textEmail.text = ""
            textPw.text = ""
        }
    }
    
    
    func masterCheck(){
        email = textEmail.text!.base64Encoding()
        let pwd = "korea1234".base64Encoding()
        NetworkManager.shared().checkMst(email: email, pass: pwd) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                userInfo = serverData
                
                let mbrsid = serverData.mbrsid
                let author = serverData.author
                let cmpsid = serverData.cmpsid
                let joindt = serverData.joindt
                
                prefs.setValue(self.email, forKey: "login_email")
                prefs.setValue(self.pass, forKey: "login_pass")
                prefs.setValue("email", forKey: "loginType")
                
                
                prefs.setValue(serverData.ttmsid, forKey: "cmt_ttmsid")
                prefs.setValue(serverData.temsid, forKey: "cmt_temsid")
                prefs.setValue(serverData.ttmname, forKey: "cmt_temname")
                prefs.setValue(serverData.temname, forKey: "temname")
                prefs.setValue(serverData.empsid, forKey: "Newempsid")
                
                self.viewMove(joindt: joindt, cmpsid: cmpsid)
            }else{
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
        }
    }
    func menberCheck() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(회원 확인)
         Parameter
         EMAIL    Email(ID) BASE64 인코딩
         PASS    비밀번호 SHA1Password 암호화 형식으로 전달 받음...
         MODE    0.근로자 1.관리자
         OSVS    OS버전(예:4.3.3)
         APPVS    어플버전
         MD        단말기모델명 BASE64 인코딩
         */
        email = textEmail.text!.base64Encoding()
        pass = textPw.text!.sha1() 
        IndicatorSetting()
        NetworkManager.shared().checkMbr(type: 5, id: "", email: email, pass: pass, mode: 1, osvs: deviceInfo.OSVS, appvs: deviceInfo.APPVS, md: deviceInfo.MD) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                userInfo = serverData
                
                let mbrsid = serverData.mbrsid
                let author = serverData.author
                let cmpsid = serverData.cmpsid
                let joindt = serverData.joindt
                
                prefs.setValue(self.email, forKey: "login_email")
                prefs.setValue(self.pass, forKey: "login_pass")
                prefs.setValue("email", forKey: "loginType")
                
                print("\n---------- [ test : \(serverData.toJSON()) ] ----------\n")
                prefs.setValue(serverData.ttmsid, forKey: "cmt_ttmsid")
                prefs.setValue(serverData.temsid, forKey: "cmt_temsid")
                prefs.setValue(serverData.ttmname, forKey: "cmt_temname")
                prefs.setValue(serverData.temname, forKey: "temname")
                 /***************************************************
                  2020.01.10 seob
                  - 기존에 empsid를 너무 많이사용하고 있어서 연차 결재 & 출장 결재에 사용하기 위해
                  따로 추가해서 만듭니다.
                  ***************************************************/
                 prefs.setValue(serverData.empsid, forKey: "Newempsid")
                
                if mbrsid > 0 {
                    self.setPushId(mbrsid: mbrsid)
                    
                    if author == 5 {
                        let alert = UIAlertController.init(title: "알림", message: "권한이 없습니다. 근로자 앱으로 이동합니다.", preferredStyle: .alert)
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
                }else if mbrsid == -1 {
                    self.customAlertView("비밀번호가 틀렸습니다.\n다시 입력해주세요.")
                }else{
                    self.customAlertView("가입된 회원이 아닙니다.\n가입해 주시기 바랍니다.")
                }
            }else {
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
        }
    }
}
// MARK: - extension UITextFieldDelegate
extension EmailLoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textEmail {
            textField.resignFirstResponder()
            textPw.becomeFirstResponder()
        }else if textField == textPw {
            textField.resignFirstResponder()
            loginClick(btnLogin)
        }
        return true
    }
}
