//
//  SettingVC.swift
//  PinPle_EE
//
//  Created by WRY_010 on 2019/12/20.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import CommonCrypto
import Firebase
import GoogleSignIn
import NaverThirdPartyLogin

class Setting: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @IBAction func barBack(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelMgrEmp") as! SelMgrEmp
           vc.modalTransitionStyle = .crossDissolve
           vc.modalPresentationStyle = .overFullScreen
           self.present(vc, animated: false, completion: nil)
       }
    
    //비밀번호 변경
    @IBAction func passChangeClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PassChange") as! PassChange
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    //푸쉬알림 설정
    @IBAction func PushNotiClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PushNotiVC") as! PushNotiVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    //핀플 문의하기
    @IBAction func PinpleClick(_ sender: UIButton) {
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
    //2020.01.20 ohsan 버전정보 추가
    // FIXME: -  버전체크(서버에서 버전체크하게 수정) - 2020.03.27 seob
    @IBAction func versionInfoClick(_ sender: UIButton) {
        print("--------------[versionInfoClick]---------------")
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
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
                    // 상용
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
        let alert = UIAlertController(title: "알림", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {action in self.logout()})
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancel)
        self.present(alert, animated: false, completion: nil)
    }
    func logout() {
        let loginType = prefs.value(forKey: "loginType") as? String ?? ""
        
        isVersionCnt = 0
        isVersionCheck = false
        
        print("\n---------- [ isVersionCnt : \(isVersionCnt) isVersionCheck:\(isVersionCheck)] ----------\n")
        
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

        for key in UserDefaults.standard.dictionaryRepresentation().keys { 
            UserDefaults.standard.removeObject(forKey: key.description)
        }

        userInfo = MbrInfo()
        CompanyInfo = CmpInfo()
        
        let vc = UIStoryboard(name: "LoginSign", bundle: nil).instantiateViewController(withIdentifier: "LaunchVC") as! LaunchVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func SecessionClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "알림", message: "탈퇴 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {action in self.secedeMbr()})
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancel)
        self.present(alert, animated: false, completion: nil)
    }
    func secedeMbr() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(회원탈퇴).. 직원의 경우 퇴사처리 됨
         Return  - 탈퇴처리 결과 1.성공 0.실패
         Parameter
         MBRSID        회원번호
         SK            인증코드(회원번호 SHA1 암호화 해서 넘김)
         */
        let mbrsid = userInfo.mbrsid
        let sk = String(mbrsid).sha1()
        
        NetworkManager.shared().SecedeMbr(mbrsid: mbrsid, sk: sk) { (isSuccess, resCode) in
            if(isSuccess){
                
                switch resCode {
                case 1:
                    self.toast("이용해주셔서 감사합니다. 정상 탈퇴 처리 되었습니다.")
                    self.logout()
                case 0:
                    self.customAlertView("회원탈퇴에 실패 하였습니다.")
                case -1:
                    self.customAlertView("회원정보가 없거나 이미 탈퇴된 회원입니다.")
                case -2:
                    self.customAlertView("회사대표의 경우 모두 퇴직처리 후 이용 가능합니다.")
                case -3:
                    self.customAlertView("결재라인 해제 후 이용 가능합니다.")
                default:
                    self.customAlertView("회원탈퇴에 실패 하였습니다.")
                break
                }
            }else{
                self.customAlertView("다시 시도해 주세요")
            }
        }
        
    }
    
}
