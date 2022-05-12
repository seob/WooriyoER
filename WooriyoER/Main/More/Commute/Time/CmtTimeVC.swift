//
//  CmtTimeVC.swift
//  PinPle
//
//  Created by WRY_010 on 26/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmtTimeVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblSTime: UILabel!
    @IBOutlet weak var lblETime: UILabel!
    @IBOutlet weak var lblBTimeSet: UILabel!
    @IBOutlet weak var lblMon: UILabel!
    @IBOutlet weak var lblTue: UILabel!
    @IBOutlet weak var lblWed: UILabel!
    @IBOutlet weak var lblThu: UILabel!
    @IBOutlet weak var lblFri: UILabel!
    @IBOutlet weak var lblSat: UILabel!
    @IBOutlet weak var lblSun: UILabel!
    @IBOutlet weak var lblWave: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    
    @IBOutlet weak var vwAuthor: UIView!
    @IBOutlet weak var swTime: UISwitch!
    @IBOutlet weak var swFreeCount: UISwitch!
    @IBOutlet weak var vwNonView: UIView!
    @IBOutlet weak var vwTimeView: UIView!
    @IBOutlet weak var vwFreeTimeView: UIView!
    
    
    @IBOutlet weak var vwCmtLtSView: UIView!
    @IBOutlet weak var vwCmtLtCView: UIView!
    @IBOutlet weak var vwCmtLtNView: UIView!
    
    @IBOutlet weak var swCmtLtS: UISwitch! //출근시간
    @IBOutlet weak var swCmtLtC: UISwitch! //회사 근로시간
    @IBOutlet weak var swCmtLtN: UISwitch! // 미사용
    
    @IBOutlet weak var btnInfoPopS: UIButton!
    @IBOutlet weak var btnInfoPopC: UIButton!
    @IBOutlet weak var btnInfoPopN: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var cmpsid: Int = 0             //회사번호
    var cmpnm: String = ""          //회사명
    
    var starttm: String = "09:00"    //근무 시작시간.. ex)09:00
    var endtm: String  = "18:00"    //근무 종료시간.. ex)18:00
    var workday: String = "2,3,4,5,6"        //근무요일.. 1(일),2(월),3(화),4(수),5(목),6(금),7(토) 구분자 ','  .. ex) 2,3,4,5,6
    
    var cmtrc: Int = 0              //출퇴근기록 설정(0.회사 근무시간기준기록 1.자율기록 default '0')
    var schdl: Int = 0              //근무일정 사용여부 0.사용안함 1.사용함
     
    var brktime: Int = 1            //휴게시간 설정(0.설정안함 1.설정 default '1')
    var cmpbrktime:Int = 1
    
    var tmpstarttm: String = "09:00"
    var tmpendtm: String = "18:00"
    var tmpworkday: String = "2,3,4,5,6"
    
    var tmpcmtrc: Int = 0
    var tmpschdl: Int = 0
    var tmpbrktime: Int = 1
    var tmpCmtlt:Int = 0
    let toggleTime = ToggleSwitch(with: images)
    let toggleFreeCount = ToggleSwitch(with: images)
    let toggleCmtLtS = ToggleSwitch(with: images)
    let toggleCmtLtC = ToggleSwitch(with: images)
    let toggleCmtLtN = ToggleSwitch(with: images)
    var switchYposition:CGFloat = 0
    
    var cmtlt:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.layer.cornerRadius = 6
        if !authorCk(msg: "권한이 없습니다.\n마스터관리자와 최고관리자만 \n변경이 가능합니다.") {
            vwAuthor.isHidden = false
        }
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
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
        
        toggleTime.frame.origin.x = switchYposition
        toggleTime.frame.origin.y = 7
        
        toggleFreeCount.frame.origin.x = switchYposition
        toggleFreeCount.frame.origin.y = 7
        
        toggleCmtLtS.frame.origin.x = switchYposition
        toggleCmtLtS.frame.origin.y = 7
        
        toggleCmtLtC.frame.origin.x = switchYposition
        toggleCmtLtC.frame.origin.y = 7
        
        toggleCmtLtN.frame.origin.x = switchYposition
        toggleCmtLtN.frame.origin.y = 7
        
        self.vwCmtLtSView.addSubview(toggleCmtLtS)
        self.vwCmtLtCView.addSubview(toggleCmtLtC)
        self.vwCmtLtNView.addSubview(toggleCmtLtN)
        
        self.vwTimeView.addSubview(toggleTime)
        self.vwFreeTimeView.addSubview(toggleFreeCount)
        
        toggleTime.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        toggleFreeCount.addTarget(self, action: #selector(toggleFreeChanged), for: .valueChanged)
        toggleCmtLtS.addTarget(self, action: #selector(toggleCmtLtSChanged), for: .valueChanged)
        toggleCmtLtC.addTarget(self, action: #selector(toggleCmtLtCChanged), for: .valueChanged)
        toggleCmtLtN.addTarget(self, action: #selector(toggleCmtLtNChanged), for: .valueChanged)
        
        btnInfoPopS.addTarget(self, action: #selector(popUseShow1(_:)), for: .touchUpInside)
        btnInfoPopC.addTarget(self, action: #selector(popUseShow2(_:)), for: .touchUpInside)
        btnInfoPopN.addTarget(self, action: #selector(popUseShow3(_:)), for: .touchUpInside)
    }
 
    @objc func popUseShow1(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "CmtLtSpopVC") as! CmtLtSpopVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func popUseShow2(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "CmtLtCpopVC") as! CmtLtCpopVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func popUseShow3(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "CmtLtNpopVC") as! CmtLtNpopVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //회사정보
        cmpsid = userInfo.cmpsid
        cmpnm = moreCmpInfo.name.urlEncoding()
        //회사근무시간 정보
        starttm = moreCmpInfo.starttm
        endtm = moreCmpInfo.endtm
        brktime = moreCmpInfo.brktime
        workday = moreCmpInfo.workday
        cmtrc = moreCmpInfo.cmtrc
        schdl = moreCmpInfo.schdl 
        cmtlt = moreCmpInfo.cmtlt
        
        if (moreCmpInfo.tmpbrktime == 99) {
            moreCmpInfo.tmpstarttm = moreCmpInfo.starttm
            moreCmpInfo.tmpendtm = moreCmpInfo.endtm
            moreCmpInfo.tmpbrktime = moreCmpInfo.brktime
            moreCmpInfo.tmpworkday = moreCmpInfo.workday
            moreCmpInfo.tmpcmtrc = moreCmpInfo.cmtrc
            moreCmpInfo.tmpschdl = moreCmpInfo.schdl
            moreCmpInfo.tmpCmtlt = moreCmpInfo.cmtlt
        }
        
        tmpstarttm = moreCmpInfo.tmpstarttm
        tmpendtm = moreCmpInfo.tmpendtm
        tmpbrktime = moreCmpInfo.brktime
        tmpworkday = moreCmpInfo.tmpworkday
        tmpcmtrc = moreCmpInfo.tmpcmtrc
        tmpschdl = moreCmpInfo.tmpschdl
        cmpbrktime = moreCmpInfo.tmpbrktime
        tmpCmtlt = moreCmpInfo.tmpCmtlt
        
        if schdl == 0 {
            swTime.isOn = false
            toggleTime.setOn(on: false, animated: true)
        }else {
            swTime.isOn = true
            toggleTime.setOn(on: true, animated: true)
            if cmtrc == 0 {
                swFreeCount.isOn = true
                toggleFreeCount.setOn(on: true, animated: true)
            }else {
                swFreeCount.isOn = false
                toggleFreeCount.setOn(on: false, animated: true)
            }
        }
       
        switch cmtlt {
        case 1:
            toggleCmtLtS.isOn = true
        case 2:
            toggleCmtLtC.isOn = true
        case 3:
            toggleCmtLtN.isOn = true
        default:
            toggleCmtLtS.isOn = false
            toggleCmtLtC.isOn = false
            toggleCmtLtN.isOn = false
        }
        WDSetting()
    }
    
   
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = UIViewController()
        if viewflag == "WeekHourVC" {
            vc = MoreSB.instantiateViewController(withIdentifier: "WeekHourVC") as! WeekHourVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    func WDSetting() {
        if schdl == 1 {
            swTime.isOn = true
            toggleTime.setOn(on: true, animated: true)
            swFreeCount.isEnabled = true
            btnSetting.isSelected = true
            btnSetting.isEnabled = true
            
            lblSTime.text = starttm
            lblETime.text = endtm
            
            lblSTime.textColor = .black
            lblETime.textColor = .black
            lblBTimeSet.textColor = .black
            
            lblSun.textColor = .black
            lblMon.textColor = .black
            lblTue.textColor = .black
            lblWed.textColor = .black
            lblThu.textColor = .black
            lblFri.textColor = .black
            lblSat.textColor = .black
            
            
            if brktime == 0 {
                lblBTimeSet.text = "미사용"
            }else {
                lblBTimeSet.text = "사용"
            }
            
            if workday.contains("1") {
                lblSun.textColor = .init(hexString: "#EF3829")
            }
            if workday.contains("2") {
                lblMon.textColor = .init(hexString: "#EF3829")
            }
            if workday.contains("3") {
                lblTue.textColor = .init(hexString: "#EF3829")
            }
            if workday.contains("4") {
                lblWed.textColor = .init(hexString: "#EF3829")
            }
            if workday.contains("5") {
                lblThu.textColor = .init(hexString: "#EF3829")
            }
            if workday.contains("6") {
                lblFri.textColor = .init(hexString: "#EF3829")
            }
            if workday.contains("7") {
                lblSat.textColor = .init(hexString: "#EF3829")
            }
        }else{
            
            lblSTime.text = starttm
            lblETime.text = endtm
            
            lblSTime.textColor = .lightGray
            lblWave.textColor = .lightGray
            lblETime.textColor = .lightGray
            lblMon.textColor = .lightGray
            lblTue.textColor = .lightGray
            lblWed.textColor = .lightGray
            lblThu.textColor = .lightGray
            lblFri.textColor = .lightGray
            lblSat.textColor = .lightGray
            lblSun.textColor = .lightGray
            lblBTimeSet.textColor = .lightGray
            
            swFreeCount.isEnabled = false
            swFreeCount.isOn = false
            btnSetting.isEnabled = true
            btnSetting.isSelected = false
            
            toggleFreeCount.setOn(on: false, animated: true)
        }
    }
 
    
    @IBAction func btnSetting(_ sender: UIButton) {
        if schdl == 0 {
            // 팀별 근로시간을 설정하지 않았을경우 toast 2020.03.09 seob
            self.toast("근로시간 설정버튼을 활성화 해주세요.")
        }else{
            var vc = MoreSB.instantiateViewController(withIdentifier: "SetTime") as!  SetTime
            if SE_flag {
                vc = MoreSB.instantiateViewController(withIdentifier: "SE_SetTime") as!  SetTime
            }
            moreCmpInfo.schdl = self.schdl
            moreCmpInfo.cmtrc = self.cmtrc
            moreCmpInfo.cmtlt = self.cmtlt
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
 
    }
    
    // 2020.04.07 변경된 사항이 없을경우는 서버통신 안되도록 수정 seob
    @IBAction func save(_ sender: UIButton) {
        print("\n---------- [ cmtlt : \(cmtlt) ] ----------\n")
        
        if (starttm == tmpstarttm && endtm == tmpendtm && workday == tmpworkday && cmtrc == tmpcmtrc && schdl == tmpschdl && cmtlt == tmpCmtlt){
            if (cmpbrktime == 99){
                if (brktime == tmpbrktime){
                    var vc = UIViewController()
                    if viewflag == "WeekHourVC" {
                        vc = MoreSB.instantiateViewController(withIdentifier: "WeekHourVC") as! WeekHourVC
                    }else{
                        vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
                    }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                }
            }else{
                if (brktime == cmpbrktime){
                    var vc = UIViewController()
                    if viewflag == "WeekHourVC" {
                        vc = MoreSB.instantiateViewController(withIdentifier: "WeekHourVC") as! WeekHourVC
                    }else{
                        vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
                    }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                }else{
                    NetworkManager.shared().SetCmpSchdl(cmpsid: cmpsid, cmpnm: cmpnm, cmtrc: cmtrc, schdl: schdl, starttm: starttm, endtm: endtm, brktime: brktime, workday: workday, cmtlt: cmtlt) { (isSuccess, resultCode) in
                        if isSuccess {
                            switch resultCode {
                            case 1:
                                moreCmpInfo.schdl = self.schdl
                                moreCmpInfo.cmtrc = self.cmtrc
                                moreCmpInfo.cmtlt = self.cmtlt
                                var vc = UIViewController()
                                if viewflag == "WeekHourVC" {
                                    vc = MoreSB.instantiateViewController(withIdentifier: "WeekHourVC") as! WeekHourVC
                                }else{
                                    vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
                                }
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: false, completion: nil)
                            default:
                                self.customAlertView("잠시 후, 다시 시도해 주세요.")
                            }
                        }else{
                            self.customAlertView("다시 시도해 주세요.")
                        }
                        
                    }
                }
            }
        }else{
            NetworkManager.shared().SetCmpSchdl(cmpsid: cmpsid, cmpnm: cmpnm, cmtrc: cmtrc, schdl: schdl, starttm: starttm, endtm: endtm, brktime: brktime, workday: workday, cmtlt: cmtlt) { (isSuccess, resultCode) in
                if isSuccess {
                    switch resultCode {
                    case 1:
                        moreCmpInfo.schdl = self.schdl
                        moreCmpInfo.cmtrc = self.cmtrc
                        moreCmpInfo.cmtlt = self.cmtlt
                        var vc = UIViewController()
                        if viewflag == "WeekHourVC" {
                            vc = MoreSB.instantiateViewController(withIdentifier: "WeekHourVC") as! WeekHourVC
                        }else{
                            vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    default:
                        self.customAlertView("잠시 후, 다시 시도해 주세요.")
                    }
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
                
            }
        }
    }
}

extension CmtTimeVC {
    // 회사 근로시간 설정
    @objc func toggleValueChanged(toggle: ToggleSwitch) {
        if toggle.isOn == false {
            schdl = 0 //위
            cmtrc = 1
            WDSetting()
        }else {
            schdl = 1
            cmtrc = 1
            WDSetting()
        }
        prefs.setValue(schdl, forKey: "schdl")
    }
    // MARK: 회사 근로시간으로 기록
    @objc func toggleFreeChanged(toggle: ToggleSwitch) {
        if toggleTime.isOn == false {
            self.toast("근로시간 설정버튼을 활성화 해주세요.")
            return
        }else{
            if toggle.isOn == false {
                cmtrc = 1 //아래
            }else {
                cmtrc = 0
            }
            print("cmtrc = ", cmtrc)
        } 
    }
    
    // MARK: 출근  근로시간으로 기록
    @objc func toggleCmtLtSChanged(toggle: ToggleSwitch) {
        if toggle.isOn == true {
            cmtlt = 1 //아래
            toggleCmtLtS.isOn = true
            toggleCmtLtC.isOn = false
            toggleCmtLtN.isOn = false
        }else{
            cmtlt = 4
        }
    }
    
    @objc func toggleCmtLtCChanged(toggle: ToggleSwitch) {
        if toggle.isOn == true {
            cmtlt = 2 //아래
            toggleCmtLtS.isOn = false
            toggleCmtLtC.isOn = true
            toggleCmtLtN.isOn = false
        }else{
            cmtlt = 4
        }
    }
    
    @objc func toggleCmtLtNChanged(toggle: ToggleSwitch) {
        if toggle.isOn == true {
            cmtlt = 3 //아래
            toggleCmtLtS.isOn = false
            toggleCmtLtC.isOn = false
            toggleCmtLtN.isOn = true
        }else{
            cmtlt = 4
        }
    }
    
    @IBAction func WTimeSw(_ sender: UISwitch) {
        if sender.isOn == false {
            schdl = 0 //위
            cmtrc = 1
            WDSetting()
        }else {
            schdl = 1
            cmtrc = 1
            WDSetting()
        }
        prefs.setValue(schdl, forKey: "schdl")
    }
    
    @IBAction func freeCount(_ sender: UISwitch) {
        if sender.isOn == false {
            cmtrc = 1 //아래
        }else {
            cmtrc = 0
        }
        print("cmtrc = ", cmtrc)
    }
}
