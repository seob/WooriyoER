//
//  TemFirstlVC.swift
//  PinPle
//
//  Created by WRY_010 on 16/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TemFirstlVC: UIViewController {    
    
    @IBOutlet weak var btnCreate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCreate.layer.cornerRadius = 6
        prefs.setValue(9, forKey: "stage")
        
        viewflag = "TemFirstlVC"
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = CmpCrtSB.instantiateViewController(withIdentifier: "WTInfoVC") as! WTInfoVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func create(_ sender: UIButton) {
        let vc = TmCrtSB.instantiateViewController(withIdentifier: "TemCrtVC") as! TemCrtVC
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

