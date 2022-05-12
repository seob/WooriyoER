//
//  SE_SecurtInfoPopup.swift
//  PinPle
//
//  Created by seob on 2021/11/15.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class SE_SecurtInfoPopup: UIViewController , PanModalPresentable {
    
    private let alertViewHeight: CGFloat = 162
    
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
    
    var selInfo : ScEmpInfo = ScEmpInfo()
    
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
        alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: alertViewHeight).isActive = true
        
        alertView.saveBtn.addTarget(self, action: #selector(tempClick(_:)), for: .touchUpInside)
        alertView.endBtn.addTarget(self, action: #selector(saveClick(_:)), for: .touchUpInside)
        self.configure(with: SelScEmpInfo, SelScEmpInfo.viewpage)
        
    }
    
    fileprivate func tempSave(){
        switch viewpage {
        case "step3":
            var param: [String: Any] = [:]
            var multiArr: [Dictionary<String, Any>] = []
            
            
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
            
            let data = try! JSONSerialization.data(withJSONObject: param, options: [])
            let jsonBatch:String = String(data: data, encoding: .utf8)!
            NetworkManager.shared().sc_step2(lctsid: selInfo.sid, cmpnm: selInfo.cmpname, lcdt: selInfo.lcdt, json: jsonBatch) { isSuccess, resCode in
                if(isSuccess){
                    DispatchQueue.main.async {
                        if resCode == 1 {
                            self.toast("임시저장 되었습니다")
                            ScMultiArrTemp.removeAll()
                            self.dismiss(animated: true, completion: nil)
                        }else{
                            self.toast("다시 시도해 주세요.")
                        }
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
        case "step3":
            print("\n---------- [ 11 ] ----------\n")
            var param: [String: Any] = [:]
            var multiArr: [Dictionary<String, Any>] = []
            
            
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
            
            let data = try! JSONSerialization.data(withJSONObject: param, options: [])
            let jsonBatch:String = String(data: data, encoding: .utf8)!
            NetworkManager.shared().sc_step2(lctsid: selInfo.sid, cmpnm: selInfo.cmpname, lcdt: selInfo.lcdt, json: jsonBatch) { isSuccess, resCode in
                if(isSuccess){
                    DispatchQueue.main.async {
                        if resCode == 1 {
                            self.toast("임시저장 되었습니다")
                            ScMultiArrTemp.removeAll()
                            self.dismiss(animated: true, completion: nil)
                        }else{
                            self.toast("다시 시도해 주세요.")
                        }
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
        tempSave()
    }
    
    //작성 종료
    @objc func saveClick(_ sender: UIButton) {
        endSave()
    }
}

extension SE_SecurtInfoPopup  {
    
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
    
    func configure(with presentable: ScEmpInfo , _ viewflag : String) {
        self.selInfo = presentable 
        self.viewpage = viewflag
    }
}
