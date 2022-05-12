//
//  MulticmtPopVC.swift
//  PinPle
//
//  Created by seob on 2021/02/16.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class MulticmtPopVC: UIViewController {
    
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
        print("\n---------- [ viewflag : \(viewflag) , payType :\(payType)] ----------\n")
        if viewflag == "moreEextension" {
            
            if payType == 1 {
                if CompanyInfo.point > 100 {
                    if checkEextension > 0 {
                        btnText.setTitle("연장하기", for: .normal)
                        lblTitle.text = "관리자앱 배너광고 제거"
                        lblContent.text = "관리자앱 배너광고 제거할 경우\n1개월에 100핀이 차감됩니다."
//                        lblsubContent.text = "기간 종료 이후에는 자동으로 비활성화 됩니다."
                        btnText.tag = 1
                    }else{
                        btnText.setTitle("활성화", for: .normal)
                        lblTitle.text = "관리자앱 배너광고 제거"
                        lblContent.text = "관리자앱 배너광고 제거할 경우\n1개월에 100핀이 차감됩니다."
//                        lblsubContent.text = "기간 종료 이후에는 자동으로 비활성화 됩니다."
                        btnText.tag = 1
                    }
                }else{
                    btnText.setTitle("핀 충전하기", for: .normal)
                    if checkEextension > 0 {
                        lblTitle.text = "관리자앱 배너광고 제거"
                    }else{
                        lblTitle.text = "관리자앱 배너광고 제거"
                    }
                    
                    lblContent.text = "관리자앱 배너광고 제거할 경우\n1개월에 100핀이 차감됩니다."
                    lblsubContent.text = "보유 핀포인트가 충분하지 않아\n핀포인트 충전 후 사용이 가능합니다."
                    btnText.tag = 2
                }
            }else if payType == 2 {
                if CompanyInfo.point > 100 {
                    if checkEextension > 0 {
                        btnText.setTitle("연장하기", for: .normal)
                        lblTitle.text = "근로자앱 배너광고 제거"
                        lblContent.text = "근로자앱 배너광고 제거할 경우\n1개월에 100핀이 차감됩니다."
//                        lblsubContent.text = "기간 종료 이후에는 자동으로 비활성화 됩니다."
                        btnText.tag = 1
                    }else{
                        btnText.setTitle("활성화", for: .normal)
                        lblTitle.text = "근로자앱 배너광고 제거"
                        lblContent.text = "근로자앱 배너광고 제거할 경우\n1개월에 100핀이 차감됩니다."
//                        lblsubContent.text = "기간 종료 이후에는 자동으로 비활성화 됩니다."
                        btnText.tag = 1
                    }
                }else{
                    btnText.setTitle("핀 충전하기", for: .normal)
                    if checkEextension > 0 {
                        lblTitle.text = "근로자앱 배너광고 제거"
                    }else{
                        lblTitle.text = "근로자앱 배너광고 제거"
                    }
                    
                    lblContent.text = "근로자앱 배너광고 제거할 경우\n1개월에 100핀이 차감됩니다."
                    lblsubContent.text = "보유 핀포인트가 충분하지 않아\n핀포인트 충전 후 사용이 가능합니다."
                    btnText.tag = 2
                }
            }else if payType == 3 {
                if CompanyInfo.point > 50 {
                    if checkEextension > 0 {
                        btnText.setTitle("연장하기", for: .normal)
                        lblTitle.text = "출퇴근 영역 복수 설정"
                        lblContent.text = "출퇴근 영역 복수 설정 사용 시\n1개월에 50핀이 차감됩니다."
//                        lblsubContent.text = "기간 종료 이후에는 자동으로 비활성화 됩니다."
                        btnText.tag = 1
                    }else{
                        btnText.setTitle("활성화", for: .normal)
                        lblTitle.text = "출퇴근 영역 복수 설정"
                        lblContent.text = "출퇴근 영역 복수 설정 사용 시\n1개월에 50핀이 차감됩니다."
//                        lblsubContent.text = "기간 종료 이후에는 자동으로 비활성화 됩니다."
                        btnText.tag = 1
                    }
                }else{
                    btnText.setTitle("핀 충전하기", for: .normal)
                    if checkEextension > 0 {
                        lblTitle.text = "출퇴근 영역 복수 설정"
                    }else{
                        lblTitle.text = "출퇴근 영역 복수 설정"
                    }
                     
                    lblContent.text = "출퇴근 영역 복수 설정 사용 시\n1개월에 50핀이 차감됩니다."
                    lblsubContent.text = "보유 핀포인트가 충분하지 않아\n핀포인트 충전 후 사용이 가능합니다."
                    btnText.tag = 2
                }
            }else if payType == 4 {
                if CompanyInfo.point > 5 {
                    if checkEextension > 0 {
                        btnText.setTitle("연장하기", for: .normal)
                        lblTitle.text = "출퇴근기록증빙서류 발급"
                        lblContent.text = "출퇴근기록증빙서류 발급 사용 시\n1개월에 5핀이 차감됩니다."
//                        lblsubContent.text = "기간 종료 이후에는 자동으로 비활성화 됩니다."
                        btnText.tag = 1
                    }else{
                        btnText.setTitle("활성화", for: .normal)
                        lblTitle.text = "출퇴근기록증빙서류 발급"
                        lblContent.text = "출퇴근기록증빙서류 발급 사용 시\n1개월에 5핀이 차감됩니다."
//                        lblsubContent.text = "기간 종료 이후에는 자동으로 비활성화 됩니다."
                        btnText.tag = 1
                    }
                }else{
                    btnText.setTitle("핀 충전하기", for: .normal)
                    if checkEextension > 0 {
                        lblTitle.text = "출퇴근기록증빙서류 발급"
                    }else{
                        lblTitle.text = "출퇴근기록증빙서류 발급"
                    }
                    
                    lblContent.text = "출퇴근기록증빙서류 발급 사용 시\n1개월에 5핀이 차감됩니다."
                    lblsubContent.text = "보유 핀포인트가 충분하지 않아\n핀포인트 충전 후 사용이 가능합니다."
                    btnText.tag = 2
                }
            }
            else {
                if CompanyInfo.point > 30 {
                    if checkEextension > 0 {
                        btnText.setTitle("연장하기", for: .normal)
                        lblTitle.text = "회계연도 기준 연차계산"
                        lblContent.text = "회계연도 기준 연차계산 사용 시\n1개월에 30핀이 차감됩니다."
//                        lblsubContent.text = "기간 종료 이후에는 자동으로 비활성화 됩니다."
                        btnText.tag = 1
                    }else{
                        btnText.setTitle("활성화", for: .normal)
                        lblTitle.text = "회계연도 기준 연차계산"
                        lblContent.text = "회계연도 기준 연차계산 사용 시\n1개월에 30핀이 차감됩니다."
//                        lblsubContent.text = "기간 종료 이후에는 자동으로 비활성화 됩니다."
                        btnText.tag = 1
                    }
                }else{
                    btnText.setTitle("핀 충전하기", for: .normal)
                    if checkEextension > 0 {
                        lblTitle.text = "회계연도 기준 연차계산"
                    }else{
                        lblTitle.text = "회계연도 기준 연차계산"
                    }
                    
                    lblContent.text = "회계연도 기준 연차계산 사용 시\n1개월에 30핀이 차감됩니다."
                    lblsubContent.text = "보유 핀포인트가 충분하지 않아\n핀포인트 충전 후 사용이 가능합니다."
                    btnText.tag = 2
                }
            }
 
        }else if viewflag == "setanualvc" {
//            if CompanyInfo.point > 30 {
//                if checkEextension > 0 {
//                    btnText.setTitle("연장하기", for: .normal)
//                    lblTitle.text = "회계연도 기준 연차계산"
//                    lblContent.text = "회계연도 기준 연차계산 사용 시\n1개월에 30핀이 차감됩니다."
//                    btnText.tag = 1
//                }else{
//                    btnText.setTitle("활성화", for: .normal)
//                    lblTitle.text = "회계연도 기준 연차계산"
//                    lblContent.text = "회계연도 기준 연차계산 사용 시\n1개월에 30핀이 차감됩니다." 
//                    btnText.tag = 1
//                }
//            }else{
//                btnText.setTitle("핀 충전하기", for: .normal)
//                lblTitle.text = "회계연도 기준 연차계산"
//                
//                lblContent.text = "회계연도 기준 연차계산 사용 시\n1개월에 30핀이 차감됩니다."
//                lblsubContent.text = "보유 핀포인트가 충분하지 않아\n핀포인트 충전 후 사용이 가능합니다."
//                btnText.tag = 2
//            }
        }else{
            if CompanyInfo.point > 50 {
                if checkEextension > 0 {
                    btnText.setTitle("연장하기", for: .normal)
                    lblTitle.text = "출퇴근 영역 복수 설정"
                    lblContent.text = "출퇴근 영역 복수 설정 사용 시\n1개월에 50핀이 차감됩니다."
//                    lblsubContent.text = "기간 종료 이후에는 출퇴근 영역 복수 설정이 자동으로 비활성화 됩니다."
                    btnText.tag = 1
                }else{
                    btnText.setTitle("활성화", for: .normal)
                    lblTitle.text = "출퇴근 영역 복수 설정"
                    lblContent.text = "출퇴근 영역 복수 설정 사용 시\n1개월에 50핀이 차감됩니다"
//                    lblsubContent.text = "기간 종료 이후에는 출퇴근 영역 복수 설정이 자동으로 비활성화 됩니다."
                    btnText.tag = 1
                }

            }else{
                btnText.setTitle("핀 충전하기", for: .normal)
                if checkEextension > 0 {
                    lblTitle.text = "출퇴근 영역 복수 설정"
                }else{
                    lblTitle.text = "출퇴근 영역 복수 설정"
                }
                lblContent.text = "출퇴근 영역 복수 설정 사용 시\n1개월에 50핀이 차감됩니다."
                lblsubContent.text = "보유 핀포인트가 충분하지 않아\n핀포인트 충전 후 사용이 가능합니다."
                btnText.tag = 2
            }
        }
 
    }
     
    @IBAction func moveToChange(_ sender: UIButton){
        if sender.tag == 1 {
            //활성화하기 
            if payType == 1 {
                self.changeHideenM()
                dismiss(animated: true, completion: nil)
            }else if payType == 2 {
                self.changeHideen()
                dismiss(animated: true, completion: nil)
            }else if payType == 4 {
                self.changeCmtList()
                dismiss(animated: true, completion: nil)
            }else if payType == 5 {
                self.changeFical()
                dismiss(animated: true, completion: nil)
            }else{
                NetworkManager.shared().set_multicmtarea(cmpsid: CompanyInfo.sid, mbrsid: userInfo.mbrsid) { (isSuccess, resCode) in
                    if(isSuccess){
                        switch resCode {
                            case 0:
                                self.toast("다시 시도해 주세요")
                                ismulticmtarea = false
                                self.dismiss(animated: true, completion: nil)
                            case 1:
                                ismulticmtarea = true
                                if viewflag == "homecmt" {
                                    let vc = MoreSB.instantiateViewController(withIdentifier: "HomecmtareaEmpListVC") as! HomecmtareaEmpListVC
                                    vc.modalTransitionStyle = .crossDissolve
                                    vc.modalPresentationStyle = .overFullScreen
                                    self.present(vc, animated: false, completion: nil)
                                }else if viewflag == "temmulticmtarea" {
                                    let vc = MoreSB.instantiateViewController(withIdentifier: "SetAddTemCmtVC") as! SetAddTemCmtVC
                                    vc.modalTransitionStyle = .crossDissolve
                                    vc.modalPresentationStyle = .overFullScreen
                                    self.present(vc, animated: false, completion: nil)
                                }else if viewflag == "moremainhomecmt" {
                                    let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
                                    vc.modalTransitionStyle = .crossDissolve
                                    vc.modalPresentationStyle = .overFullScreen
                                    self.present(vc, animated: false, completion: nil)
                                }else if viewflag == "setanualvc" {
                                    let vc = MoreSB.instantiateViewController(withIdentifier: "SetAnlVC") as! SetAnlVC
                                    vc.modalTransitionStyle = .crossDissolve
                                    vc.modalPresentationStyle = .overFullScreen
                                    self.present(vc, animated: false, completion: nil)
                                }
                                else{
                                    NotificationCenter.default.post(name: .reloadList, object: nil)
                                    self.dismiss(animated: true, completion: nil)
                                }
                            case -1 :
                                ismulticmtarea = false
                                self.toast("핀포인트가 부족합니다")
                            default:
                                print("\n---------- [ default ] ----------\n")
                        }
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }
            }

        }else{
            //핀포인트 충전으로 이동
            let vc = ContractSB.instantiateViewController(withIdentifier: "InAppVC") as! InAppVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func changeHideenM(){
        NetworkManager.shared().Sethiddenm(cmpsid: userInfo.cmpsid, mbrsid: userInfo.mbrsid) { (isSuccess, resCode, resData) in
            if(isSuccess){
                if resCode > 0 {
                    moreCmpInfo.hidebnm = resData
                    CompanyInfo.hidebnm = resData
                    NotificationCenter.default.post(name: .reloadList, object: nil)
                    self.dismiss(animated: true, completion: nil)
                 }else{
                    self.toast("다시 시도해 주세요")
                }
            }else{
                self.toast("다시 시도해 주세요")
            }
        }
    }
    
    fileprivate func changeHideen(){
        NetworkManager.shared().Sethidden(cmpsid: userInfo.cmpsid, mbrsid: userInfo.mbrsid) { (isSuccess, resCode, resData) in
            if(isSuccess){
                if resCode > 0 {
                    moreCmpInfo.hidebn = resData
                    CompanyInfo.hidebn = resData
                    NotificationCenter.default.post(name: .reloadList, object: nil)
                    self.dismiss(animated: true, completion: nil)
                 }else{
                    self.toast("다시 시도해 주세요")
                }
            }else{
                self.toast("다시 시도해 주세요")
            }
        }
    }
    
    fileprivate func changeCmtList(){
        NetworkManager.shared().SetCmtList(cmpsid: userInfo.cmpsid, mbrsid: userInfo.mbrsid) { (isSuccess, resCode, resData) in
            if(isSuccess){
                if resCode > 0 {
                    moreCmpInfo.empcmt = resData
                    CompanyInfo.empcmt = resData
                    NotificationCenter.default.post(name: .reloadList, object: nil)
                    self.dismiss(animated: true, completion: nil)
                 }else{
                    self.toast("다시 시도해 주세요")
                }
            }else{
                self.toast("다시 시도해 주세요")
            }
        }
    }
    
    //회계연도
    fileprivate func changeFical(){
        NetworkManager.shared().Setfical(cmpsid: userInfo.cmpsid, mbrsid: userInfo.mbrsid) { (isSuccess, resCode, resData) in
            if(isSuccess){
                if resCode > 0 {
                    moreCmpInfo.ficalyear = resData
                    CompanyInfo.ficalyear = resData
                    NotificationCenter.default.post(name: .reloadList, object: nil)
                    self.dismiss(animated: true, completion: nil)
                 }else{
                    self.toast("다시 시도해 주세요")
                }
            }else{
                self.toast("다시 시도해 주세요")
            }
        }
    }
    
    // 데이터보관
    fileprivate func changeDataLimits(){
        NetworkManager.shared().Setfical(cmpsid: userInfo.cmpsid, mbrsid: userInfo.mbrsid) { (isSuccess, resCode, resData) in
            if(isSuccess){
                if resCode > 0 {
                    moreCmpInfo.ficalyear = resData
                    CompanyInfo.ficalyear = resData
                    NotificationCenter.default.post(name: .reloadList, object: nil)
                    self.dismiss(animated: true, completion: nil)
                 }else{
                    self.toast("다시 시도해 주세요")
                }
            }else{
                self.toast("다시 시도해 주세요")
            }
        }
    }
}

