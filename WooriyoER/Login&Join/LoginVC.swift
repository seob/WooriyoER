//
//  LoginVC.swift
//  PinPle
//
//  Created by WRY_010 on 12/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import Alamofire
import NaverThirdPartyLogin
import KakaoOpenSDK
import AuthenticationServices
import SnapKit
import CryptoKit

class LoginVC: UIViewController, GIDSignInDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var btnNaver: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnKakao: UIButton!
    
    @IBOutlet weak private var loginProviderStackView: UIStackView! //2020.01.20 apple login seob
    @IBOutlet weak var appleHeight: NSLayoutConstraint!
    @IBOutlet weak var appleEmailHeight: NSLayoutConstraint!
    
    @IBOutlet weak var logoImageView: UIImageView!
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    fileprivate var currentNonce: String?
    var userID = String()
    
    // MARK: - IndicatorSetting
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    fileprivate func IndicatorSetting() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    // MARK: - view override
    override func viewDidLoad() {
        print("\n-----------------[UIViewController : \(self) ]---------------------\n")
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidLoad()
        
        // Google Signin
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.prepareForInterfaceBuilder()
        
        //naver Signin
        loginInstance?.delegate = self
        
        //isHidden
        btnNaver.isHidden = false
        btnGoogle.isHidden = false
        btnKakao.isHidden = false
        
        //2020.01.20 apple login seob
        if #available(iOS 13.0, *) {
            // 애플 로그인 사용시 주석 풀어주세요
            setupLoginProviderView()
            if SE_flag {
                appleHeight.constant = 40
                appleEmailHeight.constant = 10
            }else {
                appleHeight.constant = 46
                appleEmailHeight.constant = 18
            }            
        } else {
            // Fallback on earlier versions
            appleHeight.constant = 0
            appleEmailHeight.constant = 0
            loginProviderStackView.isHidden = true
            return
        }
        
        let tapGestureRecognizer = UILongPressGestureRecognizer(target:self, action:#selector(imageTapped))
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(tapGestureRecognizer)

        
        
        
        
//                                KeychainItem.currentUserIdentifier = nil
//                                 KeychainItem.currentUserFirstName = nil
//                                 KeychainItem.currentUserLastName = nil
//                                 KeychainItem.currentUserEmail = nil
//        print("\n---------- [ KeychainItem.currentUserEmail : \(KeychainItem.currentUserEmail) ] ----------\n")
        //        KeychainItem.deleteUserIdentifierFromKeychain()
        
    }
  
    @objc func imageTapped(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
           self.becomeFirstResponder()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.isMster = 1
            self.present(vc, animated: false, completion: nil)
        }
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidAppear(animated)
        
        if let appDelegate = getAppDelegate() {
            appDelegate.loginMainViewController = self
        }else {
            print("Appdelegate is nil")
        }
        Spinner.stop()
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidDisappear(animated)
        Spinner.stop()
    }
    
    
    // MARK: - @IBAction
    // MARK: 이용약관
    @IBAction func termsClick(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        if let url = URL(string: "http://pinpl.biz/serviceprovision.jsp") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    // MARK: 개인정보 취급방침
    @IBAction func policy(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        if let url = URL(string: "http://pinpl.biz/privacypolicy.jsp") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    // MAKR: 이메일로 시작
    @IBAction func emailLoginClick(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    // MARK: 네이버 아이디로 시작
    @IBAction func naverLoginClick(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        loginInstance?.requestThirdPartyLogin()
    }
    // MARK: 구글 아이디로 시작
    @IBAction func googleLoginClick(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        GIDSignIn.sharedInstance()?.signIn()
    }
    // MARK: 카카오 아이디로 시작
    @IBAction func kakaoLoginClick(_ sender: AnyObject) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        guard let session = KOSession.shared() else { return }
        if session.isOpen() {
            session.close()
        }
        session.open(completionHandler: { (error) -> Void in
            if error != nil {
                print("Kakao login Error Massage : \(error?.localizedDescription ?? "")")
            }
            else if session.isOpen() {
                KOSessionTask.userMeTask{ [weak self] (error, info) in
                    if let error = error as NSError? {
                        print(error.description)
                    }else {
                        if let info = info as KOUserMe? {
                            if let name = info.nickname {
                                prefs.setValue(name, forKey: "join_name")
                            }
                            if let account = info.account {
                                if let email = account.email {
                                    print("kakao email = \(email)")
                                    prefs.setValue(email, forKey: "join_email")
                                }
                            }
                            if let id = info.id {
                                print("kakao id = \(id)")
                                prefs.setValue(id, forKey: "id")
                            }
                        }
                        prefs.setValue("kakao", forKey: "loginType")
                        
                        self?.menberCheck()
                    }
                }
            }
        })
    }
    
    // MARK: - @func
    // MARK: getAppDelegate
    func getAppDelegate() -> AppDelegate!{
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        // AppDelegate 가져오기 - Returns: AppDelegate
        return UIApplication.shared.delegate as? AppDelegate
    }
    // MARK: 구글 회원 정보 가져오기
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            }else {
                print("\(error.localizedDescription)")
            }
            return
        }
    
        var userId = ""
        var fullName =  ""
        var email = ""
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                return
            }
            print("\n---------- [ google uid :\(authResult?.user.uid) name : \(authResult?.user.displayName) email : \(authResult?.user.email)] id :\(authResult?.user.providerID)  \(user.userID)----------\n")
            if let googleuserid = authResult?.user.uid , let googleemail = authResult?.user.email{
                
                userId = googleuserid
                email = googleemail
                if let googledisplayname = authResult?.user.displayName {
                    fullName = googledisplayname
                }else{
                    fullName = ""
                }
                
                prefs.setValue(email, forKey: "join_email")
                prefs.setValue(userId, forKey: "id")
                //                prefs.setValue(user.userID, forKey: "googleid")
                prefs.setValue(email, forKey: "googleid")
                prefs.setValue(fullName, forKey: "join_name")
                prefs.setValue("google", forKey: "loginType")
                
                
                print("\n---------- [ google 2 userid : \(userId) name :\(fullName) . email : \(email) ] ----------\n")
                //                self.menberCheck()
                self.firstMemberCheck()
            }
            
        }
    }
    
    // MARK: 회원가입 체크
    func firstMemberCheck(){
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        var id = ""
        let oriGoogle = (prefs.value(forKey: "googleid") as? String ?? "").base64Encoding()
        if oriGoogle != "" {
            id = (prefs.value(forKey: "googleid") as? String ?? "").base64Encoding()
            
        }else{
            id = (prefs.value(forKey: "id") as? String ?? "").base64Encoding()
        }
        let fid = (prefs.value(forKey: "fid") as? String ?? "").base64Encoding()
        let loginType = prefs.value(forKey: "loginType") as? String ?? ""
        var SnsloginType = 0
        switch loginType {
            case "google":
                SnsloginType = 2
                print("\n-----------------[ google Login ]---------------------\n")
            case "naver":
                SnsloginType = 1
                print("\n-----------------[ naver Login ]---------------------\n")
            case "kakao":
                SnsloginType = 3
                print("\n-----------------[ kakao Login ]---------------------\n")
            case "apple":
                SnsloginType = 4
                print("\n-----------------[ apple Login ]---------------------\n")
            default:
                SnsloginType = 5
                print("\n-----------------[ 로그인 실패 ]---------------------\n")
                break;
        }
        IndicatorSetting()
        NetworkManager.shared().checkMbr(type: SnsloginType, id: id, fid:fid ,email: "", pass: "", mode: 1, osvs: deviceInfo.OSVS, appvs: deviceInfo.APPVS, md: deviceInfo.MD) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                userInfo = serverData
                if serverData.mbrsid > 0 {
                    self.setPushId(mbrsid: serverData.mbrsid)
                     
                    let author = serverData.author
                    let cmpsid = serverData.cmpsid
                    let joindt = serverData.joindt
                    
                    
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
                    
                    if author == 5 {
                        let alert = UIAlertController.init(title: "알림", message: "권한이 없습니다. 근로자 앱으로 이동합니다.", preferredStyle: .alert)
                        let okAction = UIAlertAction.init(title: "확인", style: .default, handler: { action in
                            
                            let scheme = "WooriyoEE://"
                            let url = URL(string: scheme)!
                            print("-------------------[UIApplication.shared.canOpenURL(url)=\(UIApplication.shared.canOpenURL(url))]-------------------")
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }else {
                                UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/apple-store/id1624398964")!, options: [:], completionHandler: nil)
                            }
                        })
                        let cancel = UIAlertAction.init(title: "종료", style: .cancel, handler: { action in
                            //                            exit(0)
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
                    }
                }else{
                    print("\n---------- [ mbrsid 없음 ] ----------\n")
                    let vc = LoginSignSB.instantiateViewController(withIdentifier: "SnsJoinVC") as! SnsJoinVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                }
            }else{
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
        }
        Spinner.stop()
    }
    
    func menberCheck() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let id = (prefs.value(forKey: "id") as? String ?? "").base64Encoding()
        let loginType = prefs.value(forKey: "loginType") as? String ?? ""
        let fid = (prefs.value(forKey: "fid") as? String ?? "").base64Encoding()
        var SnsloginType = 0
        switch loginType {
            case "naver":
                SnsloginType = 1
                print("naver Login");
            case "google":
                SnsloginType = 2
                print("google Login");
            case "kakao":
                SnsloginType = 3
                print("kakao Login");
            case "apple":
                SnsloginType = 4
                print("apple login")
            default:
                SnsloginType = 5
                print("로그인 실패");
                break;
        }
        NetworkManager.shared().checkMbr(type: SnsloginType, id: id, fid:fid, email: "", pass: "", mode: 1, osvs: deviceInfo.OSVS, appvs: deviceInfo.APPVS, md: deviceInfo.MD) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                userInfo = serverData
                if serverData.mbrsid > 0 {
                    self.setPushId(mbrsid: serverData.mbrsid)
                    
                    let author = serverData.author
                    let cmpsid = serverData.cmpsid
                    let joindt = serverData.joindt 
                    
                    
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
                    
                    if author == 5 {
                        let alert = UIAlertController.init(title: "알림", message: "권한이 없습니다. 근로자 앱으로 이동합니다.", preferredStyle: .alert)
                        let okAction = UIAlertAction.init(title: "확인", style: .default, handler: { action in
                            
                            let scheme = "WooriyoEE://"
                            let url = URL(string: scheme)!
                            print("-------------------[UIApplication.shared.canOpenURL(url)=\(UIApplication.shared.canOpenURL(url))]-------------------")
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }else {
                                UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/apple-store/id1624398964")!, options: [:], completionHandler: nil)
                            }
                        })
                        let cancel = UIAlertAction.init(title: "종료", style: .cancel, handler: { action in
                            //                            exit(0)
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
                    }
                }else{
                    print("\n---------- [ mbrsid 없음 ] ----------\n")
                    let vc = LoginSignSB.instantiateViewController(withIdentifier: "SnsJoinVC") as! SnsJoinVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                }
            }else{
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
        }
        Spinner.stop()
        
    }
    
    // MARK: - 애플 회원가입시 바로 가입되게 수정 2020.09.25
    func applemenberCheck(){
        let id = (prefs.value(forKey: "id") as? String ?? "").base64Encoding()
       
        let loginType = prefs.value(forKey: "loginType") as? String ?? ""
        let fid = (prefs.value(forKey: "fid") as? String ?? "").base64Encoding()
        var SnsloginType = 0
        switch loginType {
            case "naver":
                SnsloginType = 1
                print("naver Login");
            case "google":
                SnsloginType = 2
                print("google Login");
            case "kakao":
                SnsloginType = 3
                print("kakao Login");
            case "apple":
                SnsloginType = 4
                print("apple login")
            default:
                SnsloginType = 5
                print("로그인 실패");
                break;
        }
        NetworkManager.shared().checkMbr(type: SnsloginType, id: id, fid : fid, email: "", pass: "", mode: 1, osvs: deviceInfo.OSVS, appvs: deviceInfo.APPVS, md: deviceInfo.MD) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                userInfo = serverData
                if serverData.mbrsid > 0 {
                    self.setPushId(mbrsid: serverData.mbrsid)
                    
                    let author = serverData.author
                    let cmpsid = serverData.cmpsid
                    let joindt = serverData.joindt
                    
                    
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
                    
                    if author == 5 {
                        let alert = UIAlertController.init(title: "알림", message: "권한이 없습니다. 근로자 앱으로 이동합니다.", preferredStyle: .alert)
                        let okAction = UIAlertAction.init(title: "확인", style: .default, handler: { action in
                            
                            let scheme = "WooriyoEE://"
                            let url = URL(string: scheme)!
                            print("-------------------[UIApplication.shared.canOpenURL(url)=\(UIApplication.shared.canOpenURL(url))]-------------------")
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }else {
                                UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/apple-store/id1624398964")!, options: [:], completionHandler: nil)
                            }
                        })
                        let cancel = UIAlertAction.init(title: "종료", style: .cancel, handler: { action in
                            //                            exit(0)
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
                    }
                }else{
                    print("\n---------- [ mbrsid 없음 ] ----------\n")
                    self.appleRegMbr()
                }
            }else{
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
        }
        Spinner.stop()
    }
    
    func appleRegMbr(){
        let email = prefs.value(forKey: "join_email") as? String ?? "" // nil 체크
        let id = (prefs.value(forKey: "id") as! String).base64Encoding()
        let name = prefs.value(forKey: "join_name") as? String ?? "" // nil 체크
        
        let phone = "00000000000".base64Encoding()
        let brith = ""
        let lunar = 0
        let loginType = prefs.value(forKey: "loginType") as! String
        var SnsloginType = 0
        switch loginType {
            case "naver":
                SnsloginType = 1
            case "google":
                SnsloginType = 2
            case "kakao":
                SnsloginType = 3
            case "apple":
                SnsloginType = 4
            default:
                SnsloginType = 5
                print("로그인 실패")
        }
        let tokenid = id
        IndicatorSetting()
        NetworkManager.shared().checkRegMbr(type: SnsloginType, id: tokenid,email: email.base64Encoding(), name: name.urlBase64Encoding(), pass: "", gender: 1, birth: brith, lunar: lunar, phone: phone, mode: 1, osvs: deviceInfo.OSVS, appvs: deviceInfo.APPVS, md: deviceInfo.MD) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode > 0 {
                    prefs.setValue(email, forKey: "join_email")
                    
                    userInfo.email = email
                    userInfo.name = name
                    userInfo.phonenum =   "00000000000"
                    userInfo.mbrsid = resCode
                    
                    let vc = LoginSignSB.instantiateViewController(withIdentifier: "SelMgrEmp") as! SelMgrEmp
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                    
                    
                }else if resCode == 0 {
                    print("\n---------- [ 가입 실패  ] ----------\n")
                    self.customAlertView("가입 실패하였습니다.\n 다시 시도해 주세요.")
                }else{
                    print("\n---------- [ 회원정보 업데이트  ] ----------\n")
                    self.menberCheck()
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
        }
    }
}
//MARK: extension
//네이버 로그인 연동
extension LoginVC: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        //        let naverSignInViewController = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
        //        print("네이버 로그인 시작")
        //        self.present(naverSignInViewController, animated: true, completion: nil)
    }
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithAuthCode")
        getNaverEmailFromURL()
    }
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
        getNaverEmailFromURL()
    }
    func oauth20ConnectionDidFinishDeleteToken() {
        
    }
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error.localizedDescription)
        print(error!)
    }
    func getNaverEmailFromURL() {
        guard let loginConn = NaverThirdPartyLoginConnection.getSharedInstance() else {return}
        guard let tokenType = loginConn.tokenType else {return}
        guard let accessToken = loginConn.accessToken else {return}
        print("getNaverEmailFromURL")
        let authorization = "\(tokenType) \(accessToken)"
        Alamofire.request("https://openapi.naver.com/v1/nid/me", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseJSON { (response) in
            if let result = response.result.value as? [String: Any] {
                if let object = result["response"] as? [String: Any] {
                    if let name = object["name"] as? String {
                        prefs.setValue(name, forKey: "join_name")
                        print(name)
                    }
                    if let email = object["email"] as? String {
                        prefs.setValue(email, forKey: "join_email")
                        print(email)
                    }
                    if let id = object["id"] as? String {
                        prefs.setValue(id, forKey: "id")
                        print(id)
                    }
                    prefs.setValue("naver", forKey: "loginType")
                }
            }
            self.menberCheck()
        }
    }
    
}
 
