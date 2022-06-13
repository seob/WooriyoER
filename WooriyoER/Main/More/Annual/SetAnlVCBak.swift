//
//  SetAnlVCBak.swift
//  PinPle
//
//  Created by seob on 2021/11/20.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class SetAnlVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var swAd1: UISwitch!
    @IBOutlet weak var swAd2: UISwitch!
    @IBOutlet weak var swAd3: UISwitch!
    @IBOutlet weak var vwAuthor: UIView!
    
    @IBOutlet weak var vwAd1Area: CustomView!
    @IBOutlet weak var vwAd2Area: CustomView!
    @IBOutlet weak var vwAd3Area: CustomView!
    
    @IBOutlet weak var lblFicalYear: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnAnual: UIButton!
    @IBOutlet weak var btnAnualYear: UIButton!
    @IBOutlet weak var switchImageView1: UIImageView!
    @IBOutlet weak var switchImageView2: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    
    var cmpsid: Int = 0         //화사번호... 0인경우 해당회사 없음
    var anualddctn1: Int = 0    //지각 연차차감(0.미차감, 1.차감)
    var anualddctn2: Int = 0    //조회 연차차감(0.미차감, 1.차감)
    var anualddctn3: Int = 0    //외출 연차차감(0.미차감, 1.차감)
    var stAnual : Int = 0 // 입사일기준 1 , 회계년도 0
    
    let toggleAd1 = ToggleSwitch(with: images)
    let toggleAd2 = ToggleSwitch(with: images)
    let toggleAd3 = ToggleSwitch(with: images)
    var switchYposition:CGFloat = 0
    var switchXposition:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnSave)
        if !authorCk(msg: "권한이 없습니다.\n마스터관리자와 최고관리자만 \n변경이 가능합니다.") {
            vwAuthor.isHidden = false
        }
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        
        if moreCmpInfo.stanual == 0 {
            let splitArr = moreCmpInfo.stanualyear.split(separator: "-")
//            lblFicalYear.text = "(\(splitArr[0])월 \(splitArr[1])일)"
            lblFicalYear.text = "(\(splitArr[0].replacingOccurrences(of: "(", with: ""))월 \(splitArr[1].replacingOccurrences(of: ")", with: ""))일)"
        }else{
            lblFicalYear.isHidden = true
        }
        
        if view.bounds.width == 414 {
            switchYposition = 25.75
            switchXposition = 50
        }else if view.bounds.width == 375 {
            switchYposition = 20
            switchXposition = 45
        }else if view.bounds.width == 390 {
            // iphone 12 pro
            switchYposition = 24.75
            switchXposition = 50
        }else if view.bounds.width == 320 {
            // iphone se
            switchYposition = 10
            switchXposition = 20
        }else{
            switchYposition = 26
            switchXposition = 50
        }
        
        toggleAd1.frame.origin.x = switchYposition
        toggleAd1.frame.origin.y = switchXposition
        
        toggleAd2.frame.origin.x = switchYposition
        toggleAd2.frame.origin.y = switchXposition
        
        toggleAd3.frame.origin.x = switchYposition
        toggleAd3.frame.origin.y = switchXposition
        
        
        self.vwAd1Area.addSubview(toggleAd1)
        self.vwAd2Area.addSubview(toggleAd2)
        self.vwAd3Area.addSubview(toggleAd3)
        
        toggleAd1.addTarget(self, action: #selector(toggleAd1Changed), for: .valueChanged)
        toggleAd2.addTarget(self, action: #selector(toggleAd2Changed), for: .valueChanged)
        toggleAd3.addTarget(self, action: #selector(toggleAd3Changed), for: .valueChanged)
        
        btnSetting.addTarget(self, action: #selector(setAnualOption(_:)), for: .touchUpInside)
        btnAnual.addTarget(self, action: #selector(changeFicalValue(_:)), for: .touchUpInside)
        btnAnualYear.addTarget(self, action: #selector(changeFicalValue2(_:)), for: .touchUpInside)
    }
  
    func checkEextension() {
        switch moreCmpInfo.freetype {
        case 2,3:
            if moreCmpInfo.ficalyear >= muticmttodayDate() {
                print("\n---------- [올프리 , 펀프리 ] ----------\n")
            }else{
                let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                viewflag = "multicmtarea"
                vc.checkEextension = 0
                vc.payType = 5
                print("\n---------- [ 1 ] ----------\n")
                self.present(vc, animated: false, completion: nil)
                
            }
        default:
            let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            viewflag = "multicmtarea"
            vc.checkEextension = 1
            vc.payType = 5
            print("\n---------- [ 2 ] ----------\n")
            self.present(vc, animated: false, completion: nil)
            
        }
        
    }
    
    
    @objc func changeFicalValue(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender == btnAnual {
            stAnual = 1
            moreCmpInfo.stanual = 1
            switchImageView1.image = UIImage(named: "btn_switch_on")
            switchImageView2.image = switchOffImgFree
            btnSetting.isEnabled = false
            lblFicalYear.isHidden = true
        }else{
            stAnual = 0
            moreCmpInfo.stanual = 0
            btnSetting.isEnabled = true
            switchImageView1.image = UIImage(named: "btn_switch_off")
            switchImageView2.image = UIImage(named: "y_btn")
            lblFicalYear.isHidden = false
            if moreCmpInfo.stanual == 0 {
                let splitArr = moreCmpInfo.stanualyear.split(separator: "-")
//                str.replacingOccurrences(of: "!", with: "♥︎")
                print("\n---------- [ splitArr : \(splitArr[0]) , splitArr1 : \(splitArr[1]) ] ----------\n")
                lblFicalYear.text = "(\(splitArr[0].replacingOccurrences(of: "(", with: ""))월 \(splitArr[1].replacingOccurrences(of: ")", with: ""))일)"
            }
        }
    }
    
    @objc func changeFicalValue2(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender == btnAnual {
            stAnual = 1
            moreCmpInfo.stanual = 1
            switchImageView1.image = UIImage(named: "btn_switch_on")
            switchImageView2.image = switchOffImgFree
            btnSetting.isEnabled = false
            lblFicalYear.isHidden = true
        }else{
            stAnual = 0
            moreCmpInfo.stanual = 0
            btnSetting.isEnabled = true
            switchImageView1.image = UIImage(named: "btn_switch_off")
            switchImageView2.image = UIImage(named: "y_btn")
            lblFicalYear.isHidden = false
            if moreCmpInfo.stanual == 0 {
                let splitArr = moreCmpInfo.stanualyear.split(separator: "-")
                lblFicalYear.text = "(\(splitArr[0].replacingOccurrences(of: "(", with: ""))월 \(splitArr[1].replacingOccurrences(of: ")", with: ""))일)"
            }
        }
        
//        switch moreCmpInfo.freetype {
//        case 2,3:
//            if moreCmpInfo.ficalyear >= muticmttodayDate() {
//                sender.isSelected = !sender.isSelected
//                if sender == btnAnualYear {
//                    stAnual = 0
//                    moreCmpInfo.stanual = 0
//                    switchImageView1.image = UIImage(named: "btn_switch_off")
//                    switchImageView2.image = UIImage(named: "y_btn")
//                    btnSetting.isEnabled = true
//                    lblFicalYear.isHidden = false
//                    if moreCmpInfo.stanual == 0 {
//                        let splitArr = moreCmpInfo.stanualyear.split(separator: "-")
//                        lblFicalYear.text = "(\(splitArr[0])월 \(splitArr[1])일)"
//                    }
//                }else{
//                    stAnual = 1
//                    moreCmpInfo.stanual = 1
//                    btnSetting.isEnabled = false
//                    switchImageView1.image = UIImage(named: "btn_switch_on")
//                    switchImageView2.image = switchOffImgFree
//                    lblFicalYear.isHidden = true
//                }
//            }else{
//
//                let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
//                vc.modalTransitionStyle = .crossDissolve
//                vc.modalPresentationStyle = .overFullScreen
//                viewflag = "setanualvc"
//                if moreCmpInfo.ficalyear >= muticmttodayDate() {
//                    vc.checkEextension = 1
//                }else{
//                    vc.checkEextension = 0
//                }
//                vc.payType = 5
//                self.present(vc, animated: false, completion: nil)
//
//            }
//        default:
//            if moreCmpInfo.ficalyear >= muticmttodayDate() {
//                sender.isSelected = !sender.isSelected
//                if sender == btnAnualYear {
//                    stAnual = 0
//                    moreCmpInfo.stanual = 0
//                    switchImageView1.image = UIImage(named: "btn_switch_off")
//                    switchImageView2.image = UIImage(named: "y_btn")
//                    btnSetting.isEnabled = true
//                    lblFicalYear.isHidden = false
//                    if moreCmpInfo.stanual == 0 {
//                        let splitArr = moreCmpInfo.stanualyear.split(separator: "-")
//                        lblFicalYear.text = "(\(splitArr[0])월 \(splitArr[1])일)"
//                    }
//                }else{
//                    stAnual = 1
//                    moreCmpInfo.stanual = 1
//                    btnSetting.isEnabled = false
//                    switchImageView1.image = UIImage(named: "btn_switch_on")
//                    switchImageView2.image = switchOffImgFree
//                    lblFicalYear.isHidden = true
//                }
//            }else{
//                let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
//                vc.modalTransitionStyle = .crossDissolve
//                vc.modalPresentationStyle = .overFullScreen
//                viewflag = "setanualvc"
//                if moreCmpInfo.ficalyear >= muticmttodayDate() {
//                    vc.checkEextension = 1
//                }else{
//                    vc.checkEextension = 0
//                }
//                vc.payType = 5
//                self.present(vc, animated: false, completion: nil)
//            }
//        }
    }
    
    func  setlayOut(){
        if anualddctn1 == 1 {
            swAd1.isOn = true
            toggleAd1.setOn(on: true, animated: true)
        }else {
            swAd1.isOn = false
            toggleAd1.setOn(on: false, animated: true)
        }
        
        if anualddctn2 == 1 {
            swAd2.isOn = true
            toggleAd2.setOn(on: true, animated: true)
        }else {
            swAd2.isOn = false
            toggleAd2.setOn(on: false, animated: true)
        }
        
        if anualddctn3 == 1 {
            swAd3.isOn = true
            toggleAd3.setOn(on: true, animated: true)
        }else {
            swAd3.isOn = false
            toggleAd3.setOn(on: false, animated: true)
        }
    }
    //지각
    @objc func toggleAd1Changed(toggle: ToggleSwitch) {
        print("beingLate = ", toggle.isOn)
        if toggle.isOn {
            anualddctn1 = 1
        }else {
            anualddctn1 = 0
        }
        setlayOut()
    }
    
    //조퇴
    @objc func toggleAd2Changed(toggle: ToggleSwitch) {
        print("earlyLeave = ", toggle.isOn)
        if toggle.isOn {
            anualddctn2 = 1
        }else {
            anualddctn2 = 0
        }
        setlayOut()
    }
    
    //외출
    @objc func toggleAd3Changed(toggle: ToggleSwitch) {
        print("going = ", toggle.isOn)
        if toggle.isOn {
            anualddctn3 = 1
        }else {
            anualddctn3 = 0
        }
        setlayOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cmpsid = userInfo.cmpsid
        stAnual = moreCmpInfo.stanual
        
        if stAnual > 0 {
            stAnual = 1
            btnSetting.isEnabled = false
            switchImageView1.image = switchOnImgFree
            switchImageView2.image = switchOffImgFree
            
 
        }else{
            stAnual = 0
            switchImageView1.image = UIImage(named: "btn_switch_off")
            switchImageView2.image = UIImage(named: "y_btn")
            btnSetting.isEnabled = true
        }
        
        anualddctn1 = moreCmpInfo.anualddctn1
        anualddctn2 = moreCmpInfo.anualddctn2
        anualddctn3 = moreCmpInfo.anualddctn3
        
        if anualddctn1 == 1 {
            swAd1.isOn = true
            toggleAd1.setOn(on: true, animated: true)
        }else {
            swAd1.isOn = false
            toggleAd1.setOn(on: false, animated: true)
        }
        
        if anualddctn2 == 1 {
            swAd2.isOn = true
            toggleAd2.setOn(on: true, animated: true)
        }else {
            swAd2.isOn = false
            toggleAd2.setOn(on: false, animated: true)
        }
        
        if anualddctn3 == 1 {
            swAd3.isOn = true
            toggleAd3.setOn(on: true, animated: true)
        }else {
            swAd3.isOn = false
            toggleAd3.setOn(on: false, animated: true)
        }
        
 
        
        getCmpinfo()
    }
    
    fileprivate func getCmpinfo(){
        NetworkManager.shared().getCmpInfo(cmpsid: userInfo.cmpsid) { (isSuccess, errCode, resData) in
            if(isSuccess){
                if errCode == 99 {
                    self.toast("다시 시도해 주세요.")
                }else{
                    guard let serverData = resData else { return }
                    moreCmpInfo = serverData
                    CompanyInfo = moreCmpInfo
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "AnlAprSetVC" {
            let vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlAprSetVC") as! AnlAprSetVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @objc func setAnualOption(_ sender: UIButton) { 
        let vc = MoreSB.instantiateViewController(withIdentifier: "SetAnualOptionVC") as! SetAnualOptionVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func beingLate(_ sender: UISwitch) {
        print("beingLate = ", sender.isOn)
        if sender.isOn {
            anualddctn1 = 1
        }else {
            anualddctn1 = 0
        }
        
    }
    
    @IBAction func earlyLeave(_ sender: UISwitch) {
        print("earlyLeave = ", sender.isOn)
        if sender.isOn {
            anualddctn2 = 1
        }else {
            anualddctn2 = 0
        }
        
    }
    @IBAction func going(_ sender: UISwitch) {
        print("going = ", sender.isOn)
        if sender.isOn {
            anualddctn3 = 1
        }else {
            anualddctn3 = 0
        }
    }
    
   
    
    @IBAction func save(_ sender: UIButton) {
        NetworkManager.shared().SetCmpAnualddctn(cmpsid: cmpsid, anualddctn1: anualddctn1, anualddctn2: anualddctn2, anualddctn3: anualddctn3, nStAnual: stAnual) { (isSuccess, resultCode) in
            if (isSuccess) {
                if resultCode == 1 {
                    moreCmpInfo.anualddctn1 = self.anualddctn1
                    moreCmpInfo.anualddctn2 = self.anualddctn2
                    moreCmpInfo.anualddctn3 = self.anualddctn3
                     
                    if viewflag == "AnlAprSetVC" {
                        let vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlAprSetVC") as! AnlAprSetVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    }else {
                        let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    }

                }else {
                    self.customAlertView("잠시 후, 다시 시도해 주세요.")
                }
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
}
