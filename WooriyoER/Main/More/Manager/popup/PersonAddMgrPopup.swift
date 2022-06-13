//
//  PersonAddMgrPopup.swift
//  PinPle
//
//  Created by seob on 2020/06/02.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class PersonAddMgrPopup: UIViewController {
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblName: UILabel!
     
    
    var name = ""
    var empsids = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        btnSave.backgroundColor = EnterpriseColor.btnColor
        lblName.text = "'\(name)'을(를)"
    }
    // FIXME: 팝업창 닫기
    @IBAction func okClick(_ sender: UIButton) {

        NetworkManager.shared().SetEmpAuthor(empsids: empsids, auth: 0, temsid: 0, ttmsid: 0) { (isSuccess, resCode) in
            if (isSuccess){
                switch resCode {
                case 0:
                    self.customAlertView("잠시후 다시 시도해주세요.");
                case 1:
                    let vc = MoreSB.instantiateViewController(withIdentifier: "PersonAddMgrVC") as! PersonAddMgrVC
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

    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
