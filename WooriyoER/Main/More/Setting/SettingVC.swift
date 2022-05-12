//
//  SettingVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/12/04.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import CommonCrypto
import Firebase
import GoogleSignIn
import NaverThirdPartyLogin

class SettingVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()

    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    //내정보 수정
    @IBAction func EmpInfoClick(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "UdtMbrInfoVC") as! UdtMbrInfoVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    //2020.01.20 ohsan 비밀번호 변경 추가
    //비밀번호 변경
    @IBAction func passChangeClick(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "PassChange") as! PassChange
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    //푸시알림 설정
    @IBAction func PushNotiClick(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "PushNotiVC") as! PushNotiVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    //핀플 문의하기
    @IBAction func PinpleClick(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "PinplAskVC") as! AskVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_PinplAskVC") as! AskVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "PinplAskVC") as! AskVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    //광고 문의하기
    @IBAction func AdClick(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "AdAskVC") as! AskVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_AdAskVC") as! AskVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "AdAskVC") as! AskVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    //유료기능 설정
    @IBAction func PayClick(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "PayVC") as! PayVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_PayVC") as! PayVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "PayVC") as! PayVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    //2020.01.21 ohsan 버전정보 추가
    //버전정보
    @IBAction func versionInfoClick(_ sender: UIButton) {
        print("--------------[versionInfoClick]---------------")
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
//        let appId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
//        print("--------------[version : \(version!)]---------------")
//        print("--------------[version : \(appId!)]---------------")
//        let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(appId!)")!
//
//        if let data = try? Data(contentsOf: url) {
//            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
//                if let results = json["results"] as? [[String: Any]] {
//                    if results.count > 0 {
//                        if let appStoreVersion = results[0]["version"] as? String {
//                            if version == appStoreVersion {
//                                customAlertView("Ver \(version!)\n최신 버전을 이용 중입니다.")
//                            }else {
//                                customActionAlertView("Ver \(version!)\n최신 버전을 앱스토어에서 \n다운 받으시겠습니까?")
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
        NetworkManager.shared().AppVersionCheck(mode: 1, appvs: deviceInfo.APPVS) { (isSuccess, update, updatemsg, curver , review) in
            if(isSuccess){
                guard let verSion = version else { return }
                if review == 0 {
                    //상용
                    if verSion != curver {
                        self.customActionAlertView("Ver \(curver)\n최신 버전을 앱스토어에서 \n다운 받으시겠습니까?")
                    }else{
                        self.customAlertView("Ver \(curver)\n최신 버전을 이용 중입니다.")
                    }
                }else{
                    // 리뷰기간
                    self.customAlertView("Ver \(curver)\n최신 버전을 이용 중입니다.")
                }
 
            }
        }
    }
    
    @IBAction func LogoutClick(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "로그아웃을 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {action in self.logout()})
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancel)
        self.present(alert, animated: false, completion: nil)
    }
    func logout() {
        prefs.setValue("email", forKey: "loginType")
        let loginType = prefs.value(forKey: "loginType") as! String
        
        isVersionCnt = 0
        isVersionCheck = false
        
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
        userInfo = MbrInfo()    
        CompanyInfo = CmpInfo()
        
        let vc = LoginSignSB.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func SecessionClick(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "계정삭제시 회원님의 모든정보가\n삭제됩니다. 계정을 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        
        //to change font of title and message.
        let messageFont = [kCTFontAttributeName: UIFont(name: "NotoSansCJKkr-DemiLight", size: 15.0)!]
        let messageAttrString = NSMutableAttributedString(string: "계정삭제시 회원님의 모든정보가\n삭제됩니다. 계정을 삭제하시겠습니까?", attributes: messageFont as [NSAttributedString.Key : Any])
        
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {action in self.secedeMbr()})
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancel)
        self.present(alert, animated: false, completion: nil)
    }
    func secedeMbr() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(회원탈퇴).. 직원의 경우 퇴사처리 됨
         Return  - 성공 : 1, 실패 : 0  회원정보없음(이미탈퇴) : -1, 회사대표 직원있는경우(모두 퇴직처리 후 가능) : -2, 결재라인(결재라인 변경 후 가능) : -3
         Parameter
         MBRSID        회원번호
         SK            인증코드(회원번호 SHA1 암호화 해서 넘김)
         */
//        let mbrsid = prefs.value(forKey: "mbrsid") as! Int
        let mbrsid = userInfo.mbrsid
        let sk = String(mbrsid).sha1() 

        NetworkManager.shared().SecedeMbr(mbrsid: mbrsid, sk: sk) { (isSuccess, resCode) in
            if(isSuccess){
                
                switch resCode {
                case 1:
                    self.logout()
                case 0:
                    self.toast("회원탈퇴에 실패 하였습니다.")
                case -1:
                    self.toast("회원정보가 없거나 이미 탈퇴된 회원입니다.")
                case -2:
                    self.toast("회사대표 직원이 있는 경우 모두 퇴직처리 후 이용 가능합니다.")
                case -3:
                    self.toast("결재라인 변경 후 이용 가능합니다.")
                default:
                    self.toast("다시 시도해 주세요")
                }
            }else{
                self.customAlertView("다시 시도해 주세요")
            }
        }
    }
    
}
