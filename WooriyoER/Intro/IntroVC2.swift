//
//  IntroVC2.swift
//  PinPle
//
//  Created by WRY_010 on 2019/10/24.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class IntroVC2: UIViewController {
    
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
    
    @IBAction func workerApp(_ sender: UIButton) {
        let scheme = "WooriyoEE://"
        let url = URL(string: scheme)!
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else {
            UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/apple-store/id1624398964")!, options: [:], completionHandler: nil)
        }
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = UIViewController()
        if SE_flag {
            vc = IntroSB.instantiateViewController(withIdentifier: "SE_IntroVC1")
        }else {
            vc = IntroSB.instantiateViewController(withIdentifier: "IntroVC1")
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func never(_ sender: UIButton) {
        prefs.setValue("intro", forKey: "intro")
        goMain()
    }
    
    @IBAction func next(_ sender: UIButton) {
        goMain()
    }
    func goMain() {
        var vc = UIViewController()
        if SE_flag {
            vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC")
        }else {
            vc = MainSB.instantiateViewController(withIdentifier: "MainVC")
        }

        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}
