//
//  ContractSMSPopup.swift
//  PinPle
//
//  Created by seob on 2020/07/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import MessageUI

class ContractSMSPopup: UIViewController,MFMessageComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n---------- [ SmsEmpInfo : \(SmsEmpInfo.toJSON()) ] ----------\n")
    }
 
    @IBAction func btnClicked(_ sender: UIButton) {
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        if MFMessageComposeViewController.canSendText(){
            messageComposer.recipients = ["\(SmsEmpInfo.phonenum)"]
            messageComposer.body = """
            [\(userInfo.name) 근로계약서 서명 요청]\n
            \(SmsEmpInfo.name)님에게 \(userInfo.name)의 근로계약서를 발송합니다.\n
            근로계약서 확인 후 서명을 해주세요.\n
            ▶ 중요사항\r
            1. 계약서에는 개인정보가 담겨있으니 노출에 주의해 주십시오.\r\n
            2. 본 메시지를 삭제할 경우 서명을 할 수 없습니다.\r\n
            3. 서명 완료 후 근로계약서는 본 링크를 통해 확인할 수 있습니다.\r\n\r\n
            아래 링크를 클릭하세요..\r\n
            \(shortUrl)
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
            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_ListVC") as! Lc_ListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        
    }
}
