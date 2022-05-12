//
//  EmpInfoPopUpCancel.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class EmpInfoPopUpCancel: UIViewController {
    
    @IBOutlet weak var lblTname: UILabel!
    @IBOutlet weak var lblEmpname: UILabel!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let device = DeviceInfo()
    let jsonClass = JsonClass()
    
    var temname = ""
    var ttmsid = 0
    var temsid = 0
    //2020.01.22 뷰 이동 변수 넘김 수정
    var selauthor = 0
    var selempsid = 0
    var selenddt = ""
    var selenname = ""
    var selmbrsid = 0
    var selmemo = ""
    var selname = ""
    var selphone = ""
    var selphonenum = ""
    var selprofimg = ""
    var selspot = ""
    var selstartdt = ""
    var seltype = 0
    var selworkmin = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTname.text = temname
        lblEmpname.text = selname
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
//        let ttmsid = prefs.value(forKey: "cmt_ttmsid") as! Int
//        let temsid = prefs.value(forKey: "cmt_temsid") as! Int
        let temnm = temname.urlEncoding()
        var flag = false
        var url = ""
        
        if temsid == 0 {
            flag = true
        }
        
        if flag {
            url = urlClass.ttm_exceptemply(ttmsid: ttmsid, empsid: selempsid, ttmnm: temnm)
        }else {
            url = urlClass.tem_exceptemply(temsid: temsid, empsid: selempsid, temnm: temnm)
        }
        print("\n-----------[ttmsid = \(ttmsid), empsid = \(selempsid), temnm = \(temname)]--------------\n")
        httpRequest.get(urlStr: url) {(success, jsonData) in
            if success {
                NotificationCenter.default.post(name: .reloadList, object: nil)
                self.dismiss(animated: true, completion: nil)
//                let vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpInfoVC") as! EmpInfoVC
//                vc.modalTransitionStyle = .crossDissolve
//                vc.modalPresentationStyle = .overFullScreen
//                self.present(vc, animated: false, completion: nil)
                
//
//                let nc = self.storyboard?.instantiateViewController(withIdentifier: "CmpNC") as! UINavigationController
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmpInfoVC") as! EmpInfoVC
//                vc.btnFlag = true
//                vc.selauthor = self.selauthor
//                vc.selempsid = self.selempsid
//                vc.selenddt = self.selenddt
//                vc.selenname = self.selenname
//                vc.selmbrsid = self.selmbrsid
//                vc.selmemo = self.selmemo
//                vc.selname = self.selname
//                vc.selphone = self.selphone
//                vc.selphonenum = self.selphonenum
//                vc.selprofimg = self.selprofimg
//                vc.selspot = self.selspot
//                vc.selstartdt = self.selstartdt
//                vc.seltype = self.seltype
//                vc.selworkmin = self.selworkmin
//                self.dismiss(animated: true, completion: nil)
//                nc.modalTransitionStyle = .crossDissolve
//                nc.modalPresentationStyle = .overFullScreen
//                nc.pushViewController(vc, animated: false)
//                self.present(vc, animated: false, completion: nil)
                
                
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
}
