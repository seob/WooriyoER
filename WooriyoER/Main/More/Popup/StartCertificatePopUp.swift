//
//  StartCertificatePopUp.swift
//  PinPle
//
//  Created by seob on 2020/08/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class StartCertificatePopUp: UIViewController {
    var format = 0
    var selInfo : Ce_empInfo = Ce_empInfo()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnOk.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        btnOk.backgroundColor = EnterpriseColor.btnColor
        if self.format == 0 {
            lblTitle.text = "재직증명서를\n발급하시겠습니까?"
        }else{
            lblTitle.text = "경력증명서를\n발급하시겠습니까?"
        }
        btnOk.setTitle("발급", for: .normal)
    }
    
    //돌아가기 -> history.back
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    //취소 - >메인으로
    @IBAction func okClick(_ sender: UIButton) {
        if format == 0 {
            //재직증명서
            if type == "nomember" {
                //미합류
                NetworkManager.shared().getNotJoinCe(cmpsid: CompanyInfo.sid, isuempsid: userInfo.empsid, nm: nm.urlBase64Encoding(), pn: pn.base64Encoding(), em: email.base64Encoding()) { (isSuccess, resData) in
                    if(isSuccess){
                        guard let serverData = resData else { return }
                        self.selInfo = serverData
                        if self.format == 0 { //재직증명서
                            let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step1VC") as! Ce_Step1VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.selInfo = self.selInfo
                            vc.selInfo.format = 0
                            self.present(vc, animated: false, completion: nil)
                        }else{ //경력증명서
                            let vc = CertifiSB.instantiateViewController(withIdentifier: "Career_Step1VC") as! Career_Step1VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.selInfo = self.selInfo
                            vc.selInfo.format = 1
                            self.present(vc, animated: false, completion: nil)

                        }

                    }else{
                        self.customAlertView("다시 시도해 주세요.")
                    }
                }
            }else{
                NetworkManager.shared().getJoinCe(cmpsid: CompanyInfo.sid, empsid: selInfo.sid, isuempsid: userInfo.empsid) { (isSuccess, resData) in
                    if(isSuccess){
                        guard let serverData = resData else { return }
                        self.selInfo = serverData
                        
                        if self.format == 0 { //재직증명서
                            let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step1VC") as! Ce_Step1VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.selInfo = self.selInfo
                            vc.selInfo.format = 0
                            self.present(vc, animated: false, completion: nil)
                        }else{ //경력증명서
                            let vc = CertifiSB.instantiateViewController(withIdentifier: "Career_Step1VC") as! Career_Step1VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.selInfo = self.selInfo
                            vc.selInfo.format = 1
                            self.present(vc, animated: false, completion: nil)
                        }
                        
                        
                    }else{
                        self.customAlertView("다시 시도해 주세요.")
                    }
                }
            }
        }else{
            //경력증명서
            if type == "nomember" {
                //미합류
                NetworkManager.shared().getNotJoinCc(cmpsid: CompanyInfo.sid, isuempsid: userInfo.empsid, nm: nm.urlBase64Encoding(), pn: pn.base64Encoding(), em: email.base64Encoding()) { (isSuccess, resData) in
                    if(isSuccess){
                        guard let serverData = resData else { return }
                        self.selInfo = serverData
                        if self.format == 0 { //재직증명서
                            let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step1VC") as! Ce_Step1VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.selInfo = self.selInfo
                            vc.selInfo.format = 0
                            self.present(vc, animated: false, completion: nil)
                        }else{ //경력증명서
                            let vc = CertifiSB.instantiateViewController(withIdentifier: "Career_Step1VC") as! Career_Step1VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.selInfo = self.selInfo
                            vc.selInfo.format = 1
                            self.present(vc, animated: false, completion: nil)

                        }

                    }else{
                        self.customAlertView("다시 시도해 주세요.")
                    }
                }
            }else{
                NetworkManager.shared().getJoinCc(cmpsid: CompanyInfo.sid, empsid: selInfo.sid, isuempsid: userInfo.empsid) { (isSuccess, resData) in
                    if(isSuccess){
                        guard let serverData = resData else { return }
                        self.selInfo = serverData
                        
                        if self.format == 0 { //재직증명서
                            let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step1VC") as! Ce_Step1VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.selInfo = self.selInfo
                            vc.selInfo.format = 0
                            self.present(vc, animated: false, completion: nil)
                        }else{ //경력증명서
                            let vc = CertifiSB.instantiateViewController(withIdentifier: "Career_Step1VC") as! Career_Step1VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.selInfo = self.selInfo
                            vc.selInfo.format = 1
                            self.present(vc, animated: false, completion: nil)
                        }
                        
                        
                    }else{
                        self.customAlertView("다시 시도해 주세요.")
                    }
                }
            }
        }
        
    }
}
