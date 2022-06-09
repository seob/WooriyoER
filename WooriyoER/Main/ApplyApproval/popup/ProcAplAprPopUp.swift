//
//  ProcAplAprPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class ProcAplAprPopUp: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOk.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        btnOk.backgroundColor = EnterpriseColor.btnColor
        lblName.text = name
        lblSpot.text = spot
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(근로신청 결재처리 - 보류, 승인, 반려)
         Return  - 성공:1, 실패:0, 결재권한 없는경우:-1
         Parameter
         APRSID    근로신청 번호
         EMPSID    결재자 직원번호(본인)
         STEP    결재 단계 (1.1차, 2.2차, 3.3차)
         APR        처리(1.보류, 2.승인, 3.반려)
         REASON    보류/반려사유 .. URL 인코딩
         NEXT    다음 결재자 직원번호(최종 결재자의경우 0 넘김)
         */
        
        //        let url = urlClass.proc_applyapr(aprsid: aprsid, empsid: empsid, step: step, apr: 2, reason: reason, next: nextEmpsid)
        //        let jsonTemp: Data = jsonClass.weather_request(setUrl: url)!
        //        if let jsonData: NSDictionary = jsonClass.json_parseData(jsonTemp) {
        //            print(url)
        //            print(jsonData)
        //
        //            let result = jsonData["result"] as! Int
        //
        //            switch result {
        //            case 1:
        //                let sb = UIStoryboard.init(name: "More", bundle: nil)
        //                let nc = sb.instantiateViewController(withIdentifier: "MoreNC") as! UINavigationController
        //                let vc = sb.instantiateViewController(withIdentifier: "AplAprList") as! AplAprList
        //                nc.modalTransitionStyle = .crossDissolve
        //                nc.modalPresentationStyle = .overFullScreen
        //                nc.pushViewController(vc, animated: true)
        //                self.present(nc, animated: true, completion: nil)
        //            default:
        //                break;
        //            }
        //        }
        
        NetworkManager.shared().procApplyapr(aprsid: aprsid, empsid: empsid, step: step, apr: 2, reason: reason.urlEncoding(), next: nextEmpsid) { (isSuccess, resultCode) in
            
            if(isSuccess){
                switch resultCode {
                case 1:
                    dispatchMain.async {
                        var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
                        if SE_flag {
                            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
                        }else{
                            vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
                        }
                        notitype = "22"
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    }
                case 0:
                    self.toast("다시 시도해 주세요.")
                    self.dismiss(animated: true, completion: nil)
                case -1:
                    self.toast("결제 권한이 없습니다.")
                    self.dismiss(animated: true, completion: nil)
                default:
                    break;
                }
            }else{
                self.toast("다시 시도해 주세요.")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}
 
