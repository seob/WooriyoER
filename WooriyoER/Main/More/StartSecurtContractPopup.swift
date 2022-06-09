//
//  StartSecurtContractPopup.swift
//  PinPle
//
//  Created by seob on 2021/11/11.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class StartSecurtContractPopup: UIViewController {
    var format = 0
    var selInfo : ScEmpInfo = ScEmpInfo()
    var standInfo : ScEmpInfo = ScEmpInfo()
    var empsid = 0
    var type = ""
    var nm = ""
    var pn = ""
    var email = ""
    var status = 0
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOk.backgroundColor = EnterpriseColor.btnColor
        btnOk.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        if format == 0 {
            empsid = selInfo.empsid
        }else{
            empsid = standInfo.empsid
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if empsid > 0  {
            // 핀플 직원
            if status == 0 {
                if self.format == 0 {
                    lblTitle.text = "보안서약서를\n작성하시겠습니까?"
                }else{
                    lblTitle.text = "보안서약서를\n작성하시겠습니까?"
                }
                
                btnOk.setTitle("작성", for: .normal)
            }else{
                if self.format == 0 {
                    lblTitle.text = "보안서약서를\n갱신하시겠습니까?"
                }else{
                    lblTitle.text = "보안서약서를\n갱신하시겠습니까?"
                }
                
                btnOk.setTitle("갱신", for: .normal)
            }
            
        }else{
            //미합류
            if self.format == 0 {
                lblTitle.text = "보안서약서를\n작성하시겠습니까?"
            }else{
                lblTitle.text = "보안서약서를\n작성하시겠습니까?"
            }
            btnOk.setTitle("작성", for: .normal)
        }
    }
    
    //돌아가기 -> history.back
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    //취소 - >메인으로
    @IBAction func okClick(_ sender: UIButton) {
        if type == "nomember" {
            //미합류
            NetworkManager.shared().setNotJoinSc(cmpsid: CompanyInfo.sid, nm: nm.urlBase64Encoding(), pn: pn.base64Encoding(), em: email.base64Encoding(), format: format) { (isSuccess, resData) in
                if(isSuccess){
                    guard let serverData = resData else { return }
                    self.selInfo = serverData
                    let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_Step1VC") as! Sc_Step1VC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.selInfo = self.selInfo
                    self.present(vc, animated: false, completion: nil)
                    
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
        }else{
            NetworkManager.shared().getSc_empInfo(cmpsid: CompanyInfo.sid, empsid: empsid , format: format) { (isSuccess, resData) in
                if(isSuccess){
                    guard let serverData = resData else { return }
                    self.selInfo = serverData
                    
                    print("\n---------- [ form : \(self.selInfo.format) ] ----------\n")
                    let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_Step1VC") as! Sc_Step1VC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.selInfo = self.selInfo
                    self.present(vc, animated: false, completion: nil)
                    
                    
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
        }
        
    }
}
