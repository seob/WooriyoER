//
//  CmpSecurtPopUp.swift
//  PinPle
//
//  Created by seob on 2021/11/11.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class CmpSecurtPopUp: UIViewController {

    @IBOutlet weak var btnyes: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnyes.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        btnyes.backgroundColor = EnterpriseColor.btnColor
        // Do any additional setup after loading the view.
    }
    
    //돌아가기 -> history.back
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //취소 - >메인으로
    @IBAction func okClick(_ sender: UIButton) {
        var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
        if SE_flag {
            vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }

}
