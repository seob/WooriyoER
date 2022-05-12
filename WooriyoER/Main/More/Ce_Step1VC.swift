//
//  Ce_Step1VC.swift
//  PinPle
//
//  Created by seob on 2020/08/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Ce_Step1VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var TextName: TextFieldEffects!
    @IBOutlet weak var TextSpot: TextFieldEffects!
    @IBOutlet weak var TextTeam: TextFieldEffects!
    @IBOutlet weak var lblBirth: UILabel!
    @IBOutlet weak var TextPhone: TextFieldEffects!
    @IBOutlet weak var TextAddr: TextFieldEffects!
    @IBOutlet weak var lblJoindt: UILabel!
    @IBOutlet weak var TextJumin: TextFieldEffects!
    @IBOutlet weak var Textpur: TextFieldEffects!
    
    @IBOutlet weak var chkimgSpot: UIImageView!
    @IBOutlet weak var chkimgTeam: UIImageView!
    @IBOutlet weak var chkimgBirth: UIImageView!
    @IBOutlet weak var chkimgPhone: UIImageView!
    @IBOutlet weak var chkimgAddr: UIImageView!
    @IBOutlet weak var chkimgJoindt: UIImageView!
    @IBOutlet weak var chkimgJumin: UIImageView!
    
    
    @IBOutlet weak var BirthView: UIView!
    @IBOutlet weak var JoindtView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnNext: UIButton!
    
    var dateFormatter = DateFormatter()
    var textDateFormatter = DateFormatter()
    var selInfo : Ce_empInfo = Ce_empInfo()
    
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
        
    }
    
    
    func setUi(){
        TextName.isEnabled = false
        textFields = [TextName , TextSpot , TextTeam , TextPhone , TextAddr , Textpur]
        for textfield in textFields {
            textfield.delegate = self
        }
        addToolBar(textFields: textFields)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
         
        
        if joindt == "1900-01-01" || joindt == "" {
            lblJoindt.text = todayDateKo().replacingOccurrences(of: "-", with: ".")
        }else {
            lblJoindt.text = joindt.replacingOccurrences(of: "-", with: ".")
        }
        
        
        if birth == "1900-01-01" || birth == "" {
            lblBirth.text =  DefaultBirthDay().replacingOccurrences(of: "-", with: ".")
        }else {
            lblBirth.text = birth.replacingOccurrences(of: "-", with: ".")
        }
        
  
        let startyGestuure = UITapGestureRecognizer(target: self, action: #selector(startdatePicker))
        self.BirthView.isUserInteractionEnabled = true
        self.BirthView.addGestureRecognizer(startyGestuure)
        
        
        let endGestuure = UITapGestureRecognizer(target: self, action: #selector(enddatePicker))
        self.JoindtView.isUserInteractionEnabled = true
        self.JoindtView.addGestureRecognizer(endGestuure)
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
    
    @objc func enddatePicker(_ sender: UIGestureRecognizer){
        joindt = lblJoindt.text ?? ""
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let inputData = dateFormatter.date(from: joindt) ?? Date()
        
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택", doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: inputData, minimumDate: nil, maximumDate: nil, datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                
                self.lblJoindt.text = formatter.string(from: dt)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        joindt = selInfo.joindt
        addr = selInfo.addr
        name = selInfo.name
        dept = selInfo.dept
        birth = selInfo.birth
        spot = selInfo.spot
        phone = selInfo.phonenum
          
        
        TextName.text = name
        TextSpot.text = spot
        TextTeam.text = dept
        lblBirth.text = birth
        lblJoindt.text = joindt
        TextAddr.text = addr
        TextPhone.text = phone
        
        if lblJoindt.text != "" {
            chkimgJoindt.image = chkstatusAlertpass
        }
        
        if TextSpot.text != "" {
            chkimgSpot.image = chkstatusAlertpass
        }
        
        if TextTeam.text != "" {
            chkimgTeam.image = chkstatusAlertpass
        }
        
        if lblBirth.text != "" {
            chkimgBirth.image = chkstatusAlertpass
        }
        
        if TextPhone.text != "" {
            chkimgPhone.image = chkstatusAlertpass
        }
        
        if TextAddr.text != "" {
            chkimgAddr.image = chkstatusAlertpass
        }
        
        if Textpur.text != "" {
            chkimgJumin.image = chkstatusAlertpass
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
        let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_empListVC") as! Ce_empListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        spot = TextSpot.text ?? ""
        dept = TextTeam.text ?? ""
        birth = lblBirth.text ?? ""
        phone = TextPhone.text ?? ""
        addr  = TextAddr.text ?? ""
        joindt = lblJoindt.text ?? ""
        purpose = Textpur.text ?? ""
        
        if spot == "" {
            self.toast("직위를 입력해주세요.")
            TextSpot.becomeFirstResponder()
            return
        }else if dept == "" {
            self.toast("소속을 입력해주세요.")
            TextTeam.becomeFirstResponder()
            return
        }else if birth == "" {
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
        }else if joindt == "" {
            self.toast("입사일을 입력해주세요.")
            lblJoindt.becomeFirstResponder()
            return
        }else if purpose == "" {
            self.toast("제출용도를 입력해주세요.")
            Textpur.becomeFirstResponder()
            return
        }else{
            NetworkManager.shared().udtCertEmply(CEYSID: selInfo.sid, SPOT: spot.urlEncoding(), DEPT: dept.urlEncoding(), BI: birth.base64Encoding(), PN: phone.base64Encoding(), ADDR: addr.urlBase64Encoding(), JDT: joindt.urlEncoding() , PUR: purpose.urlEncoding()) { (isSuccess, resCode) in
                if(isSuccess){
                    if(resCode == 1){
                        let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step2VC") as! Ce_Step2VC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.selInfo = self.selInfo
                        self.present(vc, animated: false, completion: nil)
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
extension Ce_Step1VC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TextName.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let str = textField.text ?? ""
        if textField == TextSpot {
            if str != "" {
                chkimgSpot.image = chkstatusAlertpass
            }else{
                chkimgSpot.image = chkstatusAlert
            }
        }else if textField == TextTeam {
            if str != "" {
                chkimgTeam.image = chkstatusAlertpass
            }else{
                chkimgTeam.image = chkstatusAlert
            }
        }else if textField == TextPhone {
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
        }else if textField == Textpur {
            if str != "" {
                chkimgJumin.image = chkstatusAlertpass
            }else{
                chkimgJumin.image = chkstatusAlert
            }
        }
    } 
}
