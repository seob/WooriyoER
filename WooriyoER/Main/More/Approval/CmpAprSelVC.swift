//
//  CmpAprSelVC.swift
//  PinPle
//
//  Created by WRY_010 on 01/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmpAprSelVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var btnAnl: UIButton!
    @IBOutlet weak var btnApl: UIButton!   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        print("\n---------- [ viewflag : \(viewflag) ] ----------\n")
        if viewflag == "AnlAprSetVC" {
            let vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlAprSetVC") as! AnlAprSetVC
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else if viewflag == "AplAprSetVC" {
            let vc = AplAprSB.instantiateViewController(withIdentifier: "AplAprSetVC") as! AplAprSetVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else if viewflag == "MainVC" {
            var vc = UIViewController()
            if SE_flag {
                vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC") as! MainVC
            }else {
                vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
//            let vc = MoreSB.instantiateViewController(withIdentifier: "CmpAprSelVC") as! CmpAprSelVC
//            vc.modalTransitionStyle = .crossDissolve
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: false, completion: nil)
            let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        /*
         Parameter
         CMPSID        회사번호 .. 상위팀번호, 팀번호는 0 또는 안보냄
         TTMSID        상위팀번호.. 회사번호, 팀번호는 0 또는 안보냄
         TEMSID        팀번호.. 회사번호, 상위팀번호는 0 또는 안보냄
         */
        
        var selApr = false // 연차, 근로 구분자 true. 연차 false. 근로
        if sender == btnAnl {
            selApr = true
        }else {
            selApr = false
        }
        
        
        NetworkManager.shared().GetAprline(aprflag: selApr, cmpsid: userInfo.cmpsid, ttmsid: 0, temsid: 0) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                SelAprInfo = serverData
                let vc = MoreSB.instantiateViewController(withIdentifier: "CmpAnlAprVC") as! CmpAnlAprVC
                vc.selApr = selApr
                
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)
            }else {
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
        }
    }
    
    
}
