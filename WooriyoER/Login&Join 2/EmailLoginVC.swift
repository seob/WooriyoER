//
//  EmailLoginViewController.swift
//  PinPle
//
//  Created by WRY_010 on 12/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class EmailLoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPw: UITextField!
    
    let prefs = UserDefaults.standard
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let deviceInfo = DeviceInfo()
    
    var email: String = ""//앱에 저장된 email(id)
    var pass: String = "" //앱에 저장된 pass
    
    //MARK: ovarride
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        self.navigationController?.viewControllers = [vc!, self]
        textEmail.delegate = self
        textPw.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if prefs.value(forKey: "search_email") != nil {
            textEmail.text = (prefs.value(forKey: "search_email") as! String)
            prefs.removeObject(forKey: "search_email")
        }
    }
    //화면 터치시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: @IBAction
    //회원가입 버튼
    @IBAction func joinClick(_ sender: UIButton) {
        performSegue(withIdentifier: "login_join", sender: self)
    }
    @IBAction func searchIdClick(_ sender: UIButton) {
        performSegue(withIdentifier: "login_search_id", sender: self)
    }
    @IBAction func searchPass(_ sender: UIButton) {
        performSegue(withIdentifier: "login_search_pass", sender: self)
    }
    //로그인 버튼
    @IBAction func loginClick(_ sender: UIButton) {
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
        if textEmail.text!.validate("email") {
            email = (textEmail.text!.data(using: .utf8)?.base64EncodedString())!
            pass = textPw.text!.sha1()
            
            let url = urlClass.check_mbr(email: email, pass: pass, osvs: deviceInfo.OSVS, appvs: deviceInfo.APPVS, md: deviceInfo.MD)
            httpRequest.get(urlStr: url) { (success, jsonData) in
                if success {
                    print(url)
                    print(jsonData)
                    let mbrsid = jsonData["mbrsid"] as! Int
                    if mbrsid > 0 {
                        let author = jsonData["author"] as! Int
                        let cmpname = jsonData["cmpname"] as! String
                        let cmpsid = jsonData["cmpsid"] as! Int
                        let curver = jsonData["curver"] as! String
                        let email = jsonData["email"] as! String
                        let empsid = jsonData["empsid"] as! Int
                        let ename = jsonData["enname"] as! String
                        let gender = jsonData["gender"] as! Int
                        let mbrsid = jsonData["mbrsid"] as! Int
                        let name = jsonData["name"] as! String
                        let notrc = jsonData["notrc"] as! Int
                        let profimg = jsonData["profimg"] as! String
                        let pushid = jsonData["pushid"] as! String
                        let regdt = jsonData["regdt"] as! String
                        let spot = jsonData["spot"] as! String
                        let temname = jsonData["temname"] as! String
                        let temsid = jsonData["temsid"] as! Int
                        let ttmname = jsonData["ttmname"] as! String
                        let ttmsid = jsonData["ttmsid"] as! Int
                        let update = jsonData["update"] as! Int
                        let updatemsg = jsonData["updatemsg"] as! String
                        
                        self.prefs.setValue(self.email, forKey: "m_email")
                        self.prefs.setValue(self.pass, forKey: "m_pass")
                        self.prefs.setValue("email", forKey: "loginType")
                        
                        self.prefs.setValue(author, forKey: "author")
                        self.prefs.setValue(cmpname, forKey: "cmpname")
                        self.prefs.setValue(cmpsid, forKey: "cmpsid")
                        self.prefs.setValue(curver, forKey: "curver")
                        self.prefs.setValue(email, forKey: "email")
                        self.prefs.setValue(empsid, forKey: "empsid")
                        self.prefs.setValue(ename, forKey: "ename")
                        self.prefs.setValue(gender, forKey: "gender")
                        self.prefs.setValue(mbrsid, forKey: "mbrsid")
                        self.prefs.setValue(name, forKey: "name")
                        self.prefs.setValue(notrc, forKey: "notrc")
                        self.prefs.setValue(profimg, forKey: "profimg")
                        self.prefs.setValue(pushid, forKey: "pushid")
                        self.prefs.setValue(regdt, forKey: "regdt")
                        self.prefs.setValue(spot, forKey: "spot")
                        self.prefs.setValue(temname, forKey: "temname")
                        self.prefs.setValue(temsid, forKey: "temsid")
                        self.prefs.setValue(ttmname, forKey: "ttmname")
                        self.prefs.setValue(ttmsid, forKey: "ttmsid")
                        self.prefs.setValue(update, forKey: "update")
                        self.prefs.setValue(updatemsg, forKey: "updatemsg")
                        
                        if empsid == 0 || cmpsid == 0 {
                            var key = 1
                            if self.prefs.value(forKey: "stage") != nil {
                                key = self.prefs.value(forKey: "stage") as! Int
                            }
                            print("key = ", key)
                            switch key{
                            case 1, 2, 3, 4, 5, 6:
                                let storyboard = UIStoryboard(name: "CmpCrt", bundle: nil);
                                guard let viewController = storyboard.instantiateInitialViewController() else { return };
                                self.present(viewController, animated: true, completion: nil);
                            case 7, 8, 9, 10, 11, 12, 13:
                                let storyboard = UIStoryboard(name: "TmCrt", bundle: nil);
                                guard let viewController = storyboard.instantiateInitialViewController() else { return };
                                self.present(viewController, animated: true, completion: nil);
                            default:
                                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                                guard let viewController = storyboard.instantiateInitialViewController() else { return };
                                self.present(viewController, animated: true, completion: nil);
                            }
                        }else {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil);
                            guard let viewController = storyboard.instantiateInitialViewController() else { return };
                            self.present(viewController, animated: true, completion: nil);
                        }
                        
                    }else if mbrsid == -1 {
                        self.alertView("비밀번호가 틀렸습니다.\n다시 입력해주세요.")
                    }else{
                        self.alertView("가입된 회원이 아닙니다.\n가입해 주시기 바랍니다.")
                    }
                }
            }
        }else{
            self.alertView("이메일과 비밀번호를 올바르게 입력해주세요.")
            textEmail.text = ""
            textPw.text = ""
        }
    }
    
    //MARK: func    
    //키보드 자동 포커스 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField)
        
        if textField == textEmail {
            textField.resignFirstResponder()
            textPw.becomeFirstResponder()
        }else if textField == textPw {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
