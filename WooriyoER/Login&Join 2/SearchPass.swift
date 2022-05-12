//
//  SearchPass.swift
//  PinPle
//
//  Created by WRY_010 on 2019/12/05.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class SearchPass: UIViewController {
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var vwLine1: UIView!
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var vwPop: UIView!
    @IBOutlet weak var lblPopEmail: UILabel!
    
    let prefs = UserDefaults.standard
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    
    //MARK: ovarride
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        textEmail.delegate = self
        lblEmail.isHidden = true
        vwBG.isHidden = true
        vwPop.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if prefs.value(forKey: "search_email") != nil {
            textEmail.text = (prefs.value(forKey: "search_email") as! String)
        }
    }
    //화면 터치시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    @IBAction func popLoginClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginVC");
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: @IBAction
    @IBAction func SearchClick(_ sender: UIButton) {
        /*
        Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(비밀번호 찾기).. 이메일 전송
        Return  - 1.성공 0.실패
        Parameter
        EM        이메일 - Base64 인코딩
        */
        Spinner.start()
        let email = textEmail.text!.base64Encoding()
        let url = urlClass.search_password(email: email)
        httpRequest.get(urlStr: url) { (success, jsonData) in
            if success {
                print(url)
                print(jsonData)
                
                let result = jsonData["result"] as! Int
                switch result {
                case 0:
                    self.alertView("E-mail을 다시 확인해주세요.\n 가입된 아이디가 아닙니다.");
                case 1:
                    self.vwBG.isHidden = false;
                    self.vwPop.isHidden = false;
                    self.lblPopEmail.text = self.textEmail.text! + "로";
                    self.prefs.setValue(self.textEmail.text!, forKey: "search_email");
                default:
                    break;
                }
            }
        }
        Spinner.stop()
    }
}
extension SearchPass: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblEmail.isHidden = false
        vwLine1.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            lblEmail.isHidden = true
        }
        
        vwLine1.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
    }
}
