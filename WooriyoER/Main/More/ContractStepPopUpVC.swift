//
//  ContractStepPopUpVC.swift
//  PinPle
//
//  Created by seob on 2020/06/09.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class ContractStepPopUpVC: UIViewController {
    
    @IBOutlet weak var uiPopUpView: UIView!
    @IBOutlet weak var saveBtnView: UIView!
    @IBOutlet weak var endBtnView: UIView!
    
    @IBOutlet weak var profimageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpot: UILabel!
    
    var selInfo : LcEmpInfo = LcEmpInfo()
    var standInfo : LcEmpInfo = LcEmpInfo()
    var viewpage = ""
    override func viewDidLoad() {
        //팝업 라운드
        uiPopUpView.layer.cornerRadius = 50;
        uiPopUpView.layer.maskedCorners = [.layerMinXMinYCorner] // .layerMaxXMinYCorner = Top right corner, .layerMinXMinYCorner = Top left corner respectively
        
        
        //팝업 버튼 보더 스타일
        let test1 = UIColor.init(hexString: "#707070")
        endBtnView.layer.borderWidth = 1;
        endBtnView.layer.borderColor = test1.cgColor
        endBtnView.layer.cornerRadius = 6;
        
        let test2 = UIColor.init(hexString: "#707070")
        saveBtnView.layer.borderWidth = 1;
        saveBtnView.layer.borderColor = test2.cgColor
        saveBtnView.layer.cornerRadius = 6;
        
        profimageView.makeRounded()
        let defaultProfimg = UIImage(named: "logo_pre")
        if ContractEmpinfo.profimg == "" {
            profimageView.image = defaultProfimg
        }else{
            if ContractEmpinfo.profimg.urlTrim() != "img_photo_default.png" {
                profimageView.setImage(with: ContractEmpinfo.profimg)
            }else{
                profimageView.image = defaultProfimg
            }
        }
        
        var infoText = ""
        if ContractEmpinfo.phonenum != "" {
            infoText += "\(ContractEmpinfo.phonenum)"
        }
        
        if ContractEmpinfo.spot != "" {
            infoText += "\(ContractEmpinfo.spot)"
        }
        
        lblName.text = ContractEmpinfo.name
        lblSpot.text = infoText
    }
    
    //임시저장을 위해 각각 step 별로 저장
    fileprivate func tempSave(){
        switch viewpage {
        case "step1":
            NetworkManager.shared().set_step1(lctsid: selInfo.sid, form: selInfo.form) { (isSuccess, resCode) in
                if(isSuccess){
                    if(resCode == 1){
                        self.toast("임시저장 되었습니다")
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "step2" :
            var trainText = ""
            if selInfo.form == 2 {
                trainText = selInfo.traincntrc
            }else{
                trainText = ""
            }
            NetworkManager.shared().set_step2(type: selInfo.form, LCTSID: selInfo.sid, SDT: selInfo.startdt, EDT: selInfo.enddt, PSDT: selInfo.paystartdt, PEDT: selInfo.payenddt, PLACE: selInfo.place.urlEncoding(), TASK: selInfo.task.urlEncoding(), STM: selInfo.starttm, ETM: selInfo.endtm, BSTM: selInfo.brkstarttm, BETM: selInfo.brkendtm, WDAY: selInfo.workday, TRAIN: trainText.urlEncoding(), DWT: selInfo.dayworktime) { (isSuccess, resCode) in
                if(isSuccess){
                    
                    DispatchQueue.main.async {
                        if resCode == 1 {
                            self.toast("임시저장 되었습니다")
                            self.dismiss(animated: true, completion: nil)
                        }else{
                            self.toast("다시 시도해 주세요.")
                        }
                    }
                    
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "step3" :
            NetworkManager.shared().set_step3(LCTSID: selInfo.sid, SLYTYPE: selInfo.slytype) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.toast("임시저장 되었습니다")
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "step4":
            NetworkManager.shared().set_step4(LCTSID: selInfo.sid, BASEPAY: selInfo.basepay, PSTNPAY: selInfo.pstnpay, OVRTMPAY: selInfo.ovrtmpay, HLDYPAY: selInfo.hldypay, BONUS: selInfo.bonus, BENEFITS: selInfo.benefits, OTHERPAY: selInfo.otherpay, MEALS: selInfo.meals, RSRCHSBDY: selInfo.rsrchsbdy, CHLDEXPNS: selInfo.chldexpns, VHCLMNCST: selInfo.vhclmncst, JOBEXPNS: selInfo.jobexpns, HLDYALWNC: selInfo.hldyalwnc, HOURPAY: selInfo.hourpay, MONTHPAY: selInfo.monthpay, YEARPAY: selInfo.yearpay, MONTHOVRTM: selInfo.monthovrtm , CNTNSPAY: selInfo.cntnspay, NIGHTPAY: selInfo.nightpay , ADJUSTPAY: selInfo.adjustpay , ANUALPAY: selInfo.anualpay) { (isSuccess, resCode) in
                
                if(isSuccess){
                    if(resCode == 1){
                        self.toast("임시저장 되었습니다")
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "step5":
            NetworkManager.shared().set_step5(LCTSID: selInfo.sid, PAYDAY:selInfo.payday.urlEncoding() , SOCIAL: selInfo.socialinsrn .urlEncoding(), ANUAL: selInfo.anual.urlEncoding(), DELIVERY: selInfo.delivery.urlEncoding(), OTHER: selInfo.other.urlEncoding()) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.toast("임시저장 되었습니다")
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "step6" :
            selInfo.lcdt =   selInfo.lcdt == "" ? "1900-01-01" : selInfo.lcdt
            selInfo.addr  =  selInfo.addr == "" ? "필수값" : selInfo.addr
            selInfo.birth = selInfo.birth == "" ? "1900-01-01" : selInfo.birth
            selInfo.phonenum = selInfo.phonenum == "" ? "필수값" : selInfo.phonenum
            selInfo.actholder = selInfo.actholder == "" ? "필수값" : selInfo.actholder
            selInfo.actnum = selInfo.actnum == "" ? "필수값" : selInfo.actnum
            selInfo.actbank = selInfo.actbank == "" ? "필수값" : selInfo.actbank
            
            NetworkManager.shared().set_step6(LCTSID: selInfo.sid, LCDT: selInfo.lcdt, ADDR: selInfo.addr.urlBase64Encoding(), BIRTH: selInfo.birth.base64Encoding(), PHONE: selInfo.phonenum.base64Encoding(), HOLDER: selInfo.actholder.urlBase64Encoding() , BANK:selInfo.actbank.urlBase64Encoding(), NUM: selInfo.actnum.urlBase64Encoding()) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.toast("임시저장 되었습니다")
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        // 표준 근로계약서
        case "std_step1":
            NetworkManager.shared().lc_std_step1(lctsid: SelLcEmpInfo.sid, form: SelLcEmpInfo.form) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.toast("임시저장 되었습니다")
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "std_step2" :
            NetworkManager.shared().lc_std_step2(LCTSID: SelLcEmpInfo.sid, SDT: SelLcEmpInfo.startdt, EDT: SelLcEmpInfo.enddt, PLACE: SelLcEmpInfo.place.urlEncoding(), TASK: SelLcEmpInfo.task.urlEncoding(), STM: SelLcEmpInfo.starttm, ETM: SelLcEmpInfo.endtm, BSTM: SelLcEmpInfo.brkstarttm, BETM: SelLcEmpInfo.brkendtm, WDAY: SelLcEmpInfo.workday) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.toast("임시저장 되었습니다")
                        self.dismiss(animated: true, completion: nil)
                        
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "std_step3":
            NetworkManager.shared().lc_std_step3(LCTSID: standInfo.sid, BASEPAY: standInfo.basepay, BONUS: standInfo.bonus, OTHERPAY: standInfo.otherpay, ADDRATE: standInfo.addrate, HOURPAY: standInfo.hourpay , DAYPAY: standInfo.daypay) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.toast("임시저장 되었습니다")
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "std_step4" :
            NetworkManager.shared().lc_std_step4(LCTSID: standInfo.sid, PAYDAY: standInfo.payday.urlEncoding(), PAYROLL: standInfo.payroll, SOCIAL: standInfo.socialinsrn.urlEncoding(), ANUAL: standInfo.anual.urlEncoding(), DELIVERY: standInfo.delivery.urlEncoding(), OTHER: standInfo.other.urlEncoding()) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.toast("임시저장 되었습니다")
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "std_step5":
            NetworkManager.shared().lc_std_step5(LCTSID: standInfo.sid, LCDT: standInfo.lcdt, ADDR: standInfo.addr.urlBase64Encoding(), BIRTH: standInfo.birth.urlBase64Encoding(), PHONE: standInfo.phonenum.base64Encoding(), HOLDER: standInfo.actholder.urlBase64Encoding(), BANK: standInfo.actbank.urlBase64Encoding(), NUM: standInfo.actnum.urlBase64Encoding()) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.toast("임시저장 되었습니다")
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        default:
            break
        }
    }
    
    //작성 종료 일때도 저장후 근로계약서 메인으로 이동 하게
    fileprivate func endSave(){
        switch viewpage {
        case "step1":
            NetworkManager.shared().set_step1(lctsid: selInfo.sid, form: selInfo.form) { (isSuccess, resCode) in
                if(isSuccess){
                    if(resCode == 1){
                        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
                            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .fullScreen
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                        })
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "step2" :
            var trainText = ""
            if selInfo.form == 2 {
                trainText = selInfo.traincntrc
            }else{
                trainText = ""
            }
            NetworkManager.shared().set_step2(type: selInfo.form, LCTSID: selInfo.sid, SDT: selInfo.startdt, EDT: selInfo.enddt, PSDT: selInfo.paystartdt, PEDT: selInfo.payenddt, PLACE: selInfo.place.urlEncoding(), TASK: selInfo.task.urlEncoding(), STM: selInfo.starttm, ETM: selInfo.endtm, BSTM: selInfo.brkstarttm, BETM: selInfo.brkendtm, WDAY: selInfo.workday, TRAIN: trainText.urlEncoding(), DWT: selInfo.dayworktime) { (isSuccess, resCode) in
                if(isSuccess){ 
                    DispatchQueue.main.async {
                        if resCode == 1 {
                            
                            self.view.window?.rootViewController?.dismiss(animated: false, completion: {
                                var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                                if SE_flag {
                                    vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                                }
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .fullScreen
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                            })
                            
                        }else{
                            self.toast("다시 시도해 주세요.")
                        }
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "step3" :
            NetworkManager.shared().set_step3(LCTSID: selInfo.sid, SLYTYPE: selInfo.slytype) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
                            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .fullScreen
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                        })
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "step4":
            NetworkManager.shared().set_step4(LCTSID: selInfo.sid, BASEPAY: selInfo.basepay, PSTNPAY: selInfo.pstnpay, OVRTMPAY: selInfo.ovrtmpay, HLDYPAY: selInfo.hldypay, BONUS: selInfo.bonus, BENEFITS: selInfo.benefits, OTHERPAY: selInfo.otherpay, MEALS: selInfo.meals, RSRCHSBDY: selInfo.rsrchsbdy, CHLDEXPNS: selInfo.chldexpns, VHCLMNCST: selInfo.vhclmncst, JOBEXPNS: selInfo.jobexpns, HLDYALWNC: selInfo.hldyalwnc, HOURPAY: selInfo.hourpay, MONTHPAY: selInfo.monthpay, YEARPAY: selInfo.yearpay, MONTHOVRTM: selInfo.monthovrtm , CNTNSPAY: selInfo.cntnspay ,NIGHTPAY: selInfo.nightpay , ADJUSTPAY: selInfo.adjustpay , ANUALPAY: selInfo.anualpay) { (isSuccess, resCode) in
                
                if(isSuccess){
                    if(resCode == 1){
                        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
                            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .fullScreen
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                        })
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "step5":
            NetworkManager.shared().set_step5(LCTSID: selInfo.sid, PAYDAY:selInfo.payday.urlEncoding() , SOCIAL: selInfo.socialinsrn .urlEncoding(), ANUAL: selInfo.anual.urlEncoding(), DELIVERY: selInfo.delivery.urlEncoding(), OTHER: selInfo.other.urlEncoding()) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
                            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .fullScreen
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                        })
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "step6" :
            selInfo.lcdt =   selInfo.lcdt == "" ? "1900-01-01" : selInfo.lcdt
            selInfo.addr  =  selInfo.addr == "" ? "필수값" : selInfo.addr
            selInfo.birth = selInfo.birth == "" ? "1900-01-01" : selInfo.birth
            selInfo.phonenum = selInfo.phonenum == "" ? "필수값" : selInfo.phonenum
            selInfo.actholder = selInfo.actholder == "" ? "필수값" : selInfo.actholder
            selInfo.actnum = selInfo.actnum == "" ? "필수값" : selInfo.actnum
            selInfo.actbank = selInfo.actbank == "" ? "필수값" : selInfo.actbank
            
            NetworkManager.shared().set_step6(LCTSID: selInfo.sid, LCDT: selInfo.lcdt, ADDR: selInfo.addr.urlBase64Encoding(), BIRTH: selInfo.birth.base64Encoding(), PHONE: selInfo.phonenum.base64Encoding(), HOLDER: selInfo.actholder.urlBase64Encoding() , BANK:selInfo.actbank.urlBase64Encoding(), NUM: selInfo.actnum.urlBase64Encoding()) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
                            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .fullScreen
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                        })
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        // 표준 근로계약서
        case "std_step1":
            NetworkManager.shared().lc_std_step1(lctsid: SelLcEmpInfo.sid, form: SelLcEmpInfo.form) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
                            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .fullScreen
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                        })
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "std_step2" :
            NetworkManager.shared().lc_std_step2(LCTSID: SelLcEmpInfo.sid, SDT: SelLcEmpInfo.startdt, EDT: SelLcEmpInfo.enddt, PLACE: SelLcEmpInfo.place.urlEncoding(), TASK: SelLcEmpInfo.task.urlEncoding(), STM: SelLcEmpInfo.starttm, ETM: SelLcEmpInfo.endtm, BSTM: SelLcEmpInfo.brkstarttm, BETM: SelLcEmpInfo.brkendtm, WDAY: SelLcEmpInfo.workday) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
                            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .fullScreen
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                        })
                        
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "std_step3":
            NetworkManager.shared().lc_std_step3(LCTSID: standInfo.sid, BASEPAY: standInfo.basepay, BONUS: standInfo.bonus, OTHERPAY: standInfo.otherpay, ADDRATE: standInfo.addrate, HOURPAY: standInfo.hourpay , DAYPAY: standInfo.daypay) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
                            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .fullScreen
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                        })
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "std_step4" :
            NetworkManager.shared().lc_std_step4(LCTSID: standInfo.sid, PAYDAY: standInfo.payday.urlEncoding(), PAYROLL: standInfo.payroll, SOCIAL: standInfo.socialinsrn.urlEncoding(), ANUAL: standInfo.anual.urlEncoding(), DELIVERY: standInfo.delivery.urlEncoding(), OTHER: standInfo.other.urlEncoding()) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
                            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .fullScreen
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                        })
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "std_step5":
            NetworkManager.shared().lc_std_step5(LCTSID: standInfo.sid, LCDT: standInfo.lcdt, ADDR: standInfo.addr.urlBase64Encoding(), BIRTH: standInfo.birth.urlBase64Encoding(), PHONE: standInfo.phonenum.base64Encoding(), HOLDER: standInfo.actholder.urlBase64Encoding(), BANK: standInfo.actbank.urlBase64Encoding(), NUM: standInfo.actnum.urlBase64Encoding()) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
                            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .fullScreen
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                        })
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        default:
            break
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    // 임시 저장 버튼
    @IBAction func tempClick(_ sender: UIButton) {
        tempSave()
    }
    
    //작성 종료
    @IBAction func saveClick(_ sender: UIButton) {
        endSave()
    }
    
}


extension ContractStepPopUpVC: PanModalPresentable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(200)
    }

    var anchorModalToLongForm: Bool {
        return false
    }
}
