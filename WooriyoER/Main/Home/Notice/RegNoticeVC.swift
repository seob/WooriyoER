//
//  RegNoticeVC.swift
//  PinPle
//
//  Created by seob on 2022/02/11.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit

class RegNoticeVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var textTName: UITextField!
    @IBOutlet weak var textTMemo: UITextView!
    
    @IBOutlet weak var lblTName: UILabel!
    @IBOutlet weak var lblTMemo: UILabel!
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    @IBOutlet weak var vwLine1: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnAdmin: UIButton!
    @IBOutlet weak var adminckImageView: UIImageView!
    @IBOutlet weak var btnEr: UIButton!
    @IBOutlet weak var erckImageView: UIImageView!
    @IBOutlet weak var btnInsert: UIButton!
    @IBOutlet weak var lblInsert: UILabel!
    
    var strTitle = ""
    var strMemo = ""
    var nType = 0
    var nTypeER = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        textTName.delegate = self
        textTMemo.delegate = self
        EnterpriseColor.eachLblBtn(btnInsert, lblInsert)
        addToolBar(textFields: [textTName], textView: textTMemo)
        
        textTMemo.layer.cornerRadius = 6
        textTMemo.layer.borderWidth = 1
        textTMemo.layer.borderColor = UIColor.init(hexString: "#DADADA").cgColor
        nTypeER = 1
        btnEr.isSelected = true
    }
    
    @IBAction func typeDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            nType = 1
            print("\n---------- [ 11 ] ----------\n")
            
            adminckImageView.image = UIImage(named: "er_checkbox")
        }else{
            nType = 0
            print("\n---------- [ 12 ] ----------\n")
            adminckImageView.image = UIImage(named: "icon_nonecheck")
        }
    }
    
    @IBAction func typeerDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            nTypeER = 1
            print("\n---------- [ 21 ] ----------\n")
            erckImageView.image = UIImage(named: "er_checkbox")
        }else{
            nTypeER = 0
            print("\n---------- [ 22 ] ----------\n")
            erckImageView.image = UIImage(named: "icon_nonecheck")
        }
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
        let vc = MainSB.instantiateViewController(withIdentifier: "PinPlNoticeVC") as! PinPlNoticeVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func saveTem(_ sender: UIButton) {
        let title = textTName.text!.urlEncoding()
        let memo = textTMemo.text!.urlEncoding()
        
        if title == "" {
            self.toast("제목을 입력해주세요.")
            return
        }else if memo == "" {
            self.toast("내용을 입력해주세요.")
            return
        }else{
            var mainType = 0
            if (nType == 1 && nTypeER == 1) {
                mainType = 3
            }else if (nType == 1 && nTypeER == 0){
                mainType = 2
            }else if (nType == 0 && nTypeER == 1){
                mainType = 1
            }else{
                mainType = 0
            }
            
            if mainType == 0 {
                customAlertView("보낼 대상을 선택해 주세요.")
            }else{
                NetworkManager.shared().RegNotice(cmpsid: userInfo.cmpsid, empsid: userInfo.empsid, type: mainType, memo: memo, title: title,name: userInfo.name) { isSuccess,  resCode in
                    
                        if isSuccess {
                            DispatchQueue.main.async {
                                if resCode > 0  {
                                    let vc = MainSB.instantiateViewController(withIdentifier: "PinPlNoticeVC") as! PinPlNoticeVC
                                    vc.modalTransitionStyle = .crossDissolve
                                    vc.modalPresentationStyle = .overFullScreen
                                    self.present(vc, animated: false, completion: nil)
                                }else{
                                    self.toast("다시 시도해 주세요")
                                }
                            }
                             
                        }else{
                            self.toast("다시 시도해 주세요")
                        }
                     
                }
                
            }
        } 
    }
    
    @IBAction func delTem(_ sender: UIButton) {
        let vc = MainSB.instantiateViewController(withIdentifier: "PinPlNoticeVC") as! PinPlNoticeVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
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
extension RegNoticeVC: UITextFieldDelegate {
    //키보드 자동 포커스 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField)
        
        if textField == textTName {
            textField.resignFirstResponder()
        }else if textField == textTName {
            textField.resignFirstResponder()
            textTMemo.becomeFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textTName {
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textTName {
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }
    }
}
extension RegNoticeVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        lblPlaceholder.isHidden = true
        textTMemo.layer.borderColor = UIColor.init(hexString: "#043856").cgColor
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" { 
            lblPlaceholder.isHidden = false
        }
        textTMemo.layer.borderColor = UIColor.init(hexString: "#DADADA").cgColor
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
       return true
   }
}


