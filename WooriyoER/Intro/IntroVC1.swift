//
//  IntroVC1.swift
//  PinPle
//
//  Created by WRY_010 on 2019/10/24.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import KakaoPlusFriend

class IntroVC1: UIViewController {
    
    @IBOutlet weak var topHeight: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.layer.cornerRadius = 6
        if deviceHeight() == 2 {
            topHeight.constant = UIScreen.main.bounds.height * ( topHeight.constant / 812) - 20
        }else {
            topHeight.constant = UIScreen.main.bounds.height * ( topHeight.constant / 812)
        }
        
    }
    
    @IBAction func inquiry(_ sender: UIButton) {
        KPFPlusFriend.init(id: "_xgEMxkT").chat()
    }
    
    @IBAction func next(_ sender: UIButton) {
        var vc = UIViewController()
        if SE_flag {
            vc = IntroSB.instantiateViewController(withIdentifier: "SE_IntroVC2")
        }else {
            vc = IntroSB.instantiateViewController(withIdentifier: "IntroVC2")
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
}