// MARK: 애플로그인
@available(iOS 13.0, *)
extension LoginVC {
    
    private func setupLoginProviderView() {
        
        let isDarkTheme = view.traitCollection.userInterfaceStyle == .dark
        let style: ASAuthorizationAppleIDButton.Style = isDarkTheme ? .white : .black

        // Create and Setup Apple ID Authorization Button
        let authorizationButton = ASAuthorizationAppleIDButton(type: .default, style: style)

        authorizationButton.addTarget(self, action: #selector(AppleIDButtonPress), for: .touchUpInside)
        authorizationButton.cornerRadius = 2
        // Add Height Constraint
        let heightConstraint = authorizationButton.heightAnchor.constraint(equalToConstant: 46)
        authorizationButton.addConstraint(heightConstraint)

        //Add Apple ID authorization button into the stack view
        loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    // Existing Account Setup Flow
    @objc func handleAppleIdRequest() {
        
        let appleSignInRequest = ASAuthorizationAppleIDProvider().createRequest()
        // set scope
        appleSignInRequest.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        // set delegate
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    
    @objc func AppleIDButtonPress(_ sender: UITapGestureRecognizer) {
        // Check Credential State
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier ?? "") {  (credentialState, error) in
            
            
            switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid.
                    print("The Apple ID credential is valid.")
                    DispatchQueue.main.async {
                        if KeychainItem.currentUserIdentifier != nil {
                            let fullName = "\(KeychainItem.currentUserLastName ?? "")\(KeychainItem.currentUserFirstName ?? "")"
                            prefs.setValue(KeychainItem.currentUserEmail, forKey: "join_email")
                            prefs.setValue(KeychainItem.currentUserIdentifier, forKey: "id")
//                            self.prefs.setValue(KeychainItem.currentUserEmail, forKey: "id") //2020.12.10 firebase apple email 로 변경
                            prefs.setValue(fullName, forKey: "join_name")
                            prefs.setValue("apple", forKey: "loginType")
                            self.applemenberCheck()
                        }
                    }

                    break
                case .revoked , .notFound:
                    // Existing Account Setup Flow
                    DispatchQueue.main.async {
                        self.handleAppleIdRequest()
                    }
                    break
                default:
                    break
            }
        }
    }
}
@available(iOS 12.0, *)
@available(iOS 13.0, *)
extension LoginVC : ASAuthorizationControllerDelegate ,ASAuthorizationControllerPresentationContextProviding  {
    // Handle ASAuthorizationController Delegate and Presentation Context
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            case let appleIdCredential as ASAuthorizationAppleIDCredential:
                if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                    registerNewAccount(credential: appleIdCredential , identify : appleIdCredential.user)
                } else {
                    signInWithExistingAccount(credential: appleIdCredential , identify : appleIdCredential.user)
                }
                break

