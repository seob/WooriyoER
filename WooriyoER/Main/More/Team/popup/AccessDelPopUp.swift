//
//  AccessDelPopUp.swift
//  PinPle
//
//  Created by seob on 2021/02/18.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class AccessDelPopUp: UIViewController {
    var empInfo = HomeCmtAreaInfo()
    @IBOutlet weak var btnOk: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOk.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        btnOk.backgroundColor = EnterpriseColor.btnColor
        homeselsid = empInfo.sid
        // Do any additional setup after loading the view.
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        NetworkManager.shared().del_Homecmtarea(hcasid: empInfo.sid, empsid: empInfo.empsid) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode > 0 {
                    NotificationCenter.default.post(name: .reloadList, object: nil)
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
