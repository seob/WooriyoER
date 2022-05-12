//
//  MasterMgrPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/30.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class MasterMgrPopUp: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var selname = ""
    var selempsid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = selname
    }
    
    // FIXME: 팝업창 닫기
    @IBAction func okClick(_ sender: UIButton) {
        //        let usersid = prefs.value(forKey: "empsid") as! Int
        let usersid = userInfo.empsid
        NetworkManager.shared().DelegateMaster(sndsid: usersid, rcvsid: selempsid) { (isSuccess, resCode) in
            if (isSuccess) {
                if resCode == 1 {                    
                    var vc = MoreSB.instantiateViewController(withIdentifier: "CmpMgrVC") as! CmpMgrVC
                    if SE_flag {
                        vc = MoreSB.instantiateViewController(withIdentifier: "SE_CmpMgrVC") as! CmpMgrVC
                    }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                    
                }else {
                    self.customAlertView("잠시 후, 다시 시도해 주세요.");
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
