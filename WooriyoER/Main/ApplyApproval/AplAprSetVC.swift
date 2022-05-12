//
//  AplAprSetVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/10/23.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AplAprSetVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var author = 0 //직원권한(1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.팀관리자  5.직원).. 관리자 구분
    var flag: Bool = false  //권한 flag 1,2 일때 true, 3,4 일때 false
    var temflag: Bool = false //권한이 3.상위팀관리자일 때 true, 4.팀관리자일 때 false 상위팀/팀 구분 flag
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n-----------------[UIViewController : \(self) ]---------------------\n")
        
//        author = prefs.value(forKey: "author") as! Int
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
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        viewflag = "AplAprSetVC"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = AplAprSB.instantiateViewController(withIdentifier: "AplAprList") as! AplAprList
        if SE_flag{
            vc = AplAprSB.instantiateViewController(withIdentifier: "SE_AplAprList") as! AplAprList
        }else{
            vc = AplAprSB.instantiateViewController(withIdentifier: "AplAprList") as! AplAprList
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func aprLine(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        if flag {
            let vc = MoreSB.instantiateViewController(withIdentifier: "CmpAprSelVC") as! CmpAprSelVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            let vc = MoreSB.instantiateViewController(withIdentifier: "AprSelVC") as! AprSelVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }

    @IBAction func aplList(_ sender: UIButton) {
//        if let url = URL(string: "http://pinpl.biz") {
//            UIApplication.shared.open(url, options: [:])
//        }
        
        let vc = MainSB.instantiateViewController(withIdentifier: "TotalEmpLits") as! TotalEmpLits
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }

    func valueSetting() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        if !flag {
            print("\n-----------------[ temflag : \(temflag) ]---------------------\n")
            print("\n-----------------[ userInfo.ttmsid : \(userInfo.ttmsid) ]---------------------\n")
            print("\n-----------------[ userInfo.temsid : \(userInfo.temsid) ]---------------------\n")
            NetworkManager.shared().GetTemInfo(temflag: temflag, ttmsid: userInfo.ttmsid, temsid: userInfo.temsid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
//                SelTemInfo = serverData
                SelTemInfo.name = serverData.name
                SelTtmSid = userInfo.ttmsid
                SelTemSid = userInfo.temsid
                SelTemFlag = self.temflag
            }else {
                    self.toast("다시 시도해 주세요.")
                }
            }
        }
    }
}
