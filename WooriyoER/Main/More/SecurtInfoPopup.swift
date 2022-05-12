//
//  SecurtInfoPopup.swift
//  PinPle
//
//  Created by seob on 2021/11/15.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class SecurtInfoPopup: UIViewController , PanModalPresentable {
    
    
    private let alertViewHeight: CGFloat = 180
    
    let alertView: SE_SecurtInfoView = {
        let alertView = SE_SecurtInfoView()
            alertView.layer.cornerRadius = 0
            if #available(iOS 11.0, *) {
                alertView.layer.maskedCorners = [.layerMinXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
            return alertView
        }()
     
    
    var saveSelinfo : ScEmpInfo = ScEmpInfo()
    
    var viewpage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        
        if SelScEmpInfo.format == 0  {
            alertView.lblName.text = "입사 보안서약서 임시저장"
        }else{
            alertView.lblName.text = "퇴사 보안서약서 임시저장"
        }
         

        alertView.saveBtn.addTarget(self, action: #selector(tempClick(_:)), for: .touchUpInside)
        alertView.endBtn.addTarget(self, action: #selector(saveClick(_:)), for: .touchUpInside)
        self.saveSelinfo = SelScEmpInfo
        self.configure(with: SelScEmpInfo, SelScEmpInfo.viewpage)
    }
 
    fileprivate func tempSave(){
        var param: [String: Any] = [:]
        var multiArr: [Dictionary<String, Any>] = []
        
        if ScMultiArrTemp.count > 0 {
//            for (i, _ ) in ScMultiArrTemp.enumerated() {
//                ScMultiArrTemp[i].optseq = i + 1
//            }
            for model in ScMultiArrTemp {
                
                let object : [String : Any] = [
                    "odysid": model.odysid,
                    "optname": model.optname,
                    "opttype": model.opttype,
                    "optseq": model.optseq
                ]
                multiArr.append(object)
            }
            param = ["optList" : multiArr ]
        }else{
            param = ["optList" : "{}" ]
        }
        
        let data = try! JSONSerialization.data(withJSONObject: param, options: [])
        let jsonBatch:String = String(data: data, encoding: .utf8)!
        
        print("\n---------- [ param : \(ScMultiArrTemp.toJSON()) ] ----------\n")
        NetworkManager.shared().sc_step2(lctsid: SelScEmpInfo.sid, cmpnm: SelScEmpInfo.cmpname, lcdt: SelScEmpInfo.lcdt, json: jsonBatch) { isSuccess, resCode in
            if(isSuccess){
                DispatchQueue.main.async {
                    if resCode == 1 {
                        ScMultiArrTemp  = SelScEmpInfo.optList
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
    }
    
    //작성 종료 일때도 저장후 근로계약서 메인으로 이동 하게
    fileprivate func endSave(){
        var param: [String: Any] = [:]
        var multiArr: [Dictionary<String, Any>] = []
        
        if ScMultiArrTemp.count > 0 {
//            for (i, _ ) in ScMultiArrTemp.enumerated() {
//                ScMultiArrTemp[i].optseq = i + 1
//            }
            for model in ScMultiArrTemp {
                
                let object : [String : Any] = [
                    "odysid": model.odysid,
                    "optname": model.optname,
                    "opttype": model.opttype,
                    "optseq": model.optseq
                ]
                multiArr.append(object)
            }
            param = ["optList" : multiArr ]
        }else{
            param = ["optList" : "" ]
        }
  
        
        print("\n---------- [ param : \(ScMultiArrTemp.toJSON()) ] ----------\n")
        let data = try! JSONSerialization.data(withJSONObject: param, options: [])
        let jsonBatch:String = String(data: data, encoding: .utf8)!
        NetworkManager.shared().sc_step2(lctsid: SelScEmpInfo.sid, cmpnm: SelScEmpInfo.cmpname, lcdt: SelScEmpInfo.lcdt, json: jsonBatch) { isSuccess, resCode in
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
    }
    
    // 임시 저장 버튼
    @objc func tempClick(_ sender: UIButton) {
        
        tempSave()
    }
    
    //작성 종료
    @objc func saveClick(_ sender: UIButton) {
        endSave()
    }
}

extension SecurtInfoPopup  {
    
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
        return UIColor.black.withAlphaComponent(0.1)
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
    
    func configure(with presentable: ScEmpInfo , _ viewflag : String) {
        self.saveSelinfo = presentable
        self.viewpage = viewflag
    }
}

