//
//  TemRtrPrcPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/09.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class TemRtrPrcPopUp: UIViewController {
    
    @IBOutlet weak var lblTname: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPost: UILabel!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var empsid = 0
    var name = ""
    var tname = ""
    var inputDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTname.text = tname
        lblName.text = name
        lblPost.text = name.postPositionText(type: 0, single: true)
        
    }
    @IBAction func okClick(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(직원 퇴직처리) .. 본인 퇴직처리시 퇴직일이 현재일보다 작거나 같은 경우 로그아웃 시키고 관리자앱 더이상 사용 못하게 처리 해야 됨
         Return  - 퇴직처리 결과 1.성공 0.실패
         Parameter
         EMPSID        직원번호
         LEAVEDT        퇴직일자(형식 2019-11-30)
         SK            인증코드(직원번호 SHA1 암호화 해서 넘김)
         */
        let sk = String(empsid).sha1()
//        let url = urlClass.leave_emply(empsid: empsid, leavedt: inputDate, sk: sk)
//        httpRequest.get(urlStr: url) {(success, jsonData) in
//            if success {
//                print(url)
//                print(jsonData)
//
//                let nc = self.storyboard?.instantiateViewController(withIdentifier: "MoreNC") as! UINavigationController
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TemEmpList") as! TemEmpList
//                nc.modalTransitionStyle = .crossDissolve
//                nc.modalPresentationStyle = .overCurrentContext
//                nc.pushViewController(vc, animated: true)
//                self.present(nc, animated: true, completion: nil)
//
//            }else {
//                self.customAlertView("다시 시도해 주세요.")
//            }
//        }
        
        NetworkManager.shared().LeaveEmply(empsid: empsid, leavedt: inputDate, sk: sk) { (isSuccess, resCode) in
             if(isSuccess){
                 switch resCode {
                 case 1:
                    self.toast("정상 처리 되었습니다.")
                     let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpList") as! TemEmpList
                     vc.modalTransitionStyle = .crossDissolve
                     vc.modalPresentationStyle = .overCurrentContext
                     self.present(vc, animated: true, completion: nil)
                 case 0:
                     self.customAlertView("회원탈퇴에 실패 하였습니다.")
                 case -1:
                     self.customAlertView("회원정보가 없거나 이미 탈퇴된 회원입니다.")
                 case -2:
                     self.customAlertView("회사대표의 경우 모두 퇴직처리 후 이용 가능합니다.")
                 case -3:
                     self.customAlertView("결재라인 해제 후 이용 가능합니다.")
                 default:
                     break
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
