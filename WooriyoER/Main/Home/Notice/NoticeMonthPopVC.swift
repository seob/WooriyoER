//
//  NoticeMonthPopVC.swift
//  PinPle
//
//  Created by seob on 2022/02/12.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit

class NoticeMonthPopVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblsubContent: UILabel!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var btnText: UIButton!
    
    var checkEextension = 0 //연장하기 시 checkEextension : 1
    var payType = 0 // 1:관리자배너 2:근로자배너 3:출퇴근영역
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPoint.text = "\(CompanyInfo.point)"
        btnText.backgroundColor = EnterpriseColor.btnColor
        btnText.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        if CompanyInfo.datalimits >= muticmttodayDate() {
            checkEextension = 1
        }else{
            checkEextension = 0
        }
 
        
        if CompanyInfo.point > 10 {
            if checkEextension > 0 {
                btnText.setTitle("연장하기", for: .normal)
                lblContent.text = "사내공지 사용 시\n1개월에 10핀이 차감됩니다."
                btnText.tag = 1
            }else{
                btnText.setTitle("활성화", for: .normal)
                lblContent.text = "사내공지 사용 시\n1개월에 10핀이 차감됩니다"
                btnText.tag = 1
            }
        }else{
            lblContent.text = "사내공지 사용 시\n1개월에 10핀이 차감됩니다."
            lblsubContent.text = "보유 핀포인트가 충분하지 않아\n핀포인트 충전 후 사용이 가능합니다."
            btnText.tag = 2
        }
 
    }
     
    @IBAction func moveToChange(_ sender: UIButton){
        if sender.tag == 1 {
            //활성화하기
            changeDataLimits()

        }else{
            //핀포인트 충전으로 이동
            let vc = ContractSB.instantiateViewController(withIdentifier: "InAppVC") as! InAppVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
//            self.toast("핀포인트 충전은 웹에서만 가능합니다.")
             
        }
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
     
    // 데이터보관
    fileprivate func changeDataLimits(){
        NetworkManager.shared().setNoticeMonth(cmpsid: userInfo.cmpsid, mbrsid: userInfo.mbrsid) { (isSuccess, resCode, resData) in
            if(isSuccess){
                switch resCode {
                case 1:
                    moreCmpInfo.notice = resData
                    CompanyInfo.notice = resData
                    NotificationCenter.default.post(name: .reloadNotice, object: nil)
                    self.dismiss(animated: true, completion: nil)
                case 0:
                    self.toast("다시 시도해 주세요")
                case -1:
                    self.toast("핀 포인트가 부족합니다")
                default:
                    print("\n---------- [ 1 ] ----------\n")
                }
            }else{
                self.toast("다시 시도해 주세요")
            }
        }
    }
}

