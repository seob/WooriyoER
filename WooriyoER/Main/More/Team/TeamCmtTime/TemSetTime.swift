//
//  TemSetTime.swift
//  PinPle
//
//  Created by WRY_010 on 26/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TemSetTime: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var lblTname: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblSave: UILabel!
    
    @IBOutlet weak var vwMainArea: UIView!
    let toggleBT = ToggleSwitch(with: images)
    var switchYposition:CGFloat = 0
    var switchXposition:CGFloat = 0
    
    let dateFormatter = DateFormatter()
    var inputData: String = ""
    
    var starttm: String = ""
    var endtm: String = ""
    var brktime: Int = 0
    var workday: String = ""
    var txtFlag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.eachLblBtn(btnSave, lblSave)
        textStart.delegate = self
        textEnd.delegate = self
        
        addToolBar(textFields: [textStart, textEnd])
        
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
        lblTname.text = SelTemInfo.name
        starttm = SelTemInfo.starttm
        endtm = SelTemInfo.endtm
        workday = SelTemInfo.workday
        brktime = SelTemInfo.brktime
        
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
        self.dismiss(animated: true, completion: nil)
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
        let st = textStart.text!
        let endtm = textEnd.text!
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
                self.toast("요일은 선택해주세요.")
                return
            }
        }
        
        print("\n---------- [ workday = \(workday) ] ----------\n")
        
        SelTemInfo.schdl = 2
        SelTemInfo.starttm = st
        SelTemInfo.endtm = endtm
        SelTemInfo.brktime = brktime
        SelTemInfo.workday = workday
        
//        let vc = MoreSB.instantiateViewController(withIdentifier: "TemCmtTimeVC") as! TemCmtTimeVC
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: false, completion: nil)
        NotificationCenter.default.post(name: .reloadList, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePicker(_ sender: UITextField) {
        let goDatePickerView = UIDatePicker()
        if #available(iOS 13.4, *) {
            goDatePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        var loc: Locale?
        
        starttm = textStart.text!
        endtm = textEnd.text!
        
        if sender == textStart {
            inputData = starttm
            txtFlag = 0
        }else if sender == textEnd {
            inputData = endtm
            txtFlag = 1
        }
        goDatePickerView.datePickerMode = UIDatePicker.Mode.time
        dateFormatter.dateFormat = "HH:mm"
        goDatePickerView.minuteInterval = 5
        loc = Locale(identifier: "en_GB")
        
        goDatePickerView.locale = loc
        sender.inputView = goDatePickerView
        
        print("inputData = ", inputData)
        if inputData != "" {
            let date = dateFormatter.date(from: inputData)
            goDatePickerView.date = date!
        }
        
        if txtFlag == 2 && textStart.text == textEnd.text {
            goDatePickerView.minimumDate = dateFormatter.date(from: starttm)
        }
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        switch txtFlag {
        case 0:
            self.textStart.becomeFirstResponder();
        case 1:
            self.textEnd.becomeFirstResponder();
        default:
            break;
        }
    }
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        switch txtFlag {
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

