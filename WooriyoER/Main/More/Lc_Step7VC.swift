//
//  Lc_Step7VC.swift
//  PinPle
//
//  Created by seob on 2020/06/05.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Lc_Step7VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var lblWorkType: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPointCharge: UILabel!
    
    @IBOutlet weak var lblInfomation: UILabel!
    @IBOutlet weak var vwLine: UIImageView!
    @IBOutlet weak var vwLine2: UIView!
    @IBOutlet weak var btnNext: UIButton!
    
    var selInfo : LcEmpInfo = LcEmpInfo()
    var standInfo : LcEmpInfo = LcEmpInfo()
    var viewflagType = ""
    let DefaultContractType : [String] = ["정규직, 무기계약직|월급" , "계약직|월급" , "소정시간,아르바이트|시급" , "근로일별,아르바이트|시급" , "소정시간|일급" , "근로일별|일급"]
    let ContractType : [String] = ["정규직" , "계약직" , "수습"]
    let SlyType : [String] = ["월급" , "연봉" , "시급"] 
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        fileExists = ""
        viewflag = "Lc_Step7VC"
        var formStr = ""
        
        if viewflagType == "stand_step5" {
            lblName.text = "\(self.standInfo.name)님의 근로계약서"
            formStr = DefaultContractType[self.standInfo.form]
            
            lblWorkType.text = "\(formStr)"
        }else{
            lblName.text = "\(selInfo.name)님의 근로계약서"
            formStr = ContractType[selInfo.form]
            lblWorkType.text = "\(formStr)|\(SlyType[selInfo.slytype])"
        }
        
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.pointCharge(_:)))
        lblPointCharge.isUserInteractionEnabled = true
        lblPointCharge.addGestureRecognizer(labelTap)
        
        lblPoint.text = "\(CompanyInfo.point)"
    }
    
    //포인트 충전버튼
    @objc func pointCharge(_ sender: UITapGestureRecognizer) {
        let vc = ContractSB.instantiateViewController(withIdentifier: "InAppVC") as! InAppVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        if viewflagType == "stand_step5" {
            vc.standInfo = self.standInfo
            vc.viewflagType = "stand_step5"
        }else{
            vc.selInfo = self.selInfo 
        }
        
        self.present(vc, animated: false, completion: nil)
    }
    
    fileprivate func getLCinfo(){
        var sid = 0
        if viewflagType == "stand_step5" {
            sid = standInfo.sid
        }else{
            sid = selInfo.sid
        }
        NetworkManager.shared().get_LCInfo(LCTSID: sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                if self.viewflagType == "stand_step5" {
                    self.standInfo = serverData
                    self.downloadImage(self.standInfo.cslimg)
                }else{
                    self.selInfo = serverData
                } 
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLCinfo()
    }
    
    //미리보기
    @IBAction func previewDidTap(_ sender: UIButton) { 
        // pdf file 서버에서 생성해서 받아오기 - 2020.07.10
        let vc = ContractSB.instantiateViewController(withIdentifier: "PDFViewerVC") as! PDFViewerVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        fileExists = ""
        if viewflagType == "stand_step5" {
            vc.selInfo = self.standInfo
            vc.viewflagType = "stand_step5"
        }else{
            vc.selInfo = self.selInfo
        }
        self.present(vc, animated: false, completion: nil)
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflagType == "stand_step5" {
            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step5VC") as! Lc_Default_Step5VC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.standInfo = self.standInfo
            self.present(vc, animated: false, completion: nil)
        }else{
            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step6VC") as! Lc_Step6VC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.selInfo = self.selInfo
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        switch moreCmpInfo.freetype {
            case 2,3:
                //올프리 , 펀프리
                if moreCmpInfo.freedt >= muticmttodayDate() {
                    if SE_flag {
                        let vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_SendMsg") as! Lc_SendMsg
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        
                        if  viewflagType == "stand_step5" {
                            vc.standInfo = self.standInfo
                            vc.viewflagType = "stand_step5"
                        }else{
                            vc.selInfo = self.selInfo
                        }
                        
                        self.present(vc, animated: false, completion: nil)
                        
                    }else{
                        
                        let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_SendMsg") as! Lc_SendMsg
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        
                        if  viewflagType == "stand_step5" {
                            vc.standInfo = self.standInfo
                            vc.viewflagType = "stand_step5"
                        }else{
                            vc.selInfo = self.selInfo
                        }
                        
                        self.present(vc, animated: false, completion: nil)
                    }
                }else{
                    if CompanyInfo.point > 0 {
                        if SE_flag {
                            let vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_SendMsg") as! Lc_SendMsg
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            
                            if  viewflagType == "stand_step5" {
                                vc.standInfo = self.standInfo
                                vc.viewflagType = "stand_step5"
                            }else{
                                vc.selInfo = self.selInfo
                            }
                            
                            self.present(vc, animated: false, completion: nil)
                            
                        }else{
                            
                            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_SendMsg") as! Lc_SendMsg
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            
                            if  viewflagType == "stand_step5" {
                                vc.standInfo = self.standInfo
                                vc.viewflagType = "stand_step5"
                            }else{
                                vc.selInfo = self.selInfo
                            }
                            
                            self.present(vc, animated: false, completion: nil)
                        }
                        
                        
                    }else{
                        // point 가 없으면 충전 페이지 이동
                        if viewflagType == "stand_step5" {
                            let vc = ContractSB.instantiateViewController(withIdentifier: "InAppVC") as! InAppVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.viewflagType = "stand_step5"
                            vc.standInfo = self.standInfo
                            self.present(vc, animated: false, completion: nil)
                        }else{
                            let vc = ContractSB.instantiateViewController(withIdentifier: "InAppVC") as! InAppVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.viewflagType = "step7"
                            vc.selInfo = self.selInfo
                            self.present(vc, animated: false, completion: nil)
                        }
                        
                    }
                }
            default:
                // 핀프리 , 사용안함
                if CompanyInfo.point > 0 {
                    if SE_flag {
                        let vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_SendMsg") as! Lc_SendMsg
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        
                        if  viewflagType == "stand_step5" {
                            vc.standInfo = self.standInfo
                            vc.viewflagType = "stand_step5"
                        }else{
                            vc.selInfo = self.selInfo
                        }
                        
                        self.present(vc, animated: false, completion: nil)
                        
                    }else{
                        
                        let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_SendMsg") as! Lc_SendMsg
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        
                        if  viewflagType == "stand_step5" {
                            vc.standInfo = self.standInfo
                            vc.viewflagType = "stand_step5"
                        }else{
                            vc.selInfo = self.selInfo
                        }
                        
                        self.present(vc, animated: false, completion: nil)
                    }
                    
                    
                }else{
                    // point 가 없으면 충전 페이지 이동
                    if viewflagType == "stand_step5" {
                        let vc = ContractSB.instantiateViewController(withIdentifier: "InAppVC") as! InAppVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.viewflagType = "stand_step5"
                        vc.standInfo = self.standInfo
                        self.present(vc, animated: false, completion: nil)
                    }else{
                        let vc = ContractSB.instantiateViewController(withIdentifier: "InAppVC") as! InAppVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.viewflagType = "step7"
                        vc.selInfo = self.selInfo
                        self.present(vc, animated: false, completion: nil)
                    }
                    
                }
        }
    }
    
}
