//
//  AnnualListVC.swift
//  PinPle
//
//  Created by seob on 2020/07/23.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class AnnualListVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var textAnl: UILabel!
    @IBOutlet weak var textCalAnlDay: UILabel!
    @IBOutlet weak var textCalAnlHour: UILabel!
    @IBOutlet weak var textCalAnlMin: UILabel!
    @IBOutlet weak var textUseAnlDay: UITextField!
    @IBOutlet weak var textUseAnlHour: UITextField!
    @IBOutlet weak var textUseAnlMin: UITextField!
    
    @IBOutlet weak var textAddAnlDay: UITextField!
    @IBOutlet weak var textAddAnlHour: UITextField!
    @IBOutlet weak var textAddAnlMin: UITextField!
    @IBOutlet weak var textJoinDt: UITextField!
    
    @IBOutlet weak var vwLine2: UIView!
    @IBOutlet weak var vwLine3: UIView!
    @IBOutlet weak var vwLine4: UIView!
    
    @IBOutlet weak var YearTitleImage: UIImageView!
    @IBOutlet weak var useView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var vwNoApr: UIView!
    var dayTemp1 = 0
    var dayTemp2 = 0
    var hourTmep1 = 0
    var hourTmep2 = 0
    var minTemp1 = 0
    var minTemp2 = 0
    var joindt = ""
    var usemin = 0
    var addmin = 0
    var stdmin = 0
    var ficalmin = 0
    var prevyearmin = 0
    var pickerDay: [String] = []
    var pickerHour: [String] = []
    var dateFormatter = DateFormatter()
    var dateFormatter2 = DateFormatter()
    var inputDate = ""
    var showDate = ""
    
    let useAnlPicker = UIPickerView()
    let addAnlPicker = UIPickerView()
    var tempMbrInfo = getMbrInfo()
    var EmpInfo = EmplyInfo()
    
    var curkey = ""
    var nextkey = ""
    var total = 0
    var listcnt = 30
    var emptyAnual = 0
    var AnualList: [anualmgrInfo] = []
    var fetchingMore: Bool = false
    var calTotal = 0 //계산된 연차
    var calAnual = 0 //입사일 기준 연차
    override func viewDidLoad() {
        super.viewDidLoad()
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        textJoinDt.text = setJoinDate2(timeStamp: tempMbrInfo.joindt)
        setUi()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reloadListFical, object: nil)
    }
    
    @objc func reloadTableData(_ notification: Notification) {
        print("\n---------- [ 111 ] ----------\n")
        valueSetting()
    }
    
    fileprivate func setUi(){
        textUseAnlDay.isUserInteractionEnabled = false
        textUseAnlHour.isUserInteractionEnabled = false
        textUseAnlMin.isUserInteractionEnabled = false
        textAddAnlDay.isUserInteractionEnabled = false
        textAddAnlHour.isUserInteractionEnabled = false
        textAddAnlMin.isUserInteractionEnabled = false
        
        
        textUseAnlDay.inputView = useAnlPicker
        textUseAnlHour.inputView = useAnlPicker
        textUseAnlMin.inputView = useAnlPicker
        
        textAddAnlDay.inputView = addAnlPicker
        textAddAnlHour.inputView = addAnlPicker
        textAddAnlMin.inputView = addAnlPicker
        
        textUseAnlDay.delegate = self
        textUseAnlHour.delegate = self
        textUseAnlMin.delegate = self
        
        textAddAnlDay.delegate = self
        textAddAnlHour.delegate = self
        textAddAnlMin.delegate = self
        
        useAnlPicker.delegate = self
        addAnlPicker.delegate = self
        
        //        anualToolBar(textFields: [textJoinDt])
        
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        var items = [UIBarButtonItem]()
        let btnDoneBar = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneBtnClicked))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         items.append(contentsOf: [spacer , btnDoneBar])
        toolBarKeyboard.setItems(items, animated: false)
        textJoinDt.inputAccessoryView = toolBarKeyboard
        
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.rowHeight = UITableView.automaticDimension
        tblList.separatorStyle = .none
