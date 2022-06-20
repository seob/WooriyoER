//
//  AppDelegate.swift
//  PinPle
//
//  Created by WRY_010 on 12/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import NaverThirdPartyLogin
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import CoreLocation
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import AuthenticationServices
import Toast_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,  CLLocationManagerDelegate {
    
    
    var window: UIWindow?
    var loginMainViewController = LoginVC()
    var lauchViewController = LaunchVC()
    let prefs = UserDefaults.standard
    let gcmMessageIDKey = "gcm.message_id"
    var locationManager = CLLocationManager()
    var backgroundState: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        sleep(3)
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        // 디바이스 SE 체크
        if UIScreen.main.bounds.size.height == 568 {
            SE_flag = true
        }else {
            SE_flag = false
        } 
        
        //구글 맵
        GMSServices.provideAPIKey(googlePlaceAPIKey)
        GMSPlacesClient.provideAPIKey(googlePlaceAPIKey)
        
         
        
        //푸쉬알림
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        self.window?.backgroundColor = .white
        let navigation = UINavigationBar.appearance()
        
        let navigationFont = UIFont(name: "NotoSansCJKkr-DemiLight", size: 22)
        let navigationLargeFont = UIFont(name: "NotoSansCJKkr-DemiLight", size: 22) //34 is Large Title size by default
        
        navigation.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: navigationFont!]
        
        if #available(iOS 11, *){
            navigation.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: navigationLargeFont!]
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0 
        resultParam = ""
        IQKeyboardManager.shared.enable = true
         
 
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
        checkWifi() 
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        KOSession.handleDidEnterBackground()
        checkWifi()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
        backgroundState = true
        KOSession.handleDidBecomeActive()
        checkWifi()
        
        print("\n---------- [ resultParam : \(resultParam) ] ----------\n")
        if resultParam != "" {
            //            Toast(text: "성공여부 \(resultParam)",  duration: Delay.short).show()
        }
        
        if resultParam == "0"  {
            let rootvc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step2VC") as! Ce_Step2VC
            self.window = UIWindow.init(frame: UIScreen.main.bounds)
            self.window?.rootViewController = rootvc
            if #available(iOS 13.0, *) {
                self.window?.overrideUserInterfaceStyle = .light
            }
            resultParam = ""
            self.window?.makeKeyAndVisible()
        }else if resultParam == "1"  {
            switch moreCmpInfo.freetype {
                case 2,3:
                    //올프리 , 펀프리
                    if moreCmpInfo.freedt >= muticmttodayDate() {
                        let rootvc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step3_FreeVC") as! Ce_Step3_FreeVC
                        self.window = UIWindow.init(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = rootvc
                        if #available(iOS 13.0, *) {
                            self.window?.overrideUserInterfaceStyle = .light
                        }
                        resultParam = ""
                        self.window?.makeKeyAndVisible()
                    }else{
                        let rootvc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step3VC") as! Ce_Step3VC
                        self.window = UIWindow.init(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = rootvc
                        if #available(iOS 13.0, *) {
                            self.window?.overrideUserInterfaceStyle = .light
                        }
                        resultParam = ""
                        self.window?.makeKeyAndVisible()
                    }
                default :
                    let rootvc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step3VC") as! Ce_Step3VC
                    self.window = UIWindow.init(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = rootvc
                    if #available(iOS 13.0, *) {
                        self.window?.overrideUserInterfaceStyle = .light
                    }
                    resultParam = ""
                    self.window?.makeKeyAndVisible()
            }
 
        }
        
    }
    
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications ")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        locationManager.requestWhenInUseAuthorization()
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
        guard let scheme = url.scheme else { return true }
        
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        print("\n---------- [ scheme : \(scheme) ] ----------\n")
        if scheme.contains("com.googleusercontent.apps")
        {
            return GIDSignIn.sharedInstance().handle(url)
        }
        else if scheme.contains("com.wooriyo.WooriyoER")
        {
            let result = NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)
            if result == CANCELBYUSER {
                print("result: \(result)")
            }
            return true
        }else if scheme.contains("wooriyoer"){
            let urlStr = url.absoluteString //1
            let component = urlStr.components(separatedBy: "=") // 2
            if component.count > 1, let productId = component.last { // 3
                resultParam = productId
                //                    Toast(text: "성공여부 \(resultParam)",  duration: Delay.short).show()
                if resultParam == "0"  {
                    let rootvc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step2VC") as! Ce_Step2VC
                    self.window = UIWindow.init(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = rootvc
                    if #available(iOS 13.0, *) {
                        self.window?.overrideUserInterfaceStyle = .light
                    }
                    self.window?.makeKeyAndVisible()
                }else if resultParam == "1"  {
                    let rootvc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step3VC") as! Ce_Step3VC
                    self.window = UIWindow.init(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = rootvc
                    if #available(iOS 13.0, *) {
                        self.window?.overrideUserInterfaceStyle = .light
                    }
                    self.window?.makeKeyAndVisible()
                }
            }
            
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        guard let scheme = url.scheme else { return true }
        
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        print("\n---------- [ scheme 2: \(scheme) ] ----------\n")
        if scheme.contains("com.googleusercontent.apps")
        {
            return GIDSignIn.sharedInstance().handle(url)
        }
        else if scheme.contains("com.wooriyo.WooriyoER")
        {
            let result = NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)
            if result == CANCELBYUSER {
                print("result: \(result)")
            }
            return true
        }else if scheme.contains("wooriyoer"){
            let urlStr = url.absoluteString //1
            let component = urlStr.components(separatedBy: "=") // 2
            if component.count > 1, let productId = component.last { // 3
                resultParam = productId
                //                Toast(text: "성공여부 \(resultParam)",  duration: Delay.short).show()
                if resultParam == "0"  {
                    let rootvc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step2VC") as! Ce_Step2VC
                    self.window = UIWindow.init(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = rootvc
                    if #available(iOS 13.0, *) {
                        self.window?.overrideUserInterfaceStyle = .light
                    }
                    self.window?.makeKeyAndVisible()
                }else if resultParam == "1"  {
                    let rootvc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step3VC") as! Ce_Step3VC
                    self.window = UIWindow.init(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = rootvc
                    if #available(iOS 13.0, *) {
                        self.window?.overrideUserInterfaceStyle = .light
                    }
                    self.window?.makeKeyAndVisible()
                }
            }
            
            return true
        }
        return false
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        isVersionCnt = 0 // 앱을 종료하고 재시작할경우 버전 체크 위해서
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("\n---------- [ userInfo : \(userInfo) ] ----------\n")
        
        var type = userInfo["type"] as! String
        print("type = ", type)
        let aps = userInfo["aps"] as! NSDictionary
        print("aps = ", aps)
        let alert = aps["alert"] as! NSDictionary
        print("alert = ", alert)
        let title = alert["title"] as! String
        print("title = ", title)
        let body = alert["body"] as? String ?? ""
        print("body = ", body)
        //        loginMainViewController.configureAppearance()
