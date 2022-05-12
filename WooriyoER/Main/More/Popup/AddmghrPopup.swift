//
//  AddmghrPopup.swift
//  PinPle
//
//  Created by seob on 2020/08/13.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class AddmghrPopup: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = "'\(SelCeEmpInfo.name)'을(를)"
    }
    @IBAction func okClick(_ sender: UIButton) {
        NetworkManager.shared().Set_certiUser(CMPSID: CompanyInfo.sid, EMPSID: SelCeEmpInfo.sid) { (isSuccess, resCode) in
            if(isSuccess){
                let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_SettingVC") as! Ce_SettingVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
