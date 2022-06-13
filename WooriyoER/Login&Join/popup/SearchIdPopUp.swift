//
//  SearchIdPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/06.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class SearchIdPopUp: UIViewController {
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        btnLogin.backgroundColor = EnterpriseColor.btnColor
        lblEmail.text = prefs.value(forKey: "search_email") as? String
    }
    @IBAction func loginClick(_ sender: UIButton) {
        let vc = LoginSignSB.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginVC
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func searchPass(_ sender: UIButton) {
        let vc = LoginSignSB.instantiateViewController(withIdentifier: "SearchPass") as! SearchPass
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
