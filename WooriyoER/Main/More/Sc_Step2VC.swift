//
//  Sc_Step2VC.swift
//  PinPle
//
//  Created by seob on 2021/11/11.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class Sc_Step2VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var TextName: TextFieldEffects!
    @IBOutlet weak var lblBirth: UILabel!
    @IBOutlet weak var TextPhone: TextFieldEffects!
    @IBOutlet weak var TextAddr: TextFieldEffects!
     
    @IBOutlet weak var chkimgBirth: UIImageView!
    @IBOutlet weak var chkimgPhone: UIImageView!
    @IBOutlet weak var chkimgAddr: UIImageView!
    
    
    @IBOutlet weak var BirthView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnNext: UIButton!
    
    var dateFormatter = DateFormatter()
    var textDateFormatter = DateFormatter()
    var selInfo : ScEmpInfo = ScEmpInfo()
    
    var showDate: String = ""
    var inputDate: String = ""
    var textFields : [UITextField] = []
    var tmflag = 0
    var joindt = ""
    var birth = ""
    var spot = ""
    var dept = ""
    var phone = ""
    var addr = ""
    var name = ""
    var jumin = ""
    var purpose = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        if selInfo.format == 0 {
            lblNavigationTitle.text = "핀플 입사 보안서약서"
        }else{
            lblNavigationTitle.text = "핀플 퇴사 보안서약서"
        }
        
    }
    
    
    func setUi(){
        TextName.isEnabled = false
        textFields = [TextName , TextPhone , TextAddr ]
        for textfield in textFields {
            textfield.delegate = self
        }
        addToolBar(textFields: textFields)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
       
        
        if birth == "1900-01-01" || birth == "" {
            lblBirth.text =  DefaultBirthDay().replacingOccurrences(of: "-", with: ".")
        }else {
            lblBirth.text = birth.replacingOccurrences(of: "-", with: ".")
        }
        
        
        let startyGestuure = UITapGestureRecognizer(target: self, action: #selector(startdatePicker))
        self.BirthView.isUserInteractionEnabled = true
        self.BirthView.addGestureRecognizer(startyGestuure)
         
    }
    
    @objc func startdatePicker(_ sender: UIGestureRecognizer){
        birth = lblBirth.text ?? ""
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let inputData = dateFormatter.date(from: birth) ?? Date()
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택", doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: inputData, minimumDate: nil, maximumDate: Date(), datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                
                self.lblBirth.text = formatter.string(from: dt)
            }
        }
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addr = (selInfo.addr != "" ? selInfo.addr : CompanyInfo.addr)
        name = selInfo.name
        birth = selInfo.birth
        spot = selInfo.spot
        phone = selInfo.phonenum
        
        
        TextName.text = name
        lblBirth.text = birth
        TextAddr.text = addr
        TextPhone.text = phone
         
        
        if lblBirth.text != "" {
            chkimgBirth.image = chkstatusAlertpass
        }
        
        if TextPhone.text != "" {
            chkimgPhone.image = chkstatusAlertpass
        }
        
        if TextAddr.text != "" {
            chkimgAddr.image = chkstatusAlertpass
        }
         
        setUi()
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
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_Step1VC") as! Sc_Step1VC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = self.selInfo
        self.present(vc, animated: false, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        birth = lblBirth.text ?? ""
        phone = TextPhone.text ?? ""
        addr  = TextAddr.text ?? ""
        
        if birth == "" {
            self.toast("생년월일을 입력해주세요.")
            lblBirth.becomeFirstResponder()
            return
        }else if phone == "" {
            self.toast("연락처를 입력해주세요.")
            TextPhone.becomeFirstResponder()
            return
        }else if addr == "" {
            self.toast("주소를 입력해주세요.")
            TextAddr.becomeFirstResponder()
            return
        }else{
            NetworkManager.shared().udSecurtEmply(CEYSID: selInfo.sid, SPOT: spot.urlEncoding(),  BI: birth.base64Encoding(), PN: phone.base64Encoding(), ADDR: addr.urlBase64Encoding()) { (isSuccess, resCode) in
                if(isSuccess){
                    if(resCode == 1){
                        let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_step3VC") as! Sc_step3VC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.selInfo = self.selInfo
                        self.present(vc, animated: true, completion: nil)
                         
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
        }
    }
     
}


// MARK: - UITextFieldDelegate
extension Sc_Step2VC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TextName.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let str = textField.text ?? ""
       if textField == TextPhone {
            if str != "" {
                chkimgPhone.image = chkstatusAlertpass
            }else{
                chkimgPhone.image = chkstatusAlert
            }
        }else if textField == TextAddr {
            if str != "" {
                chkimgAddr.image = chkstatusAlertpass
            }else{
                chkimgAddr.image = chkstatusAlert
            }
        }
    }
}
