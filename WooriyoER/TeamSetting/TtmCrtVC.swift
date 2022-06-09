//
//  TtmCrtVC.swift
//  PinPle
//
//  Created by WRY_010 on 17/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TtmCrtVC: UIViewController, NVActivityIndicatorViewable {
    
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
    
    override func viewDidLoad() {
        print("\n-----------------[UIViewController : \(self) ]---------------------\n")
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidLoad()
        prefs.setValue(12, forKey: "stage")
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
        let vc = TmCrtSB.instantiateViewController(withIdentifier: "TemCmpltVC") as! TemCmpltVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func create(_ sender: UIButton) {
        let cmpsid = CompanyInfo.sid
        let name = textTName.text!
        let memo = textTMemo.text!
        let phone = textTPhone.text!
        if name != "" {
            IndicatorSetting()
            NetworkManager.shared().RegTeam(temflag: true, cmpsid: cmpsid, name: name.urlEncoding(), memo: memo.urlEncoding(), phone: phone) { (isSuccess, error, result) in
                if (isSuccess) {
                    if error == 1 {
                        switch result {
                        case 0://실패
                            self.customAlertView("다시 시도해 주세요.")
                        case -1://동일팀 존재
                            self.customAlertView("이미 존재하는 팀입니다.\n 다시 확인해주세요.")
                        default:
                            let vc = TmCrtSB.instantiateViewController(withIdentifier: "TtmCmpltVC") as! TtmCmpltVC
                            prefs.setValue(name, forKey: "crt_ttmname")
                            prefs.setValue(result, forKey: "crt_ttmsid")                            
                            vc.modalPresentationStyle = .overFullScreen
                            vc.modalTransitionStyle = .crossDissolve
                            self.present(vc, animated: false, completion: nil)
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
        }else {
            self.customAlertView("상위팀명은 필수입니다.")
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + UIScreen.main.bounds.height * 0.2
        self.scrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }    
    
}
extension TtmCrtVC: UITextFieldDelegate {
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
extension TtmCrtVC: UITextViewDelegate {
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

