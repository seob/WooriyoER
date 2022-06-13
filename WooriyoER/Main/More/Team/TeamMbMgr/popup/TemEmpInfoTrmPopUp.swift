//
//  TemEmpInfoTrmPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/09.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class TemEmpInfoTrmPopUp: UIViewController {
    
    @IBOutlet weak var lblTname: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let device = DeviceInfo()
    let jsonClass = JsonClass()
    
    var EmpInfoList: EmpInfoList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCancel.backgroundColor = EnterpriseColor.btnColor
        btnCancel.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        lblTname.text = EmpInfoList.tname
        lblName.text = EmpInfoList.name
        lblPost.text = EmpInfoList.name.postPositionText(type: 0, single: true)
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(팀 팀원해지-제외)
         Return  - 성공:1, 실패:0
         Parameter
         TTMSID(TEMSID)        상위팀번호(팀번호)
         EMPSID        직원번호
         TTMNM(TEMNM)        팀이름 - URL 인코딩(푸시알림을위해 추가..2019-11-20)
         */
        NetworkManager.shared().TemExceptemply(temflag: SelTemFlag, ttmsid: SelTtmSid, temsid: SelTemSid, empsid: EmpInfoList.empsid, temnm: EmpInfoList.tname.urlEncoding()) { (isSuccess, resultCode) in
            if (isSuccess) {
                if resultCode == 1 {
                    self.toast("정상 처리 되었습니다.")
                    let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpInfoVC") as! TemEmpInfoVC
                    vc.btnflag = true
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
