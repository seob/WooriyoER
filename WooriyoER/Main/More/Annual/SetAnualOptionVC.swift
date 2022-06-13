//
//  SetAnualOptionVC.swift
//  PinPle
//
//  Created by seob on 2021/11/03.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit
import DatePickerDialog

class SetAnualOptionVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var swCmtNoti: UISwitch!//1월1일
    @IBOutlet weak var swAprNoti: UISwitch! //3월1일
    @IBOutlet weak var swEmpNoti: UISwitch!// 그외
    
    @IBOutlet weak var vwCmtArea: UIView!
    @IBOutlet weak var vwAprArea: UIView!
    @IBOutlet weak var vwEmpArea: UIView!
    
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    
    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    var mbrsid = 0
    var cmtmgr = 1 //1월1일
    var aprmgr = 0 //3월1일
    var empmgr = 0 //그외
    
    let toggleCmtNoti = ToggleSwitch(with: imagesFreeFical)
    let toggleAprNoti = ToggleSwitch(with: imagesFreeFical)
    let toggleEmpNoti = ToggleSwitch(with: imagesFreeFical)
    var switchYposition:CGFloat = 0
    var strAnualYear = ""
    override func viewDidLoad() {
        super.viewDidLoad()
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
        toggleCmtNoti.frame.origin.x = switchYposition
        toggleCmtNoti.frame.origin.y = 0
        
        toggleAprNoti.frame.origin.x = switchYposition
        toggleAprNoti.frame.origin.y = 0
        
        toggleEmpNoti.frame.origin.x = switchYposition
        toggleEmpNoti.frame.origin.y = 0
        
        
        self.vwCmtArea.addSubview(toggleCmtNoti)
        self.vwAprArea.addSubview(toggleAprNoti)
        self.vwEmpArea.addSubview(toggleEmpNoti)
        
        toggleCmtNoti.addTarget(self, action: #selector(toggleCmtNotiChanged), for: .valueChanged)
        toggleAprNoti.addTarget(self, action: #selector(toggleAprNotiChanged), for: .valueChanged)
        toggleEmpNoti.addTarget(self, action: #selector(toggleEmpNotiChanged), for: .valueChanged)
        
        
        let startyGestuure = UITapGestureRecognizer(target: self, action: #selector(startdatePicker))
        self.vwEmpArea.isUserInteractionEnabled = true
        self.vwEmpArea.addGestureRecognizer(startyGestuure)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        
        DateView.isHidden = true
        
        if CompanyInfo.stanualyear == "01-01" {
            cmtmgr = 1
            aprmgr = 0
            empmgr = 0
        }else if CompanyInfo.stanualyear == "03-01" {
            cmtmgr = 0
            aprmgr = 1
            empmgr = 0
        }else {
            cmtmgr = 0
            aprmgr = 0
            empmgr = 1
            DateView.isHidden = false
            let splitArr = CompanyInfo.stanualyear.split(separator: "-")
            self.lblMonth.text = "\(splitArr[0].replacingOccurrences(of: "(", with: ""))"
            self.lblDay.text =  "\(splitArr[1].replacingOccurrences(of: ")", with: ""))"
        }
        
        if cmtmgr == 1 {
            swCmtNoti.isOn = true
            toggleCmtNoti.setOn(on: true, animated: true)
        }else {
            swCmtNoti.isOn = false
            toggleCmtNoti.setOn(on: false, animated: true)
        }
        
        
        if aprmgr == 1 {
            swAprNoti.isOn = true
            toggleAprNoti.setOn(on: true, animated: true)
        }else {
            swAprNoti.isOn = false
            toggleAprNoti.setOn(on: false, animated: true)
        }
        
        
        if empmgr == 1 {
            swEmpNoti.isOn = true
            toggleEmpNoti.setOn(on: true, animated: true)
        }else {
            swEmpNoti.isOn = false
            toggleEmpNoti.setOn(on: false, animated: true)
        }
        
    }
    
    @objc func startdatePicker(_ sender: UIGestureRecognizer){
        let yearsToAdd = 1
        var dateComponents = DateComponents()
        dateComponents.year = yearsToAdd
        let tmpBefor = Calendar.current.component(.year, from: Date())
 
        let splitArr = CompanyInfo.stanualyear.split(separator: "-")
        let month = splitArr[0].replacingOccurrences(of: "(", with: "")
        let day = splitArr[1].replacingOccurrences(of: ")", with: "")
        let myDateComponents = DateComponents(year: tmpBefor, month: Int(month), day: Int(day))
        let calendar = Calendar.current
        let myDate = calendar.date(from: myDateComponents)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy.MM.dd"
        dateFormat.dateStyle = .long
        dateFormat.string(for: myDate)
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택", doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: myDate ?? Date(), minimumDate: nil, maximumDate: nil, datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                let tmpDate = formatter.string(from: dt)
                let splitArr = tmpDate.split(separator: ".")
                self.lblMonth.text = "\(splitArr[1])"
                self.lblDay.text =  "\(splitArr[2])"
            }
        }
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "SetAnlVC") as! SetAnlVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
    
    
    @IBAction func saveClick(_ sender: UIButton) {
        if cmtmgr > 0 {
            strAnualYear = "01-01"
        }else if aprmgr > 0 {
            strAnualYear = "03-01"
        }else {
            let tmpDate1 = lblMonth.text ?? ""
            let tmpDate2 = lblDay.text ?? ""
            
            if tmpDate1 != "" && tmpDate2 != "" {
                strAnualYear = "\(tmpDate1)-\(tmpDate2)"
            }
            
        }
        
        NetworkManager.shared().SetCmpAnualFical(cmpsid: CompanyInfo.sid, anualYear: strAnualYear) { isSuccess, result in
            if(isSuccess){
                switch result {
                case 1:
                    moreCmpInfo.stanualyear = self.strAnualYear
                    CompanyInfo.stanualyear = self.strAnualYear
                    let vc = MoreSB.instantiateViewController(withIdentifier: "SetAnlVC") as! SetAnlVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                case 0 :
                    self.toast("다시 시도해 주세요.")
                case -1:
                    self.toast("잔여 포인트 부족")
                default:
                    print("\n---------- [ error ] ----------\n")
                }
            }else{
                self.toast("다시 시도해 주세요")
            }
        }
    }
    
}

// MARK: - method
extension SetAnualOptionVC {
    @objc func toggleCmtNotiChanged(toggle: ToggleSwitch) {
        cmtmgr = 1
        aprmgr = 0
        empmgr = 0
        toggleCmtNoti.setOn(on: true, animated: true)
        toggleAprNoti.setOn(on: false, animated: true)
        toggleEmpNoti.setOn(on: false, animated: true)
        DateView.isHidden = true
    }
    
    @objc func toggleAprNotiChanged(toggle: ToggleSwitch) {
        cmtmgr = 0
        aprmgr = 1
        empmgr = 0
        toggleCmtNoti.setOn(on: false, animated: true)
        toggleAprNoti.setOn(on: true, animated: true)
        toggleEmpNoti.setOn(on: false, animated: true)
        
        DateView.isHidden = true
    }
    
    @objc func toggleEmpNotiChanged(toggle: ToggleSwitch) {
        cmtmgr = 0
        aprmgr = 0
        empmgr = 1
        lblMonth.text = "01"
        lblDay.text = "01"
        toggleCmtNoti.setOn(on: false, animated: true)
        toggleAprNoti.setOn(on: false, animated: true)
        toggleEmpNoti.setOn(on: true, animated: true)
        
        DateView.isHidden = false
    }
}
