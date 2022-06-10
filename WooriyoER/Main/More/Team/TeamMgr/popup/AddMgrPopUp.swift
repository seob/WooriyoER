//
//  AddMgrPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class AddMgrPopUp: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
   
    var auth = 0
    var temsid = 0
    var ttmsid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = SelEmpInfo.name
        btnSave.backgroundColor = EnterpriseColor.btnColor
        btnSave.setTitleColor(EnterpriseColor.lblColor, for: .normal)
    }
    @IBAction func okClick(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(직원 권한설정)
         Return  - 성공:설정완료 카운트, 실패:0
         Parameter
         EMPSIDS        직원번호들(구분자',')
         AUTH        권한(0.혼자쓰기 1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.팀관리자  5.직원) .. 해지시 5 넘김
         TEMSID        팀번호(팀관리자의 경우에만 필요.. 그외 0)
         TTMSID        상위팀번호(상위팀관리자의 경우에만 필요.. 그외 0)
         */
        if SelTemFlag {
            ttmsid = SelTtmSid
            auth = 3
        }else {
            temsid = SelTemSid
            auth = 4
        }
        NetworkManager.shared().SetEmpAuthor(empsids: "\(SelEmpInfo.sid)", auth: auth, temsid: temsid, ttmsid: ttmsid) { (isSuccess, resultCode) in
            if (isSuccess) {
                if resultCode > 0 {
//                    self.toast("정상 처리 되었습니다.")
//                    let vc = MoreSB.instantiateViewController(withIdentifier: "AddMgrVC") as! AddMgrVC
//                    vc.modalTransitionStyle = .crossDissolve
//                    vc.modalPresentationStyle = .overCurrentContext
//                    self.present(vc, animated: true, completion: nil)
                    NotificationCenter.default.post(name: .reloadList, object: nil)
                    self.dismiss(animated: true, completion: nil)
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