            case let passwordCredential as ASPasswordCredential:
                signInWithUserAndPassword(credential: passwordCredential , identify : "")

                break

            default:
                break
        } 
    }
    
    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential , identify : String) {
        guard let appleIDToken = credential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        
        
        let userData = AppleUserData(email: credential.email!,
                                     name: credential.fullName!,
                                     identifier: credential.user)
        
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: currentNonce)
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
                return
            }
            
            if let Result = authResult {
                KeychainItem.currentUserIdentifier = Result.user.uid
                prefs.setValue(KeychainItem.currentUserIdentifier, forKey: "id")
//                self.prefs.setValue(KeychainItem.currentUserEmail, forKey: "id") // 2020.12.10 firebase apple email 로변경
                prefs.setValue(identify, forKey: "fid")
            }
        }
        
        
        
        KeychainItem.currentUserFirstName = userData.name.familyName
        KeychainItem.currentUserLastName = userData.name.givenName
        KeychainItem.currentUserEmail = userData.email
        self.showResultViewController(userIdentifier: userData.identifier, fullName: userData.name, email: userData.email)
    }
    
    private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential , identify:String) {
        
        guard let appleIDToken = credential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        let fullName  = credential.fullName
         
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: currentNonce)
        //        // Sign in with Firebase.
        
        print("\n---------- [ identify : \(identify) ] ----------\n")
        prefs.setValue(identify, forKey: "fid")
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
                return
            }
            
            if let Result = authResult {
                KeychainItem.currentUserIdentifier = Result.user.uid
                KeychainItem.currentUserEmail = Result.user.email
                prefs.setValue(KeychainItem.currentUserIdentifier, forKey: "id")
                if isReviewStatus > 0 {
                    if let testName =  Result.user.email {
                        prefs.setValue(testName.components(separatedBy: "@"), forKey: "join_name")
                        
                    }
                }
//                self.prefs.setValue(KeychainItem.currentUserEmail, forKey: "id") // 2020.12.10 firebase apple email 로 변경


                self.showResultViewController(userIdentifier: Result.user.uid, fullName: fullName, email: Result.user.email)

            }
        }
    }
    
    private func signInWithUserAndPassword(credential: ASPasswordCredential , identify:String) {
        let username = credential.user
        let password = credential.password
        
        // For the purpose of this demo app, show the password credential as an alert.
        DispatchQueue.main.async {
            self.showPasswordCredentialAlert(username: username, password: password)
        }
    }
    
    private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
        let uid = prefs.string(forKey: "id")
        print("\n---------- [ name : \(fullName) , email :\(email) , userIdentifier :\(uid)] ----------\n")
        
        if let name = fullName ,let email = email   {
            KeychainItem.currentUserFirstName = name.givenName
            KeychainItem.currentUserLastName = name.familyName
            KeychainItem.currentUserEmail = email
            
             prefs.setValue(KeychainItem.currentUserEmail, forKey: "join_email")
           
            
            if let strGiveName = name.givenName , let strFamilyName = name.familyName {
                let strAppleName = "\(strFamilyName)\(strGiveName)"
                prefs.setValue(strAppleName, forKey: "join_name")
            }
           
            
            prefs.setValue("apple", forKey: "loginType")
            self.menberCheck()
            
        }else{
            if let email = email {
                
                KeychainItem.currentUserEmail = email
                
                 prefs.setValue(KeychainItem.currentUserEmail, forKey: "join_email")
                prefs.setValue("apple", forKey: "loginType")
                self.menberCheck()
            }
        }
        
        
    }
    
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

struct WebApi {
    static func Register(user: AppleUserData, identityToken: Data?, authorizationCode: Data?) throws -> Bool {
        return true
    }
}

extension LoginVC {
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
 
