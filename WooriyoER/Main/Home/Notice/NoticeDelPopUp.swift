//
//  NoticeDelPopUp.swift
//  PinPle
//
//  Created by seob on 2022/02/11.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit

class NoticeDelPopUp: UIViewController {
    @IBOutlet weak var btnDelete: UIButton!
    var sid = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDelete.backgroundColor = EnterpriseColor.btnColor
        btnDelete.setTitleColor(EnterpriseColor.lblColor, for: .normal)
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        NetworkManager.shared().DelNotice(nsid: sid) { isSuccess, resCode in
            if isSuccess {
                let vc = MainSB.instantiateViewController(withIdentifier: "PinPlNoticeVC") as! PinPlNoticeVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
            }else{
                self.toast("다시 시도해 주세요")
            }
        }
    }
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
