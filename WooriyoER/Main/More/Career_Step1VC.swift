//
//  Career_Step1VC.swift
//  PinPle
//
//  Created by seob on 2020/08/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Career_Step1VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var TextName: TextFieldEffects!
    @IBOutlet weak var TextSpot: TextFieldEffects!
    @IBOutlet weak var TextTeam: TextFieldEffects!
    @IBOutlet weak var lblBirth: UILabel!
    @IBOutlet weak var TextPhone: TextFieldEffects!
    @IBOutlet weak var TextAddr: TextFieldEffects!
    @IBOutlet weak var Textpur: TextFieldEffects!
    @IBOutlet weak var Texttask: TextFieldEffects!
    
    @IBOutlet weak var chkimgName: UIImageView!
    @IBOutlet weak var chkimgSpot: UIImageView!
    @IBOutlet weak var chkimgTeam: UIImageView!
    @IBOutlet weak var chkimgBirth: UIImageView!
    @IBOutlet weak var chkimgPhone: UIImageView!
    @IBOutlet weak var chkimgAddr: UIImageView!
    @IBOutlet weak var chkimgJumin: UIImageView!
    @IBOutlet weak var chkimgTask: UIImageView!
    
    @IBOutlet weak var StartView: UIView!
    @IBOutlet weak var EndView: UIView!
    @IBOutlet weak var lblStartdt: UILabel!
    @IBOutlet weak var lblEnddt: UILabel!
    @IBOutlet weak var chkImgStart: UIImageView! //시작 error
    @IBOutlet weak var BirthView: UIView!
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
    var startdt = ""
    var enddt = ""
    var ldt = ""
    var task  = "담당업무"
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textFields = [TextName , TextSpot , TextTeam , Texttask , TextPhone , Textpur ]
        addToolBar(textFields: textFields)
        
        for textField in textFields {
            textField.delegate = self
        }
        
        if startdt == "1900-01-01" || startdt == "" {
            lblStartdt.text = todayDateKo().replacingOccurrences(of: "-", with: ".")
            chkImgStart.image = chkstatusAlertpass
        }else {
            lblStartdt.text = startdt.replacingOccurrences(of: "-", with: ".")
        }
        
        if lblStartdt.text != "" {
            chkImgStart.image = chkstatusAlertpass
        }
        
        if enddt == "1900-01-01"  || enddt == "" {
            lblEnddt.text = ""
        }else {
            lblEnddt.text = enddt.replacingOccurrences(of: "-", with: ".")
        }
        
        if birth == "1900-01-01" || birth == "" {
            lblBirth.text =  DefaultBirthDay().replacingOccurrences(of: "-", with: ".")
        }else {
            lblBirth.text = birth.replacingOccurrences(of: "-", with: ".")
        }
        
        let startyGestuure = UITapGestureRecognizer(target: self, action: #selector(startdatePicker))
        self.StartView.isUserInteractionEnabled = true
        self.StartView.addGestureRecognizer(startyGestuure)
        
        
        let endGestuure = UITapGestureRecognizer(target: self, action: #selector(enddatePicker))
        self.EndView.isUserInteractionEnabled = true
        self.EndView.addGestureRecognizer(endGestuure)
        
        let birthGestuure = UITapGestureRecognizer(target: self, action: #selector(birthdatePicker))
        self.BirthView.isUserInteractionEnabled = true
        self.BirthView.addGestureRecognizer(birthGestuure)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addr = selInfo.addr
        name = selInfo.name
        dept = selInfo.dept
        birth = selInfo.birth
        spot = selInfo.spot
        phone = selInfo.phonenum
        purpose = selInfo.purpose
        task = selInfo.task
        
        TextName.text = name
        TextSpot.text = spot
        TextTeam.text = dept
        lblBirth.text = birth
        TextPhone.text = phone
        Textpur.text = purpose
        Texttask.text = task
        
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
         
        if Textpur.text != "" {
            chkimgJumin.image = chkstatusAlertpass
        }
        
        if Texttask.text != "" {
            chkimgTask.image = chkstatusAlertpass
        }
        
        setUi()
    }
    
    @objc func startdatePicker(_ sender: UIGestureRecognizer){
        startdt = lblStartdt.text ?? ""
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let inputData = dateFormatter.date(from: startdt) ?? Date()
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택", doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: inputData, minimumDate: nil, maximumDate: nil, datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                
                self.lblStartdt.text = formatter.string(from: dt)
            }
        }
    }
    
    @objc func enddatePicker(_ sender: UIGestureRecognizer){
        enddt = lblEnddt.text ?? ""
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let inputData = dateFormatter.date(from: enddt) ?? Date()
        
        let sdt = lblStartdt.text ?? ""
        let minDate = dateFormatter.date(from: sdt) ?? Date()
        
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택", doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: inputData, minimumDate: minDate, maximumDate: nil, datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                
                self.lblEnddt.text = formatter.string(from: dt)
            }
            
            if date == nil {
                self.lblEnddt.text = ""
            }
        }
    }
    
    @objc func birthdatePicker(_ sender: UIGestureRecognizer){
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
    
    @objc func keyboardWillShow(_ notification:Notification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
    
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = CertifiSB.instantiateViewController(withIdentifier: "Career_empListVC") as! Career_empListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        spot = TextSpot.text ?? ""
        dept = TextTeam.text ?? ""
        birth = lblBirth.text ?? ""
        phone = TextPhone.text ?? ""
        enddt = lblEnddt.text ?? ""
        startdt = lblStartdt.text ?? ""
        enddt = lblEnddt.text ?? ""
        task = Texttask.text ?? ""
        purpose = Textpur.text ?? ""
        
        if spot == "" {
            self.toast("직위를 입력해주세요.")
            TextSpot.becomeFirstResponder()
            return
        }else if dept == "" {
            self.toast("소속을 입력해주세요.")
            TextTeam.becomeFirstResponder()
            return
        }else if task == "" {
            self.toast("담당업무를 입력해주세요.")
            Texttask.becomeFirstResponder()
            return
        }
        else if startdt == "" {
            self.toast("근로시작일을 입력해주세요.")
            return
        } else if birth == "" {
            self.toast("생년월일을 입력해주세요.")
            return
        }else if phone == "" {
            self.toast("연락처를 입력해주세요.")
            TextPhone.becomeFirstResponder()
            return
        }else if purpose == "" {
            self.toast("제출용도를 입력해주세요.")
            Textpur.becomeFirstResponder()
            return
        } else{
            NetworkManager.shared().career_udtCertEmply(CCRSID: selInfo.sid, SPOT: spot.urlEncoding(), DEPT: dept.urlEncoding(), BI: birth.base64Encoding(), PN: phone.base64Encoding(), JDT: startdt.urlEncoding(), LDT: enddt.urlEncoding(), TASK: task.urlEncoding(), PUR: purpose.urlEncoding()) { (isSuccess, resCode) in
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
extension Career_Step1VC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TextName.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let str = textField.text ?? ""
        if textField == TextName {
            if str != "" {
                chkimgName.image = chkstatusAlertpass
            }else{
                chkimgName.image = chkstatusAlert
            }
        }else if textField == TextSpot {
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
        }else if textField == Texttask {
            if str != "" {
                chkimgTask.image = chkstatusAlertpass
            }else{
                chkimgTask.image = chkstatusAlert
            }
        }else if textField == TextPhone {
            if str != "" {
                chkimgPhone.image = chkstatusAlertpass
            }else{
                chkimgPhone.image = chkstatusAlert
            }
        }else if textField == Textpur {
            if str != "" {
                chkimgJumin.image = chkstatusAlertpass
            }else{
                chkimgJumin.image = chkstatusAlert
            }
        }
    }
    //주민번호 자동 하이픈
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        if textField == TextJumin {
    //
    //            let moddedLength = (textField.text?.count ?? 0) - (range.length - string.count)
    //
    //            if moddedLength >= 9 {
    //                return false
    //            }
    //
    //
    //            if self.range(range, containsLocation: 6) {
    //                textField.text = formatJumin((textField.text as NSString?)?.replacingCharacters(in: range, with: string))
    //                return false
    //            }
    //        }
    //        return true
    //    }
    
    func formatJumin(_ preFormatted: String?) -> String? {
        //delegate only allows numbers to be entered, so '-' is the only non-legal char.
        var workingString = preFormatted?.replacingOccurrences(of: "-", with: "")
        
        //insert second '-'
        if (workingString?.count ?? 0) > 6 {
            workingString = (workingString as NSString?)?.replacingCharacters(in: NSRange(location: 6, length: 0), with: "-")
        }
        
        return workingString
        
    }
    
    func range(_ range: NSRange, containsLocation location: Int) -> Bool {
        if range.location <= location && range.location + range.length >= location {
            return true
        }
        
        return false
    }
}
