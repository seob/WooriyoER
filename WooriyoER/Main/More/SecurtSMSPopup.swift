//
//  SecurtSMSPopup.swift
//  PinPle
//
//  Created by seob on 2021/11/15.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit
import MessageUI

class SecurtSMSPopup: UIViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n---------- [ SmsCertEmpInfo : \(SmsScEmpInfo.toJSON()) ] ----------\n")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var title = ""
        var content = ""
        
        if SmsScEmpInfo.format == 0 {
            //경력
            title = "입사 보안서약서 발송"
            content = "SMS 문자 메세지 화면으로 전환되어\n미합류 근로자에게 보안서약서를\n전송합니다."
        }else{
            //재직
            title = "퇴사 보안서약서 발송"
            content = "SMS 문자 메세지 화면으로 전환되어\n미합류 근로자에게 보안서약서를\n전송합니다."
        }
        
        lblTitle.text = title
        lblContent.text = content
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        
        var strFormat = ""
        strFormat = "보안서약서"
         
        
        if MFMessageComposeViewController.canSendText(){
            messageComposer.recipients = ["\(SmsScEmpInfo.phonenum)"]
            messageComposer.body = """
            [\(SmsScEmpInfo.name) 보안서약서 서명 요청]\n
            보안서약서 확인 후 서명을 해주세요.\n
            ▶ 중요사항\r
            1. 서약서에는 개인정보가 담겨있으니 노출에 주의해 주십시오.\r\n
            2. 본 메시지를 삭제할 경우 서명을 할 수 없습니다.\r\n
            3. 서명 완료 후 보안서약서 본 링크를 통해 확인할 수 있습니다.\r\n\r\n
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
            let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_ListVC") as! Sc_ListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)

        }
        
    }
    
}
