//
//  TeamCompleteViewController.swift
//  PinPle
//
//  Created by WRY_010 on 17/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TemCmpltVC: UIViewController {
    
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var btnCreateTeam: UIButton!
    @IBOutlet weak var lblCreateTeam: UILabel!
    
    var temname: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefs.setValue(11, forKey: "stage")
        EnterpriseColor.eachLblBtn(btnCreateTeam, lblCreateTeam)
        if let tmptemname = prefs.value(forKey: "crt_temname") as? String {
            self.temname = tmptemname
        }
        
        lblTeamName.text = temname
        
        viewflag = "TemCmpltVC"
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = TmCrtSB.instantiateViewController(withIdentifier: "TemCrtVC") as! TemCrtVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func create(_ sender: UIButton) {
        let vc = TmCrtSB.instantiateViewController(withIdentifier: "TtmCrtVC") as! TtmCrtVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func next(_ sender: UIButton) {
        let vc = TmCrtSB.instantiateViewController(withIdentifier: "ExcldWorkVC") as! ExcldWorkVC        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
}
