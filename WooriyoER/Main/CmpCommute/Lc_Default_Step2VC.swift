//
//  Lc_Default_Step2VC.swift
//  PinPle
//
//  Created by seob on 2020/06/11.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
class Lc_Default_Step2VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    // 시작 뷰
    @IBOutlet weak var StartView: UIView!
    @IBOutlet weak var EndView: UIView!
    @IBOutlet weak var lblStartdt: UILabel!
    @IBOutlet weak var lblEnddt: UILabel!
    
    @IBOutlet weak var chkImgStart: UIImageView! //시작 error
    @IBOutlet weak var chkImgTask: UIImageView! //종료 error
    @IBOutlet weak var chkImgArea: UIImageView! //종료 error
    
    //근무지
    @IBOutlet weak var TextFieldArea: TextFieldEffects!
    //담당업무
    @IBOutlet weak var TextFieldwork: TextFieldEffects!
     
    
    //출근요일
    @IBOutlet weak var btnMon: UIButton!
    @IBOutlet weak var btnTue: UIButton!
    @IBOutlet weak var btnWed: UIButton!
    @IBOutlet weak var btnThu: UIButton!
    @IBOutlet weak var btnFri: UIButton!
    @IBOutlet weak var btnSat: UIButton!
    @IBOutlet weak var btnSun: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var stepDot1: UIImageView!
    @IBOutlet weak var stepDot2: UIImageView!
    @IBOutlet weak var stepDot3: UIImageView!
    @IBOutlet weak var stepDot4: UIImageView!
    @IBOutlet weak var stepDot5: UIImageView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblSummary: UILabel! //설명은 시급별일때만 노출
    @IBOutlet weak var startViewWidthConstraint: NSLayoutConstraint! // default :148 , plus:180 , se:128
    @IBOutlet weak var endViewWidthConstraint: NSLayoutConstraint!
    var standInfo : LcEmpInfo = LcEmpInfo()
    var workday: String = "2,3,4,5,6"         //근무요일.. 1(일),2(월),3(화),4(수),5(목),6(금),7(토) 구분자 ','  .. ex) 2,3,4,5,6
    
    var showDate = ""
    var startdt = ""
    var enddt = ""
    var workstarttm = "09:00"
    var workendtm = "18:00"
    var bkstarttm = "12:00"
    var bkendtm = "13:00"
    var inputData = ""
    
    var dateFormatter = DateFormatter()
    var dateFormatter2 = DateFormatter()
    var tmflag = 0
    var form = 0 
    var textFields : [UITextField] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnNext)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textFields = [TextFieldwork, TextFieldArea ]
        addToolBar(textFields: textFields)
        
        for textField in textFields {
            textField.delegate = self
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let checkDevice = deviceHeight()
        if !SE_flag {
            print("\n---------- [ checkDevice : \(checkDevice) ] ----------\n")
            if checkDevice == 3 {
                startViewWidthConstraint.constant = 170.0
                endViewWidthConstraint.constant = 170.0
            }else{
                startViewWidthConstraint.constant = 148
                endViewWidthConstraint.constant = 148
            }
        }else{
            startViewWidthConstraint.constant = 128
            endViewWidthConstraint.constant = 128
        }
        setUi()
    }
    
    override func setNeedsFocusUpdate() {
        super.setNeedsFocusUpdate()
        print("\n---------- [ setNeedsFocusUpdate ] ----------\n")
        
         let place = TextFieldArea.text ?? "필수값"
        
        
        let task = TextFieldwork.text ?? "필수값"
        let startdt = lblStartdt.text ?? "1900-01-01"
        let enddt = lblEnddt.text ?? "1900-01-01"
        
        var workday = ""
        
        if btnSun.isSelected == true {  workday = "1,"  }
        if btnMon.isSelected == true {  workday += "2," }
        if btnTue.isSelected == true {  workday += "3," }
        if btnWed.isSelected == true {  workday += "4," }
        if btnThu.isSelected == true {  workday += "5," }
        if btnFri.isSelected == true {  workday += "6," }
        if btnSat.isSelected == true {
            workday += "7"
        }
        
        standInfo.workday = workday
        standInfo.place = place
        standInfo.task = task
        standInfo.startdt = startdt
        standInfo.enddt = enddt
        
        SelLcEmpInfo = standInfo
        
    }

    func setUi(){
        self.form = self.standInfo.form
        
        if(self.standInfo.format == 1 && (self.form == 3 || self.form == 5)) {
            lblSummary.isHidden = false
        }else{
            lblSummary.isHidden = true
        }
        
        
        
        TextFieldwork.text = standInfo.task  == "필수값" ? "" : standInfo.task
        TextFieldArea.text = (standInfo.place == "" ? CompanyInfo.addr : standInfo.place)
 
        
        btnSun.isSelected = workday.contains("1")
        btnMon.isSelected = workday.contains("2")
        btnTue.isSelected = workday.contains("3")
        btnWed.isSelected = workday.contains("4")
        btnThu.isSelected = workday.contains("5")
        btnFri.isSelected = workday.contains("6")
        btnSat.isSelected = workday.contains("7")
        
        startdt = standInfo.startdt
        enddt = standInfo.enddt
        
        if startdt == "1900-01-01" || startdt == "" {
            lblStartdt.text = todayDateKo().replacingOccurrences(of: "-", with: ".")
            chkImgStart.image = chkstatusAlertpass
            
        }else {
            lblStartdt.text = startdt.replacingOccurrences(of: "-", with: ".")
        }
        
        if enddt == "1900-01-01" {
            enddt = ""
        }
        
        if enddt != "" {
            lblEnddt.text = enddt.replacingOccurrences(of: "-", with: ".")
        }
        
        if standInfo.form == 0 {
            print("\n---------- [ enddt : \(enddt) ] ----------\n")
            if enddt == "" {
                lblEnddt.text = ""
            }else {
                lblEnddt.text = enddt.replacingOccurrences(of: "-", with: ".")
            }
        }
        
        if lblStartdt.text != "" {
            chkImgStart.image = chkstatusAlertpass
        }else{
            chkImgStart.image = chkstatusAlert
        }
        
        if TextFieldArea.text != "" {
            chkImgArea.image = chkstatusAlertpass
        }else{
            chkImgArea.image = chkstatusAlert
        }
        
        if TextFieldwork.text != "" {
            chkImgTask.image = chkstatusAlertpass
        }else{
            chkImgTask.image = chkstatusAlert
        }
        
        
        
        btnMon.setImage(UIImage(named: "on_mon"), for: .selected)
        btnMon.setImage(UIImage(named: "off_mon"), for: .normal)
        
        btnTue.setImage(UIImage(named: "on_tue"), for: .selected)
        btnTue.setImage(UIImage(named: "off_tue"), for: .normal)
        
        btnWed.setImage(UIImage(named: "on_wed"), for: .selected)
        btnWed.setImage(UIImage(named: "off_wed"), for: .normal)
        
        btnThu.setImage(UIImage(named: "on_thu"), for: .selected)
        btnThu.setImage(UIImage(named: "off_thu"), for: .normal)
        
        btnFri.setImage(UIImage(named: "on_fri"), for: .selected)
        btnFri.setImage(UIImage(named: "off_fri"), for: .normal)
        
        btnSat.setImage(UIImage(named: "on_sat"), for: .selected)
        btnSat.setImage(UIImage(named: "off_sat"), for: .normal)
        
        btnSun.setImage(UIImage(named: "on_sun"), for: .selected)
        btnSun.setImage(UIImage(named: "off_sun"), for: .normal)
        
        
        workday = standInfo.workday
        
        
        btnSun.isSelected = workday.contains("1")
        btnMon.isSelected = workday.contains("2")
        btnTue.isSelected = workday.contains("3")
        btnWed.isSelected = workday.contains("4")
        btnThu.isSelected = workday.contains("5")
        btnFri.isSelected = workday.contains("6")
        btnSat.isSelected = workday.contains("7")
        
         
        var formTitle = ""
        switch standInfo.form  {
        case 0:
            formTitle = "표준 정규직 정보"
        case 1:
            formTitle = "표준 계약직 정보"
        case 2:
            formTitle = "표준 시급/소정 정보"
        case 3:
            formTitle = "표준 시급/일별 정보"
        case 4:
            formTitle = "표준 일급/소정 정보"
        case 5:
            formTitle = "표준 일급/일별 정보"
        default:
            break
        }
        
        
        lblNavigationTitle.text = formTitle
        
        let startyGestuure = UITapGestureRecognizer(target: self, action: #selector(startdatePicker))
        self.StartView.isUserInteractionEnabled = true
        self.StartView.addGestureRecognizer(startyGestuure)
        
        
        let endGestuure = UITapGestureRecognizer(target: self, action: #selector(enddatePicker))
        self.EndView.isUserInteractionEnabled = true
        self.EndView.addGestureRecognizer(endGestuure)
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
        } 
    }
    
      
    @IBAction func selectMon(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func selectTue(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func selectWed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func selectThu(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func selectFri(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func selectSat(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func selectSun(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step1VC") as! Lc_Default_Step1VC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.standInfo = standInfo
        self.present(vc, animated: false, completion: nil)
        
    }
    
    
    @IBAction func NextDidTap(_ sender: Any) {
        
        let edt = lblEnddt.text ?? "1900-01-01"
        let place = TextFieldArea.text ?? "필수값"
        
        
        let task = TextFieldwork.text ?? "필수값"
        let sdt = lblStartdt.text ?? "1900-01-01"
        
        
        var workday = ""
        
        if btnSun.isSelected == true {  workday = "1,"  }
        if btnMon.isSelected == true {  workday += "2," }
        if btnTue.isSelected == true {  workday += "3," }
        if btnWed.isSelected == true {  workday += "4," }
        if btnThu.isSelected == true {  workday += "5," }
        if btnFri.isSelected == true {  workday += "6," }
        if btnSat.isSelected == true {
            workday += "7"
        }
        print("\n---------- [ workday : \(workday) , form :\(standInfo.form) ] ----------\n")
        standInfo.workday = workday
        
        if place == "" {
            toast("근무장소를 입력해주세요.")
            return
        }else if task == "" {
            toast("담당업무를 입력해주세요.")
            return
        }else if standInfo.workday == "" {
            toast("근로요일을 선택헤주세요.")
            return
        }else {
            standInfo.place = place 
            standInfo.task = task
            standInfo.startdt = sdt
            standInfo.enddt = edt
            
            NetworkManager.shared().lc_std_step2(LCTSID: standInfo.sid, SDT: sdt, EDT: edt, PLACE: place.urlEncoding(), TASK: task.urlEncoding(), STM: "", ETM: "", BSTM: "", BETM: "", WDAY: workday) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.standInfo.form = self.form
                        //표준근로계약서 3.시급(근로일별) 5.일급(근로일별) 근로일별 근로시간 있는경우..
                        if(self.standInfo.format == 1 && (self.form == 3 || self.form == 5)) {
                            let vc = ContractSB.instantiateViewController(withIdentifier: "StepdayVC") as! StepdayVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            
                            vc.standInfo = self.standInfo
                            self.present(vc, animated: false, completion: nil)
                            
                            
                        }else{
                            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step3VC") as! Lc_Default_Step3VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.standInfo = self.standInfo
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
        SelLcEmpInfo.viewpage = "std_step2"
        print("\n---------- [ SelLcEmpInfo : \(SelLcEmpInfo.toJSON()) ] ----------\n")
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

private extension Lc_Default_Step2VC {
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
            var viewpage: String = "std_step2"
            let rowVC: PanModalPresentable.LayoutType = ContractInfoPopup()
        }
        struct SEBsic: RowPresentable {
            var viewpage: String = "step1"
            let rowVC: PanModalPresentable.LayoutType = SE_ContractInfoPopup()
            
        }
        
    }
}


// MARK: - UITextFieldDelegate
extension Lc_Default_Step2VC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == TextFieldEnddt {
//            TextFieldArea.becomeFirstResponder()
//        }else if textField == TextFieldArea {
//            TextFieldwork.becomeFirstResponder()
//        }
        return true
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let str = textField.text ?? ""
       
        if textField == TextFieldArea {
            if str != "" {
                chkImgArea.image = chkstatusAlertpass
            }else{
                chkImgArea.image = chkstatusAlert
            }
        }else if textField == TextFieldwork {
            if str != "" {
                chkImgTask.image = chkstatusAlertpass
            }else{
                chkImgTask.image = chkstatusAlert
            }
        }
        
    }
    
}
