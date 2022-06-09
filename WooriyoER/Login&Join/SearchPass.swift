//
//  SearchPass.swift
//  PinPle
//
//  Created by WRY_010 on 2019/12/05.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class SearchPass: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var vwLine1: UIView!
    @IBOutlet weak var btnFindPw: UIButton!
    
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
    
    // MARK: - view ovarride
    override func viewDidLoad() {
        print("\n-----------------[UIViewController : \(self) ]---------------------\n")
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidLoad()
        
        EnterpriseColor.nonLblBtn(btnFindPw)
        textEmail.delegate = self
        
        addToolBar(textFields: [textEmail])
        
        lblEmail.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidAppear(animated)
        if let tempemail = prefs.value(forKey: "search_email") as? String {
            textEmail.text = tempemail
        }
    }
    // MARK: - @IBAction
    // MARK: navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func SearchClick(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        searchAction()
    }
    // MARK: - @func
    // MARK: 비밀번호 찾기 button event
    func searchAction() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let email = textEmail.text!.base64Encoding()
        IndicatorSetting()
        NetworkManager.shared().SearchPassword(email: email) { (isSuccess, error, resultCode) in
            if (isSuccess) {
                if error == 1 {
                    if resultCode == 1 {
                        prefs.setValue(self.textEmail.text!, forKey: "search_email")
                        let vc = SearchPassPopUp()
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true, completion: nil)
                    }else {
                        self.toast("E-mail을 다시 확인해주세요.\n 가입된 아이디가 아닙니다.")
                    }
                }else {
                   self.customAlertView("다시 시도해 주세요.")
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
extension SearchPass: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        textField.resignFirstResponder()
        searchAction()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        lblEmail.isHidden = false
        vwLine1.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        if textField.text == "" {
            lblEmail.isHidden = true
        }else if !(textField.text?.validate("email"))! {
            customAlertView("이메일 형식에 맞지 않습니다. 다시 입력해 주세요", textField)
        }
        vwLine1.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
    }
}
