//
//  AddTemVC.swift
//  PinPle
//
//  Created by WRY_010 on 07/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AddTemVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var textTName: UITextField!
    @IBOutlet weak var textTPhone: UITextField!
    @IBOutlet weak var textTMemo: UITextView!
    
    @IBOutlet weak var lblTName: UILabel!
    @IBOutlet weak var lblTPhone: UILabel!
    @IBOutlet weak var lblTMemo: UILabel!
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    @IBOutlet weak var vwLine1: UIView!
    @IBOutlet weak var vwLine2: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblSave: UILabel!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.eachLblBtn(btnSave, lblSave)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textTName.delegate = self
        textTPhone.delegate = self
        textTMemo.delegate = self
        
        lblTName.isHidden = true
        lblTPhone.isHidden = true
        lblTMemo.isHidden = true
        addToolBar(textFields: [textTName, textTPhone], textView: textTMemo)
        
        textTMemo.layer.cornerRadius = 6
        textTMemo.layer.borderWidth = 1
        textTMemo.layer.borderColor = UIColor.init(hexString: "#DADADA").cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidDisappear(animated)
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func create(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(팀생성)
         Return  - 성공:팀번호, 실패:0, 동일팀명 존재:-1
         Parameter
         CMPSID        회사번호
         NM            팀이름 - URL 인코딩
         MM            팀메모 - URL 인코딩
         PN            전화번호
         */
        let name = httpRequest.urlEncode(textTName.text!)
        let memo = httpRequest.urlEncode(textTMemo.text!)
        let phone = textTPhone.text!
        if name != "" {
            NetworkManager.shared().RegTeam(temflag: false, cmpsid: userInfo.cmpsid, name: name, memo: memo, phone: phone) { (isSuccess, error, resultCode) in
                if (isSuccess) {
                    if error == 1 {
                        switch resultCode {
                        case 0://실패
                            self.customAlertView("다시 시도해 주세요.")
                        case -1://동일팀 존재
                            self.customAlertView("이미 존재하는 팀입니다.\n 다시 확인해주세요.")
                        default:
//                            let vc = TmCrtSB.instantiateViewController(withIdentifier: "TtmListVC") as! TtmListVC
//                            vc.modalTransitionStyle = .crossDissolve
//                            vc.modalPresentationStyle = .overFullScreen
//                            self.present(vc, animated: false, completion: nil)
                            NotificationCenter.default.post(name: .reloadTem, object: nil)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else {
                        self.customAlertView("다시 시도해 주세요.")
                    }
                }else {
                    self.customAlertView("네트워크 상태를 확인해 주세요.")
                }
            }
        }else {
            self.customAlertView("팀명은 필수입력입니다.")
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + UIScreen.main.bounds.height * 0.1
        self.scrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
}
extension AddTemVC: UITextFieldDelegate {
    //키보드 자동 포커스 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField)
        
        if textField == textTName {
            textField.resignFirstResponder()
            textTPhone.becomeFirstResponder()
        }else if textField == textTPhone {
            textField.resignFirstResponder()
            textTMemo.becomeFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textTName {
            lblTName.isHidden = false
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }else if textField == textTPhone {
            lblTPhone.isHidden = false
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textTName {
            if textField.text == "" {
                lblTName.isHidden = true
            }
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }else if textField == textTPhone {
            if textField.text == "" {
                lblTPhone.isHidden = true
            }
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }
    }
}
extension AddTemVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        lblTMemo.isHidden = false
        lblPlaceholder.isHidden = true
        textTMemo.layer.borderColor = UIColor.init(hexString: "#043856").cgColor
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            lblTMemo.isHidden = true
            lblPlaceholder.isHidden = false
        }
        textTMemo.layer.borderColor = UIColor.init(hexString: "#DADADA").cgColor
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("textView.text.count = ", textView.text.count)
        if textView.text.count > 100 {
            textView.text.removeLast()
            let alert = UIAlertController(title: "알림", message: "팀(부서)에 대한 설명은 100자 이내로 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: false, completion: nil)
        }
        if(text == "\n") {
            view.endEditing(true)
            return false
        }else {
            return true
        }
    }
    
}

