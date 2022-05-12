//
//  TemDelPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class TemDelPopUp: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = SelTemInfo.name
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(팀 삭제)
         Return  - 성공:1, 실패:0, 팀정보 존재하지않음 : -1
         Parameter
         TTMSID        상위팀번호(TEMSID        팀번호)
         */
        NetworkManager.shared().DelTeam(temflag: SelTemFlag, ttmsid: SelTtmSid, temsid: SelTemSid) { (isSuccess, resultCode) in
            if (isSuccess) {
                if resultCode == 1 {
                    self.toast("정상 처리 되었습니다.")
                    let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true, completion: nil)
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