//        Toast(text: "우리요 관리자\n \(body)",  duration: Delay.short).show()
        
        if type.contains(",") {
            let notiType = type.components(separatedBy: ",")
            noticeGidx = Int(notiType[1]) ?? 0
            noticeType = Int(notiType[0]) ?? 0
            type = notiType[0]
            print("\n---------- [ 111 : \(type) , noticeGidx :\(noticeGidx) , notiType :\(notiType)] ----------\n")
        }
         
        
        self.window?.makeToast("우리요 관리자\n \(body)", duration: 3.0, position: .bottom)
        
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("\n---------- [ userInfo : \(userInfo) ] ----------\n")
        var type = userInfo["type"] as! String
        print("type = ", type)
        let aps = userInfo["aps"] as! NSDictionary
        print("aps = ", aps)
        let alert = aps["alert"] as! NSDictionary
        print("alert = ", alert)
        let title = alert["title"] as! String
        print("title = ", title)
        let body = alert["body"] as? String ?? ""
        print("body = ", body)
          
        if type.contains(",") {
            let notiType = type.components(separatedBy: ",")
            noticeGidx = Int(notiType[1]) ?? 0
            noticeType = Int(notiType[0]) ?? 0
            type = notiType[0]
            print("\n---------- [ 111 : \(type) , noticeGidx :\(noticeGidx) , notiType :\(notiType)] ----------\n")
        }
         
        
        var rootvc = UIViewController()
 
        rootvc = UIStoryboard.init(name: "LoginSign", bundle: nil).instantiateViewController(withIdentifier: "LaunchVC") as! LaunchVC
        notitype = type 
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootvc
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        self.window?.makeKeyAndVisible()
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        self.prefs.setValue(fcmToken, forKey: "fcmToken")
        
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

// MARK: checkWifi
extension AppDelegate {
    func shardInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // wifi check
    func checkWifi() {
        print("\n---------- [ userinfo : \(userInfo.toJSON()) ] ----------\n")
        var nowmac = ""
        var nownm = ""
        locationCheck()
        let wifiConnet = WifiNetwork().connecteToNetwork()
        if wifiConnet {
            let wifiInfo = WifiNetwork().getWifiInfo()
            Ipify.getPublicIPAddress { result in
                switch result {
                    case .success(let ip):
                        
                        GlobalShareManager.shared().setLocalData(ip, forKey: "appIp")
                        print("\n---------- [ now ip :\(ip) ] ----------\n")
                    case .failure(let error):
                        print(error)
                }
            }
            
            if let tmpnowmac = wifiInfo["BSSID"] as? String{
                GlobalShareManager.shared().setLocalData(tmpnowmac, forKey: "appBSSID")
                nowmac = tmpnowmac
            }
            
            if let tmpnownm = wifiInfo["SSID"] as? String{
                GlobalShareManager.shared().setLocalData(tmpnownm, forKey: "appSID")
                nownm = tmpnownm
            }
            GlobalShareManager.shared().setLocalData(nownm, forKey: "appNowWifiNm")
            
        }
    }
    func locationCheck(){
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            GlobalShareManager.shared().setLocalData("authorizedWhenInUse", forKey: "LocationStatus")
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            GlobalShareManager.shared().setLocalData("authorizedWhenInUse", forKey: "LocationStatus")
        case .denied:
            print("I'm sorry - I can't show location. User has not authorized it")
            GlobalShareManager.shared().setLocalData("denied", forKey: "LocationStatus")
        case .restricted:
            GlobalShareManager.shared().setLocalData("restricted", forKey: "LocationStatus")
        default:
         break
        }
    }
    
    func muticmttodayDate() -> String {
        let date = Date() // 현재 시간 가져오기
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko") // 로케일 변경
        formatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: date)
        
        return dateString
    }
}
