//
//  SelMgrEmp.swift
//  PinPle
//
//  Created by WRY_010 on 2019/12/10.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class SelMgrEmp: UIViewController {
    
    @IBOutlet weak var imgMgr: UIImageView!
    @IBOutlet weak var imgEmp: UIImageView!
    @IBOutlet weak var imgMgrCheck: UIImageView!
    @IBOutlet weak var imgEmpCheck: UIImageView!
    @IBOutlet weak var btnOk: UIButton!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    var erCheck = UIImage.init(named: "er_checkbox")
    var eeCheck = UIImage.init(named: "ee_checkbox")
    var noneCheck = UIImage.init(named: "icon_nonecheck")
    var mgrImgClick = UIImage.init(named: "er_belong")
    var mgrImgUnClick = UIImage.init(named: "gray_er_belong")
    var empImgClick = UIImage.init(named: "ee_belong")
    var empImgUnClick = UIImage.init(named: "gray_ee_belong")
    
    var loginType: String = "" // 로그인 타입
    var email: String = ""// 자동로그인 용 email(id)
    var pass: String = "" // 자동로그인 용 pass
    var snsid: String = "" // 자동로그인 sns 고유id
    var name: String = ""
    
    var flag: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefs.setValue(1, forKey: "stage")
        btnOk.layer.cornerRadius = 6
        if let tmploginType = prefs.value(forKey: "loginType") as? String {
            self.loginType = tmploginType
        }
        
        if let tmpemail = prefs.value(forKey: "login_email") as? String {
            self.email = tmpemail
        }
        
        if let tmppass = prefs.value(forKey: "login_pass") as? String {
            self.pass = tmppass
        }
        
        if let tmpsnsid = prefs.value(forKey: "id") as? String {
            self.snsid = tmpsnsid.base64Encoding()
        }
        
        menberCheck()
        
        imgMgr.image = mgrImgClick
        imgMgrCheck.image = erCheck
        
        imgEmp.image = empImgUnClick
        imgEmpCheck.image = noneCheck
        flag = false
        
        if let tmpname = prefs.value(forKey: "join_name") as? String {
            self.name = tmpname
        }
        lblTitle.text = "'\(name)'님 환영합니다."
        lblDescription.isHidden = true
    }
    @IBAction func barBoutton(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Setting") as! Setting
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    func menberCheck() {
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
        NetworkManager.shared().checkMbr(type: snstype, id: snsid, fid:fid ,email: email, pass: pass, mode: 1, osvs: deviceInfo.OSVS, appvs: deviceInfo.APPVS, md: deviceInfo.MD) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else {  return }
                userInfo = serverData
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    @IBAction func mgrClick(_ sender: UIButton) {
        imgMgr.image = mgrImgClick
        imgMgrCheck.image = erCheck
        
        imgEmp.image = empImgUnClick
        imgEmpCheck.image = noneCheck
        flag = false
        lblDescription.isHidden = true
    }
    
    @IBAction func EmpClick(_ sender: UIButton) {
        imgMgr.image = mgrImgUnClick
        imgMgrCheck.image = noneCheck
        
        imgEmp.image = empImgClick
        imgEmpCheck.image = eeCheck
        flag = true
        lblDescription.isHidden = false
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        if flag {
            openPinpl()
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddInfo") as! AddInfo
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    func openPinpl() {
        let scheme = "WooriyoEE://"
        let url = URL(string: scheme)!
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else {
            UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/apple-store/id1624398964")!, options: [:], completionHandler: nil)
        }
        
    }
}
