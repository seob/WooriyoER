//
//  SearchId.swift
//  PinPle
//
//  Created by WRY_010 on 2019/12/05.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class SearchId: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textPhone: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var vwLine1: UIView!
    @IBOutlet weak var vwLine2: UIView!
    @IBOutlet weak var btnFindId: UIButton!
    
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
        
        EnterpriseColor.nonLblBtn(btnFindId)
        textName.delegate = self
        textPhone.delegate = self
        
        self.addToolBar(textFields: [textName, textPhone])
        
        lblName.isHidden = true
        lblPhone.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidAppear(animated)
    }
    // MARK: - @IBAction
    // MARK: navigaion back button
    @IBAction func barBack(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    // MARK: 이메일 찾기 button
    @IBAction func SearchClick(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        if valueCheck() {
            searchAction()
        }
    }
    // MARK: - @func
    // MARK: 이메일 찾기 button event
    func searchAction() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let name = textName.text!.urlBase64Encoding()
        let phone = textPhone.text!.base64Encoding()
        IndicatorSetting()
        NetworkManager.shared().SearchEmail(name: name, phone: phone) { (isSuccess, error, result) in
            if (isSuccess) {
                if error == 1 {
                    if result != "" {
                        prefs.setValue(result, forKey: "search_email")
                        let vc = SearchIdPopUp()
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true, completion: nil)
                    }else {
                        self.toast("가입된 아이디가 없습니다. 다시 확인해 주세요.")
                    }
                }else if error == 0 {
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
    // MARK: 텍스트 값 체크
    func valueCheck() -> Bool {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let name = textName.text!
        let phone = textPhone.text!
        if name == "" {
            customAlertView("이름을 입력하세요.", textName)
            return false
        }else if phone == "" {
            customAlertView("핸드폰 번호를 입력하세요.", textPhone)
            return false
        }
        return true
    }
}
// MARK: - extension UITextFieldDelegate
extension SearchId: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        if textField == textName {
            textField.resignFirstResponder()
            textPhone.becomeFirstResponder()
        }else if textField == textPhone {
            textField.resignFirstResponder()
            searchAction()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        if textField == textName {
            lblName.isHidden = false
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }else if textField == textPhone {
            lblPhone.isHidden = false
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        if textField == textName {
            if textField.text == "" {
                lblName.isHidden = true
            }else if !(textField.text?.validate("name"))! {
                customAlertView("이름은 한글만 사용 가능합니다. 다시 입력해 주세요.", textField)
            }
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }else if textField == textPhone {
            if textField.text == "" {
                lblPhone.isHidden = true
            }else if !(textField.text?.validate("phone"))! {
                customAlertView("휴대폰 형식에 맞지 않습니다. 다시 입력해 주세요.", textField)
            }
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }
    }
}
