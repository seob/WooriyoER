//
//  CmpAnlAprVC.swift
//  PinPle
//
//  Created by WRY_010 on 01/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmpAnlAprVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var btnApr1: UIButton!
    @IBOutlet weak var btnApr2: UIButton!
    @IBOutlet weak var btnApr3: UIButton!
    @IBOutlet weak var btnRef1: UIButton!
    @IBOutlet weak var btnRef2: UIButton!
    @IBOutlet weak var vwAuthor: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    var selApr: Bool = false  // true. 연차 false. 근로
        
    let imgBg = UIImage.init(named: "man_bg")
    let imgPlus = UIImage.init(named: "plus_man")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.layer.cornerRadius = 6
        if !authorCk(msg: "권한이 없습니다.\n마스터관리자와 최고관리자만 \n변경이 가능합니다.") {
            vwAuthor.isHidden = false
        }
        
        if selApr {
            lblNavigationTitle.text = "연차"
        }else {
            lblNavigationTitle.text = "출장/연장/특근"
        }
        
        valueSetting()
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }

    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "CmpAprSelVC") as! CmpAprSelVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    // 퇴직처리한 경우 api에서 empsid만 내려주고 있어서 이름하고 empsid로 조건 변경 - 2020.03.13
    func valueSetting() {
        if (SelAprInfo.apr1name != "" && SelAprInfo.apr1empsid > 0) {
            btnApr1.setTitle(SelAprInfo.apr1name + " " + SelAprInfo.apr1spot, for: .normal)
            btnApr1.setBackgroundImage(imgBg, for: .normal)
        }else {
            btnApr1.setTitle("", for: .normal)
            btnApr1.setBackgroundImage(imgPlus, for: .normal)
        }
        if (SelAprInfo.apr2name != "" && SelAprInfo.apr2empsid > 0){
            btnApr2.setTitle(SelAprInfo.apr2name + " " + SelAprInfo.apr2spot, for: .normal)
            btnApr2.setBackgroundImage(imgBg, for: .normal)
        }else {
            btnApr2.setTitle("", for: .normal)
            btnApr2.setBackgroundImage(imgPlus, for: .normal)
        }
        if (SelAprInfo.apr3name != "" && SelAprInfo.apr3empsid > 0) {
            btnApr3.setTitle(SelAprInfo.apr3name + " " + SelAprInfo.apr3spot, for: .normal)
            btnApr3.setBackgroundImage(imgBg, for: .normal)
        }else {
            btnApr3.setTitle("", for: .normal)
            btnApr3.setBackgroundImage(imgPlus, for: .normal)
        }
        if (SelAprInfo.ref1name != "" && SelAprInfo.ref1empsid > 0){
            btnRef1.setTitle(SelAprInfo.ref1name + " " + SelAprInfo.ref1spot, for: .normal)
            btnRef1.setBackgroundImage(imgBg, for: .normal)
        }else {
            btnRef1.setTitle("", for: .normal)
            btnRef1.setBackgroundImage(imgPlus, for: .normal)
        }
        if (SelAprInfo.ref2name != "" && SelAprInfo.ref2empsid > 0) {
            btnRef2.setTitle(SelAprInfo.ref2name + " " + SelAprInfo.ref2spot, for: .normal)
            btnRef2.setBackgroundImage(imgBg, for: .normal)
        }else {
            btnRef2.setTitle("", for: .normal)
            btnRef2.setBackgroundImage(imgPlus, for: .normal)
        }
        
    }
    
    @IBAction func save(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(연차결재라인 설정 - 회사, 상위팀, 팀 모두 같이 이용)
         Return  - 성공:1, 실패:0, 중복(직원번호 중복된 경우):-1
         Parameter
         CMPSID        회사번호 .. 상위팀번호, 팀번호는 0 또는 안보냄
         TTMSID        상위팀번호.. 회사번호, 팀번호는 0 또는 안보냄
         TEMSID        팀번호.. 회사번호, 상위팀번호는 0 또는 안보냄
         APR1        1차 결재자 직원번호(무조건 있어야됨)
         APR2        2차 결재자 직원번호(없는경우 0 또는 안보냄)
         APR3        3차 결재자 직원번호(없는경우 0 또는 안보냄.. 2차 없는데 3차 있을 수 없음)
         REF1        1차 참조자 직원번호(없는경우 0 또는 안보냄)
         REF2        2차 참조자 직원번호(없는경우 0 또는 안보냄.. 1차 없는데 2차 있을 수 없음)
         */
        print("\n---------- [ 1111 SelAprInfo : \(SelAprInfo.toJSON()) ] ----------\n")
        if valueChc() {
             NetworkManager.shared().SetAprline(aprflag: selApr, cmpsid: userInfo.cmpsid, ttmsid: 0, temsid: 0, apr1: SelAprInfo.apr1empsid, apr2: SelAprInfo.apr2empsid, apr3: SelAprInfo.apr3empsid, ref1: SelAprInfo.ref1empsid, ref2: SelAprInfo.ref2empsid) { (isSuccess, resultCode) in
                if (isSuccess) {
                    switch resultCode {
                    case -1:
                        self.toast("결재자/참조자는 중복되면 안됩니다.");
                    case 0:
                        self.toast("다시 시도해 주세요.")
                    default:
                        self.toast("정상 처리 되었습니다.")
                        let vc = MoreSB.instantiateViewController(withIdentifier: "CmpAprSelVC") as! CmpAprSelVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    }
                }else {
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
        }
//        else {
//            self.customAlertView("중간에 빈곳이 있으면 안됩니다.\n결재자가 존재하지 않으면 참조자를 추가할 수 없습니다.")
//        }
    }
    
    @IBAction func selAprClick(_ sender: UIButton) {
        var selflag = 0
        switch sender {
        case btnApr1:
            selflag = 1
        case btnApr2:
            selflag = 2
        case btnApr3:
            selflag = 3
        case btnRef1:
            selflag = 4
        case btnRef2:
            selflag = 5
        default:
            break
        }
        
        let vc = MoreSB.instantiateViewController(withIdentifier: "CmpAprMgrListVC") as! CmpAprMgrListVC
        vc.selflag = selflag
        vc.selApr = self.selApr
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func valueChc() -> Bool {
        let apr1Flag = SelAprInfo.apr1empsid > 0
        let apr2Flag = SelAprInfo.apr2empsid > 0
        let apr3Flag = SelAprInfo.apr3empsid > 0
        let ref1Flag = SelAprInfo.ref1empsid > 0
        let ref2Flag = SelAprInfo.ref2empsid > 0
        
        // 참조자1,2번이 있는상태에서 참조자1번이 퇴직한경우 2번이 1번으로 교체 2020.06.02
        if (SelAprInfo.ref1empsid == 0 && SelAprInfo.ref2empsid > 0) {
            SelAprInfo.ref1empsid = SelAprInfo.ref2empsid
            SelAprInfo.ref1name = SelAprInfo.ref2name
            SelAprInfo.ref1spot = SelAprInfo.ref2spot
            
            
            SelAprInfo.ref2empsid = 0
            SelAprInfo.ref2name = ""
            SelAprInfo.ref2spot = ""
        }
        
        // 결재라인이 없어도 저장되도록 수정 / 결재자가 없고 참조자만 있을경우 경고 2020.06.02
        if apr1Flag == false && ref1Flag == true{
            self.toast("결재라인 해지 시 참조자를 먼저 해지해주세요.")
            return false
        }else if apr1Flag == false && ref2Flag == true{
            self.toast("결재라인 해지 시 참조자를 먼저 해지해주세요.")
            return false
        }else if apr1Flag == false && apr2Flag == true {
            self.toast("1차 결재자를 선택해 주세요.")
            return false
        }else if apr1Flag == false && apr3Flag == true {
            self.toast("1차 결재자를 선택해 주세요.")
            return false
        }else if apr1Flag == false && ref1Flag == true {
            self.toast("1차 결재자를 선택해 주세요.")
            return false
        }else if apr1Flag == false && ref2Flag == true {
            self.toast("1차 결재자를 선택해 주세요.")
            return false
        }else if apr2Flag == false && apr3Flag == true {
            self.toast("2차 결재자를 선택해 주세요.")
            return false
        }
//        else if ref1Flag == false && ref2Flag == true {
//            self.toast("1차 참조자를 선택해 주세요.")
//            return false
//        }
        return true
    }
    
}
