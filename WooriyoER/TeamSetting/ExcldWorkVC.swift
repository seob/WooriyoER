//
//  ExcldWorkVC.swift
//  PinPle
//
//  Created by WRY_010 on 17/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class ExcldWorkVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblManagerName: UILabel!
    @IBOutlet weak var btnExcept: UIButton!
    @IBOutlet weak var btnInclude: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    var notrc: Int = 0  // 출퇴근 포함 여부 0. 기록 1. 기록 안함
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefs.setValue(14, forKey: "stage")
        btnSave.layer.cornerRadius = 6
        btnExcept.isSelected = true
        btnExcept.setImage(checkImg, for: .selected)
        btnExcept.setImage(uncheckImg, for: .normal)
        btnInclude.setImage(checkImg, for: .selected)
        btnInclude.setImage(uncheckImg, for: .normal)
        
        lblManagerName.text = userInfo.name
        lblNavigationTitle.text = CompanyInfo.name
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        notrc = userInfo.notrc
        
        if notrc == 0 {
            btnExcept.isSelected = false
            btnInclude.isSelected = true
        }else {
            btnExcept.isSelected = true
            btnInclude.isSelected = false
        }
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = UIViewController()
        switch viewflag {
        case "TemFirstlVC":
            vc = TmCrtSB.instantiateViewController(withIdentifier: "TemFirstlVC") as! TemFirstlVC
        case "TemCmpltVC":
            vc = TmCrtSB.instantiateViewController(withIdentifier: "TemCmpltVC") as! TemCmpltVC
        default:
            vc = TmCrtSB.instantiateViewController(withIdentifier: "TtmListVC") as! TtmListVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func exceptClick(_ sender: UIButton) {
        btnExcept.isSelected = true
        btnInclude.isSelected = false
        notrc = 1
    }
    
    @IBAction func includeClick(_ sender: UIButton) {
        btnExcept.isSelected = false
        btnInclude.isSelected = true
        notrc = 0
    }
    
    @IBAction func save(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(출퇴근인원 제외 설정) ..대표 출퇴근 포함처리시 직원 카운트에 추가됨
         Return  - 성공:1, 실패:0
         Parameter
         EMPSID        직원번호
         NOTRC        0.출퇴근 기록함 1.출퇴근 기록하지않음
         */
        let empsid = userInfo.empsid
        IndicatorSetting()
        NetworkManager.shared().SetEmpNotrc(empsid: empsid, notrc: notrc) { (isSuccess, error, resCode) in
            if (isSuccess) {
                if error == 1 {
                    if resCode > 0 {
                        userInfo.notrc = self.notrc
                        
                        var vc = TmCrtSB.instantiateViewController(withIdentifier: "InfoSet") as! InfoSet
                        if SE_flag {
                            vc = TmCrtSB.instantiateViewController(withIdentifier: "SE_InfoSet") as! InfoSet
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    }else{
                        self.customAlertView("다시 시도해 주세요.")
                    }
                }else {
                    self.customAlertView("다시 시도해 주세요.")
                }
            }else{
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
        }
    }
}
