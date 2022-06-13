//
//  Lc_Default_Step5VC.swift
//  PinPle
//
//  Created by seob on 2020/06/11.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Lc_Default_Step5VC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
//    @IBOutlet weak var Contractdt: UITextField!
    @IBOutlet weak var Addr: TextFieldEffects!
    @IBOutlet weak var AddrDetail: TextFieldEffects!
//    @IBOutlet weak var BirthTxt: UITextField!
    @IBOutlet weak var PhoneTxt: TextFieldEffects!
    @IBOutlet weak var AccountName: TextFieldEffects!
    @IBOutlet weak var AccountNumber: TextFieldEffects!
    @IBOutlet weak var AccountBank: TextFieldEffects!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var ContractView: UIView!
    @IBOutlet weak var BirthView: UIView!
    @IBOutlet weak var lblContract: UILabel!
    @IBOutlet weak var lblBirth: UILabel!
    
    
    
    @IBOutlet weak var chkimgdt: UIImageView!
    @IBOutlet weak var chkimgaddr: UIImageView!
    @IBOutlet weak var chkimgbirth: UIImageView!
    @IBOutlet weak var chkimgphone: UIImageView!
    @IBOutlet weak var chkimgactnm: UIImageView!
    @IBOutlet weak var chkimgbank: UIImageView!
    @IBOutlet weak var chkimgactnum: UIImageView!
    
    
    @IBOutlet weak var stepDot1: UIImageView!
    @IBOutlet weak var stepDot2: UIImageView!
    @IBOutlet weak var stepDot3: UIImageView!
    @IBOutlet weak var stepDot4: UIImageView!
    @IBOutlet weak var stepDot5: UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    
    var dateFormatter = DateFormatter()
    var textDateFormatter = DateFormatter()
    var standInfo : LcEmpInfo = LcEmpInfo()
    
    var showDate: String = ""
    var inputDate: String = ""
    var tmflag = 0
    
    var contractdt : String = ""
    var birth : String = ""
    var textFields : [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnNext)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        setUi()
        
        viewflag = "std_step5"
    }
    func setUi(){
        
        var formTitle = ""
        switch standInfo.form  {
        case 0:
            formTitle = "표준 정규직 계약정보"
        case 1:
            formTitle = "표준 계약직 계약정보"
        case 2:
            formTitle = "표준 시급/소정 계약정보"
        case 3:
            formTitle = "표준 시급/일별 계약정보"
        case 4:
            formTitle = "표준 일급/소정 계약정보 "
        case 5:
            formTitle = "표준 일급/일별 계약정보"
        default:
            break
        }
        
        
        lblNavigationTitle.text = formTitle
        textFields = [ Addr ,   PhoneTxt , AccountName , AccountNumber , AccountBank]
        addToolBar(textFields: textFields)
        for textfield in textFields {
            textfield.delegate = self
        }
        standInfo.actholder = standInfo.actholder == "" ? "필수값" : standInfo.actholder
        standInfo.addr = standInfo.addr == "필수값" ? "" : standInfo.addr
        standInfo.phonenum = standInfo.phonenum == "필수값" ? "" : standInfo.phonenum
        standInfo.actholder = standInfo.actholder == "필수값" ? standInfo.name : standInfo.actholder
        standInfo.actnum = standInfo.actnum == "필수값" ? "" : standInfo.actnum
        standInfo.actbank = standInfo.actbank == "필수값" ? "" : standInfo.actbank
        
        lblContract.text = (standInfo.startdt != ""  ? standInfo.startdt : standInfo.lcdt)
        Addr.text = standInfo.addr
        lblBirth.text = standInfo.birth
        PhoneTxt.text = standInfo.phonenum
        AccountName.text = standInfo.actholder
        AccountNumber.text = standInfo.actnum
        AccountBank.text = standInfo.actbank
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        contractdt = standInfo.lcdt
        if contractdt == "1900-01-01" || contractdt == "" {
            lblContract.text = todayDateKo().replacingOccurrences(of: "-", with: ".")
            
        }else {
            lblContract.text = contractdt.replacingOccurrences(of: "-", with: ".")
        }
        
        birth = standInfo.birth
        if birth == "1900-01-01" || birth == "" {
            lblBirth.text =  DefaultBirthDay().replacingOccurrences(of: "-", with: ".")
        }else {
            lblBirth.text = birth.replacingOccurrences(of: "-", with: ".")
        }
        
        if lblContract.text != "" {
            chkimgdt.image = chkstatusAlertpass
        }
        
        if Addr.text != "" {
            chkimgaddr.image = chkstatusAlertpass
        }
        
        if lblBirth.text != "" {
            chkimgbirth.image = chkstatusAlertpass
        }
        
        if PhoneTxt.text != "" {
            chkimgphone.image = chkstatusAlertpass
        }
        
        if AccountName.text != "" {
            chkimgactnm.image = chkstatusAlertpass
        }
        
        if AccountBank.text != "" {
            chkimgbank.image = chkstatusAlertpass
        }
        
        if AccountNumber.text != "" {
            chkimgactnum.image = chkstatusAlertpass
        }
        
        let contractGestuure = UITapGestureRecognizer(target: self, action: #selector(ContractdatePicker))
        self.ContractView.isUserInteractionEnabled = true
        self.ContractView.addGestureRecognizer(contractGestuure)
        
        let endGestuure = UITapGestureRecognizer(target: self, action: #selector(birthdatePicker))
        self.BirthView.isUserInteractionEnabled = true
        self.BirthView.addGestureRecognizer(endGestuure)
    }
    
    @objc func ContractdatePicker(_ sender: UIGestureRecognizer){
        contractdt = lblContract.text ?? ""
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let inputData = dateFormatter.date(from: contractdt) ?? Date()
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택", doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: inputData, minimumDate: nil, maximumDate: nil, datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                
                self.lblContract.text = formatter.string(from: dt)
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
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
     
    
    
    override func setNeedsFocusUpdate() {
        super.setNeedsFocusUpdate()
        let lcdt = lblContract.text ?? "1900-01-01"
        let addr = Addr.text ?? "필수값"
        let birth = lblBirth.text ?? "1900-01-01"
        let phone = PhoneTxt.text ?? "필수값"
        let actname = AccountName.text ?? "필수값"
        let actnum = AccountNumber.text ?? ""
        let bank = AccountBank.text ?? "필수값"
        
        let address = addr
        
        standInfo.addr = address
        standInfo.birth = birth
        standInfo.phonenum = phone
        standInfo.lcdt = lcdt
        standInfo.actholder = actname
        standInfo.actnum = actnum
        standInfo.actbank = bank
        SelLcEmpInfo = standInfo
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step4VC") as! Lc_Default_Step4VC
        if SE_flag {
            vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_Default_Step4VC") as! Lc_Default_Step4VC
        }else{
            vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step4VC") as! Lc_Default_Step4VC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.standInfo = standInfo
        self.present(vc, animated: false, completion: nil)
        
    }
    @IBAction func NextDidTap(_ sender: Any) {
        let lcdt = lblContract.text ?? "1900-01-01"
        let addr = Addr.text ?? "필수값"
        let birth = lblBirth.text ?? "1900-01-01"
        let phone = PhoneTxt.text ?? "필수값"
        let actname = AccountName.text ?? "필수값"
        let actnum = AccountNumber.text ?? "필수값"
        let bank = AccountBank.text ?? "필수값"
        
        if lcdt == "" {
            toast("계약일을 입력해 주세요.")
            return
        }else if addr == "" {
            toast("주소를 입력해 주세요.")
            return
        }else if birth == "" {
            toast("생년월일을 입력해 주세요.")
            return
        }else if phone == "" {
            toast("연락처를 입력해 주세요.")
            return
        }else if actname == "" {
            toast("예금주를 입력해 주세요.")
            return
        }else if actnum == "" {
            toast("계좌번호를 입력해 주세요.")
            return
        }else if bank == "" {
            toast("은행명을 입력해 주세요.")
            return
        }  else{
            let address = addr
            
            standInfo.addr = address
            standInfo.birth = birth
            standInfo.phonenum = phone
            standInfo.lcdt = lcdt
            standInfo.actholder = actname
            standInfo.actnum = actnum
            standInfo.actbank = bank
            
            
            NetworkManager.shared().lc_std_step5(LCTSID: standInfo.sid, LCDT: lcdt, ADDR: address.urlBase64Encoding(), BIRTH: birth.urlBase64Encoding(), PHONE: phone.base64Encoding(), HOLDER: actname.urlBase64Encoding(), BANK: bank.urlBase64Encoding(), NUM: actnum.base64Encoding()) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        switch moreCmpInfo.freetype {
                            case 2,3:
                                //올프리 , 펀프리
                                if moreCmpInfo.freedt >= self.muticmttodayDate() {
                                    var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step7_FreeVC") as! Lc_Step7_FreeVC
                                    if SE_flag {
                                        vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_Step7_FreeVC") as! Lc_Step7_FreeVC
                                    }
                                    vc.modalTransitionStyle = .crossDissolve
                                    vc.modalPresentationStyle = .overFullScreen
                                    vc.standInfo = self.standInfo
                                    vc.viewflagType = "stand_step5"
                                    
                                    self.present(vc, animated: false, completion: nil)
                                }else{
                                    var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step7VC") as! Lc_Step7VC
                                    if SE_flag {
                                        vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_Step7VC") as! Lc_Step7VC
                                    }
                                    vc.modalTransitionStyle = .crossDissolve
                                    vc.modalPresentationStyle = .overFullScreen
                                    vc.standInfo = self.standInfo
                                    vc.viewflagType = "stand_step5"
                                    
                                    self.present(vc, animated: false, completion: nil)
                                }
                            default :
                                var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step7VC") as! Lc_Step7VC
                                if SE_flag {
                                    vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_Step7VC") as! Lc_Step7VC
                                }
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                vc.standInfo = self.standInfo
                                vc.viewflagType = "stand_step5"
                                
                                self.present(vc, animated: false, completion: nil)
                        }
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
            
        }
    }
    
    //MARK: - pop버튼
    @IBAction func moreBtn(_ sender: UIButton) {
        SelLcEmpInfo = standInfo
        SelLcEmpInfo.viewpage = "std_step5"
        if SE_flag {
            presentPanModal(RowType.sebasic.presentable.rowVC)
        }else{
            presentPanModal(RowType.basic.presentable.rowVC)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension Lc_Default_Step5VC {
    enum RowType: Int, CaseIterable {
        case basic
        case sebasic
        
        var presentable: RowPresentable {
            switch self {
            case .basic: return Basic()
            case .sebasic: return SEBsic()
            }
        }
        
        struct Basic: RowPresentable {
            var viewpage: String = "std_step5"
            let rowVC: PanModalPresentable.LayoutType = ContractInfoPopup()
        }
        
        struct SEBsic: RowPresentable {
            var viewpage: String = "step1"
            let rowVC: PanModalPresentable.LayoutType = SE_ContractInfoPopup()
            
        }
        
    }
}

// MARK: - UITextFieldDelegate
extension Lc_Default_Step5VC: UITextFieldDelegate {
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let str = textField.text ?? ""
         if textField == Addr {
            if str != "" {
                chkimgaddr.image = chkstatusAlertpass
            }else{
                chkimgaddr.image = chkstatusAlert
            }
        }else  if textField == PhoneTxt {
            if str != "" {
                chkimgphone.image = chkstatusAlertpass
            }else{
                chkimgphone.image = chkstatusAlert
            }
        }else if textField == AccountName {
            if str != "" {
                chkimgactnm.image = chkstatusAlertpass
            }else{
                chkimgactnm.image = chkstatusAlert
            }
        }else if textField == AccountNumber {
            if str != "" {
                chkimgactnum.image = chkstatusAlertpass
            }else{
                chkimgactnum.image = chkstatusAlert
            }
        }else if textField == AccountBank {
            if str != "" {
                chkimgbank.image = chkstatusAlertpass
            }else{
                chkimgbank.image = chkstatusAlert
            }
        }
    }
}
