//
//  AnlAprVC.swift
//  PinPle
//
//  Created by WRY_010 on 01/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AnlAprVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblTemName: UILabel!
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var btnApr1: UIButton!
    @IBOutlet weak var lblApr1: UILabel!
    @IBOutlet weak var btnApr2: UIButton!
    @IBOutlet weak var lblApr2: UILabel!
    @IBOutlet weak var btnApr3: UIButton!
    @IBOutlet weak var lblApr3: UILabel!
    @IBOutlet weak var btnRef1: UIButton!
    @IBOutlet weak var lblRef1: UILabel!
    @IBOutlet weak var btnRef2: UIButton!
    @IBOutlet weak var lblRef2: UILabel!
    @IBOutlet weak var swAprLine: UISwitch!
    
    @IBOutlet weak var vwAprLineArea: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    var selApr: Bool = false
    
    var ttmsid:Int = 0
    var temsid:Int = 0
    
    let imgBg = UIImage.init(named: "man_bg")
    let imgPlus = UIImage.init(named: "plus_man")
    
    var apr = 0 //연차
    
    var applyapr = 0
    var anualapr = 0
    let toggleCmtTime = ToggleSwitch(with: images) 
    var switchYposition:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        lblTemName.text = SelTemInfo.name
        
        applyapr = SelTemInfo.applyapr
        anualapr = SelTemInfo.anualapr
        
        if selApr {
            lblNavigationTitle.text = "팀 연차"
            if anualapr == 0 {
                swAprLine.isOn = true
                toggleCmtTime.setOn(on: true, animated: true)
                vwBG.isHidden = false
            }else {
                swAprLine.isOn = false
                toggleCmtTime.setOn(on: false, animated: true)
                vwBG.isHidden = true
            }
        }else {
            lblNavigationTitle.text = "팀 출장/연장/특근"
            if applyapr == 0 {
                swAprLine.isOn = true
                toggleCmtTime.setOn(on: true, animated: true)
                vwBG.isHidden = false
            }else {
                swAprLine.isOn = false
                toggleCmtTime.setOn(on: false, animated: true)
                vwBG.isHidden = true
            }
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
        toggleCmtTime.frame.origin.y = 0
         
         
        
        self.vwAprLineArea.addSubview(toggleCmtTime)
        
        toggleCmtTime.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
    }
    // MARK: reloadViewData
    @objc func reloadViewData(_ notification: Notification) {
        valueSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        valueSetting()
        //        getTeminfoLine() // 팀 연차/신청 결재라인 2020.03.09 seob
    }
    
    func getTeminfoLine(){
        NetworkManager.shared().GetTemInfo(temflag: SelTemFlag, ttmsid: SelTtmSid, temsid: SelTemSid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                SelTemInfo = serverData
                self.anualapr = serverData.anualapr
                self.applyapr = serverData.applyapr
            }else {
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func valueSetting() {
        print("\n---------- [ SelAprInfo : \(SelAprInfo.toJSON()) ] ----------\n")
        
        if SelAprInfo.apr1name != "" {
            lblApr1.text = SelAprInfo.apr1name + " " + SelAprInfo.apr1spot
            btnApr1.setBackgroundImage(imgBg, for: .normal)
        }else {
            lblApr1.text = ""
            btnApr1.setBackgroundImage(imgPlus, for: .normal)
        }
        
        if SelAprInfo.apr2name != "" {
            lblApr2.text = SelAprInfo.apr2name + " " + SelAprInfo.apr2spot
            btnApr2.setBackgroundImage(imgBg, for: .normal)
        }else {
            lblApr2.text = ""
            btnApr2.setBackgroundImage(imgPlus, for: .normal)
        }
        
        if SelAprInfo.apr3name != "" {
            lblApr3.text = SelAprInfo.apr3name + " " + SelAprInfo.apr3spot
            btnApr3.setBackgroundImage(imgBg, for: .normal)
        }else {
            lblApr3.text = ""
            btnApr3.setBackgroundImage(imgPlus, for: .normal)
        }
        
        if SelAprInfo.ref1name != "" {
            lblRef1.text = SelAprInfo.ref1name + " " + SelAprInfo.ref1spot
            btnRef1.setBackgroundImage(imgBg, for: .normal)
        }else {
            lblRef1.text = ""
            btnRef1.setBackgroundImage(imgPlus, for: .normal)
        }
        
        if SelAprInfo.ref2name != "" {
            lblRef2.text = SelAprInfo.ref2name + " " + SelAprInfo.ref2spot
            btnRef2.setBackgroundImage(imgBg, for: .normal)
        }else {
            lblRef2.text = ""
            btnRef2.setBackgroundImage(imgPlus, for: .normal)
        }
        
    }
    
    @IBAction func setApr(_ sender: UISwitch) {
        if sender.isOn {
            vwBG.isHidden = false
            if selApr {
                anualapr = 0
            }else{
                applyapr = 0
            }
            apr = 0
        }else {
            vwBG.isHidden = true
            if selApr {
                anualapr = 1
            }else{
                applyapr = 1
            }
            apr = 1
        }
    }
    
    @objc func toggleValueChanged(toggle: ToggleSwitch) {
        if toggle.isOn {
            vwBG.isHidden = false
            if selApr {
                anualapr = 0
            }else{
                applyapr = 0
            }
            apr = 0
        }else {
            vwBG.isHidden = true
            if selApr {
                anualapr = 1
            }else{
                applyapr = 1
            }
            apr = 1
        }
    }
    
    func valueChc() -> Bool {
        let apr1Flag = SelAprInfo.apr1empsid > 0
        let apr2Flag = SelAprInfo.apr2empsid > 0
        let apr3Flag = SelAprInfo.apr3empsid > 0
        let ref1Flag = SelAprInfo.ref1empsid > 0
        let ref2Flag = SelAprInfo.ref2empsid > 0
        
        // 참조자1,2번이 있는상태에서 참조자1번이 퇴직한경우 2번이 1번으로 교체 2020.06.02
        if (SelAprInfo.ref1empsid == 0 && SelAprInfo.ref2empsid > 0) {
            SelAprInfo.ref1empsid = SelAprInfo.ref2empsid
            SelAprInfo.ref1name = SelAprInfo.ref2name
            SelAprInfo.ref1spot = SelAprInfo.ref2spot
            
            
            SelAprInfo.ref2empsid = 0
            SelAprInfo.ref2name = ""
            SelAprInfo.ref2spot = ""
        }
        
        if apr1Flag == false {
            self.toast("1차 결재자를 선택해 주세요.")
            return false
        }else if apr1Flag == false && apr2Flag == true {
            self.toast("1차 결재자를 선택해 주세요.")
            return false
        }else if apr1Flag == false && apr3Flag == true {
            self.toast("1차 결재자를 선택해 주세요.")
            return false
        }else if apr1Flag == false && ref1Flag == true {
            self.toast("1차 결재자를 선택해 주세요.")
            return false
        }else if apr1Flag == false && ref2Flag == true {
            self.toast("1차 결재자를 선택해 주세요.")
            return false
        }else if apr2Flag == false && apr3Flag == true {
            self.toast("2차 결재자를 선택해 주세요.")
            return false
        }
//        else if ref1Flag == false && ref2Flag == true {
//            self.toast("1차 참조자를 선택해 주세요.")
//            return false
//        }
        return true
    }
    @IBAction func save(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(연차결재라인 설정 - 회사, 상위팀, 팀 모두 같이 이용)
         Return  - 성공:1, 실패:0, 중복(직원번호 중복된 경우):-1
         Parameter
         CMPSID        회사번호 .. 상위팀번호, 팀번호는 0 또는 안보냄
         TTMSID        상위팀번호.. 회사번호, 팀번호는 0 또는 안보냄
         TEMSID        팀번호.. 회사번호, 상위팀번호는 0 또는 안보냄
         APR1        1차 결재자 직원번호(무조건 있어야됨)
         APR2        2차 결재자 직원번호(없는경우 0 또는 안보냄)
         APR3        3차 결재자 직원번호(없는경우 0 또는 안보냄.. 2차 없는데 3차 있을 수 없음)
         REF1        1차 참조자 직원번호(없는경우 0 또는 안보냄)
         REF2        2차 참조자 직원번호(없는경우 0 또는 안보냄.. 1차 없는데 2차 있을 수 없음)
         */
   
        if swAprLine.isOn {
            if SelTemFlag {
                ttmsid = SelTtmSid
            }else {
                temsid = SelTemSid
            }
            self.SetCmpAprLine()
//            let vc = MoreSB.instantiateViewController(withIdentifier: "AprSelVC") as! AprSelVC
//            vc.modalTransitionStyle = .crossDissolve
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: false, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }else {
            if valueChc() {
                
                if SelTemFlag {
                    ttmsid = SelTtmSid
                }else {
                    temsid = SelTemSid
                }
                
                NetworkManager.shared().SetAprline(aprflag: selApr, cmpsid: 0, ttmsid: ttmsid, temsid: temsid, apr1: SelAprInfo.apr1empsid, apr2: SelAprInfo.apr2empsid, apr3: SelAprInfo.apr3empsid, ref1: SelAprInfo.ref1empsid, ref2: SelAprInfo.ref2empsid) { (isSuccess, resultCode) in
                    if (isSuccess) {
                        switch resultCode {
                        case -1:
                            self.toast("결재자/참조자는 중복되면 안됩니다.");
                        case 0:
                            self.toast("다시 시도해 주세요.")
                        default:
                            self.toast("정상 처리 되었습니다.")
                            if self.selApr {
                                SelTemInfo.anualapr = self.apr
                            }else {
                                SelTemInfo.applyapr = self.apr
                            }
                            
                            self.SetCmpAprLine()
//                            let vc = MoreSB.instantiateViewController(withIdentifier: "AprSelVC") as! AprSelVC
//                            vc.modalTransitionStyle = .crossDissolve
//                            vc.modalPresentationStyle = .overFullScreen
//                            self.present(vc, animated: false, completion: nil)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else {
                        self.customAlertView("다시 시도해 주세요.")
                    }
                }
            }
//            else {
//                self.customAlertView("중간에 빈곳이 있으면 안됩니다.\n결재자가 존재하지 않으면 참조자를 추가할 수 없습니다.")
//            }
            
        }
    }
    
    //  상위팀, 팀 연차결재라인 회사설정으로 적용/미적용 처리
    func SetCmpAprLine(){
        if SelTemFlag {
            ttmsid = SelTtmSid
        }else {
            temsid = SelTemSid
        }
        
        NetworkManager.shared().SetCmpAprline(aprflag: selApr, ttmsid: ttmsid, temsid: temsid, apr: apr) { (isSuccess, resultCode) in
            if (isSuccess) {
                if resultCode == 1 {

                    if self.selApr {
                        SelTemInfo.anualapr = self.apr
                    }else {
                        SelTemInfo.applyapr = self.apr
                    }
                    if self.swAprLine.isOn {
                        self.toast("정상 처리 되었습니다.")
                    }
//                    let vc = MoreSB.instantiateViewController(withIdentifier: "AprSelVC") as! AprSelVC
//                    vc.modalTransitionStyle = .crossDissolve
//                    vc.modalPresentationStyle = .overFullScreen
//                    self.present(vc, animated: false, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                }else {
                    self.customAlertView("잠시 후, 다시 시도해 주세요.")
                }
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    @IBAction func aprEmpSelect(_ sender: UIButton) {
        var selflag = 0
        switch sender {
        case btnApr1:
            selflag = 1
        case btnApr2:
            selflag = 2
        case btnApr3:
            selflag = 3
        case btnRef1:
            selflag = 4
        case btnRef2:
            selflag = 5
        default:
            break
        }
        
        let vc = MoreSB.instantiateViewController(withIdentifier: "AprMgrListVC") as! AprMgrListVC
        vc.selflag = selflag
        vc.selApr = self.selApr
         
 
        if selApr {
            if self.apr != self.anualapr {
                vc.anualapr = self.anualapr
                vc.apr = self.anualapr
                apr =  self.anualapr
            }else{
                vc.anualapr = self.apr
                vc.apr = self.apr
            }
        }else{
            if self.apr != self.applyapr {
                vc.applyapr = self.applyapr
                vc.apr = self.applyapr
                apr =  self.applyapr
            }else{
                vc.applyapr = self.apr
                vc.apr = self.apr
            }
        }
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }

}
