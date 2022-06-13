//
//  UbtMbrInfoVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/12/05.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class UdtMbrInfoVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textEnname: UITextField!
    @IBOutlet weak var textBcemail: UITextField!
    @IBOutlet weak var textEmpNumber: UITextField!
    @IBOutlet weak var textBirthDay: UITextField!
    @IBOutlet weak var textJoinType: UITextField!
    @IBOutlet weak var textPhone: UITextField!
    @IBOutlet weak var btnLunar: UIButton!
    @IBOutlet weak var lblMgrCmt: UILabel!
    @IBOutlet weak var btnMan: UIButton!
    @IBOutlet weak var btnWoman: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var dateFormatter = DateFormatter()
    var textDateFormatter = DateFormatter()
    
    var showDate = ""
    var inputDate = ""
    var ori_birth = ""
    
    var mbrsid = 0
    var bcemail = ""
    var birth = ""
    var email = ""
    var empnum = ""
    var enname = ""
    var gender = 0
    var join = ""
    var lunar = 0
    var name = ""
    var phonenum = ""
    var profimg = ""
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnSave)
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.borderColor = UIColor.clear.cgColor
        imgProfile.clipsToBounds = true
        
        textName.delegate = self
        textEnname.delegate = self
        textBcemail.delegate = self
        textEmpNumber.delegate = self
        textBirthDay.delegate = self
        textPhone.delegate = self
        
        
        addToolBar(textFields: [textName, textEnname, textBcemail, textEmpNumber, textBirthDay,textPhone])
        btnMan.setImage(UIImage(named: "er_checkbox"), for: .selected)
        btnMan.setImage(UIImage(named: "icon_nonecheck"), for: .normal)
        btnWoman.setImage(UIImage(named: "er_checkbox"), for: .selected)
        btnWoman.setImage(UIImage(named: "icon_nonecheck"), for: .normal)
        btnLunar.setImage(UIImage(named: "er_checkbox"), for: .selected)
        btnLunar.setImage(UIImage(named: "icon_nonecheck"), for: .normal)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 100
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        let author = prefs.value(forKey: "author") as! Int
        let author = userInfo.author
        //        let notrc = prefs.value(forKey: "notrc") as! Int
        let notrc = userInfo.notrc
        var mgrCmtStr = ""
        switch author {
        case 1:
            mgrCmtStr = "마스터관리자 / "
        case 2:
            mgrCmtStr = "최고관리자 / "
        case 3:
            mgrCmtStr = "상위팀관리자 / "
        case 4:
            mgrCmtStr = "팀관리자 / "
        default:
            break;
        }
        if notrc == 0 {
            mgrCmtStr += "출퇴근 기록"
        }else {
            mgrCmtStr += "출퇴근 제외"
        }
        lblMgrCmt.text = mgrCmtStr
        //        mbrsid = prefs.value(forKey: "mbrsid") as! Int
        mbrsid = userInfo.mbrsid
        valueSetting()
        
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "MainVC" {
            var vc = UIViewController()
            if SE_flag {
                vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC") as! MainVC
            }else {
                vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            var vc = MoreSB.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            if SE_flag {
                vc = MoreSB.instantiateViewController(withIdentifier: "SE_SettingVC") as! SettingVC
            }else{
                vc = MoreSB.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    func valueSetting() {
        NetworkManager.shared().GetMbrInfo(mbrsid: mbrsid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                userInfo.mbrsid = serverData.mbrsid
                self.bcemail = serverData.bcemail
                self.birth = serverData.birth
                self.email = serverData.email
                self.empnum = serverData.empnum
                self.enname = serverData.enname
                self.gender = serverData.gender
                self.join = serverData.joindt
                self.lunar = serverData.lunar
                self.name = serverData.name
                self.phonenum = serverData.phonenum
                self.profimg = serverData.profimg

                var img = UIImage(named: "logo_pre")
//                if self.profimg.urlTrim() != "img_photo_default.png" {
//                    img = self.urlImage(url: self.profimg)
//                }
                
                               
                if prefs.object(forKey: "mbr_profile") != nil {
                    let profile = prefs.object(forKey: "mbr_profile") as? NSData
                    img = UIImage(data: profile! as Data)
                    prefs.removeObject(forKey: "mbr_profile")
                }
                self.imgProfile.sd_setImage(with: URL(string: self.profimg), placeholderImage: UIImage(named: "logo_pre"))

                self.textEmail.text = self.email
                self.textName.text = self.name
                self.textEnname.text = self.enname
                self.textBcemail.text = self.bcemail
                self.textEmpNumber.text = self.empnum
                self.textPhone.text = self.phonenum
                 
                self.textBirthDay.text = self.birth.replacingOccurrences(of: "-", with: ".")
                if self.lunar == 0 {
                    self.btnLunar.isSelected = false
                }else {
                    self.btnLunar.isSelected = true
                }

                if self.gender == 0 {
                    self.btnMan.isSelected = true
                    self.btnWoman.isSelected = false
                }else {
                    self.btnMan.isSelected = false
                    self.btnWoman.isSelected = true
                }

                let type = prefs.value(forKey: "loginType") as! String
                switch type {
                case "kakao":
                    self.textJoinType.text = "카카오톡 로그인";
                case "google":
                    self.textJoinType.text = "구글 로그인";
                case "naver":
                    self.textJoinType.text = "네이버 로그인";
                case "email":
                    self.textJoinType.text = "이메일 로그인";
                default:
                    break
                }
            }else {
                self.toast("다시 시도해 주세요.")
            }
        }
     
    }
    
    @IBAction func lunarClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print(sender.isSelected)
        if sender.isSelected {
            lunar = 1
        }else{
            lunar = 0
        }
    }
    
    @IBAction func profileClick(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_ProfileVC") as! ProfileVC
        }
        vc.profimg = profimg
        vc.profileImg = imgProfile.image
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        if valueCheck() {
            name = textName.text!.urlBase64Encoding()
            enname = textEnname.text!.urlEncoding()
            bcemail = textBcemail.text!.urlEncoding()
            empnum = textEmpNumber.text!.urlEncoding()
            birth = (textBirthDay.text?.replacingOccurrences(of: ".", with: "-").base64Encoding())!
            phonenum = textPhone.text!.base64Encoding()
            let url = urlClass.mod_mbr_info(mbrsid: mbrsid, name: name, enname: enname, bcem: bcemail, empnum: empnum, birth: birth, lunar: lunar, gender: gender,phonenum: phonenum)
            httpRequest.get(urlStr: url) {(success, jsonData) in
                if success {
                    userInfo.name = self.textName.text ?? ""
                    userInfo.enname = self.textEnname.text ?? ""
                    if viewflag == "MainVC" {
                        var vc = UIViewController()
                        if SE_flag {
                            vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC") as! MainVC
                        }else {
                            vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    }else {
                        var vc = MoreSB.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
                        if SE_flag {
                            vc = MoreSB.instantiateViewController(withIdentifier: "SE_SettingVC") as! SettingVC
                        }else{
                            vc = MoreSB.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    }
                    
                }else {
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
        }
        
    }
    
    // FIXME: valueCheck
    func valueCheck() -> Bool {
        let name = textName.text!
        let enname = textEnname.text ?? ""
        let bcemail = textBcemail.text ?? ""
        let phonenum = textPhone.text ?? ""
        if name == "" {
            self.customAlertView("이름을 입력해 주세요.", textName)
            return false
        }else if !name.validate("koeng") {
            self.customAlertView("이름은 한글 또는 영문만 가능합니다.", textName)
            return false
        }else if enname != "" {
            if !enname.validate("enname") {
                self.customAlertView("영문이름은 영어만 가능합니다.", textEnname)
                return false
            }
        }else if phonenum != "" {
            if !phonenum.validate("phone") {
                customAlertView("핸드폰번호 형식에 맞지않습니다.\n 다시 입력해 주세요.", textPhone)
                return false
            }
        }else if bcemail != "" {
            if !bcemail.validate("email") {
                self.customAlertView("업무메일이 메일 형식에 맞지 않습니다.", textBcemail)
                return false
            }
        }
        
        return true
    }
    //성별 남자
    @IBAction func manClick(_ sender: UIButton) {
        gender = 0
        btnMan.isSelected = true
        btnWoman.isSelected = false
        prefs.setValue(gender, forKey: "gender")
    }
    //성별 여자
    @IBAction func womanClick(_ sender: UIButton) {
        gender = 1
        btnMan.isSelected = false
        btnWoman.isSelected = true
        prefs.setValue(gender, forKey: "gender")
    }
    //생년월일 데이트픽커
    @IBAction func datePicker(_ sender: UITextField) {
        inputDate = textBirthDay.text!
        showDate = textBirthDay.text!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let goDatePickerView = UIDatePicker()
        goDatePickerView.datePickerMode = UIDatePicker.Mode.date
        goDatePickerView.locale = Locale(identifier: "ko_kr")
        goDatePickerView.maximumDate = Date()
        if #available(iOS 13.4, *) {
            goDatePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        sender.inputView = goDatePickerView
        
        if inputDate != "" {
            let date = dateFormatter.date(from: inputDate)
            goDatePickerView.date = date!
        }
        
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        textBirthDay.becomeFirstResponder()
    }
    //MARK: @objc
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        textDateFormatter.dateFormat = "yyyy.MM.dd"
        inputDate = dateFormatter.string(from: sender.date)
        showDate = textDateFormatter.string(from: sender.date)
        if showDate == "" {
            showDate = textDateFormatter.string(from: Date())
            inputDate = dateFormatter.string(from: Date())
        }
        textBirthDay.text = showDate
    }
    
}

extension UdtMbrInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textName:
            textName.resignFirstResponder();
            textEnname.becomeFirstResponder();
        case textEnname:
            textEnname.resignFirstResponder();
            textBcemail.becomeFirstResponder();
        case textBcemail:
            textBcemail.resignFirstResponder();
            textEmpNumber.becomeFirstResponder();
        case textEmpNumber:
            textEmpNumber.resignFirstResponder();
            textPhone.becomeFirstResponder();
        case textPhone:
            textPhone.resignFirstResponder();
            textBirthDay.becomeFirstResponder();
        default:
            break;
        }
        return true
    }
}
