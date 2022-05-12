//
//  NoticeDetailVC.swift
//  PinPle
//
//  Created by seob on 2022/01/27.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit
import WebKit

class NoticeDetailVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var webNoticeView: WKWebView!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var btnModify: UIButton!
    var noticeDetail : NoticeListInfo = NoticeListInfo()
    var type = 0 // 1 사내공지 , 2 핀플 공지
    override func viewDidLoad() {
        super.viewDidLoad()
        btnModify.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        if noticeType  > 0 {
            if noticeType == 1 {
                btnView.isHidden = false
                lblNavigationTitle.text = "사내공지"
                if let url = URL(string: "\(API.baseURL)ios/m/noticeDetailView.jsp?sid=\(noticeGidx)") {
                    print("\n---------- [ noticeType : \(noticeType) ] ----------\n")
                    let request = URLRequest(url: url)
                    webNoticeView.load(request)
                }
            }else{
                btnView.isHidden = true
                lblNavigationTitle.text = "핀플알림"
                if let url = URL(string: "\(API.baseURL)ios/m/MasterNoticeDetailView.jsp?sid=\(noticeGidx)") {
                    print("\n---------- [ noticeType : \(noticeType) ] ----------\n")
                    let request = URLRequest(url: url)
                    webNoticeView.load(request)
                }
            }
        }else{
            if type == 1 {
                btnView.isHidden = false
                lblNavigationTitle.text = "사내공지"
                if let url = URL(string: "\(API.baseURL)ios/m/noticeDetailView.jsp?sid=\(noticeDetail.sid)") {
                    print("\n---------- [ url : \(url) ] ----------\n")
                    let request = URLRequest(url: url)
                    webNoticeView.load(request)
                }
            }else{
                btnView.isHidden = true
                lblNavigationTitle.text = "핀플알림"
                if let url = URL(string: "\(API.baseURL)ios/m/MasterNoticeDetailView.jsp?sid=\(noticeDetail.sid)") {
                    print("\n---------- [ url : \(url) ] ----------\n")
                    let request = URLRequest(url: url)
                    webNoticeView.load(request)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDtail()
    }
    
    func getDtail(){
        var noticeSid = 0
        if noticeType  > 0 {
            noticeSid = noticeGidx
        }else{
            noticeSid = noticeDetail.sid
        }
        NetworkManager.shared().getNoticeDetailApp(sid: noticeSid) { isSuccess, resData in
            if isSuccess {
                guard let serverData = resData else { return }
                self.noticeDetail = serverData
            }
        }
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if noticeType == 0 {
            self.dismiss(animated: true, completion: nil)
        }else{
            let vc = MainSB.instantiateViewController(withIdentifier: "PinPlNoticeVC") as! PinPlNoticeVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            noticeType = 0
            noticeGidx = 0 
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    
    @IBAction func delAction(_ sender: UIButton) {
        
        //마스터 및 최고관리자는 수정가능
        if (userInfo.author == 1 || userInfo.author == 2) {
            let vc = MainSB.instantiateViewController(withIdentifier: "NoticeDelPopUp") as! NoticeDelPopUp
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            if noticeType  > 0 {
                vc.sid = noticeGidx
            }else{
                vc.sid = noticeDetail.sid
            }
            self.present(vc, animated: true, completion: nil)
            
        }else{
            if noticeDetail.empsid == userInfo.empsid {
                let vc = MainSB.instantiateViewController(withIdentifier: "NoticeDelPopUp") as! NoticeDelPopUp
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                if noticeType  > 0 {
                    vc.sid = noticeGidx
                }else{
                    vc.sid = noticeDetail.sid
                }
                self.present(vc, animated: true, completion: nil)
            }else{
                self.customAlertView("본인이 작성한 게시물만 삭제 가능합니다.")
            }
        }
        
        
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        print("\n---------- [ noticeDetail : \(noticeDetail.toJSON()) ] ----------\n")
        if noticeDetail.type == 1 {
            if (userInfo.author == 1 || userInfo.author == 2) {
                let vc = MainSB.instantiateViewController(withIdentifier: "EditNoticeVC") as! EditNoticeVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                vc.noticeDetail = noticeDetail
                self.present(vc, animated: true, completion: nil)
            }else{
                if noticeDetail.empsid == userInfo.empsid {
                    let vc = MainSB.instantiateViewController(withIdentifier: "EditNoticeVC") as! EditNoticeVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.noticeDetail = noticeDetail
                    self.present(vc, animated: true, completion: nil)
                }else{
                    self.customAlertView("본인이 작성한 게시물만 수정 가능합니다.")
                }
            } 
            
        }else{
            let vc = MainSB.instantiateViewController(withIdentifier: "NoticeNotEditPopup") as! NoticeNotEditPopup
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
             
        }
    }
    
}