//        tblList.frame = tblList.frame.inset(by: UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0))

        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        tblList.register(UINib.init(nibName: "AnnualCell", bundle: nil), forCellReuseIdentifier: "AnnualCell")
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.useAnnualDidTap))
        self.useView.addGestureRecognizer(gesture)
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.addAnnualDidTap))
        self.addView.addGestureRecognizer(gesture2)
        
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
        getAnualList()
        if CompanyInfo.stanual == 0 {
            //회계년도
//            YearTitleImage.images = UIImage(named: "ficalText")
            YearTitleImage.image = UIImage(named: "ficalText")
        }else{
            //입사일
//            YearTitleImage.images = UIImage(named: "annualText")
            YearTitleImage.image = UIImage(named: "annualText")
        }
    }
    
    //사용한 연차
    @objc func useAnnualDidTap(sender : UITapGestureRecognizer) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "UseAnnualAddVC") as! UseAnnualAddVC
        vc.EmpInfo = EmpInfo
        vc.tempMbrInfo = tempMbrInfo
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    //추가된 연차
    @objc func addAnnualDidTap(sender : UITapGestureRecognizer) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "AddAnnualAddVC") as! AddAnnualAddVC
        vc.EmpInfo = EmpInfo
        vc.tempMbrInfo = tempMbrInfo
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func barBack(_ sender: UIButton) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpInfoMainVC") as! EmpInfoMainVC
        vc.EmpInfo = EmpInfo
        vc.tempMbrInfo = tempMbrInfo
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: datePicker
    @IBAction func datePicker(_ sender: UITextField) {
        inputDate = textJoinDt.text!
        showDate = textJoinDt.text!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let goDatePickerView = UIDatePicker()
        goDatePickerView.datePickerMode = UIDatePicker.Mode.date
        goDatePickerView.locale = Locale(identifier: "ko_kr")
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
        
        goDatePickerView.maximumDate = Date()
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        textJoinDt.becomeFirstResponder()
        
    }
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        dateFormatter2.dateFormat = "yyyy.MM.dd"
        showDate = dateFormatter2.string(from: sender.date)
        inputDate = dateFormatter.string(from: sender.date)
        if showDate == "" {
            showDate = dateFormatter2.string(from: Date())
            inputDate = dateFormatter.string(from: Date())
        }
        
        textJoinDt.text = showDate
        countAnl()
    }
    
    fileprivate func getAnualList(){
        NetworkManager.shared().AnualmgrList(empsid: tempMbrInfo.empsid, curkey: curkey, listcnt: listcnt) { (isSuccess, reskey, resData) in
            if(isSuccess){
                guard let serverData = resData else { return self.tblList.reloadData() }
                if serverData.count > 0 {
                    self.nextkey = reskey
                    if serverData.count >= self.listcnt {
                        if serverData.count > 0 {
                            for i in 0...serverData.count-1 {
                                self.AnualList.append(serverData[i])
                            }
                            self.emptyAnual = 1
                        }
                        self.total = self.AnualList.count
                    }else{
                        if serverData.count > 0 {
                            for i in 0...serverData.count-1 {
                                self.AnualList.append(serverData[i])
                            }
                        }
                        self.emptyAnual = 0
                        self.total = self.AnualList.count
                    }
                    self.tblList.reloadData()
                }else{
                    self.tblList.reloadData()
                }
                
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    
    func valueSetting() {
        NetworkManager.shared().GetEmpInfo(empsid: tempMbrInfo.empsid) { (isSuccess, resData) in
            if (isSuccess){
                guard let serverData = resData else { return }
                self.addmin = serverData.addmin //추가된
                self.usemin = serverData.usemin //사용한
                self.stdmin = serverData.stdmin //기존연차
                self.prevyearmin  = serverData.prevyearmin //전년도 남은연차2020.08.11
                self.ficalmin = serverData.ficalmin // 회계년도연차 2021.12.06
                self.joindt = serverData.joindt
                self.FormLayout()
                self.countAnl()
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    // 레이아웃
    func FormLayout(){
        
        textJoinDt.text = tempMbrInfo.joindt.replacingOccurrences(of: "-", with: ".")
        
        textUseAnlDay.text = timeStr(self.usemin)[0].replacingOccurrences(of: "0-", with: "-")
        textUseAnlHour.text = timeStr(self.usemin)[1].replacingOccurrences(of: "0-", with: "-")
        textUseAnlMin.text =  timeStr(self.usemin)[2].replacingOccurrences(of: "0-", with: "-")
        textAddAnlDay.text = timeStr(self.addmin)[0].replacingOccurrences(of: "0-", with: "-")
        textAddAnlHour.text = timeStr(self.addmin)[1].replacingOccurrences(of: "0-", with: "-")
        textAddAnlMin.text = timeStr(self.addmin)[2].replacingOccurrences(of: "0-", with: "-")
        
        minTemp1 = minSave(self.usemin)
        minTemp2 = minSave(self.addmin)
        
        dayTemp1 = Int(timeStr(self.usemin)[0]) ?? 0
        dayTemp1 = Int(timeStr(self.usemin)[0]) ?? 0
        hourTmep1 = Int(timeStr(self.usemin)[1])  ?? 0
        minTemp1 =  Int(timeStr(self.usemin)[2])  ?? 0
        
        
        
        dayTemp2 = Int(timeStr(self.addmin)[0]) ?? 0
        hourTmep2 = Int(timeStr(self.addmin)[1]) ?? 0
        minTemp2 =  Int(timeStr(self.addmin)[2]) ?? 0
        
        useAnlPicker.selectRow(dayTemp1, inComponent: 0, animated: false)
        useAnlPicker.selectRow(hourTmep1, inComponent: 1, animated: false)
        
        addAnlPicker.selectRow(dayTemp2, inComponent: 0, animated: false)
        addAnlPicker.selectRow(hourTmep2, inComponent: 1, animated: false)
         
    }
     
    func countAnl() {
        let joindt = textJoinDt.text!.replacingOccurrences(of: ".", with: "-").urlEncoding()
        NetworkManager.shared().GetAnualminNew(empsid: tempMbrInfo.empsid, joindt: joindt) { isSuccess, resCode, resFical, resRemain, resUsemin, resAddmin in
            if isSuccess {
                let arr = joindt.components(separatedBy: "-")
                let nJoinYear: Int = Int(arr[0]) ?? 0
                let nJoinMonth: Int = Int(arr[1]) ?? 0
                let nJoinDay: Int = Int(arr[2]) ?? 0
                let nWorkYear: Int = self.getWorkYear(nJoinYear, nJoinMonth, nJoinDay)
                if CompanyInfo.stanual == 0 {
                    //회계연도
                    self.calAnual = resFical
                }else{
                    //입사일
                    self.calAnual = resCode
                }
                
                self.textAnl.text = "\(self.calAnual / 480)"
                self.tempMbrInfo.joindt = self.textJoinDt.text ?? ""

                if(nWorkYear >= 1 && nWorkYear < 2) {
                    self.calTotal = (self.calAnual + self.prevyearmin - self.usemin ) + self.addmin
                }else{
                    self.calTotal = (self.calAnual - self.usemin ) + self.addmin
                }
                self.textCalAnlDay.text = self.timeStr(self.calTotal)[0].replacingOccurrences(of: "0-", with: "-")
                self.textCalAnlHour.text = self.timeStr(self.calTotal)[1].replacingOccurrences(of: "0-", with: "-")
                self.textCalAnlMin.text = self.timeStr(self.calTotal)[2].replacingOccurrences(of: "0-", with: "-")
                
            }else{
                self.toast("다시 시도해 주세요")
            }
        } 
    }
    
    func numberOfDaysBetween(_ from: String, _ to: String) -> Int {
        let date1 = setDateformat(from)
        let date2 = setDateformat(to)

        let diffs = Calendar.current.dateComponents([.day], from: date1, to: date2)
        return diffs.day!
    }
 
    //사용한연차 설명팝업
    @IBAction func popUseAnlShow(_ sender: UIButton) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpInfoPopUpInfo1") as! EmpInfoPopUpInfo
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    // 추가된연차 설명팝업
    @IBAction func popAddAnlShow(_ sender: UIButton) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpInfoPopUpInfo2") as! EmpInfoPopUpInfo
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @objc func doneBtnClicked (sender: Any) {
        let oriDate = tempMbrInfo.joindt
        let changeDate = showDate.replacingOccurrences(of: ".", with: "-")
        
        NetworkManager.shared().udtJoindt(empsid: tempMbrInfo.empsid, jndt: oriDate, njndt: changeDate) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode == 1 {
                    self.view.endEditing(true)
                    NotificationCenter.default.post(name: .reloadListFical, object: nil)
                    self.toast("입사일이 변경되었습니다.")
                }else{
                    self.view.endEditing(true)
                    self.toast("다시 시도해 주세요.")
                }
            }else{
                self.view.endEditing(true)
                self.toast("다시 시도해 주세요.")
                
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AnnualListVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AnualList.count == 0 {
            vwNoApr.isHidden = false
        }else {
            vwNoApr.isHidden = true
        }
        return AnualList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AnnualCell", for: indexPath) as? AnnualCell {
            cell.selectionStyle = .none
            let indexPathRow = AnualList[indexPath.row]
 
            var strTitle = ""
            var bgColor: UIColor!
            var blPluse = ""
            if indexPathRow.type == 0 {
                strTitle = "연차사용"
                blPluse = "-"
                bgColor = UIColor.init(hexString: "#FF0000")
            }else{
                strTitle = "연차추가"
                blPluse = "+"
                bgColor = UIColor.init(hexString: "#003ADB")
            }
            
            cell.lblTitle.text = strTitle
            cell.lblDate.text = setJoinDate2(timeStamp: indexPathRow.regdt)
            if (self.timeStr(indexPathRow.setmin)[1] == "00" && self.timeStr(indexPathRow.setmin)[2] == "00"){
                cell.lblTime.text = "\(blPluse)\(self.anualtimeStr(indexPathRow.setmin)[0])일"
            }else{
                cell.lblTime.text = "\(blPluse)\(self.anualtimeStr(indexPathRow.setmin)[0])일 \(self.anualtimeStr(indexPathRow.setmin)[1])시간 \(self.anualtimeStr(indexPathRow.setmin)[2])분"
            }
             
            cell.lblTime.textColor = bgColor
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if AnualList[indexPath.row].type == 0 {
            let vc = CmpCmtSB.instantiateViewController(withIdentifier: "UseAnnualModifyVC") as! UseAnnualModifyVC
            vc.AnualInfo = AnualList[indexPath.row]
            vc.EmpInfo = EmpInfo
            vc.tempMbrInfo = tempMbrInfo
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }else{
            let vc = CmpCmtSB.instantiateViewController(withIdentifier: "AddAnnualModifyVC") as! AddAnnualModifyVC
            vc.AnualInfo = AnualList[indexPath.row]
            vc.EmpInfo = EmpInfo
            vc.tempMbrInfo = tempMbrInfo
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableHeight = tblList.frame.height
        
        if offsetY + tableHeight > contentHeight + 50 {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        
        if self.AnualList.count > 0 {
            if self.AnualList.count >= self.listcnt {
                print("\n---------- [ self.emptyAnual : \(self.emptyAnual) ] ----------\n")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.curkey = self.nextkey
                    self.fetchingMore = false
                    if self.emptyAnual == 1 {
                        self.getAnualList()
                    }
                    
                })
            }
        }
        
    }
}

// MARK:  - UITextFieldDelegate
extension AnnualListVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case textJoinDt:
            vwLine2.backgroundColor = UIColor.init(hexString: "#043856");
        case textUseAnlHour, textUseAnlDay:
            vwLine3.backgroundColor = UIColor.init(hexString: "#043856");
        case textAddAnlHour, textAddAnlDay:
            vwLine4.backgroundColor = UIColor.init(hexString: "#043856");
        default:
            break;
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case textJoinDt:
            vwLine2.backgroundColor = UIColor.init(hexString: "#DADADA");
        case textUseAnlHour, textUseAnlDay:
            vwLine3.backgroundColor = UIColor.init(hexString: "#DADADA");
        case textAddAnlHour, textAddAnlDay:
            vwLine4.backgroundColor = UIColor.init(hexString: "#DADADA");
        default:
            break;
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AnnualListVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return pickerDay.count
        }
        return pickerHour.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return pickerDay[row]
        }
        return pickerHour[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == useAnlPicker {
            if component == 0 {
                dayTemp1 = row
                textUseAnlDay.text = pickerDay[row]
            }else {
                hourTmep1 = row
                textUseAnlHour.text = pickerHour[row]
            }
        }else {
            if component == 0 {
                dayTemp2 = row
                textAddAnlDay.text = pickerDay[row]
            }else {
                hourTmep2 = row
                textAddAnlHour.text = pickerHour[row]
            }
        }
        
        
    }
}
