//
//  SetTime.swift
//  PinPle
//
//  Created by WRY_010 on 26/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class SetTime: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var textStart: UITextField!
    @IBOutlet weak var textEnd: UITextField!
    @IBOutlet weak var btnMon: UIButton!
    @IBOutlet weak var btnTue: UIButton!
    @IBOutlet weak var btnWed: UIButton!
    @IBOutlet weak var btnThu: UIButton!
    @IBOutlet weak var btnFri: UIButton!
    @IBOutlet weak var btnSat: UIButton!
    @IBOutlet weak var btnSun: UIButton!
    @IBOutlet weak var swBT: UISwitch!
    @IBOutlet weak var btnOk: UIButton!
    
    @IBOutlet weak var vwMainArea: UIView!
    let toggleBT = ToggleSwitch(with: images)
    var switchYposition:CGFloat = 0
    var switchXposition:CGFloat = 0
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    let dateFormatter = DateFormatter()
    var inputData = ""                  //picker 시간
    
    var starttm: String = "09:00"       //근무 시작시간.. ex)09:00
    var endtm: String  = "18:00"        //근무 종료시간.. ex)18:00
    var brktime: Int = 1                //휴게시간 설정(0.설정안함 1.설정 default '1')
    var workday: String = "2,3,4,5,6"        //근무요일.. 1(일),2(월),3(화),4(수),5(목),6(금),7(토) 구분자 ','  .. ex) 2,3,4,5,6
    var tmflag = 0                     //출근,퇴근 구분(0.시작시간 1.종료시간)
    var tmpbrktime: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOk.layer.cornerRadius = 6
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
        
        textStart.delegate = self
        textEnd.delegate = self
        
        addToolBar(textFields: [textStart, textEnd])
        
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
        }else{
            switchYposition = 340
        }
        toggleBT.frame.origin.x = switchYposition
        toggleBT.frame.origin.y = 155
        
        
        
        self.vwMainArea.addSubview(toggleBT)
        
        toggleBT.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
    }
    
    @objc func toggleValueChanged(toggle: ToggleSwitch) {
        if toggle.isOn {
            brktime = 1
        }else {
            brktime = 0
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        starttm = moreCmpInfo.starttm
        endtm = moreCmpInfo.endtm
        brktime = moreCmpInfo.brktime
        workday = moreCmpInfo.workday 
        textStart.text = starttm
        textEnd.text = endtm
        
        if brktime == 0 {
            swBT.isOn = false
            toggleBT.setOn(on: false, animated: true)
        }else {
            swBT.isOn = true
            toggleBT.setOn(on: true, animated: true)
        }
        
        btnSun.isSelected = workday.contains("1")
        btnMon.isSelected = workday.contains("2")
        btnTue.isSelected = workday.contains("3")
        btnWed.isSelected = workday.contains("4")
        btnThu.isSelected = workday.contains("5")
        btnFri.isSelected = workday.contains("6")
        btnSat.isSelected = workday.contains("7")
        
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "CmtTimeVC") as! CmtTimeVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func swBTimeSet(_ sender: UISwitch) {
        if sender.isOn {
            brktime = 1
        }else {
            brktime = 0
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
    @IBAction func save(_ sender: UIButton) {
        var workday = ""
        
        if btnSun.isSelected == true {  workday = "1,"  }
        if btnMon.isSelected == true {  workday += "2," }
        if btnTue.isSelected == true {  workday += "3," }
        if btnWed.isSelected == true {  workday += "4," }
        if btnThu.isSelected == true {  workday += "5," }
        if btnFri.isSelected == true {  workday += "6," }
        if btnSat.isSelected == true {
            workday += "7"
        } else{
            if workday != "" {
                workday.remove(at: workday.lastIndex(of: ",")!)
            }else{
                self.toast("요일을 선택해주세요.")
                return
            }
            
        }
        
        print("\n---------- [ SetTime save schdl : \(moreCmpInfo.schdl) . cmtrc : \(moreCmpInfo.cmtrc)] ----------\n")
        //        print("\n---------- [ workday = \(workday) ] ----------\n")
        
        moreCmpInfo.starttm = starttm
        moreCmpInfo.endtm = endtm
        moreCmpInfo.brktime =  brktime
        moreCmpInfo.workday = workday
        
        let vc = MoreSB.instantiateViewController(withIdentifier: "CmtTimeVC") as! CmtTimeVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func datePicker(_ sender: UITextField) {
        let goDatePickerView = UIDatePicker()
        if #available(iOS 13.4, *) {
            goDatePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        if sender == textStart {
            inputData = starttm
            tmflag = 0
        }else if sender == textEnd {
            inputData = endtm
            tmflag = 1
        }
        goDatePickerView.datePickerMode = UIDatePicker.Mode.time
        dateFormatter.dateFormat = "HH:mm"
        goDatePickerView.minuteInterval = 5
        goDatePickerView.locale = Locale(identifier: "en_GB")
        
        sender.inputView = goDatePickerView
        
        print("inputData = ", inputData)
        if inputData != "" {
            let date = dateFormatter.date(from: inputData)
            goDatePickerView.date = date!
        }
        
        if tmflag == 2 && textStart.text == textEnd.text {
            goDatePickerView.minimumDate = dateFormatter.date(from: starttm)
        }
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        switch tmflag {
            case 0:
                self.textStart.becomeFirstResponder();
            case 1:
                self.textEnd.becomeFirstResponder();
            default:
                break;
        }
    }
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        switch tmflag {
            case 0:
                self.starttm = dateFormatter.string(from: sender.date)
                self.textStart.text = self.starttm
            case 1:
                self.endtm = dateFormatter.string(from: sender.date)
                self.textEnd.text = self.endtm
            default:
                break;
        }
    }
    
}
