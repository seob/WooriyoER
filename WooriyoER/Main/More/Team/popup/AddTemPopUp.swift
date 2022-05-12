//
//  AddTemPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class AddTemPopUp: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
    }
    //팀(부서)생성
    @IBAction func addTem(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "AddTemVC") as! AddTemVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_AddTemVC") as! AddTemVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "AddTemVC") as! AddTemVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    //상위팀생성
    @IBAction func addTtm(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "AddTtmVC") as! AddTtmVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_AddTtmVC") as! AddTtmVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "AddTtmVC") as! AddTtmVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cancelClick(_ sender: UIButton) { 
        dismiss(animated: true, completion: nil)
    }
    
}
