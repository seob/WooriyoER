//
//  CmpCertificatePopUp.swift
//  PinPle
//
//  Created by seob on 2020/08/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class CmpCertificatePopUp: UIViewController {

    @IBOutlet weak var btnYes: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnYes.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        btnYes.backgroundColor = EnterpriseColor.btnColor
        // Do any additional setup after loading the view.
    }
    
    //돌아가기 -> history.back
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //취소 - >메인으로
    @IBAction func okClick(_ sender: UIButton) {
        var vc = CertifiSB.instantiateViewController(withIdentifier: "CertifiCateMainVC") as! CertifiCateMainVC
        if SE_flag {
            vc = CertifiSB.instantiateViewController(withIdentifier: "SE_CertifiCateMainVC") as! CertifiCateMainVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }

}
