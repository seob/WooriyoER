//
//  CmpInfoVC.swift
//  PinPle
//
//  Created by WRY_010 on 27/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmpInfoVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var companyImg: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEName: UILabel!
    @IBOutlet weak var textAddress: UITextField!
    @IBOutlet weak var textNumber: UITextField!
    @IBOutlet weak var textUrl: UITextField!
    
    @IBOutlet weak var vwLine1: UIView!
    @IBOutlet weak var vwLine2: UIView!
    @IBOutlet weak var vwLine3: UIView!
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblUrl: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnNext: UILabel!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    
    var profileImg = UIImage(named: "btn_logo")
    var flag = false
    var fontSize: CGFloat = 0.0
    
    var cmpname: String = ""
    var cmpenname: String = ""
    var cmpaddr: String = ""
    var cmppn: String = ""
    var site: String = ""
    
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
    
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        prefs.setValue(4, forKey: "stage")
        btnNext.layer.cornerRadius = 6
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textAddress.delegate = self
        textNumber.delegate = self
        textUrl.delegate = self
        
        addToolBar(textFields: [textAddress, textNumber, textUrl])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.cmpname = CompanyInfo.name
        self.cmpenname = CompanyInfo.enname
        self.cmpaddr = CompanyInfo.addr
        self.cmppn = CompanyInfo.phone
        self.site = CompanyInfo.site
        
        if cmpaddr != "" {
            lblAddress.isHidden = false
        }else {
            lblAddress.isHidden = true
        }
        
        if cmppn != "" {
            lblNumber.isHidden = false
        }else {
            lblNumber.isHidden = true
        }
        
        if site != "" {
            lblUrl.isHidden = false
        }else {
            lblUrl.isHidden = true
        }
        
        lblEName.text = cmpenname
        lblName.text = cmpname
        textAddress.text = cmpaddr
        textNumber.text = cmppn
        textUrl.text = site
         
        if CompanyInfo.logo != "" {
            if CompanyInfo.logo.urlTrim() != "img_logo_default.png" {
                profileImg = self.urlImage(url: CompanyInfo.logo)
            }
        }
        companyImg.image = profileImg        
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidDisappear(animated)
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
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
    //MARK: @IBAction
    @IBAction func btnNext(_ sender: UIButton) {
        let cmpsid = CompanyInfo.sid
        let pn = textNumber.text!.urlEncoding()
        let addr = textAddress.text!.urlEncoding()
        let site = textUrl.text!.urlEncoding()
        
        IndicatorSetting()
        let url: String = urlClass.set_cmp_addinfo(cmpsid: cmpsid, pn: pn, addr: addr, site: site)
        httpRequest.get(urlStr: url) { (success, jsonData) in
            if success {
                print(url)
                print(jsonData)
                
                CompanyInfo.addr = self.textAddress.text!
                CompanyInfo.phone = self.textNumber.text!
                CompanyInfo.site = self.textUrl.text!
                
                let vc = CmpCrtSB.instantiateViewController(withIdentifier: "RegMgrVC") as! RegMgrVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
        }
    }
    
    @IBAction func profileImageClick(_ sender: UIButton) {
        var vc = CmpCrtSB.instantiateViewController(withIdentifier: "LogoRegVC") as! LogoRegVC
        if SE_flag {
            vc = CmpCrtSB.instantiateViewController(withIdentifier: "SE_LogoRegVC") as! LogoRegVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    //MARK: func
    func valueCheck() -> Bool {
        let pn = textNumber.text!
        let addr = textAddress.text!
        let site = textUrl.text!
        
        if pn == "" {
            self.customAlertView("대표번호를 입력하세요.", textNumber)
            return false
        }else if !pn.validate("phone") || !pn.validate("tele") {
            self.customAlertView("전화번호 형식에 맞지 않습니다.\n 다시입력해주세요", textNumber)
            textNumber.text = ""
            return false
        }else if addr == "" {
            self.customAlertView("주소를 입력하세요", textAddress)
            return false
        }else if !site.isValidURL {
            self.customAlertView("웹사이트를 URL에 맞게 다시 입력해주세요.", textUrl)
            textUrl.text = ""
            return false
        }
        return true
    }
    
}
extension CmpInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textAddress {
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
        if textField == textAddress {
            lblAddress.isHidden = false
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }else if textField == textNumber {
            lblNumber.isHidden = false
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }else {
            lblUrl.isHidden = false
            vwLine3.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textAddress {
            if textField.text == "" {
                lblAddress.isHidden = true
            }
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }else if textField == textNumber {
            if textField.text == "" {
                lblNumber.isHidden = true
            }
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }else {
            if textField.text == "" {
                lblUrl.isHidden = true
            }
            vwLine3.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }
    }
}
