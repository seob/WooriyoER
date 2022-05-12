//
//  EmpInfoMainVC.swift
//  PinPle
//
//  Created by seob on 2020/07/23.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class EmpInfoMainVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    var tempMbrInfo = getMbrInfo()
    var EmpInfo = EmplyInfo()
    override func viewDidLoad() {
        super.viewDidLoad()

        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        print("\n---------- [ tempMbrInfo : \(tempMbrInfo.toJSON()) ] ----------\n")
//        lblTitle.text = "\(tempMbrInfo.name)의 기본정보와 연차정보를 관리합니다."
//        lblTitle.text = "\(tempMbrInfo.name)의 기본정보와 연차정보를 관리합니다."
    }
     
    @IBAction func barBack(_ sender: UIButton) {
        
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpCmtList") as! EmpCmtList
        SelEmpInfo.sid = tempMbrInfo.empsid
        SelEmpInfo.name = tempMbrInfo.name
        SelEmpInfo.enname = tempMbrInfo.enname
        SelEmpInfo.author = tempMbrInfo.author
        SelEmpInfo.mbrsid = tempMbrInfo.mbrsid
        vc.tempMbrInfo = tempMbrInfo
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    //근로자 정보
    @IBAction func empinfoDidTap(_ sender: UIButton) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpInfoVC") as! EmpInfoVC
        vc.selname = tempMbrInfo.name
        vc.selspot = tempMbrInfo.spot
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    //연차 정보
    @IBAction func annualDidTap(_ sender: UIButton) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "AnnualListVC") as! AnnualListVC
        vc.EmpInfo.mbrsid = EmpInfo.mbrsid
        vc.EmpInfo.sid = EmpInfo.sid
        vc.tempMbrInfo = tempMbrInfo
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}
