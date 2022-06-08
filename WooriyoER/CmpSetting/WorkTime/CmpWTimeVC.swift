//
//  CmpWTimeVC.swift
//  PinPle
//
//  Created by WRY_010 on 26/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmpWTimeVC: UIViewController, NVActivityIndicatorViewable {
    // MARK: - IBOutlet
    //회사 근로 시간
    @IBOutlet weak var btnSetting: UIButton!   // 설정 버튼
    @IBOutlet weak var btnSchdl: UIButton!  // 스위치 버튼
    
    @IBOutlet weak var lblCmtime: UILabel!   // 근무시간 라벨
    @IBOutlet weak var lblBrktime: UILabel!   // 휴게시간 라벨
    
    @IBOutlet weak var lblMon: UILabel!   // 월요일 라벨
    @IBOutlet weak var lblTue: UILabel!   // 화요일 라벨
    @IBOutlet weak var lblWed: UILabel!   // 수요일 라벨
    @IBOutlet weak var lblThu: UILabel!   // 목요일 라벨
    @IBOutlet weak var lblFri: UILabel!   // 금요일 라벨
    @IBOutlet weak var lblSat: UILabel!   // 토요일 라벨
    @IBOutlet weak var lblSun: UILabel!   // 일요일 라벨
    
    // 회사 근로시간으로 기록
    @IBOutlet weak var btnCmtrc: UIButton!  // 스위치 버튼
    
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
    
    var cmpsid: Int = 0             //회사번호
    var cmpnm: String = ""          //회사명
    
    var starttm: String = ""    //근무 시작시간.. ex)09:00
    var endtm: String  = ""    //근무 종료시간.. ex)18:00
    var workday: String = ""        //근무요일.. 1(일),2(월),3(화),4(수),5(목),6(금),7(토) 구분자 ','  .. ex) 2,3,4,5,6
    
    var cmtrc: Int = 0              //출퇴근기록 설정(0.회사 근무시간기준기록 1.자율기록 default '0')
    var schdl: Int = 0              //근무일정 사용여부 0.사용안함 1.사용함
    var brktime: Int = 1            //휴게시간 설정(0.설정안함 1.설정 default '1')
    
    var cmtlt: Int = 1 //자동퇴근기록 설정 (1. 출근시간으로 자동기록 , 2.회사퇴근시간으로 자동기록, 3.자동 퇴근기록 사용안함 default 1) 2022.01.10 추가
    let toggleCmtLtS = ToggleSwitch(with: images)
    let toggleCmtLtC = ToggleSwitch(with: images)
    let toggleCmtLtN = ToggleSwitch(with: images)
    var switchYposition:CGFloat = 0
    // MARK: - IndicatorSetting
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    fileprivate func IndicatorSetting() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    // MARK: - view override
    override func viewDidLoad() {
        super.viewDidLoad()
        prefs.setValue(8, forKey: "stage")
        
        EnterpriseColor.eachLblBtn(btnSave, lblSave)
        
        btnSchdl.setImage(switchOnImg, for: .selected)
        btnSchdl.setImage(switchOffImg, for: .normal)
        btnCmtrc.setImage(switchOnImg, for: .selected)
        btnCmtrc.setImage(switchOffImg, for: .normal)
        
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
         
        
        toggleCmtLtS.frame.origin.x = switchYposition
        toggleCmtLtS.frame.origin.y = 7
        
        toggleCmtLtC.frame.origin.x = switchYposition
        toggleCmtLtC.frame.origin.y = 7
        
        toggleCmtLtN.frame.origin.x = switchYposition
        toggleCmtLtN.frame.origin.y = 7
        
        self.vwCmtLtSView.addSubview(toggleCmtLtS)
        self.vwCmtLtCView.addSubview(toggleCmtLtC)
        self.vwCmtLtNView.addSubview(toggleCmtLtN)
        
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
    
    // MARK: 출근  근로시간으로 기록
    @objc func toggleCmtLtSChanged(toggle: ToggleSwitch) {
        if toggle.isOn == true {
            cmtlt = 1 //아래
            toggleCmtLtS.isOn = true
            toggleCmtLtC.isOn = false
            toggleCmtLtN.isOn = false
        }
    }
    
    @objc func toggleCmtLtCChanged(toggle: ToggleSwitch) {
        if toggle.isOn == true {
            cmtlt = 2 //아래
            toggleCmtLtS.isOn = false
            toggleCmtLtC.isOn = true
            toggleCmtLtN.isOn = false
        }
    }
    
    @objc func toggleCmtLtNChanged(toggle: ToggleSwitch) {
        if toggle.isOn == true {
            cmtlt = 3 //아래
            toggleCmtLtS.isOn = false
            toggleCmtLtC.isOn = false
            toggleCmtLtN.isOn = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cmpsid = CompanyInfo.sid
        cmpnm = CompanyInfo.name.urlEncoding()
        starttm = CompanyInfo.starttm
        endtm = CompanyInfo.endtm
        brktime = CompanyInfo.brktime
        workday = CompanyInfo.workday
        cmtrc = CompanyInfo.cmtrc
        schdl = CompanyInfo.schdl
        
        if starttm.count > 5 {
            starttm = starttm.timeTrim()
            endtm = endtm.timeTrim()
        }
        if starttm == "" {
            starttm = "09:00"
            CompanyInfo.starttm = "09:00"
        }
        if endtm == "" {
            endtm = "18:00"
            CompanyInfo.endtm = "18:00"
        }
        if workday == "" {
            workday = "2,3,4,5,6"
            CompanyInfo.workday = "2,3,4,5,6"
        }
        
        workdaySetting()
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = CmpCrtSB.instantiateViewController(withIdentifier: "WTInfoVC") as! WTInfoVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func workdaySetting() {
        if schdl == 1 {
            btnSchdl.isSelected = true
            btnSetting.isEnabled = true
            
            if cmtrc == 1 {
                btnCmtrc.isSelected = false
            }else {
                btnCmtrc.isSelected = true
            }
            
            lblCmtime.textColor = .black
            lblBrktime.textColor = .black
            
            lblSun.textColor = .black
            lblMon.textColor = .black
            lblTue.textColor = .black
            lblWed.textColor = .black
            lblThu.textColor = .black
            lblFri.textColor = .black
            lblSat.textColor = .black
            
            lblCmtime.text = starttm + " ~ " + endtm
            
            if brktime == 0 {
                lblBrktime.text = "미사용"
            }else {
                lblBrktime.text = "사용"
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
            btnSchdl.isSelected = false
            btnSetting.isEnabled = false
            btnCmtrc.isSelected = false
            
            lblCmtime.textColor = .lightGray
            lblBrktime.textColor = .lightGray
            lblMon.textColor = .lightGray
            lblTue.textColor = .lightGray
            lblWed.textColor = .lightGray
            lblThu.textColor = .lightGray
            lblFri.textColor = .lightGray
            lblSat.textColor = .lightGray
            lblSun.textColor = .lightGray
        }
    }
    
    @IBAction func settingAction(_ sender: UIButton) {
        
        CompanyInfo.schdl = self.schdl
        CompanyInfo.cmtrc = self.cmtrc
        
        var vc = CmpCrtSB.instantiateViewController(withIdentifier: "CmpWTimeSetVC") as! CmpWTimeSetVC
        if SE_flag {
            vc = CmpCrtSB.instantiateViewController(withIdentifier: "SE_CmpWTimeSetVC") as! CmpWTimeSetVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func schdlAction(_ sender: UIButton) {
        print("\n---------- [ 1111 schdlAction.isSelected = \(sender.isSelected) ] ----------\n")
        sender.isSelected = !sender.isSelected
        print("\n---------- [ 2222 schdlAction.isSelected = \(sender.isSelected) ] ----------\n")
        if sender.isSelected {
            schdl = 1
            cmtrc = 1
            workdaySetting()
        }else {
            schdl = 0
            cmtrc = 1
            workdaySetting()
        }
        print("\n---------- [ schdl = \(schdl) ] ----------\n")
    }
    
    @IBAction func cmtrcAction(_ sender: UIButton) {
        if btnSchdl.isSelected {
            print("\n---------- [ 1111 cmtrcAction.isSelected = \(sender.isSelected) ] ----------\n")
            sender.isSelected = !sender.isSelected
            print("\n---------- [ 2222 cmtrcAction.isSelected = \(sender.isSelected) ] ----------\n")
            if sender.isSelected {
                cmtrc = 0
            }else {
                cmtrc = 1
            }
        }else {
            self.toast("회사 근로 시간 설정이 켜져있어야 사용 가능합니다.")
        }
        print("\n---------- [ cmtrc = \(cmtrc) ] ----------\n")
    }
    
    @IBAction func saveAction(_ sender: UIButton) { 
        
        IndicatorSetting() 
        NetworkManager.shared().SetCmpSchdl(cmpsid: cmpsid, cmpnm: cmpnm, cmtrc: cmtrc, schdl: schdl, starttm: starttm, endtm: endtm, brktime: brktime, workday: workday, cmtlt: cmtlt) { (isSuccess, resultCode) in
            if isSuccess {
                switch resultCode {
                case 1:
                    CompanyInfo.schdl = self.schdl
                    CompanyInfo.cmtrc = self.cmtrc
                    CompanyInfo.cmtlt = self.cmtlt
                    let vc = TmCrtSB.instantiateViewController(withIdentifier: "TemFirstlVC") as! TemFirstlVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                default:
                    self.customAlertView("잠시 후, 다시 시도해 주세요.")
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
        }
    }
}
