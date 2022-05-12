//
//  ShotTimeVC.swift
//  PinPle
//
//  Created by seob on 2020/07/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class ShotTimeVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    @IBOutlet weak var monView: UIView!
    @IBOutlet weak var tueView: UIView!
    @IBOutlet weak var wedView: UIView!
    @IBOutlet weak var thurView: UIView!
    @IBOutlet weak var friView: UIView!
    @IBOutlet weak var satView: UIView!
    @IBOutlet weak var sunView: UIView!
    
    
    @IBOutlet weak var monStarttmTextField: UITextField!
    @IBOutlet weak var monEndtmTextField: UITextField!
    @IBOutlet weak var monBkstarttmTextField: UITextField!
    @IBOutlet weak var monBkendtmTextField: UITextField!
    @IBOutlet weak var lblMonWorkmin: UILabel!
    
    @IBOutlet weak var tueStarttmTextField: UITextField!
    @IBOutlet weak var tueEndtmTextField: UITextField!
    @IBOutlet weak var tueBkstarttmTextField: UITextField!
    @IBOutlet weak var tueBkendtmTextField: UITextField!
    @IBOutlet weak var lblTueWorkmin: UILabel!
    
    @IBOutlet weak var wedStarttmTextField: UITextField!
    @IBOutlet weak var wedEndtmTextField: UITextField!
    @IBOutlet weak var wedBkstarttmTextField: UITextField!
    @IBOutlet weak var wedBkendtmTextField: UITextField!
    @IBOutlet weak var lblWedWorkmin: UILabel!
    
    @IBOutlet weak var thurStarttmTextField: UITextField!
    @IBOutlet weak var thurEndtmTextField: UITextField!
    @IBOutlet weak var thurBkstarttmTextField: UITextField!
    @IBOutlet weak var thurBkendtmTextField: UITextField!
    @IBOutlet weak var lblThurWorkmin: UILabel!
    
    @IBOutlet weak var friStarttmTextField: UITextField!
    @IBOutlet weak var friEndtmTextField: UITextField!
    @IBOutlet weak var friBkstarttmTextField: UITextField!
    @IBOutlet weak var friBkendtmTextField: UITextField!
    @IBOutlet weak var lblFriWorkmin: UILabel!
    
    @IBOutlet weak var satStarttmTextField: UITextField!
    @IBOutlet weak var satEndtmTextField: UITextField!
    @IBOutlet weak var satBkstarttmTextField: UITextField!
    @IBOutlet weak var satBkendtmTextField: UITextField!
    @IBOutlet weak var lblSatWorkmin: UILabel!
    
    @IBOutlet weak var sunStarttmTextField: UITextField!
    @IBOutlet weak var sunEndtmTextField: UITextField!
    @IBOutlet weak var sunBkstarttmTextField: UITextField!
    @IBOutlet weak var sunBkendtmTextField: UITextField!
    @IBOutlet weak var lblSunWorkmin: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint! // 7개일땐 1700 , 1일땐 230
    var textFields : [UITextField] = []
    
    var workday = ""
    var arrayCnt: [String] = []
    var firstarrayCnt: [String] = []
    var starttm = "09:00"
    var endtm = "18:00"
    var bkstarttm = ""
    var bkendtm = ""
    var inputData = ""
    var standInfo : LcEmpInfo = LcEmpInfo()
    var SelMultiArr : [MultiConstractDate] = []
    var dayweek = 0
    var workmin = 0
    
    var tmpArr : [String] = []
    var serverArr: [ String] = []
    var dateFormatter = DateFormatter()
    var dateFormatter2 = DateFormatter()
    var tmflag = 0
    
    var indexPathDataRow = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        setUi()
        textFields = [monStarttmTextField, monEndtmTextField,  monBkstarttmTextField, monBkendtmTextField , tueStarttmTextField ,tueEndtmTextField , tueBkstarttmTextField , tueBkendtmTextField , wedStarttmTextField , wedEndtmTextField ,wedBkstarttmTextField , wedBkendtmTextField , thurStarttmTextField , thurEndtmTextField , thurBkstarttmTextField ,thurBkendtmTextField , friStarttmTextField , friEndtmTextField , friBkstarttmTextField , friBkendtmTextField , satStarttmTextField , satEndtmTextField , satBkstarttmTextField , satBkendtmTextField , sunStarttmTextField , sunEndtmTextField ,  sunBkstarttmTextField ,sunBkendtmTextField ]
        
        
        for textField in textFields {
            textField.delegate = self
        }
        
        addToolBar(textFields: textFields)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\n---------- [ SelMultiArr : \(SelMultiArr) ] ----------\n")
        var formTitle = ""
        switch standInfo.form  {
        case 0:
            formTitle = "표준 정규직 근로"
        case 1:
            formTitle = "표준 계약직 근로"
        case 2:
            formTitle = "표준 시급/소정 근로"
        case 3:
            formTitle = "표준 시급/일별 근로"
        case 4:
            formTitle = "표준 일급/소정 근로"
        case 5:
            formTitle = "표준 일급/일별 근로"
        default:
            break
        }
        
        
        lblNavigationTitle.text = formTitle
    }
    
    fileprivate func setUi(){
        workday = standInfo.workday
        
        arrayCnt = workday.components(separatedBy: ",")
        arrayCnt = arrayCnt.filter({ !$0.isEmpty })
        
        var workdayList = MultiConstractDate()
        for ( i , _) in arrayCnt.enumerated() {
            if (getWorkDay(Int(arrayCnt[i]) ?? 0)  == -1 ){
                workdayList.wdysid = 0
                workdayList.starttm = starttm
                workdayList.endtm = endtm
                workdayList.brkstarttm = bkstarttm
                workdayList.brkendtm = bkendtm
                workdayList.dayweek = Int(arrayCnt[i]) ?? 0
                workdayList.workmin = 480
                
            }else{
                let a = getWorkDay(Int(arrayCnt[i]) ?? 0)
                workdayList.wdysid = standInfo.workdaylist[a].wdysid
                workdayList.starttm = standInfo.workdaylist[a].starttm
                workdayList.endtm = standInfo.workdaylist[a].endtm
                workdayList.brkstarttm = standInfo.workdaylist[a].brkstarttm
                workdayList.brkendtm = standInfo.workdaylist[a].brkendtm
                workdayList.dayweek = standInfo.workdaylist[a].dayweek
                workdayList.workmin = standInfo.workdaylist[a].workmin
                
            }
            SelMultiArr.append(workdayList)
        }
        
        self.viewHeightConstraint.constant = (CGFloat(SelMultiArr.count) * 230.0) + 20
        if arrayCnt.contains("1") {
            sunView.isHidden = false
            let resData = getWorkDayArr(1)
            sunStarttmTextField.text = resData.resData.starttm.timeTrim()
            sunEndtmTextField.text = resData.resData.endtm.timeTrim()
            sunBkstarttmTextField.text = resData.resData.brkstarttm.timeTrim()
            sunBkstarttmTextField.text = resData.resData.brkendtm.timeTrim()
            sunStarttmTextField.tag = resData.resIndex
            lblSunWorkmin.text = "일요일 근로시간은 \(calworkmin(resData.resData.starttm.timeTrim(), resData.resData.endtm.timeTrim(), resData.resData.brkstarttm.timeTrim(), resData.resData.brkendtm.timeTrim(), 1)) 입니다."
        } else {
            sunView.isHidden = true
            
        }
        if arrayCnt.contains("2") {
            monView.isHidden = false
            monView.tag = 2
            let resData = getWorkDayArr(2)
            monStarttmTextField.text = resData.resData.starttm.timeTrim()
            monEndtmTextField.text = resData.resData.endtm.timeTrim()
            monBkstarttmTextField.text = resData.resData.brkstarttm.timeTrim()
            monBkendtmTextField.text = resData.resData.brkendtm.timeTrim()
            monStarttmTextField.tag = resData.resIndex
            lblMonWorkmin.text = "월요일 근로시간은 \(calworkmin(resData.resData.starttm.timeTrim(), resData.resData.endtm.timeTrim(), resData.resData.brkstarttm.timeTrim(), resData.resData.brkendtm.timeTrim(), 2)) 입니다."
        } else {
            monView.isHidden = true
            
        }
        if arrayCnt.contains("3") {
            tueView.isHidden = false
            let resData = getWorkDayArr(3)
            tueStarttmTextField.text = resData.resData.starttm.timeTrim()
            tueEndtmTextField.text = resData.resData.endtm.timeTrim()
            tueBkstarttmTextField.text = resData.resData.brkstarttm.timeTrim()
            tueBkendtmTextField.text = resData.resData.brkendtm.timeTrim()
            tueStarttmTextField.tag = resData.resIndex
             lblTueWorkmin.text = "화요일 근로시간은 \(calworkmin(resData.resData.starttm.timeTrim(), resData.resData.endtm.timeTrim(), resData.resData.brkstarttm.timeTrim(), resData.resData.brkendtm.timeTrim(), 3)) 입니다."
        } else {
            tueView.isHidden = true
            
        }
        if arrayCnt.contains("4") {
            wedView.isHidden = false
            let resData =  getWorkDayArr(4)
            wedStarttmTextField.text = resData.resData.starttm.timeTrim()
            wedEndtmTextField.text = resData.resData.endtm.timeTrim()
            wedBkstarttmTextField.text = resData.resData.brkstarttm.timeTrim()
            wedBkendtmTextField.text = resData.resData.brkendtm.timeTrim()
            wedStarttmTextField.tag = resData.resIndex
                         lblWedWorkmin.text = "수요일 근로시간은 \(calworkmin(resData.resData.starttm.timeTrim(), resData.resData.endtm.timeTrim(), resData.resData.brkstarttm.timeTrim(), resData.resData.brkendtm.timeTrim(), 4)) 입니다."
        } else {
            wedView.isHidden = true
            
        }
        if arrayCnt.contains("5") {
            thurView.isHidden = false
            let resData =  getWorkDayArr(5)
            thurStarttmTextField.text = resData.resData.starttm.timeTrim()
            thurEndtmTextField.text = resData.resData.endtm.timeTrim()
            thurBkstarttmTextField.text = resData.resData.brkstarttm.timeTrim()
            thurBkendtmTextField.text = resData.resData.brkendtm.timeTrim()
            thurStarttmTextField.tag = resData.resIndex
                                     lblThurWorkmin.text = "목요일 근로시간은 \(calworkmin(resData.resData.starttm.timeTrim(), resData.resData.endtm.timeTrim(), resData.resData.brkstarttm.timeTrim(), resData.resData.brkendtm.timeTrim(), 5)) 입니다."
        } else {
            thurView.isHidden = true
            
        }
        if arrayCnt.contains("6") {
            friView.isHidden = false
            let resData =  getWorkDayArr(6)
            friStarttmTextField.text = resData.resData.starttm.timeTrim()
            friEndtmTextField.text = resData.resData.endtm.timeTrim()
            friBkstarttmTextField.text = resData.resData.brkstarttm.timeTrim()
            friBkendtmTextField.text = resData.resData.brkendtm.timeTrim()
            friStarttmTextField.tag = resData.resIndex
             lblFriWorkmin.text = "금요일 근로시간은 \(calworkmin(resData.resData.starttm.timeTrim(), resData.resData.endtm.timeTrim(), resData.resData.brkstarttm.timeTrim(), resData.resData.brkendtm.timeTrim(), 6)) 입니다."
        } else {
            friView.isHidden = true
            
        }
        if arrayCnt.contains("7") {
            satView.isHidden = false
            let resData =  getWorkDayArr(7)
            satStarttmTextField.text = resData.resData.starttm.timeTrim()
            satEndtmTextField.text = resData.resData.endtm.timeTrim()
            satBkstarttmTextField.text = resData.resData.brkstarttm.timeTrim()
            satBkendtmTextField.text = resData.resData.brkendtm.timeTrim()
            satStarttmTextField.tag = resData.resIndex
            lblSatWorkmin.text = "토요일 근로시간은 \(calworkmin(resData.resData.starttm.timeTrim(), resData.resData.endtm.timeTrim(), resData.resData.brkstarttm.timeTrim(), resData.resData.brkendtm.timeTrim(), 7)) 입니다."
        } else {
            satView.isHidden = true
            
        }
        
    }
    
    //시간계산
    fileprivate func calworkmin(_ starttm: String , _ endtm: String , _ brkstarttm:String , _ brkendtm:String , _ dayweek:Int) -> String {
        let starttm:Int = calTime(starttm)
        let endtm:Int = calTime(endtm)
        let bkstm:Int = calTime(brkstarttm)
        let bketm:Int = calTime(brkendtm)
        var str = ""
        if (starttm > 0 && endtm > 0){
            var nDistance:uint = 0
            if (bkstm > 0 && bketm > 0){
                if endtm > starttm {
                    if bketm > bkstm {
                        nDistance = uint((endtm - starttm) - (bketm - bkstm))
                    }else{
                        nDistance = uint((endtm - starttm) - (bkstm - bketm))
                    }
                    
                }else{
                    if bketm > bkstm {
                        nDistance = uint((starttm - endtm) - (bketm - bkstm))
                    }else{
                        nDistance = uint((starttm - endtm) - (bkstm - bketm))
                    }
                }
            }else{
                if endtm > starttm {
                    nDistance = uint(endtm - starttm)
                }else{
                    nDistance = uint(starttm - endtm)
                }
            }
            
            let workmin = getMinTohm(Int(nDistance.magnitude))
            
            switch dayweek {
            case 2:
                str =  "\(workmin)"
            case 3:
                str =  "\(workmin)"
            case 4:
                str =  "\(workmin)"
            case 5:
                str =  "\(workmin)"
            case 6:
                str =  "\(workmin)"
            case 7:
                str =  "\(workmin)"
            case 1:
                str =  "\(workmin)"
            default:
                break
            }
        }
        
        return str
    }
    
    fileprivate func getWorkDay(_ nDayWeek: Int) -> Int {
        var nResult = -1
        for (i,_) in standInfo.workdaylist.enumerated() {
            if (standInfo.workdaylist[i].dayweek == nDayWeek) {
                nResult = i
            }
        }
        return nResult
    }
    
    fileprivate func getWorkDayArr(_ nDayWeek:Int) -> (resData: MultiConstractDate , resIndex: Int) {
        var nResult = MultiConstractDate()
        var index = -1
        for (i,_) in SelMultiArr.enumerated() {
            if (SelMultiArr[i].dayweek == nDayWeek) {
                nResult = SelMultiArr[i]
                index = i
            }
        }
        
        print("\n---------- [ index : \(index) ] ----------\n")
        return (nResult , index)
    }
    
    @IBAction func barBack(_ sender: UIButton) {
        
        if(standInfo.format == 1 && (standInfo.form == 3 || standInfo.form == 5)) {
            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step2_1VC") as! Lc_Default_Step2_1VC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.standInfo = standInfo
            self.present(vc, animated: false, completion: nil)
        }else{
            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step2VC") as! Lc_Default_Step2VC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.standInfo = standInfo
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    fileprivate func datePicker(_ field:UITextField ,_ flag: Int , _ index: Int){
        tmflag = flag
        indexPathDataRow = index
    }
    
    @IBAction func setDatePicker(_ sender: UITextField) {
        let goDatePickerView = UIDatePicker()
        if #available(iOS 13.4, *) {
            goDatePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        var loc: Locale?
        if sender == monStarttmTextField {
            datePicker(monStarttmTextField, 0, 2)
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = monStarttmTextField.text ?? ""
            tmflag = 0
            indexPathDataRow = 2
        }else if sender == monEndtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = monEndtmTextField.text ?? ""
            tmflag = 1
            indexPathDataRow = 2
        }else if sender == monBkstarttmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = monBkstarttmTextField.text ?? ""
            tmflag = 2
            indexPathDataRow = 2
        }else if sender == monBkendtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = monBkendtmTextField.text ?? ""
            tmflag = 3
            indexPathDataRow = 2
        }else if sender == tueStarttmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = tueStarttmTextField.text ?? ""
            tmflag = 4
            indexPathDataRow = 3
        }else if sender == tueEndtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = tueEndtmTextField.text ?? ""
            tmflag = 5
            indexPathDataRow = 3
        }else if sender == tueBkstarttmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = tueBkstarttmTextField.text ?? ""
            tmflag = 6
            indexPathDataRow = 3
        }else if sender == tueBkendtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = tueBkendtmTextField.text ?? ""
            tmflag = 7
            indexPathDataRow = 3
        }else if sender == wedStarttmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = wedStarttmTextField.text ?? ""
            tmflag = 8
            indexPathDataRow = 4
        }else if sender == wedEndtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = wedEndtmTextField.text ?? ""
            tmflag = 9
            indexPathDataRow = 4
        }else if sender == wedBkstarttmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = wedBkstarttmTextField.text ?? ""
            tmflag = 10
            indexPathDataRow = 4
        }else if sender == wedBkendtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = wedBkendtmTextField.text ?? ""
            tmflag = 11
            indexPathDataRow = 4
        }else if sender == thurStarttmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = thurStarttmTextField.text ?? ""
            tmflag = 12
            indexPathDataRow = 5
        }else if sender == thurEndtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = thurEndtmTextField.text ?? ""
            tmflag = 13
            indexPathDataRow = 5
        }else if sender == thurBkstarttmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = thurBkstarttmTextField.text ?? ""
            tmflag = 14
            indexPathDataRow = 5
        }else if sender == thurBkendtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = thurBkendtmTextField.text ?? ""
            tmflag = 15
            indexPathDataRow = 5
        }else if sender == friStarttmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = friStarttmTextField.text ?? ""
            tmflag = 16
            indexPathDataRow = 6
        }else if sender == friEndtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = friEndtmTextField.text ?? ""
            tmflag = 17
            indexPathDataRow = 6
        }else if sender == friBkstarttmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = friBkstarttmTextField.text ?? ""
            tmflag = 18
            indexPathDataRow = 6
        }else if sender == friBkendtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = friBkendtmTextField.text ?? ""
            tmflag = 19
            indexPathDataRow = 6
        }else if sender == satStarttmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = satStarttmTextField.text ?? ""
            tmflag = 20
            indexPathDataRow = 7
        }else if sender == satEndtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = satEndtmTextField.text ?? ""
            tmflag = 21
            indexPathDataRow = 7
        }else if sender == satBkstarttmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = satBkstarttmTextField.text ?? ""
            tmflag = 22
            indexPathDataRow = 7
        }else if sender == satBkendtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = satBkendtmTextField.text ?? ""
            tmflag = 23
            indexPathDataRow = 7
        }else if sender == sunStarttmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = sunStarttmTextField.text ?? ""
            tmflag = 24
            indexPathDataRow = 1
        }else if sender == sunEndtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = sunEndtmTextField.text ?? ""
            tmflag = 25
            indexPathDataRow = 1
        }else if sender == sunBkstarttmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = sunBkstarttmTextField.text ?? ""
            tmflag = 26
            indexPathDataRow = 1
        }else if sender == sunBkendtmTextField {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = sunBkendtmTextField.text ?? ""
            tmflag = 27
            indexPathDataRow = 1
        }
        
        goDatePickerView.locale = loc
        sender.inputView = goDatePickerView
        
        print("inputData = ", inputData)
        if inputData != "" {
            let date = dateFormatter.date(from: inputData)
            goDatePickerView.date = date!
        }
        
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.editingDidBegin)
        switch tmflag {
        case 0:
            self.monStarttmTextField.becomeFirstResponder()
        case 1:
            self.monEndtmTextField.becomeFirstResponder()
        case 2:
            self.monBkstarttmTextField.becomeFirstResponder()
        case 3:
            self.monBkendtmTextField.becomeFirstResponder()
            
        case 4:
            self.tueStarttmTextField.becomeFirstResponder()
        case 5:
            self.tueEndtmTextField.becomeFirstResponder()
        case 6:
            self.tueBkstarttmTextField.becomeFirstResponder()
        case 7:
            self.tueBkendtmTextField.becomeFirstResponder()
            
        case 8:
            self.wedStarttmTextField.becomeFirstResponder()
        case 9:
            self.wedEndtmTextField.becomeFirstResponder()
        case 10:
            self.wedBkstarttmTextField.becomeFirstResponder()
        case 11:
            self.wedBkendtmTextField.becomeFirstResponder()
            
        case 12:
            self.thurStarttmTextField.becomeFirstResponder()
        case 13:
            self.thurEndtmTextField.becomeFirstResponder()
        case 14:
            self.thurBkstarttmTextField.becomeFirstResponder()
        case 15:
            self.thurBkendtmTextField.becomeFirstResponder()
            
        case 16:
            self.friStarttmTextField.becomeFirstResponder()
        case 17:
            self.friEndtmTextField.becomeFirstResponder()
        case 18:
            self.friBkstarttmTextField.becomeFirstResponder()
        case 19:
            self.friBkendtmTextField.becomeFirstResponder()
            
        case 20:
            self.satStarttmTextField.becomeFirstResponder()
        case 21:
            self.satEndtmTextField.becomeFirstResponder()
        case 22:
            self.satBkstarttmTextField.becomeFirstResponder()
        case 23:
            
            self.satBkendtmTextField.becomeFirstResponder()
        case 24:
            self.sunStarttmTextField.becomeFirstResponder()
        case 25:
            self.sunEndtmTextField.becomeFirstResponder()
        case 26:
            self.sunBkstarttmTextField.becomeFirstResponder()
        case 27:
            self.sunBkendtmTextField.becomeFirstResponder()
        default:
            break;
        }
    }
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        switch tmflag {
        case 0:
            self.monStarttmTextField.text = dateFormatter.string(from: sender.date)
            //            if (self.monStarttmTextField.text != "" ){
            //                self.errstImg.image = chkstatusAlertpass
            //            }else{
            //                self.errstImg.image = chkstatusAlert
            //            }
            
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].starttm = monStarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 1:
            self.monEndtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].endtm = monEndtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 2:
            self.monBkstarttmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].brkstarttm = monBkstarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 3:
            self.monBkendtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].brkendtm = monBkendtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 4:
            self.tueStarttmTextField.text = dateFormatter.string(from: sender.date)
            
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].starttm = tueStarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 5:
            self.tueEndtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].endtm = tueEndtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 6:
            self.tueBkstarttmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].brkstarttm = tueBkstarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 7:
            self.tueBkendtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (i == indexPathDataRow) {
                    SelMultiArr[i].brkendtm = tueBkendtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 8:
            self.wedStarttmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].starttm = wedStarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 9:
            self.wedEndtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].endtm = wedEndtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 10:
            self.wedBkstarttmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].brkstarttm = wedBkstarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 11:
            self.wedBkendtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].brkendtm = wedBkendtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 12:
            self.thurStarttmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].starttm = thurStarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 13:
            self.thurEndtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].endtm = thurEndtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 14:
            self.thurBkstarttmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].brkstarttm = thurBkstarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 15:
            self.thurBkendtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].brkendtm = thurBkendtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 16:
            self.friStarttmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].starttm = friStarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 17:
            self.friEndtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].endtm = friEndtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 18:
            self.friBkstarttmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].brkstarttm = friBkstarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 19:
            self.friBkendtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].brkendtm = friBkendtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 20:
            self.satStarttmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].starttm = satStarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 21:
            self.satEndtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].endtm = satEndtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 22:
            self.satBkstarttmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].brkstarttm = satBkstarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 23:
            self.satBkendtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].brkendtm = satBkendtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 24:
            self.sunStarttmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].starttm = sunStarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 25:
            self.sunEndtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].endtm = sunEndtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 26:
            self.sunBkstarttmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].brkstarttm = sunBkstarttmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        case 27:
            self.sunBkendtmTextField.text = dateFormatter.string(from: sender.date)
            for (i,_) in SelMultiArr.enumerated() {
                if (SelMultiArr[i].dayweek == indexPathDataRow) {
                    SelMultiArr[i].brkendtm = sunBkendtmTextField.text ?? ""
                    setValueArr(of: SelMultiArr[i], i: i)
                }
            }
        default:
            break;
        }
        
        
        
    }
    
    fileprivate func setValueArr(of cast: MultiConstractDate, i: Int ){
        print("\n---------- [ cast : \(cast) , i :\(i) , indexPathDataRow : \(indexPathDataRow)] ----------\n")
        if SelMultiArr.count > 0 {
            SelMultiArr[i].starttm = cast.starttm
            SelMultiArr[i].endtm = cast.endtm
            SelMultiArr[i].brkstarttm = cast.brkstarttm
            SelMultiArr[i].brkendtm = cast.brkendtm
            if SelMultiArr[i].wdysid > 0 {
                SelMultiArr[i].wdysid = SelMultiArr[i].wdysid
            }
            
            SelMultiArr[i].dayweek = SelMultiArr[i].dayweek
            
            let starttm:Int = calTime(cast.starttm)
            let endtm:Int = calTime(cast.endtm)
            let bkstm:Int = calTime(cast.brkstarttm)
            let bketm:Int = calTime(cast.brkendtm)
            
            
            if (starttm > 0 && endtm > 0){
                //                if (bkstm > 0 && bketm > 0 ) {
                //                    if starttm > 0 || endtm > 0 {
                //                        self.toast("근로시간에 해당하지 않습니다.")
                //                        SelMultiArr[i].brkstarttm = ""
                //                        SelMultiArr[i].brkendtm = ""
                //                        return
                //                    }
                //                }else{
                var nDistance:uint = 0
                if (bkstm > 0 && bketm > 0){
                    if endtm > starttm {
                        if endtm > starttm {
                            if bketm > bkstm {
                                nDistance = uint((endtm - starttm) - (bketm - bkstm))
                            }else{
                                nDistance = uint((endtm - starttm) - (bkstm - bketm))
                            }
                            
                        }else{
                            if bketm > bkstm {
                                nDistance = uint((starttm - endtm) - (bketm - bkstm))
                            }else{
                                nDistance = uint((starttm - endtm) - (bkstm - bketm))
                            }
                        }
                        
                    }else{
                        if endtm > starttm {
                            nDistance = uint(endtm - starttm)
                        }else{
                            nDistance = uint(starttm - endtm)
                        }
                    }
                }
                
                let workmin = getMinTohm(Int(nDistance.magnitude))
                
                SelMultiArr[i].workmin = Int(nDistance)
                switch SelMultiArr[i].dayweek {
                case 2:
                    lblMonWorkmin.text =  "월요일 근로시간은 \(workmin) 입니다."
                case 3:
                    lblTueWorkmin.text =  "화요일 근로시간은 \(workmin) 입니다."
                case 4:
                    lblWedWorkmin.text =  "수요일 근로시간은 \(workmin) 입니다."
                case 5:
                    lblThurWorkmin.text =  "목요일 근로시간은 \(workmin) 입니다."
                case 6:
                    lblFriWorkmin.text =  "금요일 근로시간은 \(workmin) 입니다."
                case 7:
                    lblSatWorkmin.text =  "토요일 근로시간은 \(workmin) 입니다."
                case 1:
                    lblSunWorkmin.text =  "일요일 근로시간은 \(workmin) 입니다."
                default:
                    break
                }
                //                }
            }
            
            SelMultiArrTemp.removeAll()
            SelMultiArrTemp = SelMultiArr
            
        }
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        
        var param: [String: Any] = [:]
        var multiArr: [Dictionary<String, Any>] = []
        print("\n---------- [ SelMultiArr : \(SelMultiArr) ] ----------\n")
        //
        for model in SelMultiArr {
            let object : [String : Any] = [
                "wdysid": model.wdysid,
                "dayweek": model.dayweek,
                "starttm": model.starttm,
                "endtm": model.endtm,
                "brkstarttm": model.brkstarttm,
                "brkendtm": model.brkendtm,
                "workmin": model.workmin
            ]
            multiArr.append(object)
        }
        
        
        param = ["workday" : multiArr ]
        
        let data = try! JSONSerialization.data(withJSONObject: param, options: [])
        let jsonBatch:String = String(data: data, encoding: .utf8)!
        
        print("\n---------- [ json : \(jsonBatch) ] ----------\n")
        
        NetworkManager.shared().lc_std_step2_1(lctsid: standInfo.sid, json: jsonBatch) { (isSuccess, resCode) in
            if(isSuccess){
                DispatchQueue.main.async {
                    if resCode == 1 {
                        let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step3VC") as! Lc_Default_Step3VC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.standInfo = self.standInfo
                        self.present(vc, animated: false, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }
                
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    //MARK: - pop버튼
    @IBAction func moreBtn(_ sender: UIButton) {
        SelLcEmpInfo = standInfo
        SelLcEmpInfo.viewpage = "std_step2_1"
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

private extension ShotTimeVC {
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
            var viewpage: String = "std_step2_1"
            let rowVC: PanModalPresentable.LayoutType = ContractInfoPopup()
        }
        
        struct SEBsic: RowPresentable {
            var viewpage: String = "step1"
            let rowVC: PanModalPresentable.LayoutType = SE_ContractInfoPopup()
            
        }
        
    }
}

// MARK: - UITextFieldDelegate
extension ShotTimeVC :  UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //CalPay()
    }
}
