//
//  LaunchVC.swift
//  PinPle
//
//  Created by WRY_010 on 12/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import CommonCrypto
import Firebase
import GoogleSignIn
import NaverThirdPartyLogin

class LaunchVC: UIViewController {
    
    var loginType: String = "" // 로그인 타입
    var email: String = ""// 자동로그인 용 email(id)
    var pass: String = "" // 자동로그인 용 pass
    var snsid: String = "" // 자동로그인 sns 고유id
    var disposeBag: DisposeBag = DisposeBag()
     
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tmploginType = prefs.value(forKey: "loginType") as? String {
            self.loginType = tmploginType
        }
        
        if let tmpemail = prefs.value(forKey: "login_email") as? String {
            self.email = tmpemail
        }
        
        if let tmppass = prefs.value(forKey: "login_pass") as? String {
            self.pass = tmppass
        }
        
 
        
        let oriGoogle = (prefs.value(forKey: "googleid") as? String ?? "").base64Encoding()
        if oriGoogle != "" {
            self.snsid = (prefs.value(forKey: "googleid") as? String ?? "").base64Encoding()
             
        }else{
            self.snsid = (prefs.value(forKey: "id") as? String ?? "").base64Encoding()
        }
        
//
//        print("email = \(email)\n pass = \(pass)\n osvs = \(deviceInfo.OSVS)\n appvs = \(deviceInfo.APPVS)\n md = \(deviceInfo.MD) \n loginType = \(loginType)")
    }
    
    // MARK: -  버전체크
    func versionCheck(){
        isVersionCnt += 1
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        NetworkManager.shared().AppVersionCheck(mode: 1, appvs: deviceInfo.APPVS) { (isSuccess, update, updatemsg, curver , review) in
            if(isSuccess){
                if review == 0 {
                    // 상용
                    isReviewStatus = 0
                }else{
                    // 리뷰기간
                    isReviewStatus = 1
                }
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        versionCheck()
        self.loadAppInfo {
            print("\n---------- [ viewDidAppear cmpsid : \(userInfo.cmpsid) ] ----------\n")
            if userInfo.cmpsid > 0 {
                self.getCmpInfo() {
                    if notitype != "" {
                        self.notiGoApp()
                    }else {
                        self.goApp()
                    }
                }
            }else{
                self.goApp()
            }
            
        }
    }
    // 회사 정보 불러오기
    func getCmpInfo(finished : @escaping ()-> Void) {
        print("\n---------- [ cmpsid : \(userInfo.cmpsid) ] ----------\n")
        NetworkManager.shared().getCmpInfo(cmpsid: userInfo.cmpsid) { (isSuccess, errCode ,resData) in
            if (isSuccess) {
                if errCode == 99 {
                    self.customAlertView("다시 시도해 주세요.")
                }else{
                    guard let serverData = resData else { return }
                    CompanyInfo = serverData
                }
                
            }else{
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
            finished()
        }
    }
    func loadAppInfo(finished : @escaping ()-> Void) {
        
        var snstype = 0
        
        if loginType == "naver" {
            snstype = 1
        }else if loginType == "google" {
            snstype = 2
        }else if loginType == "kakao" {
            snstype = 3
        }else if loginType == "apple" {
            snstype = 4
        }else {
            snstype = 5
        }
         
        let fid = (prefs.value(forKey: "fid") as? String ?? "").base64Encoding()
        
        // apple id 가없거나 firebase id 가 없으면 캐시삭제 후 로그인으로 이동 - 2020.12.17  seob
        if loginType == "apple" {
//            if(snsid == "" || fid == ""){
//                KeychainItem.currentUserIdentifier = nil
//                KeychainItem.currentUserFirstName = nil
//                KeychainItem.currentUserLastName = nil
//                KeychainItem.currentUserEmail = nil
//     
//                for key in UserDefaults.standard.dictionaryRepresentation().keys {
//                    UserDefaults.standard.removeObject(forKey: key.description)
//                }
//            }
        }
        
        NetworkManager.shared().checkMbr(type: snstype, id: snsid, fid:fid, email: email, pass: pass, mode: 1, osvs: deviceInfo.OSVS, appvs: deviceInfo.APPVS, md: deviceInfo.MD) { (isSuccess, resData) in
            if (isSuccess){
                guard let serverData = resData else {  return   }
                userInfo = serverData
                prefs.setValue(serverData.ttmsid, forKey: "cmt_ttmsid")
                prefs.setValue(serverData.temsid, forKey: "cmt_temsid")
                prefs.setValue(serverData.ttmname, forKey: "cmt_temname")
                prefs.setValue(serverData.temname, forKey: "temname")

                /***************************************************
                 2020.01.10 seob
                 - 기존에 empsid를 너무 많이사용하고 있어서 연차 결재 & 출장 결재에 사용하기 위해
                 따로 추가해서 만듭니다.
                 ***************************************************/
                prefs.setValue(serverData.empsid, forKey: "Newempsid")
            }else{
                self.customAlertView("네트워크 상태를 확인해 주세요.")

            }
            finished()
        }
        
    }
    //앱 실행
    func goApp() {
        let mbrsid = userInfo.mbrsid
        let author = userInfo.author
        let cmpsid = userInfo.cmpsid
        let joindt = userInfo.joindt
        
        if(mbrsid > 0){
            self.setPushId(mbrsid: mbrsid)
            
            if author == 5 {
                let alert = UIAlertController.init(title: "알림", message: "권한이 없습니다. 근로자 앱으로 이동합니다.", preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "확인", style: .default, handler: { action in
                    
                    let pinplURL = URL(string: "WooriyoEE://")!
                    
                    if UIApplication.shared.canOpenURL(pinplURL) {
                        UIApplication.shared.open(pinplURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/apple-store/id1624398964")!, options: [:], completionHandler: nil)
                    }
                })
                let cancel = UIAlertAction.init(title: "종료", style: .cancel, handler: { action in
                    //                    exit(0)
                    if SE_flag {
                        let vc = LoginSignSB.instantiateViewController(withIdentifier: "SE_LoginVC") as! LoginVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    }else {
                        let vc = LoginSignSB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    }
                })
                alert.addAction(cancel)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else {
                self.viewMove(joindt: joindt, cmpsid: cmpsid)
//                self.viewMove(joindt: "1900-01-01", cmpsid: cmpsid)

            }
        }else{
            if SE_flag {
                let vc = LoginSignSB.instantiateViewController(withIdentifier: "SE_LoginVC") as! LoginVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)
            }else {
                let vc = LoginSignSB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    
    func notiGoApp() {
        var vc1 = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        var vc2 = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
        var vc3 = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        var vc4 = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        let vc5 = ContractSB.instantiateViewController(withIdentifier: "Lc_ListVC") as! Lc_ListVC
        let vc6 = MoreSB.instantiateViewController(withIdentifier: "HomeMTTListVC") as! HomeMTTListVC //재택 출퇴근 설정내역
        let vc7 = CertifiSB.instantiateViewController(withIdentifier: "CertifiCateMainVC") as! CertifiCateMainVC //재증명서 메인
        let vc8 = SecurtSB.instantiateViewController(withIdentifier: "Sc_ListVC") as! Sc_ListVC
        let vc9 = MainSB.instantiateViewController(withIdentifier: "PinPlNoticeVC") as! PinPlNoticeVC
        let vc10 = MainSB.instantiateViewController(withIdentifier: "NoticeDetailVC") as! NoticeDetailVC
        
        if SE_flag {
            vc1 = MainSB.instantiateViewController(withIdentifier: "SE_MainVC") as! MainVC
            vc2 = CmpCmtSB.instantiateViewController(withIdentifier: "SE_CmtEmpList") as! CmtEmpList
            vc3 = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
            vc4 = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
        }
        
        var rootvc = UIViewController()
        
        //관리자 수신
//         static final public int PUSH_MGR_CMT_CHK = 10; //직원 출퇴근 알림
//         static final public int PUSH_MGR_ANL_APR = 20; //연차신청 결재 알림
//         static final public int PUSH_MGR_ANL_REF = 21; //연차신청 참조 알림
//         static final public int PUSH_MGR_APL_APR = 22; //출장,근로신청 결재 알림
//         static final public int PUSH_MGR_APL_REF = 23; //출장,근로신청 참조 알림
//         static final public int PUSH_MGR_EMP_JOIN = 30; //직원 합류 알림
//         static final public int PUSH_MGR_TEM_JOIN = 31; //직원 팀추가 알림
//         static final public int PUSH_MGR_TEM_ECPT = 32; //직원 팀해제 알림
//         static final public int PUSH_MGR_EMP_LEV = 33; //직원 퇴직처리 알림
//         static final public int PUSH_MGR_DLG_MST = 30; //마스터관리자 권한 위임 알림, 구버전 때문에 직원합류 알림과 동일한 타입 사용
//         static final public int PUSH_MGR_LC_REJECT = 40; //근로계약서 서명 거절 .. 최고관리자, 인사관리자 수신
//         static final public int PUSH_MGR_LC_SIGN = 41; //근로계약서 서명 완료.. 최고관리자, 인사관리자 수신

        
//        static final public int PUSH_MGR_SC_REJECT = 53; //보안서약서 서명 거절 .. 마스터관리자, 인사관리자 수신
//        static final public int PUSH_MGR_SC_SIGN = 54; //보안서약서 서명 완료.. 마스터관리자, 인사관리자 수신
//        static final public int PUSH_USER_SC_SND = 53; //보안서약서 발급 알림
        
        switch notitype {
        case "10": 
            rootvc = vc2
        case "20", "21":
            rootvc = vc3
        case "22", "23", "24", "25":
            rootvc = vc4
        case "30", "31", "32":
            rootvc = vc1
        case "34", "35":
            rootvc = vc6
        case "40" , "41" : //근로계약서 서명 거절 , 완료 - 권한 인사담당자만
            rootvc = vc5 //서명완료
        case "42", "43":
            rootvc = vc7
        case "53" , "54":
            rootvc = vc8
        case "1","2" :
            if noticeGidx > 0 {
                rootvc = vc10
            }else{
                rootvc = vc9
            }
             
        default:
            rootvc = vc1;
        }
         
         
        rootvc.modalTransitionStyle = .crossDissolve
        rootvc.modalPresentationStyle = .overFullScreen
        self.present(rootvc, animated: false, completion: nil)
    }
    
    func logout() {
        prefs.setValue("email", forKey: "loginType")
        let loginType = prefs.value(forKey: "loginType") as! String
        
        switch loginType {
        case "google":
            //구글연동 해제
            print("google 해제")
            GIDSignIn.sharedInstance().signOut();
        case "naver":
            //네이버연동 해제
            print("naver 해제")
            NaverThirdPartyLoginConnection.getSharedInstance()?.requestDeleteToken();
        case "kakao":
            //카카오연동 해제
            print("kakao 해제")
            KOSession.shared()?.close();
        default:
            break;
        }
        // 탈퇴시 기존의 앱에 등록된 정보 모두 날리기 - 2020.01.08 seob
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
