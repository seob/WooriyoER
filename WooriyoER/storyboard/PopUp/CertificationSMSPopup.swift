//
//  CertificationSMSPopup.swift
//  PinPle
//
//  Created by seob on 2020/09/04.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import MessageUI

class CertificationSMSPopup: UIViewController , MFMessageComposeViewControllerDelegate {


        override func viewDidLoad() {
            super.viewDidLoad()
            print("\n---------- [ SmsCertEmpInfo : \(SmsCertEmpInfo.toJSON()) ] ----------\n")
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
                [\(userInfo.name) \(strFormat) 서명 요청]\n
                \(SmsCertEmpInfo.name)님에게 \(userInfo.name)의 \(strFormat)가 도착하였습니다.\n
                \(strFormat)를 확인해주세요.\n
                ▶ 중요사항\r
                1. 증명서에는 개인정보가 담겨있으니 노출에 주의해 주십시오.\r\n
                2. \(strFormat)는 \(SmsCertEmpInfo.name)님 이메일로 발송됩니다.\r\n\r\n
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
                let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_ListVC") as! Ce_ListVC
                vc.type = SmsCertEmpInfo.format
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
            }
            
        }
    }
