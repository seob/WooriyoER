//
//  SE_ContractInfoPinplPopup.swift
//  PinPle
//
//  Created by seob on 2020/07/05.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class SE_ContractInfoPinplPopup: UIViewController , PanModalPresentable {
    
    private let alertViewHeight: CGFloat = 262
    
    let alertView: ContractInfoView = {
        let alertView = ContractInfoView()
        alertView.layer.cornerRadius = 0
        if #available(iOS 11.0, *) {
            alertView.layer.maskedCorners = [.layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        return alertView
    }()
    
    var selInfo : LcEmpInfo = LcEmpInfo()
    var standInfo : LcEmpInfo = LcEmpInfo()
    
    var viewpage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("\n---------- [ 111 ] ----------\n")
        
        setupView()
        
    }
    
    private func setupView() {
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: alertViewHeight).isActive = true
        
        alertView.saveBtn.addTarget(self, action: #selector(tempClick(_:)), for: .touchUpInside)
        alertView.endBtn.addTarget(self, action: #selector(saveClick(_:)), for: .touchUpInside)
        self.configure(with: SelPinplLcEmpInfo, SelPinplLcEmpInfo.viewpage)
        
    }
    
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
        case "stepDay2_1" :
            var param: [String: Any] = [:]
            var multiArr: [Dictionary<String, Any>] = []
            
            for model in SelMultiArrTemp {
                let object : [String : Any] = ["wdysid": model.wdysid,
                                               "dayweek": model.dayweek,
                                               "starttm": model.starttm,
                                               "endtm": model.endtm,
                                               "brkstarttm": model.brkstarttm,
                                               "brkendtm": model.brkendtm,
                                               "workmin": model.workmin
                ]
                multiArr.append(object )
            }
            param = ["workday" : multiArr ]
            
            let data = try! JSONSerialization.data(withJSONObject: param, options: [])
            let jsonBatch:String = String(data: data, encoding: .utf8)!
            
            print("\n---------- [ json : \(jsonBatch) ] ----------\n")
            NetworkManager.shared().lc_step2_1(lctsid: selInfo.sid, json: jsonBatch) { (isSuccess, resCode) in
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
            NetworkManager.shared().set_step4(LCTSID: selInfo.sid, BASEPAY: selInfo.basepay, PSTNPAY: selInfo.pstnpay, OVRTMPAY: selInfo.ovrtmpay, HLDYPAY: selInfo.hldypay, BONUS: selInfo.bonus, BENEFITS: selInfo.benefits, OTHERPAY: selInfo.otherpay, MEALS: selInfo.meals, RSRCHSBDY: selInfo.rsrchsbdy, CHLDEXPNS: selInfo.chldexpns, VHCLMNCST: selInfo.vhclmncst, JOBEXPNS: selInfo.jobexpns, HLDYALWNC: selInfo.hldyalwnc, HOURPAY: selInfo.hourpay, MONTHPAY: selInfo.monthpay, YEARPAY: selInfo.yearpay, MONTHOVRTM: selInfo.monthovrtm, CNTNSPAY: selInfo.cntnspay, NIGHTPAY: selInfo.nightpay , ADJUSTPAY: selInfo.adjustpay , ANUALPAY: selInfo.anualpay) { (isSuccess, resCode) in
                
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
        case "step6" :
            selInfo.lcdt =   selInfo.lcdt == "" ? "1900-01-01" : selInfo.lcdt
            selInfo.addr  =  selInfo.addr == "" ? "필수값" : selInfo.addr
            selInfo.birth = selInfo.birth == "" ? "1900-01-01" : selInfo.birth
            selInfo.phonenum = selInfo.phonenum == "" ? "필수값" : selInfo.phonenum
            selInfo.actholder = selInfo.actholder == "" ? "필수값" : selInfo.actholder
            selInfo.actnum = selInfo.actnum == "" ? "" : selInfo.actnum
            selInfo.actbank = selInfo.actbank == "" ? "필수값" : selInfo.actbank
            
            NetworkManager.shared().set_step6(LCTSID: selInfo.sid, LCDT: selInfo.lcdt, ADDR: selInfo.addr.urlBase64Encoding(), BIRTH: selInfo.birth.base64Encoding(), PHONE: selInfo.phonenum.base64Encoding(), HOLDER: selInfo.actholder.urlBase64Encoding() , BANK:selInfo.actbank.urlBase64Encoding(), NUM: selInfo.actnum.base64Encoding()) { (isSuccess, resCode) in
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
                        var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                        if SE_flag {
                            vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.presentDismiss(vc)
                        
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
                            
                            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.presentDismiss(vc)
                            
                        }else{
                            self.toast("다시 시도해 주세요.")
                        }
                    }
 
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "stepDay2_1" :
            var param: [String: Any] = [:]
            var multiArr: [Dictionary<String, Any>] = []
            
            for model in SelMultiArrTemp {
                let object : [String : Any] = ["wdysid": model.wdysid,
                                               "dayweek": model.dayweek,
                                               "starttm": model.starttm,
                                               "endtm": model.endtm,
                                               "brkstarttm": model.brkstarttm,
                                               "brkendtm": model.brkendtm,
                                               "workmin": model.workmin
                ]
                multiArr.append(object )
            }
            param = ["workday" : multiArr ]
            
            let data = try! JSONSerialization.data(withJSONObject: param, options: [])
            let jsonBatch:String = String(data: data, encoding: .utf8)!
            
            print("\n---------- [ json : \(jsonBatch) ] ----------\n")
            NetworkManager.shared().lc_step2_1(lctsid: selInfo.sid, json: jsonBatch) { (isSuccess, resCode) in
                if(isSuccess){ 
                        DispatchQueue.main.async {
                            if resCode == 1 {
                                
                                var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                                if SE_flag {
                                    vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                                }
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                self.presentDismiss(vc)
                                
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
                        var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                        if SE_flag {
                            vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.presentDismiss(vc)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "step4":
            NetworkManager.shared().set_step4(LCTSID: selInfo.sid, BASEPAY: selInfo.basepay, PSTNPAY: selInfo.pstnpay, OVRTMPAY: selInfo.ovrtmpay, HLDYPAY: selInfo.hldypay, BONUS: selInfo.bonus, BENEFITS: selInfo.benefits, OTHERPAY: selInfo.otherpay, MEALS: selInfo.meals, RSRCHSBDY: selInfo.rsrchsbdy, CHLDEXPNS: selInfo.chldexpns, VHCLMNCST: selInfo.vhclmncst, JOBEXPNS: selInfo.jobexpns, HLDYALWNC: selInfo.hldyalwnc, HOURPAY: selInfo.hourpay, MONTHPAY: selInfo.monthpay, YEARPAY: selInfo.yearpay, MONTHOVRTM: selInfo.monthovrtm, CNTNSPAY: selInfo.cntnspay, NIGHTPAY: selInfo.nightpay , ADJUSTPAY: selInfo.adjustpay , ANUALPAY: selInfo.anualpay) { (isSuccess, resCode) in
                
                if(isSuccess){
                    if(resCode == 1){
                        var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                        if SE_flag {
                            vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.presentDismiss(vc)
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
                    DispatchQueue.main.async {
                        if resCode == 1 {
                            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.presentDismiss(vc)
                        }else{
                            self.toast("다시 시도해 주세요.")
                        }
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
            selInfo.actnum = selInfo.actnum == "" ? "" : selInfo.actnum
            selInfo.actbank = selInfo.actbank == "" ? "필수값" : selInfo.actbank
            
            NetworkManager.shared().set_step6(LCTSID: selInfo.sid, LCDT: selInfo.lcdt, ADDR: selInfo.addr.urlBase64Encoding(), BIRTH: selInfo.birth.base64Encoding(), PHONE: selInfo.phonenum.base64Encoding(), HOLDER: selInfo.actholder.urlBase64Encoding() , BANK:selInfo.actbank.urlBase64Encoding(), NUM: selInfo.actnum.urlBase64Encoding()) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
                        if SE_flag {
                            vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.presentDismiss(vc)
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
    
    // 임시 저장 버튼
    @objc func tempClick(_ sender: UIButton) {
        print("\n---------- [ SelLcEmpInfo : \(SelPinplLcEmpInfo.toJSON()) ] ----------\n")
        tempSave()
    }
    
    //작성 종료
    @objc func saveClick(_ sender: UIButton) {
        print("\n---------- [ SelLcEmpInfo : \(SelPinplLcEmpInfo.toJSON()) ] ----------\n")
        endSave()
    }
}

extension SE_ContractInfoPinplPopup  {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(alertViewHeight)
    }
    
    var longFormHeight: PanModalHeight {
        return shortFormHeight
    }
    
    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
    
    var shouldRoundTopCorners: Bool {
        return false
    }
    
    var showDragIndicator: Bool {
        return true
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
    
    var isUserInteractionEnabled: Bool {
        return true
    }
    
    func panModalSetNeedsLayoutUpdate() {
        print("\n---------- [ <#heder#> ] ----------\n")
    }
    
    func configure(with presentable: LcEmpInfo , _ viewflag : String) {
        self.selInfo = presentable
        self.standInfo = presentable
        self.viewpage = viewflag
    }
}
