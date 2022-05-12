//
//  AprSelVC.swift
//  PinPle
//
//  Created by WRY_010 on 01/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AprSelVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var btnAnl: UIButton!
    @IBOutlet weak var btnApl: UIButton!
  
    var ttmsid = 0
    var temsid = 0
    var author = 0 //직원권한(1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.팀관리자  5.직원).. 관리자 구분
    var flag: Bool = false  //권한 flag 1,2 일때 true, 3,4 일때 false
    var temflag: Bool = false //권한이 3.상위팀관리자일 때 true, 4.팀관리자일 때 false 상위팀/팀 구분 flag
    
    override func viewDidLoad() {
        super.viewDidLoad()
        author = userInfo.author
        print("author = ", author)
        switch author {
        case 1, 2:
            self.flag = true
        case 3:
            self.flag = false
            self.temflag = true
        case 4:
            self.flag = false
            self.temflag = false
        default:
            self.flag = true
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "AnlAprSetVC" {
            let vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlAprSetVC") as! AnlAprSetVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else if viewflag == "AplAprSetVC" {
            let vc = AplAprSB.instantiateViewController(withIdentifier: "AplAprSetVC") as! AplAprSetVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
//            let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
//            vc.modalTransitionStyle = .crossDissolve
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: false, completion: nil)
            NotificationCenter.default.post(name: .reloadTem, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func setAnlApr(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(연차결재라인 조회 - 회사, 상위팀, 팀 같이 이용)
         Return  - 연차결재라인 정보
         Parameter
         CMPSID        회사번호 .. 상위팀번호, 팀번호는 0 또는 안보냄
         TTMSID        상위팀번호.. 회사번호, 팀번호는 0 또는 안보냄
         TEMSID        팀번호.. 회사번호, 상위팀번호는 0 또는 안보냄
         */
        var selApr = false
        if sender == btnAnl {
            selApr = true
        }else {
            selApr = false
        }
 
        
        if SelTemFlag {
            ttmsid = SelTtmSid
        }else {
            temsid = SelTemSid
        }
        
        if temsid > 0 {
            SelTemFlag = false
        }else{
            SelTemFlag = true
        }
        
       print("\n---------- [ 111 1 SelTtmSid : \(SelTtmSid) , SelTemSid : \(SelTemSid)] ----------\n")
       NetworkManager.shared().GetTemInfo(temflag: SelTemFlag, ttmsid: SelTtmSid, temsid: SelTemSid) { (isSuccess, resData) in
           if (isSuccess) {
               guard let serverData = resData else { return }
               SelTemInfo = serverData
               SelTemInfo.name = serverData.name
           }else {
               self.toast("다시 시도해 주세요.")
           }
       }
        
        
        print("\n---------- [ 111 1 ttmsid : \(ttmsid) , temsid : \(temsid)] ----------\n")
        
        NetworkManager.shared().GetAprline(aprflag: selApr, cmpsid: 0, ttmsid: ttmsid, temsid: temsid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                SelAprInfo = serverData
                let vc = MoreSB.instantiateViewController(withIdentifier: "AnlAprVC") as! AnlAprVC
                vc.selApr = selApr
//                vc.applyapr = SelTemInfo.applyapr
//                vc.anualapr = SelTemInfo.anualapr
                
                
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)
            }else {
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
        }
    }
}
