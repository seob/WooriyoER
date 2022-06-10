//
//  PersonMgrPopUp.swift
//  PinPle
//
//  Created by seob on 2020/06/02.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class PersonMgrPopUp: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    var name = ""
    var empsids = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = "'\(name)'을(를)"
        btnSave.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        btnSave.backgroundColor = EnterpriseColor.btnColor
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        NetworkManager.shared().SetEmpAuthor(empsids: empsids, auth: 2, temsid: 0, ttmsid: 0) { (isSuccess, resCode) in
            if (isSuccess){
                switch resCode {
                case 0:
                    self.customAlertView("잠시후 다시 시도해주세요.");
                case 1:
                    let vc = MoreSB.instantiateViewController(withIdentifier: "PersonMgrListVC") as! PersonMgrListVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                default:
                    break;
                }

            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        } 
    }
}
