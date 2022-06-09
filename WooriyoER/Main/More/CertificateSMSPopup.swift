//
//  CertificateSMSPopup.swift
//  PinPle
//
//  Created by seob on 2020/08/11.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import MessageUI

class CertificateSMSPopup: UIViewController ,MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOk.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        btnOk.backgroundColor = EnterpriseColor.btnColor
        print("\n---------- [ SmsCertEmpInfo : \(SmsCertEmpInfo.toJSON()) ] ----------\n")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var title = ""
        var content = ""
        
        if SmsCertEmpInfo.format > 0 {
            //경력
            title = "경력증명서 발송"
            content = "SMS 문자 메세지 화면으로 전환되어\n미합류 근로자에게 경력증명서를\n전송합니다."
        }else{
            //재직
            title = "재직증명서 발송"
            content = "SMS 문자 메세지 화면으로 전환되어\n미합류 근로자에게 재직증명서를\n전송합니다."
        }
        
        lblTitle.text = title
        lblContent.text = content
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        
        var strFormat = ""
        if (SmsCertEmpInfo.format > 0) {    //경력증명서
            strFormat = "경력증명서"
        } else {
            strFormat = "재직증명서"
        }
         
        
        if MFMessageComposeViewController.canSendText(){
            messageComposer.recipients = ["\(SmsCertEmpInfo.phonenum)"]
            messageComposer.body = """
            [\(CompanyInfo.name) \(strFormat) 발급]\n
            \(SmsCertEmpInfo.name)님에게 \(CompanyInfo.name)의 \(strFormat)가 도착하였습니다.\n
            \(strFormat)를 확인해주세요.\n
            ▶ 중요사항\r
            1. 증명서에는 개인정보가 담겨있으니 노출에 주의해 주십시오.\r\n
            2. \(SmsCertEmpInfo.name)님 이메일로 발송됩니다.
            """
            self.present(messageComposer, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case MessageComposeResult.sent:
            self.toast("메세지 전송을 완료하였습니다.")
            shortUrl = ""
            print("전송 완료")
            break
        case MessageComposeResult.cancelled:
            self.toast("메세지 전송이 취소되었습니다.")
            shortUrl = ""
            print("취소")
            break
        case MessageComposeResult.failed:
            self.toast("메세지 전송에 실패하였습니다.")
            shortUrl = ""
            print("전송 실패")
            break
        default:
            break
        }
        
        controller.dismiss(animated: true) {
            if SmsCertEmpInfo.format > 0 {
                let vc = CertifiSB.instantiateViewController(withIdentifier: "Cc_ListVC") as! Cc_ListVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
            }else{
                let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_ListVC") as! Ce_ListVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
            }

        }
        
    }
    
}
