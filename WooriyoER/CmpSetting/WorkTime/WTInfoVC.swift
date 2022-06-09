//
//  WTInfoVC.swift
//  PinPle
//
//  Created by WRY_010 on 11/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class WTInfoVC: UIViewController {
    
    @IBOutlet weak var btnCustom: UIButton!
    @IBOutlet weak var lblCustom: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.eachLblBtn(btnCustom, lblCustom)
        prefs.setValue(7, forKey: "stage")
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "RegMgrVC" {
            let vc = CmpCrtSB.instantiateViewController(withIdentifier: "RegMgrVC") as! RegMgrVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            let vc = CmpCrtSB.instantiateViewController(withIdentifier: "CmpTtmListVC") as! CmpTtmListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    @IBAction func btnNext(_ sender: UIButton) {
        let vc = TmCrtSB.instantiateViewController(withIdentifier: "TemFirstlVC") as! TemFirstlVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func btnSetting(_ sender: UIButton) {
        let vc = CmpCrtSB.instantiateViewController(withIdentifier: "CmpWTimeVC") as! CmpWTimeVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }    
}
