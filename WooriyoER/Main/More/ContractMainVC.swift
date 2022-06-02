//
//  ContractMainVC.swift
//  PinPle
//
//  Created by seob on 2020/06/02.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class ContractMainVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel! 
    @IBOutlet weak var lblPoint: UILabel!
    
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var tabbarCustomView: UIView! //하단 탭바뷰
    @IBOutlet weak var tabButtonPinpl: UIButton! //하단 탭바 핀플
    @IBOutlet weak var tabButtonCmt: UIButton! // 하단 탭바 출퇴근
    @IBOutlet weak var tabButtonAnnual: UIButton! // 하단 탭바 연차
    @IBOutlet weak var tabButtonApply: UIButton! // 하단 탭바 신청
    @IBOutlet weak var tabButtonMore: UIButton! // 하단 탭바 더보기
    
    @IBOutlet weak var vwDefaultTop: UIView!
    @IBOutlet weak var vwFreeTop: UIView!
    @IBOutlet weak var lblFirstText: UILabel!
    @IBOutlet weak var lblSecondText: UILabel! 
    @IBOutlet weak var lblPointCharge: UILabel!
    @IBOutlet weak var FreeLeadingConstraint: NSLayoutConstraint! // default 75
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
 
        viewflag = "contractmain"
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.pointCharge(_:)))
        lblPointCharge.isUserInteractionEnabled = true
        lblPointCharge.addGestureRecognizer(labelTap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
 
    }
    
    //포인트 충전버튼
    @objc func pointCharge(_ sender: UITapGestureRecognizer) {
        let vc = ContractSB.instantiateViewController(withIdentifier: "InAppVC") as! InAppVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    //MARK: - Tabbar
    @IBAction func pinplTab(_ sender: UIButton) {
        let vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func cmtTab(_ sender: UIButton) {
        var vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
        if SE_flag {
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_CmtEmpList") as! CmtEmpList
        }else{
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func anlTab(_ sender: UIButton) {
        var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        if SE_flag {
            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
        }else{
            vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func aplTab(_ sender: UIButton) {
        var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
        if SE_flag {
            vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
        }else{
            vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
        }
        isTap = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func moreTab(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
     
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    // 회사정보 불러오기 (핀 포인트 갱신때문에 호출)
    func valueSetting() {
        NetworkManager.shared().getCmpInfo(cmpsid: userInfo.cmpsid) { (isSuccess, errCode, resData) in
            if(isSuccess){
                if errCode == 99 {
                    self.toast("다시 시도해 주세요.")
                }else{
                    guard let serverData = resData else { return }
                    CompanyInfo = serverData
                    self.lblPoint.text = "\(CompanyInfo.point)"
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    
    // 직인 체크( 없을경우 등록하라고 알림창 띄우기)
    func checkSeal(_ type:Int){
        NetworkManager.shared().getcmp_sealList(cmpsid: userInfo.cmpsid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                var isuseflag: Bool = false
                if serverData.count > 0 {
                    for i in 0...serverData.count - 1{
                        if serverData[i].useflag == 1 {
                            isuseflag = true
                            break
                        }
                    }
                    
                    if (isuseflag) {
//                        if userInfo.author == 0 || userInfo.author == 1 {
                            var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_empListVC") as! Lc_empListVC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_empListVC") as! Lc_empListVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            if type == 1 {
                                vc.format = 0
                            }else{
                                vc.format = 1
                            }
                            
                            self.present(vc, animated: false, completion: nil)
//                        }else{
//                            self.customAlertView("권한이 없습니다.")
//                        }
                    }else{
                        let alert = UIAlertController.init(title: "알림", message: "근로계약서에 필요한 직인 또는 서명을\n 등록해주세요.", preferredStyle: .alert)
                        let okAction = UIAlertAction.init(title: "등록하기", style: .default, handler: {action in
                            
                            let vc = ContractSB.instantiateViewController(withIdentifier: "CmpsealVC") as! CmpsealVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false, completion: nil)
                        })
                        let cancelAction = UIAlertAction.init(title: "확인", style: .cancel, handler: { action in
                            print("\n---------- [ 확인 ] ----------\n")
                        })
                        
                        alert.addAction(okAction)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: false, completion: nil)
                    }
                    
                    
                }else{
                    let alert = UIAlertController.init(title: "알림", message: "근로계약서에 필요한 직인 또는 서명을\n 등록해주세요.", preferredStyle: .alert)
                    let okAction = UIAlertAction.init(title: "등록하기", style: .default, handler: {action in
                        
                        let vc = ContractSB.instantiateViewController(withIdentifier: "CmpsealVC") as! CmpsealVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    })
                    let cancelAction = UIAlertAction.init(title: "확인", style: .cancel, handler: { action in
                        print("\n---------- [ 확인 ] ----------\n")
                    })
                    
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: false, completion: nil)
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    //핀플근로계약서
    @IBAction private func pinpleContractDidTap(_ sender: Any) {
//        if userInfo.author == 0 || userInfo.author == 1 {
            NetworkManager.shared().chkCmpinfo(cmpsid: userInfo.cmpsid) { (isSuccess, resCode) in
                if(isSuccess){
                    if (resCode == 1){
                        self.checkSeal(1)
                    }else{
                        let alert = UIAlertController.init(title: "알림", message: "근로계약서에 필요한 \n회사정보(대표자명,주소,대표번호)를\n 입력해주세요.", preferredStyle: .alert)
                        let okAction = UIAlertAction.init(title: "설정하기", style: .default, handler: {action in
                            moreCmpInfo.wk52h = 1
                            
                            let vc = MoreSB.instantiateViewController(withIdentifier: "SetCmpInfoVC") as! SetCmpInfoVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false, completion: nil)
                        })
                        let cancelAction = UIAlertAction.init(title: "확인", style: .cancel, handler: { action in
                            print("\n---------- [ 확인 ] ----------\n")
                        })
                        
                        alert.addAction(okAction)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: false, completion: nil)
                    }
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
//        }else{
//            customAlertView("권한이 없습니다.\n마스터관리자와 인사담당자만 가능합니다.")
//        }
    }
    
    //표준근로계약서
    @IBAction private func defaultContractDidTap(_ sender: Any) {
//        if userInfo.author == 0 || userInfo.author == 1 {
            NetworkManager.shared().chkCmpinfo(cmpsid: userInfo.cmpsid) { (isSuccess, resCode) in
                if(isSuccess){
                    if (resCode == 1){
                        self.checkSeal(2)
                    }else{
                        let alert = UIAlertController.init(title: "알림", message: "근로계약서에 필요한 \n회사정보(대표자명,주소,대표번호)를\n 입력해주세요.", preferredStyle: .alert)
                        let okAction = UIAlertAction.init(title: "설정하기", style: .default, handler: {action in
                            moreCmpInfo.wk52h = 1
                            
                            let vc = MoreSB.instantiateViewController(withIdentifier: "SetCmpInfoVC") as! SetCmpInfoVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false, completion: nil)
                        })
                        let cancelAction = UIAlertAction.init(title: "확인", style: .cancel, handler: { action in
                            print("\n---------- [ 확인 ] ----------\n")
                        })
                        
                        alert.addAction(okAction)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: false, completion: nil)
                    }
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
//        }else{
//            customAlertView("권한이 없습니다.\n마스터관리자와 인사담당자만 가능합니다.")
//        }
        
    }
    
    //근로계약서 리스트
    @IBAction private func ContractListDidTap(_ sender: Any) {
//        if userInfo.author == 0 || userInfo.author == 1 {
            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_ListVC") as! Lc_ListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
//        }else{
//            customAlertView("권한이 없습니다.\n마스터관리자와 인사담당자만 가능합니다.")
//        }
        
    }
    
    //직인 관리
    @IBAction private func signSettingDidTap(_ sender: Any) {
//        if userInfo.author == 0 || userInfo.author == 1 {
            let vc = ContractSB.instantiateViewController(withIdentifier: "CmpsealVC") as! CmpsealVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
//        }else{
//            customAlertView("권한이 없습니다.\n마스터관리자와 인사담당자만 가능합니다.")
//        }
        
    }
    
    //보안서약서
    @IBAction private func  SecurtDidTap(_ sender: Any) {
//        if userInfo.author == 0 || userInfo.author == 1 {
            NetworkManager.shared().chkCmpinfo(cmpsid: userInfo.cmpsid) { (isSuccess, resCode) in
                if(isSuccess){
                    if (resCode == 1){
                        self.checkSealSc(1)
                    }else{
                        let alert = UIAlertController.init(title: "알림", message: "보안서약서에 필요한 \n회사정보(대표자명,주소,대표번호)를\n 입력해주세요.", preferredStyle: .alert)
                        let okAction = UIAlertAction.init(title: "설정하기", style: .default, handler: {action in
                            moreCmpInfo.wk52h = 1
                            
                            let vc = MoreSB.instantiateViewController(withIdentifier: "SetCmpInfoVC") as! SetCmpInfoVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false, completion: nil)
                        })
                        let cancelAction = UIAlertAction.init(title: "확인", style: .cancel, handler: { action in
                            print("\n---------- [ 확인 ] ----------\n")
                        })
                        
                        alert.addAction(okAction)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: false, completion: nil)
                    }
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
//        }else{
//            customAlertView("권한이 없습니다.\n마스터관리자와 인사담당자만 가능합니다.")
//        }
    }
    
    //보안서약서 리스트
    @IBAction private func SctListDidTap(_ sender: Any) {
//        if userInfo.author == 0 || userInfo.author == 1 {
            let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_ListVC") as! Sc_ListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
//        }else{
//            customAlertView("권한이 없습니다.\n마스터관리자와 인사담당자만 가능합니다.")
//        }
        
    }
    
    // 직인 체크( 없을경우 등록하라고 알림창 띄우기)
    func checkSealSc(_ type:Int){
        NetworkManager.shared().getcmp_sealList(cmpsid: userInfo.cmpsid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                var isuseflag: Bool = false
                if serverData.count > 0 {
                    for i in 0...serverData.count - 1{
                        if serverData[i].useflag == 1 {
                            isuseflag = true
                            break
                        }
                    }
                    
                    if (isuseflag) {
//                        if userInfo.author == 0 || userInfo.author == 1 {
                            var vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_empListVC") as! Sc_empListVC
                            if SE_flag {
                                vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_empListVC") as! Sc_empListVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            if type == 1 {
                                vc.format = 0
                            }else{
                                vc.format = 1
                            } 
                            self.present(vc, animated: false, completion: nil)
//                        }else{
//                            self.customAlertView("권한이 없습니다.")
//                        }
                    }else{
                        let alert = UIAlertController.init(title: "알림", message: "보안서약서에 필요한 직인 또는 서명을\n 등록해주세요.", preferredStyle: .alert)
                        let okAction = UIAlertAction.init(title: "등록하기", style: .default, handler: {action in
                            
                            let vc = ContractSB.instantiateViewController(withIdentifier: "CmpsealVC") as! CmpsealVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false, completion: nil)
                        })
                        let cancelAction = UIAlertAction.init(title: "확인", style: .cancel, handler: { action in
                            print("\n---------- [ 확인 ] ----------\n")
                        })
                        
                        alert.addAction(okAction)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: false, completion: nil)
                    }
                    
                    
                }else{
                    let alert = UIAlertController.init(title: "알림", message: "보안서약서에 필요한 직인 또는 서명을\n 등록해주세요.", preferredStyle: .alert)
                    let okAction = UIAlertAction.init(title: "등록하기", style: .default, handler: {action in
                        
                        let vc = ContractSB.instantiateViewController(withIdentifier: "CmpsealVC") as! CmpsealVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    })
                    let cancelAction = UIAlertAction.init(title: "확인", style: .cancel, handler: { action in
                        print("\n---------- [ 확인 ] ----------\n")
                    })
                    
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: false, completion: nil)
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
}
