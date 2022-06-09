//
//  EditNoticeVC.swift
//  PinPle
//
//  Created by seob on 2022/02/11.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit

class EditNoticeVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var textTName: UITextField!
    @IBOutlet weak var textTMemo: UITextView!
    
    @IBOutlet weak var lblTName: UILabel!
    @IBOutlet weak var lblTMemo: UILabel!
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    @IBOutlet weak var vwLine1: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblSave: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var strTitle = ""
    var strMemo = ""
    var sid = 0
    var noticeDetail : NoticeListInfo = NoticeListInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n---------- [ noticeDetail : \(noticeDetail.toJSON()) ] ----------\n")
        EnterpriseColor.eachLblBtn(btnSave, lblSave)
        
        textTName.delegate = self
        textTMemo.delegate = self
         
        addToolBar(textFields: [textTName], textView: textTMemo)
        
        textTMemo.layer.cornerRadius = 6
        textTMemo.layer.borderWidth = 1
        textTMemo.layer.borderColor = UIColor.init(hexString: "#DADADA").cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDtail()
 
    }
    
    func getDtail(){
        var noticeSid = 0
        if noticeType  > 0 {
            noticeSid = noticeGidx
        }else{
            noticeSid = noticeDetail.sid
        }
        NetworkManager.shared().getNoticeDetailApp(sid: noticeSid) { isSuccess, resData in
            if isSuccess {
                guard let serverData = resData else { return }
                self.noticeDetail = serverData
                self.textTName.text = serverData.title
                self.textTMemo.text = serverData.content
                if serverData.content != "" {
                    self.lblPlaceholder.isHidden = true
                }
            }
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
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
             
            NetworkManager.shared().UdtNotice(nsid: noticeDetail.sid, title: title, memo: memo) { isSuccess, resCode in
                if isSuccess {
                    DispatchQueue.main.async {
                        if resCode == 1 {
                            let vc = MainSB.instantiateViewController(withIdentifier: "NoticeDetailVC") as! NoticeDetailVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.noticeDetail = self.noticeDetail
                            vc.type = 1
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
    
    @IBAction func delTem(_ sender: UIButton) {
        let vc = MainSB.instantiateViewController(withIdentifier: "NoticeDelPopUp") as! NoticeDelPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.sid = noticeDetail.sid
        self.present(vc, animated: true, completion: nil)
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
extension EditNoticeVC: UITextFieldDelegate {
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
extension EditNoticeVC: UITextViewDelegate {
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


