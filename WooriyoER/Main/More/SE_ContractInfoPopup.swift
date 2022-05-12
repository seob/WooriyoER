//
//  SE_ContractInfoPopup.swift
//  PinPle
//
//  Created by seob on 2020/07/13.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class SE_ContractInfoPopup: UIViewController , PanModalPresentable {
    
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
        alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: alertViewHeight).isActive = true
        
        alertView.layer.cornerRadius = 50
        alertView.layer.masksToBounds = true
        alertView.clipsToBounds = true
        
        alertView.saveBtn.addTarget(self, action: #selector(tempClick(_:)), for: .touchUpInside)
        alertView.endBtn.addTarget(self, action: #selector(saveClick(_:)), for: .touchUpInside)
        self.configure(with: SelPinplLcEmpInfo, SelPinplLcEmpInfo.viewpage)
        
    }
    
    fileprivate func tempSave(){
        switch viewpage {
        // 표준 근로계약서
        case "std_step1":
            NetworkManager.shared().lc_std_step1(lctsid: standInfo.sid, form: standInfo.form) { (isSuccess, resCode) in
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
        case "std_step2_1":
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
            
            NetworkManager.shared().lc_std_step2_1(lctsid: standInfo.sid, json: jsonBatch) { (isSuccess, resCode) in
                if(isSuccess){
                    DispatchQueue.main.async {
                        if resCode == 1 {
                            self.toast("임시저장 되었습니다")
                            SelMultiArrTemp.removeAll()
                            self.dismiss(animated: true, completion: nil)
                        }else{
                            self.toast("다시 시도해 주세요.")
                        }
                    }
                    
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        case "std_step3":
            NetworkManager.shared().lc_std_step3(LCTSID: standInfo.sid, BASEPAY: standInfo.basepay, BONUS: standInfo.bonus, OTHERPAY: standInfo.otherpay, ADDRATE: standInfo.addrate , HOURPAY: standInfo.hourpay , DAYPAY: standInfo.daypay) { (isSuccess, resCode) in
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
        case "std_step5":
            NetworkManager.shared().lc_std_step5(LCTSID: standInfo.sid, LCDT: standInfo.lcdt, ADDR: standInfo.addr.urlBase64Encoding(), BIRTH: standInfo.birth.urlBase64Encoding(), PHONE: standInfo.phonenum.base64Encoding(), HOLDER: standInfo.actholder.urlBase64Encoding(), BANK: standInfo.actbank.urlBase64Encoding(), NUM: standInfo.actnum.base64Encoding()) { (isSuccess, resCode) in
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
        // 표준 근로계약서
        case "std_step1":
            NetworkManager.shared().lc_std_step1(lctsid: SelLcEmpInfo.sid, form: SelLcEmpInfo.form) { (isSuccess, resCode) in
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
        case "std_step2" :
            NetworkManager.shared().lc_std_step2(LCTSID: SelLcEmpInfo.sid, SDT: SelLcEmpInfo.startdt, EDT: SelLcEmpInfo.enddt, PLACE: SelLcEmpInfo.place.urlEncoding(), TASK: SelLcEmpInfo.task.urlEncoding(), STM: SelLcEmpInfo.starttm, ETM: SelLcEmpInfo.endtm, BSTM: SelLcEmpInfo.brkstarttm, BETM: SelLcEmpInfo.brkendtm, WDAY: SelLcEmpInfo.workday) { (isSuccess, resCode) in
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
        case "std_step2_1":
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
            NetworkManager.shared().lc_std_step2_1(lctsid: SelLcEmpInfo.sid, json: jsonBatch) { (isSuccess, resCode) in
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
        case "std_step3":
            NetworkManager.shared().lc_std_step3(LCTSID: standInfo.sid, BASEPAY: standInfo.basepay, BONUS: standInfo.bonus, OTHERPAY: standInfo.otherpay, ADDRATE: standInfo.addrate , HOURPAY: standInfo.hourpay , DAYPAY: standInfo.daypay) { (isSuccess, resCode) in
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
        case "std_step4" :
            NetworkManager.shared().lc_std_step4(LCTSID: SelLcEmpInfo.sid, PAYDAY: SelLcEmpInfo.payday.urlEncoding(), PAYROLL: SelLcEmpInfo.payroll, SOCIAL: SelLcEmpInfo.socialinsrn.urlEncoding(), ANUAL: SelLcEmpInfo.anual.urlEncoding(), DELIVERY: SelLcEmpInfo.delivery.urlEncoding(), OTHER: SelLcEmpInfo.other.urlEncoding()) { (isSuccess, resCode) in
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
        case "std_step5":
            NetworkManager.shared().lc_std_step5(LCTSID: SelLcEmpInfo.sid, LCDT: SelLcEmpInfo.lcdt, ADDR: SelLcEmpInfo.addr.urlBase64Encoding(), BIRTH: SelLcEmpInfo.birth.urlBase64Encoding(), PHONE: SelLcEmpInfo.phonenum.base64Encoding(), HOLDER: SelLcEmpInfo.actholder.urlBase64Encoding(), BANK: SelLcEmpInfo.actbank.urlBase64Encoding(), NUM: SelLcEmpInfo.actnum.urlBase64Encoding()) { (isSuccess, resCode) in
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

extension SE_ContractInfoPopup  {
    
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
