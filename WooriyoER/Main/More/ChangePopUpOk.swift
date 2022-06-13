//
//  ChangePopUpOk.swift
//  PinPle
//
//  Created by seob on 2020/03/24.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class ChangePopUpOk: UIViewController {
  
    @IBOutlet weak var btnSave: UIButton!
    var selname = ""
    var selenname = ""
    var selphone = ""
    var seladdr = ""
    var selsite = ""
    var logoimage = ""
    var selceo = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        btnSave.backgroundColor = EnterpriseColor.btnColor
    }
    
    // FIXME: 팝업창 닫기
    @IBAction func okClick(_ sender: UIButton) {
        //        let usersid = prefs.value(forKey: "empsid") as! Int
        let cmpsid = userInfo.cmpsid
        NetworkManager.shared().UdtCmpinfo(cmpsid: cmpsid, name: selname.urlEncoding(), enname: selenname.urlEncoding(), phone: selphone.urlEncoding(), addr: seladdr.urlEncoding(), site: selsite.urlEncoding() , ceo: selceo.urlEncoding()) { (isSuccess, resultCode) in
            if (isSuccess) {
                if resultCode == 1 {
                    let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                }else {
                   self.customAlertView("잠시 후, 다시 시도해 주세요.")
                }
            }else {
               self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
