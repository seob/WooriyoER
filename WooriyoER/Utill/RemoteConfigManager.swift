//
//  RemoteConfigManager.swift
//  PinPle
//
//  Created by seob on 2020/02/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class RemoteConfigManager: NSObject {
    
    static let sharedManager = RemoteConfigManager()
    override private init() {}
    let prefs = UserDefaults.standard
    let deviceInfo = DeviceInfo()
    
    public func loadAppInfo(finished : @escaping (_ need: Bool)->Void){
        
//        NetworkManager.shared().AppVersionCheck(mode: 1, appvs: deviceInfo.APPVS) { (isSuccess, resUpdate, resMsg , resCurver) in
//            if(isSuccess){
//                appData.update = resUpdate //업데이트 강제 여부
//                appData.updateMsg = resMsg // 업데이트 메세지
//                appData.version = resCurver // 서버 버전
//                finished(true)
//            }
//        }
    }
    
    
    public func launching(completionHandler: @escaping (_ conf: AppData) -> (), forceUpdate:@escaping (_ need: Bool)->()){
        print("\n---------- [ server app : \(appData.version) , current app : \(appData.currentVersion) ] ----------\n")
        if appData.needUpdate {
            
            if appData.update == 0 {
                // 선택업데이트
                forceUpdate(true)
                
                let alertController = UIAlertController.init(title: "업데이트", message: "\(appData.updateMsg)", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction.init(title: "업데이트", style: UIAlertAction.Style.default, handler: { (action) in
                    // 앱스토어마켓으로 이동
                    self.openAppStore()
                }))
                alertController.addAction(UIAlertAction.init(title: "나중에", style: UIAlertAction.Style.default, handler: { (action) in
                    // 앱으로 진입
                    
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        
                        while let presentedViewController = topController.presentedViewController {
                            
                            topController = presentedViewController
                            
                        }
                        var vc = UIViewController()
                        if userInfo.mbrsid > 0 {
                            if userInfo.author == 5 {
                                let alert = UIAlertController.init(title: "알림", message: "권한이 없습니다. 근로자 앱으로 이동합니다.", preferredStyle: .alert)
                                let okAction = UIAlertAction.init(title: "확인", style: .default, handler: { action in
                                    let pinplURL = URL(string: "pinpl://")!
                                    
                                    if UIApplication.shared.canOpenURL(pinplURL) {
                                        UIApplication.shared.open(pinplURL, options: [:], completionHandler: nil)
                                    } else {
                                        UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/apple-store/id1493507438")!, options: [:], completionHandler: nil)
                                    }
                                })
                                let cancel = UIAlertAction.init(title: "종료", style: .cancel, handler: { action in
                                    //                    exit(0)
                                    
                                    if SE_flag {
                                        let vc = LoginSignSB.instantiateViewController(withIdentifier: "SE_LoginVC") as! LoginVC
                                        vc.modalTransitionStyle = .crossDissolve
                                        vc.modalPresentationStyle = .overFullScreen
                                        topController.present(vc, animated: false, completion: nil)
                                    }else {
                                        let vc = LoginSignSB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                        vc.modalTransitionStyle = .crossDissolve
                                        vc.modalPresentationStyle = .overFullScreen
                                        topController.present(vc, animated: false, completion: nil)
                                    }
//                                    let vc = UIStoryboard(name: "LoginSign", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//                                    vc.modalTransitionStyle = .crossDissolve
//                                    vc.modalPresentationStyle = .overFullScreen
//                                    topController.present(vc, animated: false, completion: nil)
                                })
                                alert.addAction(cancel)
                                alert.addAction(okAction)
                                topController.present(alert, animated: true, completion: nil)
                            }else{
                                if userInfo.joindt == "1900-01-01" {
                                    if let stage = self.prefs.value(forKey: "stage") as? Int {
                                        if userInfo.cmpsid == 0 && stage == 1 {
                                            vc = LoginSignSB.instantiateViewController(withIdentifier: "SelMgrEmp")
                                        }else if userInfo.cmpsid == 0 && stage == 2 {
                                            vc = LoginSignSB.instantiateViewController(withIdentifier: "AddInfo")
                                        }else if userInfo.cmpsid == 0 && stage == 3 {
                                            vc = CmpCrtSB.instantiateViewController(withIdentifier: "CmpVC")
                                        }else if stage == 4 {
                                            vc = CmpCrtSB.instantiateViewController(withIdentifier: "CmpInfoVC")
                                        }else if stage == 5 {
                                            vc = CmpCrtSB.instantiateViewController(withIdentifier: "RegMgrVC")
                                        }else if stage == 6 {
                                            vc = CmpCrtSB.instantiateViewController(withIdentifier: "CmpTtmListVC")
                                        }else if stage == 7 {
                                            vc = CmpCrtSB.instantiateViewController(withIdentifier: "WTInfoVC")
                                        }else if stage == 8 {
                                            vc = CmpCrtSB.instantiateViewController(withIdentifier: "CmpWTimeVC")
                                        }else if stage == 9 {
                                            vc = TmCrtSB.instantiateViewController(withIdentifier: "TemFirstlVC")
                                        }else if stage == 10 {
                                            vc = TmCrtSB.instantiateViewController(withIdentifier: "TemCrtVC")
                                        }else if stage == 11 {
                                            vc = TmCrtSB.instantiateViewController(withIdentifier: "TemCmpltVC")
                                        }else if stage == 12 {
                                            vc = TmCrtSB.instantiateViewController(withIdentifier: "TtmCrtVC")
                                        }else if stage == 13 {
                                            vc = TmCrtSB.instantiateViewController(withIdentifier: "TtmCmpltVC")
                                        }else if stage == 14 {
                                            vc = TmCrtSB.instantiateViewController(withIdentifier: "ExcldWorkVC")
                                        }else {
                                            if SE_flag {
                                                vc = TmCrtSB.instantiateViewController(withIdentifier: "SE_InfoSet")
                                            }else {
                                               vc = TmCrtSB.instantiateViewController(withIdentifier: "InfoSet")
                                            }
                                        }
                                    }else if userInfo.cmpsid == 0 {
                                        vc = LoginSignSB.instantiateViewController(withIdentifier: "SelMgrEmp")
                                    }else {
                                        if self.prefs.value(forKey: "intro") != nil {
                                            if SE_flag {
                                                vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC")
                                            }else {
                                                vc = MainSB.instantiateViewController(withIdentifier: "MainVC")
                                            }
                                        }else {
                                            if SE_flag {
                                                vc = IntroSB.instantiateViewController(withIdentifier: "SE_IntroVC1")
                                            }else {
                                                vc = IntroSB.instantiateViewController(withIdentifier: "IntroVC1")
                                            }
                                        }
                                    }
                                }else if userInfo.cmpsid == 0 {
                                    vc = LoginSignSB.instantiateViewController(withIdentifier: "SelMgrEmp")
                                }else {
                                    if self.prefs.value(forKey: "intro") != nil {
                                        if SE_flag {
                                            vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC")
                                        }else {
                                            vc = MainSB.instantiateViewController(withIdentifier: "MainVC")
                                        }
                                    }else {
                                        if SE_flag {
                                            vc = IntroSB.instantiateViewController(withIdentifier: "SE_IntroVC1")
                                        }else {
                                            vc = IntroSB.instantiateViewController(withIdentifier: "IntroVC1")
                                        }
                                    }
                                }
                            } 
                        }else{
                            vc = LoginSignSB.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchVC
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        topController.present(vc, animated: false, completion: nil)
                        
                    }
                }))
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    topController.present(alertController, animated: false, completion: nil)
                }
            }else{
                // 강제업데이트
                forceUpdate(true)
                let alertController = UIAlertController.init(title: "업데이트", message: "\(appData.updateMsg)", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction.init(title: "업데이트", style: UIAlertAction.Style.default, handler: { (action) in
                    // 앱스토어마켓으로 이동
                    self.openAppStore()
                }))
                
            }
        }
    }
    
    private func openAppStore(){
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: appData.updateURL)!)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL(string: appData.updateURL)!)
            }
        }
        
    }
    
}
