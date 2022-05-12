//
//  CmpWTimeVC.swift
//  PinPle
//
//  Created by WRY_010 on 26/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmpWTimeSetVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textStarttm: UITextField!    // 근무 시작 시간 텍스트 필드
    @IBOutlet weak var textEndtm: UITextField!  // 근무 종료 시간 텍스트필드
    @IBOutlet weak var btnBrktime: UIButton!    // 휴게시간 스위치 버튼
    
    @IBOutlet weak var btnMon: UIButton! // 월요일 버튼
    @IBOutlet weak var btnTue: UIButton! // 화요일 버튼
    @IBOutlet weak var btnWed: UIButton! // 수요일 버튼
    @IBOutlet weak var btnThu: UIButton! // 목요일 버튼
    @IBOutlet weak var btnFri: UIButton! // 금요일 버튼
    @IBOutlet weak var btnSat: UIButton! // 토요일 버튼
    @IBOutlet weak var btnSun: UIButton! // 일요일 버튼
    @IBOutlet weak var btnSave: UIButton!
    
    let dateFormatter = DateFormatter()
    var inputData = ""                  //picker 시간
    
    var starttm: String = "09:00"       //근무 시작시간.. ex)09:00
    var endtm: String  = "18:00"        //근무 종료시간.. ex)18:00
    var brktime: Int = 1                //휴게시간 설정(0.설정안함 1.설정 default '1')
    var workday: String = "2,3,4,5,6"        //근무요일.. 1(일),2(월),3(화),4(수),5(목),6(금),7(토) 구분자 ','  .. ex) 2,3,4,5,6
    var tmflag = 0                     //출근,퇴근 구분(0.시작시간 1.종료시간)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.layer.cornerRadius = 6
        textStarttm.delegate = self
        textEndtm.delegate = self
        
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
        btnBrktime.setImage(switchOnImg, for: .selected)
        btnBrktime.setImage(switchOffImg, for: .normal)
        
        addToolBar(textFields: [textStarttm, textEndtm])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        starttm = CompanyInfo.starttm
        endtm = CompanyInfo.endtm
        brktime = CompanyInfo.brktime
        workday = CompanyInfo.workday
        
        if starttm.count > 5 {
            starttm = starttm.timeTrim()
            endtm = endtm.timeTrim()
        }
        
        textStarttm.text = starttm
        textEndtm.text = endtm
        
        if brktime == 0 {
            btnBrktime.isSelected = false
        }else {
            btnBrktime.isSelected = true
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
        let vc = CmpCrtSB.instantiateViewController(withIdentifier: "CmpWTimeVC") as! CmpWTimeVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func brktimeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            brktime = 1
        }else {
            brktime = 0
        }
    }
    
    @IBAction func weekAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
   
    @IBAction func saveAction(_ sender: UIButton) {
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
        
        print("\n---------- [ workday = \(workday) ] ----------\n")
        
        
        CompanyInfo.starttm = starttm
        CompanyInfo.endtm = endtm
        CompanyInfo.brktime =  brktime
        CompanyInfo.workday = workday
        
        let vc = CmpCrtSB.instantiateViewController(withIdentifier: "CmpWTimeVC") as! CmpWTimeVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func datePicker(_ sender: UITextField) {
        let goDatePickerView = UIDatePicker()
        goDatePickerView.datePickerMode = UIDatePicker.Mode.time
        goDatePickerView.minuteInterval = 10
        goDatePickerView.locale = Locale(identifier: "en_GB")
        if #available(iOS 13.4, *) {
            goDatePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        sender.inputView = goDatePickerView
        
        dateFormatter.dateFormat = "HH:mm"
        
        if sender == textStarttm {
            inputData = starttm
            tmflag = 0
        }else if sender == textEndtm {
            inputData = endtm
            tmflag = 1
        }
        
        if inputData != "" {
            let date = dateFormatter.date(from: inputData)
            goDatePickerView.date = date!
        }
        
//        if tmflag == 2 && textStarttm.text == textEndtm.text {
//            goDatePickerView.minimumDate = dateFormatter.date(from: starttm)
//        }
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        switch tmflag {
        case 0:
            self.textStarttm.becomeFirstResponder();
        case 1:
            self.textEndtm.becomeFirstResponder();
        default:
            break;
        }
    }
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        switch tmflag {
        case 0:
            self.starttm = dateFormatter.string(from: sender.date)
            self.textStarttm.text = self.starttm
        case 1:
            self.endtm = dateFormatter.string(from: sender.date)
            self.textEndtm.text = self.endtm
        default:
            break;
        }
    }
    
}
