//
//  AddCmpMgrPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class AddCmpMgrPopUp: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var name = ""
    var empsids = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = name
    }
    // FIXME: 팝업창 닫기
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

        NetworkManager.shared().SetEmpAuthor(empsids: empsids, auth: 2, temsid: 0, ttmsid: 0) { (isSuccess, resCode) in
            if (isSuccess){
                switch resCode {
                case 0:
                    self.customAlertView("잠시후 다시 시도해주세요.");
                case 1: 
                    let vc = MoreSB.instantiateViewController(withIdentifier: "AddCmpMgrVC") as! AddCmpMgrVC
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
