//
//  LoginVC.swift
//  PinPle
//
//  Created by WRY_010 on 12/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Alamofire
import NaverThirdPartyLogin

class LoginVC: UIViewController, GIDSignInDelegate {
    
    let prefs = UserDefaults.standard
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let deviceInfo = DeviceInfo()
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    //MARK: override view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //네비게이션바 부분
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Google Signin
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.prepareForInterfaceBuilder()
        //naver Signin
        loginInstance?.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        Spinner.start()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let appDelegate = getAppDelegate() {
            appDelegate.loginMainViewController = self
        }else {
            print("Appdelegate is nil")
        }
        Spinner.stop()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Spinner.stop()
    }
    
    //MARK: @IBAction
    //이메일로 시작
    @IBAction func emailLoginClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "EmailLoginVC", sender: self)
    }
    //네이버 아이디로 시작
    @IBAction func naverLoginClick(_ sender: UIButton) {
        loginInstance?.requestThirdPartyLogin()
    }
    //구글 아이디로 시작
    @IBAction func googleLoginClick(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    //카카오 아이디로 시작
    @IBAction func kakaoLoginClick(_ sender: AnyObject) {
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
                            if let account = info.account {
                                if let email = account.email {
                                    print("kakao email = \(email)")
                                    self!.prefs.setValue(email, forKey: "email")
                                }
                                switch account.gender {
                                case .male:     self!.prefs.setValue(0, forKey: "gender");
                                case .female:   self!.prefs.setValue(1, forKey: "gender");
                                default:    break;
                                }
                                print("kakao gender = \(account.gender)")
                            }
                            if let id = info.id {
                                let tempid = ((id).data(using: .utf8)?.base64EncodedString())!
                                print("kakao id = \(tempid)")
                                self!.prefs.setValue(tempid, forKey: "id")
                            }
                        }
                        self!.prefs.setValue("kakao", forKey: "loginType")
                        self!.menberCheck()
                    }
                }
            }
        })
    }
    
    //MARK: func
    func getAppDelegate() -> AppDelegate!{
        // AppDelegate 가져오기 - Returns: AppDelegate
        return UIApplication.shared.delegate as? AppDelegate
    }
    //구글 회원 정보 가져오기
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        /*
         구글 로그인 정보 가져옵니다.
         - Parameters:
         - signIn: SignIn 된 정보를 가져옵니다
         - user: 구글 로그인 정보를 가져옵니다
         - error: 에러 메시지를 가져옵니다
         */
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            }else {
                print("\(error.localizedDescription)")
            }
            return
        }
        let userId = user.userID
        //      let idToken = user.authentication.idToken
        let fullName = user.profile.name
        //      let givenName = user.profile.givenName
        //      let familyName = user.profile.familyName
        let email = user.profile.email
        
        self.prefs.setValue(email, forKey: "email")
        self.prefs.setValue(userId, forKey: "id")
        self.prefs.setValue(fullName, forKey: "name")
        self.prefs.setValue("google", forKey: "loginType")
    }
    
    //회원가입 체크
    func menberCheck() {
        let id = self.prefs.value(forKey: "id") as! String
        let loginType = self.prefs.value(forKey: "loginType") as! String
        var url = ""
        
        switch loginType {
        case "google":
            print("google Login");
            url = urlClass.check_mbr4google(gid: id, osvs: deviceInfo.OSVS, appvs: deviceInfo.APPVS, md: deviceInfo.MD);
        case "naver":
            print("naver Login");
            url = urlClass.check_mbr4naver(nid: id, osvs: deviceInfo.OSVS, appvs: deviceInfo.APPVS, md: deviceInfo.MD);
        case "kakao":
            print("kakao Login");
            url = urlClass.check_mbr4kakao(kid: id, osvs: deviceInfo.OSVS, appvs: deviceInfo.APPVS, md: deviceInfo.MD);
        default:
            print("로그인 실패");
            break;
        }
        
        httpRequest.get(urlStr: url) { (success, jsonData) in
            if success {
                print(url)
                print(jsonData)
                
                let mbrsid = jsonData["mbrsid"] as! Int
                if mbrsid > 0 {
                    let author = jsonData["author"] as! Int
                    let cmpname = jsonData["cmpname"] as! String
                    let cmpsid = jsonData["cmpsid"] as! Int
                    let curver = jsonData["curver"] as! String
                    let email = jsonData["email"] as! String
                    let empsid = jsonData["empsid"] as! Int
                    let ename = jsonData["enname"] as! String
                    let gender = jsonData["gender"] as! Int
                    let mbrsid = jsonData["mbrsid"] as! Int
                    let name = jsonData["name"] as! String
                    let notrc = jsonData["notrc"] as! Int
                    let profimg = jsonData["profimg"] as! String
                    let pushid = jsonData["pushid"] as! String
                    let regdt = jsonData["regdt"] as! String
                    let spot = jsonData["spot"] as! String
                    let temname = jsonData["temname"] as! String
                    let temsid = jsonData["temsid"] as! Int
                    let ttmname = jsonData["ttmname"] as! String
                    let ttmsid = jsonData["ttmsid"] as! Int
                    let update = jsonData["update"] as! Int
                    let updatemsg = jsonData["updatemsg"] as! String
                    
                    self.prefs.setValue(author, forKey: "author")
                    self.prefs.setValue(cmpname, forKey: "cmpname")
                    self.prefs.setValue(cmpsid, forKey: "cmpsid")
                    self.prefs.setValue(curver, forKey: "curver")
                    self.prefs.setValue(email, forKey: "email")
                    self.prefs.setValue(empsid, forKey: "empsid")
                    self.prefs.setValue(ename, forKey: "ename")
                    self.prefs.setValue(gender, forKey: "gender")
                    self.prefs.setValue(mbrsid, forKey: "mbrsid")
                    self.prefs.setValue(name, forKey: "name")
                    self.prefs.setValue(notrc, forKey: "notrc")
                    self.prefs.setValue(profimg, forKey: "profimg")
                    self.prefs.setValue(pushid, forKey: "pushid")
                    self.prefs.setValue(regdt, forKey: "regdt")
                    self.prefs.setValue(spot, forKey: "spot")
                    self.prefs.setValue(temname, forKey: "temname")
                    self.prefs.setValue(temsid, forKey: "temsid")
                    self.prefs.setValue(ttmname, forKey: "ttmname")
                    self.prefs.setValue(ttmsid, forKey: "ttmsid")
                    self.prefs.setValue(update, forKey: "update")
                    self.prefs.setValue(updatemsg, forKey: "updatemsg")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil);
                    guard let viewController = storyboard.instantiateInitialViewController() else { return };
                    self.present(viewController, animated: true, completion: nil);
                }else {
                    self.performSegue(withIdentifier: "SNSJoinVC", sender: self)
                }
            }
        }
        Spinner.stop()
    }
}
//MARK: extension
//네이버 로그인 연동
extension LoginVC: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        let naverSignInViewController = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
        print("네이버 로그인 시작")
        self.present(naverSignInViewController, animated: true, completion: nil)
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
                        self.prefs.setValue(name, forKey: "name")
                        print(name)
                    }
                    if let email = object["email"] as? String {
                        self.prefs.setValue(email, forKey: "email")
                        print(email)
                    }
                    if let gender = object["gender"] as? String {
                        var tempGender = 1
                        if gender == "M" {
                            tempGender = 0
                        }
                        self.prefs.setValue(tempGender, forKey: "gender")
                        print(gender)
                    }
                    if let id = object["id"] as? String {
                        let tempid = ((id).data(using: .utf8)?.base64EncodedString())!
                        self.prefs.setValue(tempid, forKey: "id")
                        print(tempid)
                    }
                    self.prefs.setValue("naver", forKey: "loginType")
                }
            }
            self.menberCheck()
        }
    }
}
