//
//  ProcAnlAprPopupOk.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class ProcAnlAprPopupOk: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpot: UILabel!
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    
    var name = ""
    var spot = ""
    var aprsid = 0
    var empsid = 0
    var step = 0
    var ddctn = 0
    var reason = ""
    var nextEmpsid = 0
    var aprflag = 0 
    var anlAprArr = AnualListArr()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = name
        lblSpot.text = spot
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(연차결재처리 - 보류, 승인, 반려)
         Return  - 성공:1, 실패:0, 결재권한 없는경우:-1
         Parameter
         APRSID    연차신청 번호
         EMPSID    결재자 직원번호(본인)
         STEP    결재 단계 (1.1차, 2.2차, 3.3차)
         DDCTN    연차차감 여부(0.미차감 1.차감)
         APR        처리(1.보류, 2.승인, 3.반려)
         REASON    보류/반려사유 .. URL 인코딩
         NEXT    다음 결재자 직원번호(최종 결재자의경우 0 넘김)
         */
        print("ProcAnlAprPopupOk : 49 empsid = ", empsid)
         
        
        NetworkManager.shared().procAnualapr(aprsid: aprsid, empsid: empsid, step: step, ddctn: ddctn, apr: 2, reason: reason, next: nextEmpsid) { (isSuccess, resCode) in
            if(isSuccess){
                dispatchMain.async {
                    switch resCode {
                    case 1:
                       var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
                        if SE_flag {
                            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
                        }else{
                            vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    case -1 :
                        self.toast("결재 권한이 없습니다.")
                        self.dismiss(animated: true, completion: nil)
                    default:
                        self.toast("다시 시도해 주세요.")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
 
            }else{
                self.toast("다시 시도해 주세요.")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
