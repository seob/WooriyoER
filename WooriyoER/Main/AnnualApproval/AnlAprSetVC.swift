//
//  AnlAprSetVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/10/23.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AnlAprSetVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var author = 0 //직원권한(1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.팀관리자  5.직원).. 관리자 구분
    var flag = false
    var temflag = false
    var CmpInfo:CmpInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        author = prefs.value(forKey: "author") as! Int
        author = userInfo.author
        print("author = ", author)
        
        switch author {
        case 1, 2:
            self.flag = true
        case 3:
            self.flag = false
            self.temflag = true
        case 4:
            self.flag = false
            self.temflag = false
        default:
            self.flag = true
            break
        }
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        viewflag = "AnlAprSetVC"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\n---------- [ cmpsid : \(userInfo.toJSON()) ] ----------\n")
        valueSetting()
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        if SE_flag {
            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
        }else{
            vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func setAnl(_ sender: UIButton) {
        if flag {
            var vc = MoreSB.instantiateViewController(withIdentifier: "SetAnlVC") as! SetAnlVC
            if SE_flag {
                vc = MoreSB.instantiateViewController(withIdentifier: "SE_SetAnlVC") as! SetAnlVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            let vc = AnlAprSB.instantiateViewController(withIdentifier: "TemAnlSet") as! TemAnlSet
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    @IBAction func anlPrm(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "PrmListVC") as! PrmListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func aprLine(_ sender: UIButton) {
        if flag {
            let vc = MoreSB.instantiateViewController(withIdentifier: "CmpAprSelVC") as! CmpAprSelVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            let vc = MoreSB.instantiateViewController(withIdentifier: "AprSelVC") as! AprSelVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    @IBAction func anlList(_ sender: UIButton) {
    //        self.alertView("www.pinple.com 에서 연차내역을 확인 할 수 있습니다.")
//        if let url = URL(string: "http://pinpl.biz") {
//            UIApplication.shared.open(url, options: [:])
//        }
        
        let vc = MainSB.instantiateViewController(withIdentifier: "TotalEmpLits") as! TotalEmpLits
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func valueSetting() {
        if !flag {
            var url = ""
            if temflag {
//                let temsid = prefs.value(forKey: "ttmsid") as! Int
                let temsid = userInfo.ttmsid
                url = urlClass.get_ttm_info(ttmsid: temsid)
            }else {
//                let temsid = prefs.value(forKey: "temsid") as! Int
                let temsid = userInfo.temsid
                url = urlClass.get_tem_info(temsid: temsid)
            }
            
            if let jsonTemp = jsonClass.weather_request(setUrl: url) {
                if let jsonData = jsonClass.json_parseData(jsonTemp) {
                    print(url)
                    print(jsonData)
                     
                    let anualapr = jsonData["anualapr"] as? Int ?? 0
                    let anuallimit = jsonData["anuallimit"] as? Int ?? 0
                    let applyapr = jsonData["applyapr"] as? Int ?? 0
                    let beacon = jsonData["beacon"] as? String ?? ""
                    let brktime = jsonData["brktime"] as? Int ?? 0
                    let cmpsid = jsonData["cmpsid"] as? Int ?? 0
                    let cmtarea = jsonData["cmtarea"] as? Int ?? 0
                    let empcnt = jsonData["empcnt"] as? Int ?? 0
                    let endtm = jsonData["endtm"] as? String ?? ""
                    let loclat = jsonData["loclat"] as? String ?? ""
                    let loclong = jsonData["loclong"] as? String ?? ""
                    let locaddr = jsonData["locaddr"] as? String ?? ""
                    let memo = jsonData["memo"] as? String ?? ""
                    let mgrcnt = jsonData["mgrcnt"] as? Int ?? 0
                    let name = jsonData["name"] as? String ?? ""
                    let phone = jsonData["phone"] as? String ?? ""
                    let schdl = jsonData["schdl"] as? Int ?? 0
                    let sid = jsonData["sid"] as? Int ?? 0
                    let starttm = jsonData["starttm"] as? String ?? ""
                    let wifiip = jsonData["wifiip"] as? String ?? ""
                    let wifimac = jsonData["wifimac"] as? String ?? ""
                    let wifinm = jsonData["wifinm"] as? String ?? ""
                    let workday = jsonData["workday"] as? String ?? ""
                     
                    prefs.setValue(temflag, forKey: "mt_selflag")
                    prefs.setValue(anualapr, forKey: "mt_anualapr")
                    prefs.setValue(anuallimit, forKey: "mt_anuallimit")
                    prefs.setValue(applyapr, forKey: "mt_applyapr")
                    prefs.setValue(beacon, forKey: "mt_beacon")
                    prefs.setValue(brktime, forKey: "mt_brktime")
                    prefs.setValue(cmpsid, forKey: "mt_cmpsid")
                    prefs.setValue(cmtarea, forKey: "mt_cmtarea")
                    prefs.setValue(empcnt, forKey: "mt_empcnt")
                    prefs.setValue(endtm.timeTrim(), forKey: "mt_endtm")
                    prefs.setValue(loclat, forKey: "mt_loclat")
                    prefs.setValue(loclong, forKey: "mt_loclong")
                    prefs.setValue(locaddr, forKey: "mt_locaddr")
                    prefs.setValue(memo, forKey: "mt_memo")
                    prefs.setValue(mgrcnt, forKey: "mt_mgrcnt")
                    prefs.setValue(name, forKey: "mt_name")
                    prefs.setValue(phone, forKey: "mt_phone")
                    prefs.setValue(schdl, forKey: "mt_schdl")
                    prefs.setValue(sid, forKey: "mt_selsid")
                    prefs.setValue(starttm.timeTrim(), forKey: "mt_starttm")
                    prefs.setValue(wifiip, forKey: "mt_wifiip")
                    prefs.setValue(wifimac, forKey: "mt_wifimac")
                    prefs.setValue(wifinm, forKey: "mt_wifinm")
                    prefs.setValue(workday, forKey: "mt_workday")
                }
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
}
