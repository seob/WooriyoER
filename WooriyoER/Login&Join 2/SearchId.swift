//
//  SearchId.swift
//  PinPle
//
//  Created by WRY_010 on 2019/12/05.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class SearchId: UIViewController {
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textPhone: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var vwLine1: UIView!
    @IBOutlet weak var vwLine2: UIView!
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var vwPop: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    
    let prefs = UserDefaults.standard
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
        
    //MARK: ovarride
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        textName.delegate = self
        textPhone.delegate = self
        
        lblName.isHidden = true
        lblPhone.isHidden = true
        vwBG.isHidden = true
        vwPop.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    //화면 터치시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    @IBAction func popSearchClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchPass")
       self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    @IBAction func popLoginClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: @IBAction
    @IBAction func SearchClick(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(이메일 찾기)
         Return  - 이메일
         Parameter
         NM        이름 - URL인코딩 후 Base64 인코딩(한글깨짐 방지)
         PN        폰번호 - Base64 인코딩
         */
        let name = textName.text!.urlBase64Encoding()
        let phone = textPhone.text!.base64Encoding()
        let url = urlClass.search_email(name: name, phone: phone)
        httpRequest.get(urlStr: url) { (success, jsonData) in
            if success {
                print(url)
                print(jsonData)
                
                let result = jsonData["result"] as! String
                
                if result != "" {
                    self.vwBG.isHidden = false
                    self.vwPop.isHidden = false
                    self.lblEmail.text = result
                    self.prefs.setValue(result, forKey: "search_email")
                }else {
                    self.alertView("가입된 아이디가 없습니다. 다시 확인해 주세요.")
                }
                
            }
        }
    }
    @IBAction func toolbar(_ sender: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "확인", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.toolbarSet))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        sender.inputAccessoryView = toolBar
    }
    @objc func toolbarSet(sender: UIBarButtonItem) {
        textPhone.resignFirstResponder()
    }
    
}
extension SearchId: UITextFieldDelegate {
    //키보드 자동 포커스 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textName {
            textField.resignFirstResponder()
            textPhone.becomeFirstResponder()
        }else if textField == textPhone {
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textName {
            lblName.isHidden = false
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }else if textField == textPhone {
            lblPhone.isHidden = false
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textName {
            if textField.text == "" {
                lblName.isHidden = true
            }
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }else if textField == textPhone {
            if textField.text == "" {
                lblPhone.isHidden = true
            }
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }
    }
}
