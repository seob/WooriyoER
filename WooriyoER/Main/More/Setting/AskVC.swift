//
//  AdAskVC.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import KakaoPlusFriend

class AskVC: UIViewController {

    @IBOutlet weak var lblNavigationTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_SettingVC") as! SettingVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func adAskClick(_ sender: UIButton) {
        KPFPlusFriend.init(id: "_LaxoExb").chat()
    }
    
    @IBAction func askClick(_ sender: UIButton) {
        KPFPlusFriend.init(id: "_xgEMxkT").chat()
    }
}
