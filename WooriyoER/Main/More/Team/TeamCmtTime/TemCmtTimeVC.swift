//
//  CmtTimeVC.swift
//  PinPle
//
//  Created by WRY_010 on 26/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TemCmtTimeVC: UIViewController {
    
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
    @IBOutlet weak var lblTname: UILabel!
    
    @IBOutlet weak var swTemTime: UISwitch!
    @IBOutlet weak var swCmtTime: UISwitch!
    @IBOutlet weak var vwHidden: UIView!
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
    @IBOutlet weak var lblSave: UILabel!
    
    var starttm: String = "09:00"
    var endtm: String = "18:00"
    var workday: String = ""
    
    var cmtrc: Int = 0
    var schdl: Int = 0
    var cmpschdl: Int = 0
    var brktime: Int = 1
    
    var tmpstarttm: String = "09:00"
    var tmpendtm: String = "18:00"
    var tmpworkday: String = ""
    
    var tmpcmtrc: Int = 0
    var tmpschdl: Int = 0
    var tmpbrktime: Int = 1
    var tmpcmtlt: Int = 0
    var isteamtime:Int = 0
    
    let toggleCmtTime = ToggleSwitch(with: images)
    let toggleTemTime = ToggleSwitch(with: images)
    let toggleCmtLtS = ToggleSwitch(with: images)
    let toggleCmtLtC = ToggleSwitch(with: images)
    let toggleCmtLtN = ToggleSwitch(with: images)
    
    var switchYposition:CGFloat = 0
  
    var cmtlt:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.eachLblBtn(btnSave, lblSave)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViewData), name: .reloadList, object: nil)
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
        toggleCmtTime.frame.origin.x = switchYposition
        toggleCmtTime.frame.origin.y = 7
        
        toggleTemTime.frame.origin.x = switchYposition
        toggleTemTime.frame.origin.y = 7
         
        toggleCmtLtS.frame.origin.x = switchYposition
        toggleCmtLtS.frame.origin.y = 7
        
        toggleCmtLtC.frame.origin.x = switchYposition
        toggleCmtLtC.frame.origin.y = 7
        
        toggleCmtLtN.frame.origin.x = switchYposition
        toggleCmtLtN.frame.origin.y = 7
        
        self.vwCmtLtSView.addSubview(toggleCmtLtS)
        self.vwCmtLtCView.addSubview(toggleCmtLtC)
        self.vwCmtLtNView.addSubview(toggleCmtLtN)
        
        self.vwTimeView.addSubview(toggleCmtTime)
        self.vwFreeTimeView.addSubview(toggleTemTime)
        
        toggleCmtTime.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        toggleTemTime.addTarget(self, action: #selector(toggleFreeChanged), for: .valueChanged)
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
        let vc = MoreSB.instantiateViewController(withIdentifier: "CmtLtTeamPopVC") as! CmtLtTeamPopVC
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
    
    // MARK: reloadViewData
    @objc func reloadViewData(_ notification: Notification) {
        starttm = SelTemInfo.starttm
        endtm = SelTemInfo.endtm
        schdl = SelTemInfo.schdl
        workday = SelTemInfo.workday
        brktime = SelTemInfo.brktime
        lblTname.text = "'\(SelTemInfo.name)'"
        WDSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        starttm = SelTemInfo.starttm
        endtm = SelTemInfo.endtm
        schdl = SelTemInfo.schdl
        cmtlt = SelTemInfo.cmtlt
        workday = SelTemInfo.workday
        brktime = SelTemInfo.brktime
        print("\n---------- [ cmtlt : \(cmtlt) ] ----------\n")
        
        tmpstarttm = SelTemInfo.starttm
        tmpendtm = SelTemInfo.endtm
        tmpschdl = SelTemInfo.schdl
        tmpworkday = SelTemInfo.workday
        tmpbrktime = SelTemInfo.brktime
        cmpschdl = SelTemInfo.schdl
        lblTname.text = "'\(SelTemInfo.name)'"
        tmpcmtlt = SelTemInfo.cmtlt
        
        isteamtime = schdl
        
        WDSetting()
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        NotificationCenter.default.post(name: .reloadTem, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    func WDSetting() {
        switch schdl {
        case 0:
            swCmtTime.isOn = false
            toggleCmtTime.setOn(on: false, animated: true)
            swTemTime.isOn = false
            toggleTemTime.setOn(on: false, animated: true)
            btnSetting.isEnabled = true
            vwHidden.isHidden = false
            
            lblSTime.textColor = .init(hexString: "#DADADA");
            lblETime.textColor = .init(hexString: "#DADADA");
            lblWave.textColor = .init(hexString: "#DADADA")
            lblBTimeSet.textColor = .init(hexString: "#DADADA");
            lblSun.textColor = .init(hexString: "#DADADA");
            lblMon.textColor = .init(hexString: "#DADADA");
            lblTue.textColor = .init(hexString: "#DADADA");
            lblWed.textColor = .init(hexString: "#DADADA");
            lblThu.textColor = .init(hexString: "#DADADA");
            lblFri.textColor = .init(hexString: "#DADADA");
            lblSat.textColor = .init(hexString: "#DADADA");
 
            
        case 1:
            swCmtTime.isOn = true
            toggleCmtTime.setOn(on: true, animated: true)
            swTemTime.isOn = false
            toggleTemTime.setOn(on: false, animated: true)
            btnSetting.isEnabled = true
            vwHidden.isHidden = true
            
            lblSTime.textColor = .init(hexString: "#DADADA");
            lblETime.textColor = .init(hexString: "#DADADA");
            lblWave.textColor = .init(hexString: "#DADADA")
            lblBTimeSet.textColor = .init(hexString: "#DADADA");
            lblSun.textColor = .init(hexString: "#DADADA");
            lblMon.textColor = .init(hexString: "#DADADA");
            lblTue.textColor = .init(hexString: "#DADADA");
            lblWed.textColor = .init(hexString: "#DADADA");
            lblThu.textColor = .init(hexString: "#DADADA");
            lblFri.textColor = .init(hexString: "#DADADA");
            lblSat.textColor = .init(hexString: "#DADADA");
        case 2:
            swCmtTime.isOn = false
            toggleCmtTime.setOn(on: false, animated: true)
            swTemTime.isOn = true
            toggleTemTime.setOn(on: true, animated: true)
            btnSetting.isEnabled = true
            vwHidden.isHidden = false
            
            lblSTime.text = starttm;
            lblETime.text = endtm;
            
            lblSTime.textColor = .black;
            lblETime.textColor = .black;
            lblWave.textColor = .black;
            lblBTimeSet.textColor = .black;
            
            lblSun.textColor = .black;
            lblMon.textColor = .black;
            lblTue.textColor = .black;
            lblWed.textColor = .black;
            lblThu.textColor = .black;
            lblFri.textColor = .black;
            lblSat.textColor = .black;
            
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
             
        default:
            break;
        }
        
        switch cmtlt {
        case 1:
            toggleCmtLtS.isOn = true
            toggleCmtLtS.setOn(on: true, animated: true)
        case 2:
            toggleCmtLtC.isOn = true
            toggleCmtLtC.setOn(on: true, animated: true)
        case 3:
            toggleCmtLtN.isOn = true
            toggleCmtLtN.setOn(on: true, animated: true)
        default:
            toggleCmtLtS.isOn = false
            toggleCmtLtS.setOn(on: false, animated: true)
            toggleCmtLtC.isOn = false
            toggleCmtLtC.setOn(on: false, animated: true)
            toggleCmtLtN.isOn = false
            toggleCmtLtN.setOn(on: false, animated: true)
        }
    }
 
    
    @IBAction func WTimeSw(_ sender: UISwitch) {
        if sender.isOn {
            schdl = 2
            SelTemInfo.schdl = 2
            cmpschdl = 2
            isteamtime = 2
            lblSTime.textColor = .black
            lblWave.textColor = .black
            lblETime.textColor = .black
            lblBTimeSet.textColor = .black
            btnSetting.isEnabled = true
            WDSetting()
        }else {
            schdl = 0
            SelTemInfo.schdl = 0
            cmpschdl = 0
            isteamtime = 0
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
            
            btnSetting.isEnabled = true
            btnSetting.isSelected = false
         }
    }
    
    @objc func toggleFreeChanged(toggle: ToggleSwitch) {
        if toggle.isOn {
            schdl = 2
            SelTemInfo.schdl = 2
            cmpschdl = 2
            isteamtime = 2
            lblSTime.textColor = .black
            lblWave.textColor = .black
            lblETime.textColor = .black
            lblBTimeSet.textColor = .black
            btnSetting.isEnabled = true
            WDSetting()
        }else {
            schdl = 0
            SelTemInfo.schdl = 0
            cmpschdl = 0
            isteamtime = 0
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
            
            btnSetting.isEnabled = true
            btnSetting.isSelected = false
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
 
    @IBAction func setCmpTime(_ sender: UISwitch) {
        if sender.isOn {
            schdl = 1
            cmpschdl = 1
            vwHidden.isHidden = true
        }else {
            schdl = 0
            cmpschdl = 2
            vwHidden.isHidden = false
        }
    }
    @objc func toggleValueChanged(toggle: ToggleSwitch) {
        if toggle.isOn {
            schdl = 1
            cmpschdl = 1
            vwHidden.isHidden = true
        }else {
            schdl = 0
            cmpschdl = 2
            vwHidden.isHidden = false
        }
    }
    
    @IBAction func btnSetting(_ sender: UIButton) {
        print("\n---------- [ schd1 : \(schdl) ,tmpschdl : \(tmpschdl) , cmpschdl : \(cmpschdl) ,isteamtime : \(isteamtime)] ----------\n")
        if (tmpschdl == 0){
            if(isteamtime == 0){
                // 팀별 근로시간을 설정하지 않았을경우 toast 2020.03.09 seob
                self.toast("팀별근로시간 설정버튼을 활성화 해주세요.")
            }else{
                var vc = MoreSB.instantiateViewController(withIdentifier: "TemSetTime") as! TemSetTime
                if SE_flag {
                    vc = MoreSB.instantiateViewController(withIdentifier: "SE_TemSetTime") as! TemSetTime
                }
                SelTemInfo.schdl = schdl
                SelTemInfo.cmtlt = cmtlt
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)

            }
        }else{
            if(isteamtime == 0){
                self.toast("팀별근로시간 설정버튼을 활성화 해주세요.")
            }else{
                var vc = MoreSB.instantiateViewController(withIdentifier: "TemSetTime") as! TemSetTime
                if SE_flag {
                    vc = MoreSB.instantiateViewController(withIdentifier: "SE_TemSetTime") as! TemSetTime
                }
                SelTemInfo.schdl = schdl
                SelTemInfo.cmtlt = cmtlt
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
     
    // 2020.04.07 변경된 사항이 없을경우는 서버통신 안되도록 수정 seob
    @IBAction func save(_ sender: UIButton) {
 print("\n---------- [ cmtlt : \(cmtlt)  tmpcmtlt : \(tmpcmtlt) ] ----------\n")
//        if (starttm == tmpstarttm && endtm == tmpendtm && workday == tmpworkday && brktime == tmpbrktime && (cmpschdl == tmpschdl || (schdl == tmpschdl) && (cmtlt == tmpcmtlt))){
//            print("\n---------- [ 변경 없음 ] ----------\n")
//            NotificationCenter.default.post(name: .reloadTem, object: nil)
//            self.dismiss(animated: true, completion: nil)
//        }else{
//            print("\n---------- [ 변경 있음 ] ----------\n")
//            SelTemInfo.schdl = schdl
//            SelTemInfo.cmtlt = cmtlt
//            tmpcmtlt = cmtlt
//            NetworkManager.shared().SetTemSchdl(temflag: SelTemFlag, ttmsid: SelTtmSid, temsid: SelTemSid, temnm: SelTemInfo.name.urlEncoding(), scd: schdl, st: starttm, et: endtm, bt: brktime, wd: workday, cmtlt: cmtlt) { (isSuccess, resultCode) in
//                if (isSuccess) {
//                    if resultCode == 1 {
//                        NotificationCenter.default.post(name: .reloadTem, object: nil)
//                        self.dismiss(animated: true, completion: nil)
//                    }else {
//                        self.customAlertView("잠시 후, 다시 시도해 주세요.")
//                    }
//                }else {
//                    self.customAlertView("다시 시도해 주세요.")
//                }
//            }
//        }
        SelTemInfo.schdl = schdl
        SelTemInfo.cmtlt = cmtlt
        tmpcmtlt = cmtlt
        NetworkManager.shared().SetTemSchdl(temflag: SelTemFlag, ttmsid: SelTtmSid, temsid: SelTemSid, temnm: SelTemInfo.name.urlEncoding(), scd: schdl, st: starttm, et: endtm, bt: brktime, wd: workday, cmtlt: cmtlt) { (isSuccess, resultCode) in
            if (isSuccess) {
                if resultCode == 1 {
                    NotificationCenter.default.post(name: .reloadTem, object: nil)
                    self.dismiss(animated: true, completion: nil)
                }else {
                    self.customAlertView("잠시 후, 다시 시도해 주세요.")
                }
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
}
