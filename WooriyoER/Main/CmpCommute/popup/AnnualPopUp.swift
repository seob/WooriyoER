//
//  AnnualPopUp.swift
//  PinPle
//
//  Created by seob on 2020/07/23.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class AnnualPopUp: UIViewController {
    var tempMbrInfo = getMbrInfo()
    var EmpInfo = EmplyInfo()
    var anmsid = 0
    var usemin = 0
    var type = 0
    var AnualInfo: anualmgrInfo = anualmgrInfo()
    @IBOutlet weak var btnDelete: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDelete.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        btnDelete.backgroundColor = EnterpriseColor.btnColor
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        NetworkManager.shared().del_Anual(empsid: tempMbrInfo.empsid, anmsid: AnualInfo.sid, type: AnualInfo.type, setmin: AnualInfo.setmin) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode == 1 {
                    self.toast("삭제 되었습니다.")
                    let vc = CmpCmtSB.instantiateViewController(withIdentifier: "AnnualListVC") as! AnnualListVC
                    vc.EmpInfo = self.EmpInfo
                    vc.tempMbrInfo = self.tempMbrInfo
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }

}
