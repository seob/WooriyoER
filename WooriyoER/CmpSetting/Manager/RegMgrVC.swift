//
//  RegMgrVC.swift
//  PinPle
//
//  Created by WRY_010 on 04/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class RegMgrVC: UIViewController {
     
    @IBOutlet weak var lblSEtext1: UILabel!
    @IBOutlet weak var lblSEtext2: UILabel!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var lblJoin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefs.setValue(5, forKey: "stage")
        lblSEtext1.adjustsFontSizeToFitWidth = true
        lblSEtext2.adjustsFontSizeToFitWidth = true
        EnterpriseColor.eachLblBtn(btnJoin, lblJoin)
        viewflag = "RegMgrVC"
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = CmpCrtSB.instantiateViewController(withIdentifier: "CmpInfoVC") as! CmpInfoVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func btnJoin(_ sender: UIButton) {
        let vc = CmpCrtSB.instantiateViewController(withIdentifier: "CmpTtmListVC") as! CmpTtmListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        let vc = CmpCrtSB.instantiateViewController(withIdentifier: "WTInfoVC") as! WTInfoVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen        
        self.present(vc, animated: false, completion: nil)
    }
    
}
