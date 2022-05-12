//
//  SetMgrVC.swift
//  PinPle
//
//  Created by WRY_010 on 30/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class SetMgrVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
//        let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: false, completion: nil)
        NotificationCenter.default.post(name: .reloadTem, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func mgmtMgr(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MgmtMgrVC") as! MgmtMgrVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func addMgr(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "AddMgrVC") as! AddMgrVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}
