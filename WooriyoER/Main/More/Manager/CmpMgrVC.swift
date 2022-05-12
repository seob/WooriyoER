//
//  CmpMgrVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/11/08.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmpMgrVC: UIViewController {
       
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    var author = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        author = prefs.value(forKey: "author") as! Int
        author = userInfo.author
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "MainVC" {
            var vc = UIViewController()
            if SE_flag {
                vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC") as! MainVC
            }else {
                vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else{
            let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
         
    }
    // MARK: 최고관리자 관리
    @IBAction func mgmtMgr(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MgmtCmpMgrVC") as! MgmtCmpMgrVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    // MARK: 최고관리자 추가
    @IBAction func addMgr(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "AddCmpMgrVC") as! AddCmpMgrVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    // MARK: 최고관리자 출퇴근 설정
    @IBAction func mgrCmt(_ sender: UIButton) {
//        if author == 1 || author == 2 {
        if author <= 2 {
            let vc = MoreSB.instantiateViewController(withIdentifier: "MgrCmtSetting") as! MgrCmtSetting
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
//            Toast(text: "마스터관리자와 최고관리자만 사용 가능합니다.",  duration: Delay.short).show()
            self.toast("마스터관리자와 최고관리자만 사용 가능합니다.")
//            self.configureAppearance()
        }
    }
    // MARK: 마스터관리자 위임
    @IBAction func masterMgr(_ sender: UIButton) {
        if author == 1 {
            let vc = MoreSB.instantiateViewController(withIdentifier: "MasterMgrChange") as! MasterMgrChange
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
//            Toast(text: "마스터관리자만 사용 가능합니다.",  duration: Delay.short).show()
            self.toast("마스터관리자만 사용 가능합니다.")
//            self.configureAppearance()
        }
        
    }
    
    // MARK: 인사관리자 관리
    @IBAction func hrrMgr(_ sender: UIButton) {
         if author == 0 || author == 1 {
            let vc = MoreSB.instantiateViewController(withIdentifier: "PersonMgrListVC") as! PersonMgrListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
         }else{
//           Toast(text: "마스터관리자와 인사담당자만 사용 가능합니다.",  duration: Delay.short).show()
            self.toast("마스터관리자와 인사담당자만 사용 가능합니다.")
//            self.configureAppearance()
        }

    }
    
    // MARK: 인사관리자 관리
    @IBAction func hrrMgradd(_ sender: UIButton) {
        if author == 0 || author == 1 {
            let vc = MoreSB.instantiateViewController(withIdentifier: "PersonAddMgrVC") as! PersonAddMgrVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else{
//            Toast(text: "마스터관리자와 인사담당자만 사용 가능합니다.",  duration: Delay.short).show()
            self.toast("마스터관리자와 인사담당자만 사용 가능합니다.")
//             self.configureAppearance()
        }

    }
}
