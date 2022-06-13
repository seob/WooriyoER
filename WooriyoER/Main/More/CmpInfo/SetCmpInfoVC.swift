//
//  SetCmpInfoVC.swift
//  PinPle
//
//  Created by WRY_010 on 25/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit 

class SetCmpInfoVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!    
    @IBOutlet weak var companyImg: UIImageView!
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textEname: UITextField!
    @IBOutlet weak var textAddress: UITextField!
    @IBOutlet weak var textNumber: UITextField!
    @IBOutlet weak var textUrl: UITextField!
    @IBOutlet weak var textCeo: UITextField!
    
    @IBOutlet weak var vwLine1: UIView!
    @IBOutlet weak var vwLine2: UIView!
    @IBOutlet weak var vwLine3: UIView!
    @IBOutlet weak var vwLine4: UIView!
    @IBOutlet weak var vwLine5: UIView!
    @IBOutlet weak var vwLine6: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblUrl: UILabel!
    @IBOutlet weak var lblCeo: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var logoImg: UIImage!
    var logoimage = "" // 2020.01.15 seob
    var flag = false
    var fontSize: CGFloat = 0.0
    
    var logo: String = ""
    var name: String = ""
    var enname: String = ""
    var addr: String = ""
    var phone: String = ""
    var site: String = ""
    var changeLogo = 0
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnSave)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textName.delegate = self
        textEname.delegate = self
        textAddress.delegate = self
        textNumber.delegate = self
        textUrl.delegate = self
        companyImg.makeRounded()
        addToolBar(textFields: [textName, textEname, textAddress, textNumber, textUrl , textCeo])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
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
        let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }

    //MARK: @IBAction
    @IBAction func profileImageClick(_ sender: UIButton){
        var vc = MoreSB.instantiateViewController(withIdentifier: "LogoVC") as! LogoVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_LogoVC") as! LogoVC
        }
        vc.logoimg = logoimage
        vc.logoImg = companyImg.image
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        /*
         Pinpl Android SmartPhone APP으로부터 요청받은 데이터 처리(회사 정보 수정)
         Return  - 성공:1, 실패:0
         Parameter
         CMPSID        회사번호
         NM            회사이름 - URL 인코딩 .. 필수
         ENNM        영문회사이름 - URL 인코딩
         PN            대표전화번호 - URL 인코딩(-, 띄어쓰기 처리할것인지..)
         ADDR        주소 - URL 인코딩
         SITE        사이트주소 - URL 인코딩 (http://, https:// 제거 url 패턴 검사 후 전달)
         */
        if valueCheck(){
            let cmpsid = userInfo.cmpsid
            let name = textName.text!.urlEncoding()
            let enname = textEname.text!.urlEncoding()
            let phone = textNumber.text!.urlEncoding()
            let addr = textAddress.text!.urlEncoding()
            let site = httpTrim(textUrl.text!).urlEncoding()
            let ceo = textCeo.text!.urlEncoding()
            
            
            let changename = textName.text ?? ""
            let changeenname = textEname.text ?? ""
            let changephone = textNumber.text ?? ""
            let changeaddr = textAddress.text ?? ""
            let changesite = textUrl.text ?? ""
            let changeceo = textCeo.text ?? ""
             
            
            if (changename != moreCmpInfo.name || changeenname != moreCmpInfo.enname || changephone != moreCmpInfo.phone || changeaddr != moreCmpInfo.addr || changesite != moreCmpInfo.site || changeceo != moreCmpInfo.ceoname || changeLogo == 1){
                let vc = MoreSB.instantiateViewController(withIdentifier: "ChangePopUpOk") as! ChangePopUpOk
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                vc.selname = changename
                vc.selenname = changeenname
                vc.seladdr = changeaddr
                vc.selsite = changesite
                vc.selphone = changephone
                vc.selceo = changeceo
                self.present(vc, animated: false, completion: nil)
            }else{
                NetworkManager.shared().UdtCmpinfo(cmpsid: cmpsid, name: name, enname: enname, phone: phone, addr: addr, site: site, ceo: ceo) { (isSuccess, resultCode) in
                    if (isSuccess) {
                        if resultCode == 1 {
                            let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false, completion: nil)
                        }else {
                           self.customAlertView("잠시 후, 다시 시도해 주세요.")
                        }
                    }else {
                       self.customAlertView("다시 시도해 주세요.")
                    }
                }
            }
        }
 
    }
     
    //MARK: @objc
    
    @objc func keyboardWillShow(_ notification:Notification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
   
    //MARK: func
    func valueSetting() {
         var img = UIImage(named: "btn_logo")
         if moreCmpInfo.logo.urlTrim() != "img_photo_default.png" {
             img = self.urlImage(url: moreCmpInfo.logo)
            self.changeLogo = 0
         }
         if prefs.object(forKey: "cmp_mbr_logo") != nil {
             let profile = prefs.object(forKey: "cmp_mbr_logo") as? NSData
             img = UIImage(data: profile! as Data)
             prefs.removeObject(forKey: "cmp_mbr_logo")
            self.changeLogo = 1
         }
   
        self.logoimage = moreCmpInfo.logo
        self.logoImg = img
        self.companyImg.image = img
        self.textName.text = moreCmpInfo.name
        self.textEname.text = moreCmpInfo.enname
        self.textAddress.text = moreCmpInfo.addr
        self.textNumber.text = moreCmpInfo.phone
        self.textUrl.text = moreCmpInfo.site
        self.textCeo.text = moreCmpInfo.ceoname
        
    }
    
    func valueCheck() -> Bool {
        let name = textName.text ?? ""
        let enname = textEname.text ?? ""
        //        let addr = textAddress.text!
        let site = textUrl.text ?? ""
        
        if name == "" {
            self.customAlertView("회사명은 필수 입니다.", textName)
            return false
        }else if site != "" {
            if !site.isValidURL {
                self.customAlertView("웹사이트를 URL에 맞게 다시 입력해주세요.", textUrl)
                textUrl.text = ""
                return false
            }
        }
        return true
    }
    func httpTrim(_ url: String) -> String {
        let arr = url.components(separatedBy: ["/"])        
        if arr[0] == "http:" || arr[0] == "https:" {
            let start = url.index(url.firstIndex(of: "/")!, offsetBy: 2)
            let end = url.index(before: url.endIndex)
            let subUrl = url[start...end]
            return String(subUrl)
        }
        return url
    }
}
extension SetCmpInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textName {
            textField.resignFirstResponder()
            textEname.becomeFirstResponder()
        }else if textField == textEname {
            textField.resignFirstResponder()
            textAddress.becomeFirstResponder()
        }else if textField == textAddress {
            textField.resignFirstResponder()
            textNumber.becomeFirstResponder()
        }else if textField == textNumber {
            textField.resignFirstResponder()
            textUrl.becomeFirstResponder()
        }else if textField == textUrl {
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textName {
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }else if textField == textEname {
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }else if textField == textAddress {
            vwLine3.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }else if textField == textNumber {
            vwLine4.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }else if textField == textUrl {
            vwLine5.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textName {
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }else if textField == textEname {
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }else if textField == textAddress {
            vwLine3.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }else if textField == textNumber {
            vwLine4.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }else if textField == textUrl {
            vwLine5.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }
    }
}
