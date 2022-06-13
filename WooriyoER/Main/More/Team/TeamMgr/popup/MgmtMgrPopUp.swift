//
//  SetMgrPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/09.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class MgmtMgrPopUp: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = SelEmpInfo.name.postPositionText(type: 0)
        btnCancel.backgroundColor = EnterpriseColor.btnColor
        btnCancel.setTitleColor(EnterpriseColor.lblColor, for: .normal)
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
        var temsid: Int = 0
        var ttmsid: Int = 0
        
        if SelTemFlag {
            ttmsid = SelTtmSid
        }else {
            temsid = SelTemSid
        }
//        NetworkManager.shared().SetEmpAuthor(empsids: "\(SelEmpInfo.sid)", auth: 5, temsid: temsid, ttmsid: ttmsid) { (isSuccess, resultCode) in
//            if (isSuccess) {
//                if resultCode > 0 {
//                    self.toast("정상 처리 되었습니다.")
//                    let vc = MoreSB.instantiateViewController(withIdentifier: "MgmtMgrVC") as! MgmtMgrVC
//                    vc.modalTransitionStyle = .crossDissolve
//                    vc.modalPresentationStyle = .overCurrentContext
//                    self.present(vc, animated: true, completion: nil)
//                }else {
//                    self.customAlertView("잠시 후, 다시 시도해 주세요.")
//                }
//            }else {
//                self.customAlertView("다시 시도해 주세요.")
//            }
//        }
        NetworkManager.shared().CancelAuthor(empsids: "\(SelEmpInfo.sid)", temsid: temsid, ttmsid: ttmsid) { (isSuccess, resCode) in
            if(isSuccess){
                switch resCode {
                case 0:
                    self.toast("잠시후 다시 시도해주세요.");
                case 1:
//                    let vc = MoreSB.instantiateViewController(withIdentifier: "MgmtCmpMgrVC") as! MgmtCmpMgrVC
//                    vc.modalTransitionStyle = .crossDissolve
//                    vc.modalPresentationStyle = .overFullScreen
//                    self.present(vc, animated: false, completion: nil)
                    NotificationCenter.default.post(name: .reloadList, object: nil)
                    self.dismiss(animated: true, completion: nil)
                case -1:
                    self.toast("결재라인 해제 후 이용 가능합니다.")
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
