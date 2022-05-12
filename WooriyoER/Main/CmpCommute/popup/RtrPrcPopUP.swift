//
//  RtrPrcPopUP.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class RtrPrcPopUP: UIViewController {
    
    @IBOutlet weak var lblTname: UILabel!
    @IBOutlet weak var lblEmpname: UILabel!
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    
    var temname = ""
    var inputDate = ""
    
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
    
    // FIXME: 팝업창 닫기
    @IBAction func rtrClick(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(직원 퇴직처리) .. 본인 퇴직처리시 퇴직일이 현재일보다 작거나 같은 경우 로그아웃 시키고 관리자앱 더이상 사용 못하게 처리 해야 됨
         Return  - 퇴직처리 결과 1.성공 0.실패
         Parameter
         EMPSID        직원번호
         LEAVEDT        퇴직일자(형식 2019-11-30)
         SK            인증코드(직원번호 SHA1 암호화 해서 넘김)
         */
        let sk = String(selempsid).sha1()
        NetworkManager.shared().LeaveEmply(empsid: selempsid, leavedt: inputDate, sk: sk) { (isSuccess, resCode) in
            if(isSuccess){ 
                switch resCode {
                case 1:
                    var vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
                    if SE_flag {
                        vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_CmtEmpList") as! CmtEmpList
                    }else{
                        vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
                    }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                case 0:
                    self.toast("회원탈퇴에 실패 하였습니다.")
                case -1:
                    self.toast("회원정보가 없거나 이미 탈퇴된 회원입니다.")
                case -2:
                    self.toast("회사대표의 경우 모두 퇴직처리 후 이용 가능합니다.")
                case -3:
                    self.toast("결재라인 해제 후 이용 가능합니다.")
                default:
                    break
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
}
