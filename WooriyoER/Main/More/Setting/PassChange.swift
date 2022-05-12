//
//  PassChange.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/20.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
//2020.01.20 비밀번호 변경 추가
class PassChange: UIViewController {

    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var btnPass1: UIButton!
    @IBOutlet weak var btnPass2: UIButton!
    @IBOutlet weak var btnPass3: UIButton!
    @IBOutlet weak var textPass1: UITextField!
    @IBOutlet weak var textPass2: UITextField!
    @IBOutlet weak var textPass3: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureAppearance()
        btnSave.layer.cornerRadius = 6
        textPass1.delegate = self
        textPass2.delegate = self
        textPass3.delegate = self
        addToolBar(textFields: [textPass1, textPass2, textPass3])
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_SettingVC") as! SettingVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func passShow(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            switch sender {
            case btnPass1:
                textPass1.isSecureTextEntry = false
            case btnPass2:
                textPass2.isSecureTextEntry = false
            case btnPass3:
                textPass3.isSecureTextEntry = false
            default:
                break;
            }
        }else {
            switch sender {
            case btnPass1:
                textPass1.isSecureTextEntry = true
            case btnPass2:
                textPass2.isSecureTextEntry = true
            case btnPass3:
                textPass3.isSecureTextEntry = true
            default:
                break;
            }
        }
    }
    
     @IBAction func save(_ sender: UIButton) {
        if valueCheck() {
//                let mbrsid = prefs.value(forKey: "mbrsid") as! Int
            let mbrsid = userInfo.mbrsid
                let oldpw = textPass1.text!.sha1()
                let newpw = textPass2.text!.sha1()
                
                print("\n---------- [ mbrsid : \(mbrsid) ,  oldpw : \(oldpw) , newpw : \(newpw) ] ----------\n")
                NetworkManager.shared().PassChange(mbrsid: mbrsid, oldpw: oldpw, newpw: newpw) { (isSuccess, resCode) in
                    if (isSuccess) {
                        switch resCode {
                        case 1:
                            prefs.setValue(newpw, forKey: "login_pass")
//                            Toast(text: "정상적으로 비밀번호가 변경되었습니다.",  duration: Delay.short).show()
                            self.toast("정상적으로 비밀번호가 변경되었습니다.")
                            var vc = MoreSB.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
                            if SE_flag {
                                vc = MoreSB.instantiateViewController(withIdentifier: "SE_SettingVC") as! SettingVC
                            }else{
                                vc = MoreSB.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false, completion: nil)
                        case 0:
                            self.customAlertView("다시 시도해 주세요")
                        case -1:
                            self.customAlertView("기존 비밀번호가 틀렸습니다.\n 다시 입력해 주세요.", self.textPass1)
                        default:
                            break
                        }
                    }else{
                        self.customAlertView("다시 시도해 주세요.")
                    }
                }
        }
    }
    
    func valueCheck() -> Bool {
        let pass1 = textPass1.text!
        let pass2 = textPass2.text!
        let pass3 = textPass3.text!
        
        if pass1 == "" {
            self.customAlertView("기존 비밀번호를 입력해주세요.", self.textPass1)
            return false
        }else if pass2 == "" {
            self.customAlertView("새로운 비밀번호를 입력해주세요.", self.textPass2)
            return false
        }else if !pass2.validate("pass") {
            self.customAlertView("대문자, 소문자, 숫자,특수문자(!@#$%^*+=-)를 포함한 6자리이상을 사용해야 합니다.", self.textPass2)
            return false
        }else if pass3 == "" {
            self.customAlertView("새로운 비밀번호 확인을 입력해주세요.", self.textPass3)
            return false
        }else if !pass3.validate("pass") {
            self.customAlertView("대문자, 소문자, 숫자,특수문자(!@#$%^*+=-)를 포함한 6자리이상을 사용해야 합니다.", self.textPass3)
            return false
        }else if pass2 != pass3 {
            self.customAlertView("새로운 비밀번호가 다릅니다.\n 다시 확인해주세요.", self.textPass3)
            return false
        }else if pass1 == pass2 {
            self.customAlertView("기존 비밀번호와 똑같습니다.\n 다시 확인해주세요.", self.textPass2)
            return false
        }
        return true
    }
}
extension PassChange: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textPass1 {
            textField.resignFirstResponder()
            textPass2.becomeFirstResponder()
        }else if textField == textPass2 {
            textField.resignFirstResponder()
            textPass3.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
}
