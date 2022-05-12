//
//  PushNotiVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/12/05.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class PushNotiVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var swCmtNoti: UISwitch!
    @IBOutlet weak var swAprNoti: UISwitch!
    @IBOutlet weak var swEmpNoti: UISwitch!
    
    @IBOutlet weak var vwCmtArea: UIView!
    @IBOutlet weak var vwAprArea: UIView!
    @IBOutlet weak var vwEmpArea: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var mbrsid = 0
    var aprmgr = 1
    var cmtmgr = 1
    var empmgr = 1
    
    let toggleCmtNoti = ToggleSwitch(with: images)
    let toggleAprNoti = ToggleSwitch(with: images)
    let toggleEmpNoti = ToggleSwitch(with: images)
    var switchYposition:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.layer.cornerRadius = 6
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mbrsid = userInfo.mbrsid 
        valueSetting()
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
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
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(관리자앱 푸시수신 설정 조회)
         Return  - 푸시수신 설정
         Parameter
         MBRSID        회원번호
         */
        let url = urlClass.get_mbrpush_mgr(mbrsid: mbrsid)
        let jsonTemp = jsonClass.weather_request(setUrl: url)
        if let jsonData = jsonClass.json_parseData(jsonTemp!) {
            print(url)
            print(jsonData)
            
            //0.거부 1.허용
            aprmgr = jsonData["aprmgr"] as! Int
            cmtmgr = jsonData["cmtmgr"] as! Int
            empmgr = jsonData["empmgr"] as! Int
            
            if aprmgr == 0 {
                swAprNoti.isOn = false
                toggleAprNoti.setOn(on: false, animated: true)
            }else {
                swAprNoti.isOn = true
                toggleAprNoti.setOn(on: true, animated: true)
            }
            if cmtmgr == 0 {
                swCmtNoti.isOn = false
                toggleCmtNoti.setOn(on: false, animated: true)
            }else {
                swCmtNoti.isOn = true
                toggleCmtNoti.setOn(on: true, animated: true)
            }
            if empmgr == 0 {
                swEmpNoti.isOn = false
                toggleEmpNoti.setOn(on: false, animated: true)
            }else {
                swEmpNoti.isOn = true
                toggleEmpNoti.setOn(on: true, animated: true)
            }
        }
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        let url = urlClass.set_mbrpush_mgr(mbrsid: mbrsid, cmtmgr: cmtmgr, aprmgr: aprmgr, empmgr: empmgr)
        if let jsonTemp = jsonClass.weather_request(setUrl: url) {
            if let jsonData = jsonClass.json_parseData(jsonTemp) {
                print(url)
                print(jsonData)
                
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

// MARK: - method
extension PushNotiVC {
    @objc func toggleCmtNotiChanged(toggle: ToggleSwitch) {
        if  toggle.isOn {
            cmtmgr = 1
        }else {
            cmtmgr = 0
        }
    }
    
    @objc func toggleAprNotiChanged(toggle: ToggleSwitch) {
        if  toggle.isOn {
            aprmgr = 1
        }else {
            aprmgr = 0
        }
    }
    
    @objc func toggleEmpNotiChanged(toggle: ToggleSwitch) {
        if  toggle.isOn {
            empmgr = 1
        }else {
            empmgr = 0
        }
    }
    
    @IBAction func cmtChange(_ sender: UISwitch) {
        if  sender.isOn {
            cmtmgr = 1
        }else {
            cmtmgr = 0
        }
    }
    
    @IBAction func aprChange(_ sender: UISwitch) {
        if  sender.isOn {
            aprmgr = 1
        }else {
            aprmgr = 0
        }
    }
    
    @IBAction func empChange(_ sender: UISwitch) {
        if  sender.isOn {
            empmgr = 1
        }else {
            empmgr = 0
        }
    }
}
