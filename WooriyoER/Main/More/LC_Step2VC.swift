//
//  LC_Step2VC.swift
//  PinPle
//
//  Created by seob on 2020/06/04.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import DatePickerDialog

class LC_Step2VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    // 시작 뷰
    @IBOutlet weak var StartView: UIView!
    @IBOutlet weak var EndView: UIView!
    @IBOutlet weak var paystView: UIView!
    @IBOutlet weak var payendView: UIView!
    @IBOutlet weak var workstView: UIView!
    @IBOutlet weak var workendView: UIView!
    @IBOutlet weak var bkstView: UIView!
    @IBOutlet weak var bkendView: UIView!
    @IBOutlet weak var lblStartdt: UILabel!
    @IBOutlet weak var lblEnddt: UILabel!
    @IBOutlet weak var lblPaystdt: UILabel!
    @IBOutlet weak var lblPayenddt: UILabel!
    @IBOutlet weak var lblWorkstdt: UILabel!
    @IBOutlet weak var lblWorkenddt: UILabel!
    @IBOutlet weak var lblBkstdt: UILabel!
    @IBOutlet weak var lblBkenddt: UILabel!
    @IBOutlet weak var TextFieldArea: TextFieldEffects! //근무지
    @IBOutlet weak var TextFieldwork: TextFieldEffects!     //담당업무
    @IBOutlet weak var EndViewLine: UIView!
    
    //출근요일
    @IBOutlet weak var btnMon: UIButton!
    @IBOutlet weak var btnTue: UIButton!
    @IBOutlet weak var btnWed: UIButton!
    @IBOutlet weak var btnThu: UIButton!
    @IBOutlet weak var btnFri: UIButton!
    @IBOutlet weak var btnSat: UIButton!
    @IBOutlet weak var btnSun: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var chkImgStart: UIImageView! //시작 error
    @IBOutlet weak var chkImgEnd: UIImageView! //종료 error
    @IBOutlet weak var chkImgPayStart: UIImageView! //종료 error
    @IBOutlet weak var chkImgArea: UIImageView! //종료 error
    @IBOutlet weak var chkImgWorkStart: UIImageView! //종료 error
    @IBOutlet weak var chkImgWorkEnd: UIImageView! //종료 error
    
    @IBOutlet weak var stepDot1: UIImageView!
    @IBOutlet weak var stepDot2: UIImageView!
    @IBOutlet weak var stepDot3: UIImageView!
    @IBOutlet weak var stepDot4: UIImageView!
    @IBOutlet weak var stepDot5: UIImageView!
    @IBOutlet weak var stepDot6: UIImageView!
    
    @IBOutlet weak var lblsubtitleStartdt: UILabel!
    @IBOutlet weak var lblsubtitleEnddt: UILabel!
    @IBOutlet weak var lblsubtitlepaySdt: UILabel!
    @IBOutlet weak var lblsubtitlepayEdt: UILabel!
    
    @IBOutlet weak var traincntrcTextView: UITextView! //수습기간특약
    @IBOutlet weak var traincntrcConstraintHeight: NSLayoutConstraint! // 수습일때 184 , 아닐땐 17
    @IBOutlet weak var trainView: UIView! //수습기간특약뷰
    
    @IBOutlet weak var startViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var endViewWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var workDayView: UIView! // 일별근로 
    @IBOutlet weak var btnNext: UIButton!
    
    
    let toggleTwo = ToggleSwitch(with: images) //일별근로 스위치
    var switchYposition:CGFloat = 0
    
    var selInfo : LcEmpInfo = LcEmpInfo()
    var workday: String = "2,3,4,5,6"         //근무요일.. 1(일),2(월),3(화),4(수),5(목),6(금),7(토) 구분자 ','  .. ex) 2,3,4,5,6
    
    var showDate = ""
    var startdt = ""
    var enddt = ""
    var paystartdt = ""
    var payenddt = ""
    var workstarttm = ""
    var workendtm = ""
    var bkstarttm = ""
    var bkendtm = ""
    var inputData = ""
    var dayworktime = 0
    
    var dateFormatter = DateFormatter()
    var dateFormatter2 = DateFormatter()
    var tmflag = 0
    var textFields : [UITextField] = []
    var traincntrc = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnNext)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        if view.bounds.width == 414 {
            switchYposition = 340
        }else if view.bounds.width == 375 {
            switchYposition = 300
        }else if view.bounds.width == 390 {
            // iphone 12 pro
            switchYposition = 310
        }else if view.bounds.width == 320 {
            // iphone se
            switchYposition = 240
        }else {
            switchYposition = 340
        }
        toggleTwo.frame.origin.x = switchYposition
        toggleTwo.frame.origin.y = -5
        
        self.workDayView.addSubview(toggleTwo)
        
        toggleTwo.addTarget(self, action: #selector(toggleTwoChanged), for: .valueChanged)
        print("\n---------- [ selInfo.dayworktime : \(selInfo.dayworktime) ] ----------\n")
        if selInfo.dayworktime == 0 {
            toggleTwo.setOn(on: false, animated: true)
        }else{
            toggleTwo.setOn(on: true, animated: true)
        }
        
        dayworktime = selInfo.dayworktime
         
    }
    
    @objc func toggleTwoChanged(toggle: ToggleSwitch) {
        toggle.isSelected = !toggle.isSelected
        if toggle.isOn {
            self.dayworktime = 1
        } else {
            self.dayworktime = 0
        }
    }
    
    //스크롤뷰 터치했을때도 키보드 내려가도록 해주는 코드
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
        //        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        //        self.scrollView.contentInset = contentInset
        
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
        
    }
    
    func setUI(){
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
        
        
        workday = selInfo.workday
        
        
        btnSun.isSelected = workday.contains("1")
        btnMon.isSelected = workday.contains("2")
        btnTue.isSelected = workday.contains("3")
        btnWed.isSelected = workday.contains("4")
        btnThu.isSelected = workday.contains("5")
        btnFri.isSelected = workday.contains("6")
        btnSat.isSelected = workday.contains("7")
        
        
        if selInfo.form == 2 {
            traincntrcConstraintHeight.constant = 184
            trainView.isHidden = false
        }else{
            traincntrcConstraintHeight.constant = 17
            trainView.isHidden = true
        }
        
        traincntrcTextView.layer.cornerRadius = 6
        traincntrcTextView.layer.borderWidth = 1
        traincntrcTextView.layer.borderColor = UIColor.init(hexString: "#EDEDF2").cgColor
        
        //textview padding
        traincntrcTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        
        textFields = [TextFieldArea , TextFieldwork]
        if selInfo.form == 2 {
            addToolBar(textFields: textFields, textView: traincntrcTextView)
        }else{
            addToolBar(textFields: textFields)
        }
        
        for textField in textFields {
            textField.delegate = self
        }
        traincntrcTextView.delegate = self
        traincntrc = selInfo.traincntrc
        print("\n---------- [ selInfo : \(selInfo.toJSON()) ] ----------\n")
        if traincntrc != "" {
            traincntrcTextView.text = traincntrc
        }else{
            //            traincntrcTextView.text = "ex)계약직에 해당. 수습기간은 월급여의 80%에 해당하나 최저임금의 90% 적용"
            textViewSetUpView()
        }
        
        if selInfo.form == 0 {
            lblNavigationTitle.text = "정규직 필수정보"
            lblsubtitleStartdt.text = "근로개시일"
            lblsubtitleEnddt.text = "근로종료일"
            lblsubtitlepaySdt.text = "급여적용일"
            lblsubtitlepayEdt.text = "급여적용종료일"
            // EndView.isHidden = true
            lblsubtitleEnddt.isHidden = true
            lblEnddt.isHidden = true
            chkImgEnd.isHidden = true
            EndViewLine.isHidden = true
        }else if selInfo.form == 1 {
            lblNavigationTitle.text = "계약직 필수정보"
            lblsubtitleStartdt.text = "근로개시일"
            lblsubtitleEnddt.text = "근로종료일"
            lblsubtitlepaySdt.text = "급여적용일"
            lblsubtitlepayEdt.text = "급여적용종료일"
        }else {
            lblNavigationTitle.text = "수습 필수정보"
            lblsubtitleStartdt.text = "근로계약시작일"
            lblsubtitleEnddt.text = "근로계약종료일"
            lblsubtitlepaySdt.text = "수습기간 시작일"
            lblsubtitlepayEdt.text = "수습기간 종료일"
        }
        
        
        
        startdt = selInfo.startdt
        if startdt == "1900-01-01" || startdt == "" {
            lblStartdt.text = todayDateKo().replacingOccurrences(of: "-", with: ".")
            chkImgStart.image = chkstatusAlertpass
        }else {
            lblStartdt.text = startdt.replacingOccurrences(of: "-", with: ".")
        }
        
        if lblStartdt.text != "" {
            chkImgStart.image = chkstatusAlertpass
        }
        
        
        // 수습일경우 근로종료일 디폴트 1년 넣기
        if selInfo.form  == 2 {
            var dateComponent = DateComponents()
            dateComponent.day = 364
            dateFormatter.dateFormat = "yyyy.MM.dd"
            let currentDate = dateFormatter.date(from: startdt) ?? Date()
            let calDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
            
            let resultDate  = dateFormatter.string(from: calDate)
            enddt = "\(resultDate)"
        }else{
            enddt = selInfo.enddt
        }
        
        if enddt == "1900-01-01"  || enddt == "" {
            lblEnddt.text = ""
        }else {
            lblEnddt.text = enddt.replacingOccurrences(of: "-", with: ".")
        }
        
        
        paystartdt = selInfo.paystartdt
        if paystartdt == "1900-01-01" || paystartdt == ""{
            lblPaystdt.text = ""
        }else {
            lblPaystdt.text = paystartdt.replacingOccurrences(of: "-", with: ".")
        }
        
        if lblPaystdt.text != "" {
            chkImgPayStart.image = chkstatusAlertpass
        }
        
        payenddt = selInfo.payenddt
        if payenddt == "1900-01-01" || payenddt == "" {
            lblPayenddt.text = ""
        }else {
            lblPayenddt.text = payenddt.replacingOccurrences(of: "-", with: ".")
        }
        
        if workstarttm == "" {
            lblWorkstdt.text = "09:00"
            chkImgWorkStart.image = chkstatusAlertpass
        }
        
        if lblWorkstdt.text != "" {
            chkImgWorkStart.image = chkstatusAlertpass
        }
        
        if lblWorkenddt.text != "" {
            chkImgWorkEnd.image = chkstatusAlertpass
        }
        
        
        if workendtm == "" {
            lblWorkenddt.text = "18:00"
            chkImgWorkEnd.image = chkstatusAlertpass
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let checkDevice = deviceHeight()
        workstarttm = selInfo.starttm.timeTrim()
        lblWorkstdt.text = workstarttm
        workendtm = selInfo.endtm.timeTrim()
        lblWorkenddt.text = workendtm
        bkstarttm = selInfo.brkstarttm.timeTrim()
        lblBkstdt.text = bkstarttm
        bkendtm = selInfo.brkendtm.timeTrim()
        lblBkenddt.text = bkendtm
        
        TextFieldwork.text = selInfo.task
        TextFieldArea.text = (selInfo.place != "" ? selInfo.place : CompanyInfo.addr)
        
        btnSun.isSelected = workday.contains("1")
        btnMon.isSelected = workday.contains("2")
        btnTue.isSelected = workday.contains("3")
        btnWed.isSelected = workday.contains("4")
        btnThu.isSelected = workday.contains("5")
        btnFri.isSelected = workday.contains("6")
        btnSat.isSelected = workday.contains("7")
        
        setUI()
        
        
        
        if TextFieldArea.text != "" {
            chkImgArea.image = chkstatusAlertpass
        }
        
        if lblPaystdt.text != "" {
            chkImgPayStart.image = chkstatusAlertpass
        }
        
        if lblEnddt.text != "" {
            chkImgEnd.image = chkstatusAlertpass
        }
        
        let startyGestuure = UITapGestureRecognizer(target: self, action: #selector(startdatePicker))
        self.StartView.isUserInteractionEnabled = true
        self.StartView.addGestureRecognizer(startyGestuure)
        
        
        let endGestuure = UITapGestureRecognizer(target: self, action: #selector(enddatePicker))
        self.EndView.isUserInteractionEnabled = true
        self.EndView.addGestureRecognizer(endGestuure)
        
        let paysGestuure = UITapGestureRecognizer(target: self, action: #selector(paystdatePicker))
        self.paystView.isUserInteractionEnabled = true
        self.paystView.addGestureRecognizer(paysGestuure)
        
        let payeGestuure = UITapGestureRecognizer(target: self, action: #selector(payenddatePicker))
        self.payendView.isUserInteractionEnabled = true
        self.payendView.addGestureRecognizer(payeGestuure)
        
        let worksGestuure = UITapGestureRecognizer(target: self, action: #selector(workstdatePicker))
        self.workstView.isUserInteractionEnabled = true
        self.workstView.addGestureRecognizer(worksGestuure)
        
        let workeGestuure = UITapGestureRecognizer(target: self, action: #selector(workenddatePicker))
        self.workendView.isUserInteractionEnabled = true
        self.workendView.addGestureRecognizer(workeGestuure)
        
        let bksGestuure = UITapGestureRecognizer(target: self, action: #selector(bkstdatePicker))
        self.bkstView.isUserInteractionEnabled = true
        self.bkstView.addGestureRecognizer(bksGestuure)
        
        let bkeGestuure = UITapGestureRecognizer(target: self, action: #selector(bkenddatePicker))
        self.bkendView.isUserInteractionEnabled = true
        self.bkendView.addGestureRecognizer(bkeGestuure)
    }
    
    override func setNeedsFocusUpdate() {
        super.setNeedsFocusUpdate()
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
        
        selInfo.workday = workday
        
        
        let place = TextFieldArea.text ?? "필수값"
        let task = TextFieldwork.text ?? "필수값"
        let sdt = lblStartdt.text ?? "1900-01-01"
        let edt = lblEnddt.text ?? "1900-01-01"
        let psdt = lblPaystdt.text ?? "1900-01-01"
        let pedt = lblPayenddt.text ?? "1900-01-01"
        let stm = lblWorkstdt.text ?? "00:00"
        let etm = lblWorkenddt.text ?? "00:00"
        let bstm = lblBkstdt.text ?? "00:00"
        let betm = lblBkenddt.text ?? "00:00"
        var train = traincntrcTextView.text ?? ""
        
        selInfo.place = place
        selInfo.task = task
        selInfo.startdt = sdt
        selInfo.enddt = edt
        selInfo.paystartdt = psdt
        selInfo.payenddt = pedt
        selInfo.starttm = stm
        selInfo.endtm = etm
        selInfo.brkstarttm = bstm
        selInfo.brkendtm = betm
        if train == "ex)계약직에 해당. 수습기간은 월급여의 80%에 해당하나 최저임금의 90% 적용" {
            train = ""
        }
        selInfo.traincntrc = train
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
        var inputData =  Date()
        inputData = dateFormatter.date(from: enddt) ?? Date()
        let sdt = lblStartdt.text ?? ""
        let minDate = dateFormatter.date(from: sdt) ?? Date()
        
        
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택", doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: inputData, minimumDate: minDate, maximumDate: nil, datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                
                self.lblEnddt.text = formatter.string(from: dt)
                self.chkImgEnd.image = chkstatusAlertpass
            }
        }
    }
    
    @objc func paystdatePicker(_ sender: UIGestureRecognizer){
        paystartdt = lblPaystdt.text ?? ""
        dateFormatter.dateFormat = "yyyy.MM.dd"
        var inputData =  Date()
        inputData = dateFormatter.date(from: paystartdt) ?? Date()
        
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택",doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: inputData, minimumDate: nil, maximumDate: nil, datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                
                self.lblPaystdt.text = formatter.string(from: dt)
                self.chkImgPayStart.image = chkstatusAlertpass
            }
        }
        
    }
    
    @objc func payenddatePicker(_ sender: UIGestureRecognizer){
        payenddt = lblPayenddt.text ?? ""
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let inputData = dateFormatter.date(from: payenddt)
        let sdt = lblPaystdt.text ?? ""
        let minDate = dateFormatter.date(from: sdt) ?? Date()
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택", doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: inputData ?? Date(), minimumDate: minDate, maximumDate: nil, datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                
                self.lblPayenddt.text = formatter.string(from: dt)
            }
            
            if date == nil {
                self.lblPayenddt.text = ""
            }
        }
    }
    
    @objc func workstdatePicker(_ sender: UIGestureRecognizer){
        
        workstarttm = lblWorkstdt.text ?? "00:00"
        dateFormatter.dateFormat = "HH:mm"
        let inputData = dateFormatter.date(from: workstarttm) ?? Date()
         
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택", doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: inputData, minimumDate: nil, maximumDate: nil, datePickerMode: .time, minuteInterval: 10){ (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                self.lblWorkstdt.text = formatter.string(from: dt)
            }
        }
        
    }
    
    @objc func workenddatePicker(_ sender: UIGestureRecognizer){ 
        workendtm = lblWorkenddt.text ?? "00:00"
        dateFormatter.dateFormat = "HH:mm"
        let inputData = dateFormatter.date(from: workendtm) ?? Date()
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택",doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: inputData, minimumDate: nil, maximumDate: nil, datePickerMode: .time, minuteInterval: 10) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                self.lblWorkenddt.text = formatter.string(from: dt)
            }
        }
    }
    
    @objc func bkstdatePicker(_ sender: UIGestureRecognizer){
        bkstarttm = lblBkstdt.text ?? "00:00"
        dateFormatter.dateFormat = "HH:mm"
        let inputData = dateFormatter.date(from: bkstarttm) ?? Date()
        
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택",doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: inputData, minimumDate: nil, maximumDate: nil, datePickerMode: .time, minuteInterval: 10) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                self.lblBkstdt.text = formatter.string(from: dt)
            }
        }
        
    }
    
    @objc func bkenddatePicker(_ sender: UIGestureRecognizer){
        bkendtm = lblBkenddt.text ?? "00:00"
        dateFormatter.dateFormat = "HH:mm"
        let inputData = dateFormatter.date(from: bkendtm) ?? Date()
        
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택",doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: inputData, minimumDate: nil, maximumDate: nil, datePickerMode: .time, minuteInterval: 10) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                self.lblBkenddt.text = formatter.string(from: dt)
            }
        }
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
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
        let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step1VC") as! Lc_Step1VC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = self.selInfo
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        
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
        
        selInfo.workday = workday
        
        if lblStartdt.text == "" {
            toast("시작일을 입력하세요.")
            return
        }else if lblPaystdt.text == "" {
            toast("급여시작일을 입력하세요.")
            return
        }else if TextFieldArea.text == "" {
            toast("근무지를 입력하세요.")
            TextFieldArea.becomeFirstResponder()
        }else if lblWorkstdt.text == "" {
            toast("근무시간을 입력하세요.")
            return
        }else if lblWorkenddt.text == "" {
            toast("근무시간을 입력하세요.")
            return
        }else if selInfo.workday == "" {
            toast("근로요일을 선택헤주세요.")
            return
        }else{
            
            let place = TextFieldArea.text ?? "필수값"
            let task = TextFieldwork.text ?? "필수값"
            let sdt = lblStartdt.text ?? "1900-01-01"
            let edt = lblEnddt.text ?? "1900-01-01"
            let psdt = lblPaystdt.text ?? "1900-01-01"
            let pedt = lblPayenddt.text ?? "1900-01-01"
            let stm = lblWorkstdt.text ?? "00:00"
            let etm = lblWorkenddt.text ?? "00:00"
            let bstm = lblBkstdt.text ?? "00:00"
            let betm = lblBkenddt.text ?? "00:00"
            var train = traincntrcTextView.text ?? ""
            
            selInfo.place = place
            selInfo.task = task
            selInfo.startdt = sdt
            selInfo.enddt = edt
            selInfo.paystartdt = psdt
            selInfo.payenddt = pedt
            selInfo.starttm = stm
            selInfo.endtm = etm
            selInfo.brkstarttm = bstm
            selInfo.brkendtm = betm
            if train == "ex)계약직에 해당. 수습기간은 월급여의 80%에 해당하나 최저임금의 90% 적용" {
                train = ""
            }
            selInfo.traincntrc = train
            
            var trainText = ""
            if selInfo.form == 2 {
                trainText = train
            }else{
                trainText = ""
            }
            print("\n---------- [ trainText : \(trainText) ] ----------\n")
            NetworkManager.shared().set_step2(type: selInfo.form, LCTSID: selInfo.sid, SDT: sdt, EDT: edt, PSDT: psdt, PEDT: pedt, PLACE: place.urlEncoding(), TASK: task.urlEncoding(), STM: stm, ETM: etm, BSTM: bstm, BETM: betm, WDAY: workday, TRAIN: trainText.urlEncoding(), DWT: dayworktime) { (isSuccess, resCode) in
                if(isSuccess){
                    print("\n---------- [ resCode : \(resCode) ] ----------\n")
                    DispatchQueue.main.async {
                        
                        if resCode == 1 {
                            if self.dayworktime == 0 {
                                let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step3VC") as! Lc_Step3VC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                vc.selInfo = self.selInfo
                                self.present(vc, animated: false, completion: nil)
                            }else{
                                let vc = ContractSB.instantiateViewController(withIdentifier: "DayWorkStepVC") as! DayWorkStepVC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                vc.selInfo = self.selInfo
                                self.present(vc, animated: false, completion: nil)
                            }
 
                        }else{
                            self.toast("다시 시도해 주세요.")
                        }
                    }
                    
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
            
        }
    }
    
    //MARK: - pop버튼
    @IBAction func moreBtn(_ sender: UIButton) { 
        SelPinplLcEmpInfo = selInfo
        SelPinplLcEmpInfo.viewpage = "step2"
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


private extension LC_Step2VC {
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
            var viewpage: String = "step2"
            let rowVC: PanModalPresentable.LayoutType = ContractInfoPinplPopup()
            
        }
        
        struct SEBsic: RowPresentable {
            var viewpage: String = "step1"
            let rowVC: PanModalPresentable.LayoutType = SE_ContractInfoPinplPopup()
            
        }
        
    }
}

// MARK: - UITextFieldDelegate
extension LC_Step2VC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let str = textField.text ?? ""
        if textField == TextFieldArea {
            if str != "" {
                chkImgArea.image = chkstatusAlertpass
            }else{
                chkImgArea.image = chkstatusAlert
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let str = textField.text ?? ""
        if textField == TextFieldArea {
            if str != "" {
                chkImgArea.image = chkstatusAlertpass
            }else{
                chkImgArea.image = chkstatusAlert
            }
        }
    }
}

extension LC_Step2VC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetUpView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewSetUpView()
    }
    
    func textViewSetUpView(){
        if traincntrcTextView.text == "ex)계약직에 해당. 수습기간은 월급여의 80%에 해당하나 최저임금의 90% 적용" {
            traincntrcTextView.text = ""
            traincntrcTextView.textColor = UIColor.black
        }else if traincntrcTextView.text ==  "" {
            traincntrcTextView.text = "ex)계약직에 해당. 수습기간은 월급여의 80%에 해당하나 최저임금의 90% 적용"
            traincntrcTextView.textColor = UIColor.lightGray
        }
    }
}
