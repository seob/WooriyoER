//
//  CertifiCateMainVC.swift
//  PinPle
//
//  Created by seob on 2020/08/06.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class CertifiCateMainVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblPointCharge: UILabel!
    @IBOutlet weak var lblPoint: UILabel!
    
    @IBOutlet weak var vwDefaultTop: UIView!
    @IBOutlet weak var vwFreeTop: UIView!
    @IBOutlet weak var lblFirstText: UILabel!
    @IBOutlet weak var lblSecondText: UILabel!
    @IBOutlet weak var FreeLeadingConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        if view.bounds.width == 414 {
            FreeLeadingConstraint.constant = 100
        }else if view.bounds.width == 375 {
            FreeLeadingConstraint.constant = 75
        }else if view.bounds.width == 390 {
            // iphone 12 pro
            FreeLeadingConstraint.constant = 95
        }
        
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
        viewflag = "certificate"
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
     
 
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    //재직증명서 발급
    @IBAction func ce_emplistClick(_ sender: UIButton) {
//        if userInfo.author == 0 || userInfo.author == 1 {
            NetworkManager.shared().chkCmpinfo(cmpsid: userInfo.cmpsid) { (isSuccess, resCode) in
                if(isSuccess){
                    if (resCode == 1){
                        self.checkSeal(0)
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
//            customAlertView("권한이 없습니다.\n마스터관리자와 최고관리자만 가능합니다.")
//        }
    }
    
    //경력증명서 발급
    @IBAction func career_emplistClick(_ sender: UIButton) {
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
//            customAlertView("권한이 없습니다.\n마스터관리자와 최고관리자만 가능합니다.")
//        }
    }
    
    //재직증명서 리스트
    @IBAction func ce_ListClick(_ sender: UIButton) {
        if sender.tag == 0 { //재직증명서
            let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_ListVC") as! Ce_ListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.type  = 0
            self.present(vc, animated: false, completion: nil)
        }else{
            let vc = CertifiSB.instantiateViewController(withIdentifier: "Cc_ListVC") as! Cc_ListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.type  = 1
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    //증명서 설정
    @IBAction func ce_settingClick(_ sender: UIButton) {
        let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_SettingVC") as! Ce_SettingVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    //직인관리
    @IBAction func ce_seallistClick(_ sender: UIButton) {
        let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_sealListVC") as! Ce_sealListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    // 직인 체크( 없을경우 등록하라고 알림창 띄우기)
    func checkSeal(_ type:Int){
        NetworkManager.shared().getcmp_sealList(cmpsid: userInfo.cmpsid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                var isuseflag: Bool = false
                if serverData.count > 0 {
                    for i in 0...serverData.count - 1{ 
                        if serverData[i].certflag == 1 {
                            isuseflag = true
                            break
                        }
                    }
                    
                    if (isuseflag) {
//                        if userInfo.author == 0 || userInfo.author == 1 {
                            if type == 0 { //재직
                                let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_empListVC") as! Ce_empListVC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                vc.format = 0
                                self.present(vc, animated: false, completion: nil)
                            }else{ //경력
                                let vc = CertifiSB.instantiateViewController(withIdentifier: "Career_empListVC") as! Career_empListVC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                vc.format = 1
                                self.present(vc, animated: false, completion: nil)
                            }
                            
//                        }else{
//                            self.customAlertView("권한이 없습니다.")
//                        }
                    }else{
                        let alert = UIAlertController.init(title: "알림", message: "증명서에 필요한 직인 또는 서명을\n 등록해주세요.", preferredStyle: .alert)
                        let okAction = UIAlertAction.init(title: "등록하기", style: .default, handler: {action in
                            
                            let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_sealListVC") as! Ce_sealListVC
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
                    let alert = UIAlertController.init(title: "알림", message: "증명서에 필요한 직인 또는 서명을\n 등록해주세요.", preferredStyle: .alert)
                    let okAction = UIAlertAction.init(title: "등록하기", style: .default, handler: {action in
                        
                        let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_sealListVC") as! Ce_sealListVC
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
