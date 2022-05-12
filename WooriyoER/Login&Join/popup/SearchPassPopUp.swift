//
//  SearchPassPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/06.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class SearchPassPopUp: UIViewController {
    
    @IBOutlet weak var lblEmail: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        lblEmail.text = (prefs.value(forKey: "search_email") as? String)! + "으로"
        
    }
    @IBAction func loginClick(_ sender: UIButton) {
        let vc = LoginSignSB.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginVC
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
