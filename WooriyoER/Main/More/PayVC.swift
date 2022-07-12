//
//  PayVC.swift
//  PinPle
//
//  Created by seob on 2021/02/25.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class PayVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    @IBOutlet weak var btnBannerM: UIButton!
    @IBOutlet weak var btnBanner: UIButton!
    @IBOutlet weak var btnCmt: UIButton!
    @IBOutlet weak var btnCmtList: UIButton!
    @IBOutlet weak var lblMultiendDate: UILabel!
    
    @IBOutlet weak var lblbannerMDate: UILabel!
    @IBOutlet weak var lblbannerDate: UILabel!
    @IBOutlet weak var lblCmtListDate: UILabel!
    
    @IBOutlet weak var lblBannerMPin: UILabel!
    @IBOutlet weak var lblBannerEPin: UILabel!
    @IBOutlet weak var lblCmtPin: UILabel!
    @IBOutlet weak var lblCmtListPin: UILabel!
    
    @IBOutlet weak var lblFicalDate: UILabel!
    @IBOutlet weak var btnFiical: UIButton!
    
    @IBOutlet weak var lblStorageDate: UILabel!
    @IBOutlet weak var btnStorage: UIButton!
    
    @IBOutlet weak var lblStorePin: UILabel!
    @IBOutlet weak var lblFicalPin: UILabel!
    
    @IBOutlet weak var lblDisplayAnualDate: UILabel!
    @IBOutlet weak var btnDisplayAnual: UIButton!
    
    var bannerM = 0
    var bannner = 0
    var cmtonoff = 0
    var cmtListonoff = 0
    var ficaloff = 0
    var storageoff = 0
    var displayanualoff = 0
    
    let extensiomimg = UIImage(named: "extension_btn_none")
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reloadList, object: nil)
        setUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
    }
    
    @objc func reloadTableData(_ notification: Notification) {
        valueSetting()
        checkmultiarea()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    fileprivate func setUi(){
        btnBannerM.addTarget(self, action: #selector(bannerMAction(_:)), for: .touchUpInside)
        btnBanner.addTarget(self, action: #selector(bannerAction(_:)), for: .touchUpInside)
        btnCmt.addTarget(self, action: #selector(cmtAction(_:)), for: .touchUpInside)
        btnCmtList.addTarget(self, action: #selector(cmtListAction(_:)), for: .touchUpInside)
        btnFiical.addTarget(self, action: #selector(ficalAction(_:)), for: .touchUpInside)
        btnStorage.addTarget(self, action: #selector(storageAction(_:)), for: .touchUpInside)
        btnDisplayAnual.addTarget(self, action: #selector(changeDiaplayAnual(_:)), for: .touchUpInside)
    }
    
    
    func valueSetting() {
        NetworkManager.shared().getCmpInfo(cmpsid: userInfo.cmpsid) { (isSuccess, errCode, resData) in
            if(isSuccess){
                if errCode == 99 {
                    self.toast("다시 시도해 주세요.")
                }else{
                    guard let serverData = resData else { return }
                    moreCmpInfo = serverData
                    CompanyInfo = serverData
                    self.checkmultiarea()
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    func checkmultiarea() {
        switch moreCmpInfo.freetype {
        case 3 :
            //올프리
            if moreCmpInfo.freedt >= muticmttodayDate() {
                //관리자앱 배너
                bannerM = 1
                btnBannerM.setTitle("FREE", for: .normal)
                btnBannerM.setBackgroundImage(extensiomimg, for: .normal)
                lblbannerMDate.isHidden = true
                
                
                //근로자앱 배너
                if CompanyInfo.hidebn >= muticmttodayDate() {
                    bannner = 1
                    btnBanner.setTitle("FREE", for: .normal)
                    btnBanner.setBackgroundImage(extensiomimg, for: .normal)
                    lblbannerDate.isHidden = false
                    let orihidebn = setJoinDate2(timeStamp: CompanyInfo.hidebn)
                    let str = orihidebn.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let hidebnDate = str[start...end]
                    if SE_flag {
                        lblbannerDate.text = "\(hidebnDate)"
                    }else{
                        lblbannerDate.text = "종료일 \(hidebnDate)"
                    }
                    
                }else{
                    bannner = 0
                    btnBanner.setTitle("", for: .normal)
                    btnBanner.setBackgroundImage(swOffimg, for: .normal)
                    lblbannerDate.isHidden = true
                }
                
                
                
                //출퇴근
                cmtonoff = 1
                ismulticmtarea = true
                btnCmt.setTitle("FREE", for: .normal)
                btnCmt.setBackgroundImage(extensiomimg, for: .normal)
                lblMultiendDate.isHidden = true
                
                //근무내역
                cmtListonoff = 1
                btnCmtList.setTitle("FREE", for: .normal)
                btnCmtList.setBackgroundImage(extensiomimg, for: .normal)
                lblCmtListDate.isHidden = true
                
                //회계년도
                ficaloff = 1
                btnFiical.setTitle("FREE", for: .normal)
                btnFiical.setBackgroundImage(extensiomimg, for: .normal)
                lblFicalDate.isHidden = true
                
                //데이터보관
                storageoff = 1
                btnStorage.setTitle("FREE", for: .normal)
                btnStorage.setBackgroundImage(extensiomimg, for: .normal)
                lblStorageDate.isHidden = true
                
                //근로자 연차 노출설정
                displayanualoff = 1
                btnDisplayAnual.setTitle("FREE", for: .normal)
                btnDisplayAnual.setBackgroundImage(extensiomimg, for: .normal)
                lblDisplayAnualDate.isHidden = true
                
                lblBannerMPin.text = "\(PayTypeKoArray[moreCmpInfo.freetype])"
                lblCmtPin.text = "\(PayTypeKoArray[moreCmpInfo.freetype])"
                lblCmtListPin.text = "\(PayTypeKoArray[moreCmpInfo.freetype])"
                lblFicalPin.text = "\(PayTypeKoArray[moreCmpInfo.freetype])"
                lblStorePin.text = "\(PayTypeKoArray[moreCmpInfo.freetype])"
            }else{
                //관리자앱 배너
                
                if CompanyInfo.hidebnm >= muticmttodayDate() {
                    bannerM = 1
                    btnBannerM.setTitle("연장", for: .normal)
                    btnBannerM.setBackgroundImage(extensiomimg, for: .normal)
                    lblbannerMDate.isHidden = false
                    let orihidebnm = setJoinDate2(timeStamp: CompanyInfo.hidebnm)
                    let str = orihidebnm.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let hidebnMDate = str[start...end]
                    if SE_flag {
                        lblbannerMDate.text = "\(hidebnMDate)"
                    }else{
                        lblbannerMDate.text = "종료일 \(hidebnMDate)"
                    }
                    
                }else{
                    bannerM = 0
                    btnBannerM.setTitle("", for: .normal)
                    btnBannerM.setBackgroundImage(swOffimg, for: .normal)
                    lblbannerMDate.isHidden = true
                }
                
                //근로자앱 배너
                if CompanyInfo.hidebn >= muticmttodayDate() {
                    bannner = 1
                    btnBanner.setTitle("연장", for: .normal)
                    btnBanner.setBackgroundImage(extensiomimg, for: .normal)
                    lblbannerDate.isHidden = false
                    let orihidebn = setJoinDate2(timeStamp: CompanyInfo.hidebn)
                    let str = orihidebn.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let hidebnDate = str[start...end]
                    if SE_flag {
                        lblbannerDate.text = "\(hidebnDate)"
                    }else{
                        lblbannerDate.text = "종료일 \(hidebnDate)"
                    }
                    
                }else{
                    bannner = 0
                    btnBanner.setTitle("", for: .normal)
                    btnBanner.setBackgroundImage(swOffimg, for: .normal)
                    lblbannerDate.isHidden = true
                }
                
                //출퇴근
                if CompanyInfo.multicmtarea >= muticmttodayDate() {
                    cmtonoff = 1
                    ismulticmtarea = true
                    btnCmt.setTitle("연장", for: .normal)
                    btnCmt.setBackgroundImage(extensiomimg, for: .normal)
                    lblMultiendDate.isHidden = false
                    let orimulti = setJoinDate2(timeStamp: CompanyInfo.multicmtarea)
                    let str = orimulti.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let multiDate = str[start...end]
                    if SE_flag {
                        lblMultiendDate.text = "\(multiDate)"
                    }else{
                        lblMultiendDate.text = "종료일 \(multiDate)"
                    }
                    
                    
                }else{
                    cmtonoff = 0
                    ismulticmtarea = false
                    btnCmt.setTitle("", for: .normal)
                    btnCmt.setBackgroundImage(swOffimg, for: .normal)
                    lblMultiendDate.isHidden = true
                }
                
                //근무내역
                if CompanyInfo.empcmt >= muticmttodayDate() {
                    cmtListonoff = 1
                    btnCmtList.setTitle("연장", for: .normal)
                    btnCmtList.setBackgroundImage(extensiomimg, for: .normal)
                    lblCmtListDate.isHidden = false
                    let orimulti = setJoinDate2(timeStamp: CompanyInfo.empcmt)
                    let str = orimulti.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let multiDate = str[start...end]
                    if SE_flag {
                        lblCmtListDate.text = "\(multiDate)"
                    }else{
                        lblCmtListDate.text = "종료일 \(multiDate)"
                    }
                    
                    
                }else{
                    cmtListonoff = 0
                    btnCmtList.setTitle("", for: .normal)
                    btnCmtList.setBackgroundImage(swOffimg, for: .normal)
                    lblCmtListDate.isHidden = true
                }
                
                //회계년도
                if CompanyInfo.ficalyear >= muticmttodayDate() {
                    ficaloff = 1
                    btnFiical.setTitle("연장", for: .normal)
                    btnFiical.setBackgroundImage(extensiomimg, for: .normal)
                    lblFicalDate.isHidden = false
                    let orimulti = setJoinDate2(timeStamp: CompanyInfo.ficalyear)
                    let str = orimulti.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let multiDate = str[start...end]
                    if SE_flag {
                        lblFicalDate.text = "\(multiDate)"
                    }else{
                        lblFicalDate.text = "종료일 \(multiDate)"
                    }
                    
                    
                }else{
                    ficaloff = 0
                    btnFiical.setTitle("", for: .normal)
                    btnFiical.setBackgroundImage(swOffimg, for: .normal)
                    lblFicalDate.isHidden = true
                }
                
                //데이터보관
                if moreCmpInfo.datalimits >= muticmttodayDate() {
                    storageoff = 1
                    btnStorage.setTitle("연장", for: .normal)
                    btnStorage.setBackgroundImage(extensiomimg, for: .normal)
                    lblStorageDate.isHidden = false
                    let orimulti = setJoinDate2(timeStamp: CompanyInfo.datalimits)
                    let str = orimulti.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let multiDate = str[start...end]
                    if SE_flag {
                        lblStorageDate.text = "\(multiDate)"
                    }else{
                        lblStorageDate.text = "종료일 \(multiDate)"
                    }
                }else{
                    storageoff = 0
                    btnStorage.setTitle("", for: .normal)
                    btnStorage.setBackgroundImage(swOffimg, for: .normal)
                    lblStorageDate.isHidden = true
                }
                //근로자 연차 노출 설정
                if moreCmpInfo.displayAualDate >= muticmttodayDate() {
                    displayanualoff = 1
                    btnDisplayAnual.setTitle("연장", for: .normal)
                    btnDisplayAnual.setBackgroundImage(extensiomimg, for: .normal)
                    lblDisplayAnualDate.isHidden = false
                    let orimulti = setJoinDate2(timeStamp: CompanyInfo.displayAualDate)
                    let str = orimulti.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let multiDate = str[start...end]
                    if SE_flag {
                        lblDisplayAnualDate.text = "\(multiDate)"
                    }else{
                        lblDisplayAnualDate.text = "종료일 \(multiDate)"
                    }
                }else{
                    displayanualoff = 0
                    btnDisplayAnual.setTitle("", for: .normal)
                    btnDisplayAnual.setBackgroundImage(swOffimg, for: .normal)
                    lblDisplayAnualDate.isHidden = true
                }
            }
        case 2:
            //   펀프리
            if moreCmpInfo.freedt >= muticmttodayDate() {
                //관리자앱 배너
                if CompanyInfo.hidebnm >= muticmttodayDate() {
                    bannerM = 1
                    btnBannerM.setTitle("연장", for: .normal)
                    btnBannerM.setBackgroundImage(extensiomimg, for: .normal)
                    lblbannerMDate.isHidden = false
                    let orihidebnm = setJoinDate2(timeStamp: CompanyInfo.hidebnm)
                    let str = orihidebnm.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let hidebnMDate = str[start...end]
                    if SE_flag {
                        lblbannerMDate.text = "\(hidebnMDate)"
                    }else{
                        lblbannerMDate.text = "종료일 \(hidebnMDate)"
                    }
                    
                }else{
                    bannerM = 0
                    btnBannerM.setTitle("", for: .normal)
                    btnBannerM.setBackgroundImage(swOffimg, for: .normal)
                    lblbannerMDate.isHidden = true
                }
                
                //근로자앱 배너
                if CompanyInfo.hidebn >= muticmttodayDate() {
                    bannner = 1
                    btnBanner.setTitle("FREE", for: .normal)
                    btnBanner.setBackgroundImage(extensiomimg, for: .normal)
                    lblbannerDate.isHidden = false
                    let orihidebn = setJoinDate2(timeStamp: CompanyInfo.hidebn)
                    let str = orihidebn.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let hidebnDate = str[start...end]
                    if SE_flag {
                        lblbannerDate.text = "\(hidebnDate)"
                    }else{
                        lblbannerDate.text = "종료일 \(hidebnDate)"
                    }
                    
                }else{
                    bannner = 0
                    btnBanner.setTitle("", for: .normal)
                    btnBanner.setBackgroundImage(swOffimg, for: .normal)
                    lblbannerDate.isHidden = true
                }
                
                
                
                //출퇴근
                cmtonoff = 1
                ismulticmtarea = true
                btnCmt.setTitle("FREE", for: .normal)
                btnCmt.setBackgroundImage(extensiomimg, for: .normal)
                lblMultiendDate.isHidden = true
                
                //근무내역
                cmtListonoff = 1
                btnCmtList.setTitle("FREE", for: .normal)
                btnCmtList.setBackgroundImage(extensiomimg, for: .normal)
                lblCmtListDate.isHidden = true
                
                //회계년도
                ficaloff = 1
                btnFiical.setTitle("FREE", for: .normal)
                btnFiical.setBackgroundImage(extensiomimg, for: .normal)
                lblFicalDate.isHidden = true
                
                //데이터보관
                storageoff = 1
                btnStorage.setTitle("FREE", for: .normal)
                btnStorage.setBackgroundImage(extensiomimg, for: .normal)
                lblStorageDate.isHidden = true
                
                //근로자 연차 노출설정
                displayanualoff = 1
                btnDisplayAnual.setTitle("FREE", for: .normal)
                btnDisplayAnual.setBackgroundImage(extensiomimg, for: .normal)
                lblDisplayAnualDate.isHidden = true
                
                lblBannerMPin.text = "\(PayTypeKoArray[moreCmpInfo.freetype])"
                lblCmtPin.text = "\(PayTypeKoArray[moreCmpInfo.freetype])"
                lblCmtListPin.text = "\(PayTypeKoArray[moreCmpInfo.freetype])"
                lblFicalPin.text = "\(PayTypeKoArray[moreCmpInfo.freetype])"
                lblStorePin.text = "\(PayTypeKoArray[moreCmpInfo.freetype])"
            }else{
                //관리자앱 배너
                
                if CompanyInfo.hidebnm >= muticmttodayDate() {
                    bannerM = 1
                    btnBannerM.setTitle("연장", for: .normal)
                    btnBannerM.setBackgroundImage(extensiomimg, for: .normal)
                    lblbannerMDate.isHidden = false
                    let orihidebnm = setJoinDate2(timeStamp: CompanyInfo.hidebnm)
                    let str = orihidebnm.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let hidebnMDate = str[start...end]
                    if SE_flag {
                        lblbannerMDate.text = "\(hidebnMDate)"
                    }else{
                        lblbannerMDate.text = "종료일 \(hidebnMDate)"
                    }
                    
                }else{
                    bannerM = 0
                    btnBannerM.setTitle("", for: .normal)
                    btnBannerM.setBackgroundImage(swOffimg, for: .normal)
                    lblbannerMDate.isHidden = true
                }
                
                //근로자앱 배너
                if CompanyInfo.hidebn >= muticmttodayDate() {
                    bannner = 1
                    btnBanner.setTitle("연장", for: .normal)
                    btnBanner.setBackgroundImage(extensiomimg, for: .normal)
                    lblbannerDate.isHidden = false
                    let orihidebn = setJoinDate2(timeStamp: CompanyInfo.hidebn)
                    let str = orihidebn.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let hidebnDate = str[start...end]
                    if SE_flag {
                        lblbannerDate.text = "\(hidebnDate)"
                    }else{
                        lblbannerDate.text = "종료일 \(hidebnDate)"
                    }
                    
                }else{
                    bannner = 0
                    btnBanner.setTitle("", for: .normal)
                    btnBanner.setBackgroundImage(swOffimg, for: .normal)
                    lblbannerDate.isHidden = true
                }
                
                //출퇴근
                if CompanyInfo.multicmtarea >= muticmttodayDate() {
                    cmtonoff = 1
                    ismulticmtarea = true
                    btnCmt.setTitle("연장", for: .normal)
                    btnCmt.setBackgroundImage(extensiomimg, for: .normal)
                    lblMultiendDate.isHidden = false
                    let orimulti = setJoinDate2(timeStamp: CompanyInfo.multicmtarea)
                    let str = orimulti.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let multiDate = str[start...end]
                    if SE_flag {
                        lblMultiendDate.text = "\(multiDate)"
                    }else{
                        lblMultiendDate.text = "종료일 \(multiDate)"
                    }
                    
                    
                }else{
                    cmtonoff = 0
                    ismulticmtarea = false
                    btnCmt.setTitle("", for: .normal)
                    btnCmt.setBackgroundImage(swOffimg, for: .normal)
                    lblMultiendDate.isHidden = true
                }
                
                //근무내역
                if CompanyInfo.empcmt >= muticmttodayDate() {
                    cmtListonoff = 1
                    btnCmtList.setTitle("연장", for: .normal)
                    btnCmtList.setBackgroundImage(extensiomimg, for: .normal)
                    lblCmtListDate.isHidden = false
                    let orimulti = setJoinDate2(timeStamp: CompanyInfo.empcmt)
                    let str = orimulti.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let multiDate = str[start...end]
                    if SE_flag {
                        lblCmtListDate.text = "\(multiDate)"
                    }else{
                        lblCmtListDate.text = "종료일 \(multiDate)"
                    }
                    
                    
                }else{
                    cmtListonoff = 0
                    btnCmtList.setTitle("", for: .normal)
                    btnCmtList.setBackgroundImage(swOffimg, for: .normal)
                    lblCmtListDate.isHidden = true
                }
                
                //회계년도
                if CompanyInfo.ficalyear >= muticmttodayDate() {
                    ficaloff = 1
                    btnFiical.setTitle("연장", for: .normal)
                    btnFiical.setBackgroundImage(extensiomimg, for: .normal)
                    lblFicalDate.isHidden = false
                    let orimulti = setJoinDate2(timeStamp: CompanyInfo.ficalyear)
                    let str = orimulti.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let multiDate = str[start...end]
                    if SE_flag {
                        lblFicalDate.text = "\(multiDate)"
                    }else{
                        lblFicalDate.text = "종료일 \(multiDate)"
                    }
                    
                    
                }else{
                    ficaloff = 0
                    btnFiical.setTitle("", for: .normal)
                    btnFiical.setBackgroundImage(swOffimg, for: .normal)
                    lblFicalDate.isHidden = true
                }
                
                //데이터보관
                if moreCmpInfo.datalimits >= muticmttodayDate() {
                    storageoff = 1
                    btnStorage.setTitle("연장", for: .normal)
                    btnStorage.setBackgroundImage(extensiomimg, for: .normal)
                    lblStorageDate.isHidden = false
                    let orimulti = setJoinDate2(timeStamp: CompanyInfo.datalimits)
                    let str = orimulti.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let multiDate = str[start...end]
                    if SE_flag {
                        lblStorageDate.text = "\(multiDate)"
                    }else{
                        lblStorageDate.text = "종료일 \(multiDate)"
                    }
                }else{
                    storageoff = 0
                    btnStorage.setTitle("", for: .normal)
                    btnStorage.setBackgroundImage(swOffimg, for: .normal)
                    lblStorageDate.isHidden = true
                }
                
                //근로자 연차 노출 설정
                if moreCmpInfo.displayAualDate >= muticmttodayDate() {
                    displayanualoff = 1
                    btnDisplayAnual.setTitle("연장", for: .normal)
                    btnDisplayAnual.setBackgroundImage(extensiomimg, for: .normal)
                    lblDisplayAnualDate.isHidden = false
                    let orimulti = setJoinDate2(timeStamp: CompanyInfo.displayAualDate)
                    let str = orimulti.replacingOccurrences(of: "-", with: ".")
                    let start = str.index(str.startIndex, offsetBy: 2)
                    let end = str.index(before: str.endIndex)
                    let multiDate = str[start...end]
                    if SE_flag {
                        lblDisplayAnualDate.text = "\(multiDate)"
                    }else{
                        lblDisplayAnualDate.text = "종료일 \(multiDate)"
                    }
                }else{
                    displayanualoff = 0
                    btnDisplayAnual.setTitle("", for: .normal)
                    btnDisplayAnual.setBackgroundImage(swOffimg, for: .normal)
                    lblDisplayAnualDate.isHidden = true
                }
            }
        case 1 :
            //핀프리 , 사용안함
            //관리자앱 배너
            
            if CompanyInfo.hidebnm >= muticmttodayDate() {
                print("\n---------- [ 444 ] ----------\n")
                bannerM = 1
                btnBannerM.setTitle("연장", for: .normal)
                btnBannerM.setBackgroundImage(extensiomimg, for: .normal)
                lblbannerMDate.isHidden = false
                let orihidebnm = setJoinDate2(timeStamp: CompanyInfo.hidebnm)
                let str = orihidebnm.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let hidebnMDate = str[start...end]
                if SE_flag {
                    lblbannerMDate.text = "\(hidebnMDate)"
                }else{
                    lblbannerMDate.text = "종료일 \(hidebnMDate)"
                }
                
            }else{
                bannerM = 0
                btnBannerM.setTitle("", for: .normal)
                btnBannerM.setBackgroundImage(swOffimg, for: .normal)
                lblbannerMDate.isHidden = true
            }
            
            //근로자앱 배너
            if CompanyInfo.hidebn >= muticmttodayDate() {
                bannner = 1
                btnBanner.setTitle("연장", for: .normal)
                btnBanner.setBackgroundImage(extensiomimg, for: .normal)
                lblbannerDate.isHidden = false
                let orihidebn = setJoinDate2(timeStamp: CompanyInfo.hidebn)
                let str = orihidebn.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let hidebnDate = str[start...end]
                if SE_flag {
                    lblbannerDate.text = "\(hidebnDate)"
                }else{
                    lblbannerDate.text = "종료일 \(hidebnDate)"
                }
                
            }else{
                bannner = 0
                btnBanner.setTitle("", for: .normal)
                btnBanner.setBackgroundImage(swOffimg, for: .normal)
                lblbannerDate.isHidden = true
            }
            
            //출퇴근
            if CompanyInfo.multicmtarea >= muticmttodayDate() {
                cmtonoff = 1
                ismulticmtarea = true
                btnCmt.setTitle("연장", for: .normal)
                btnCmt.setBackgroundImage(extensiomimg, for: .normal)
                lblMultiendDate.isHidden = false
                let orimulti = setJoinDate2(timeStamp: CompanyInfo.multicmtarea)
                let str = orimulti.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let multiDate = str[start...end]
                if SE_flag {
                    lblMultiendDate.text = "\(multiDate)"
                }else{
                    lblMultiendDate.text = "종료일 \(multiDate)"
                }
                
                
            }else{
                cmtonoff = 0
                ismulticmtarea = false
                btnCmt.setTitle("", for: .normal)
                btnCmt.setBackgroundImage(swOffimg, for: .normal)
                lblMultiendDate.isHidden = true
            }
            
            //근무내역
            if CompanyInfo.empcmt >= muticmttodayDate() {
                cmtListonoff = 1
                btnCmtList.setTitle("연장", for: .normal)
                btnCmtList.setBackgroundImage(extensiomimg, for: .normal)
                lblCmtListDate.isHidden = false
                let orimulti = setJoinDate2(timeStamp: CompanyInfo.empcmt)
                let str = orimulti.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let multiDate = str[start...end]
                if SE_flag {
                    lblCmtListDate.text = "\(multiDate)"
                }else{
                    lblCmtListDate.text = "종료일 \(multiDate)"
                }
                
                
            }else{
                cmtListonoff = 0
                btnCmtList.setTitle("", for: .normal)
                btnCmtList.setBackgroundImage(swOffimg, for: .normal)
                lblCmtListDate.isHidden = true
            }
            
            //회계년도
            if CompanyInfo.ficalyear >= muticmttodayDate() {
                ficaloff = 1
                btnFiical.setTitle("연장", for: .normal)
                btnFiical.setBackgroundImage(extensiomimg, for: .normal)
                lblFicalDate.isHidden = false
                let orimulti = setJoinDate2(timeStamp: CompanyInfo.ficalyear)
                let str = orimulti.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let multiDate = str[start...end]
                if SE_flag {
                    lblFicalDate.text = "\(multiDate)"
                }else{
                    lblFicalDate.text = "종료일 \(multiDate)"
                }
                
                
            }else{
                ficaloff = 0
                btnFiical.setTitle("", for: .normal)
                btnFiical.setBackgroundImage(swOffimg, for: .normal)
                lblFicalDate.isHidden = true
            }
            
            //데이터보관
            if moreCmpInfo.datalimits >= muticmttodayDate() {
                storageoff = 1
                btnStorage.setTitle("연장", for: .normal)
                btnStorage.setBackgroundImage(extensiomimg, for: .normal)
                lblStorageDate.isHidden = false
                let orimulti = setJoinDate2(timeStamp: CompanyInfo.datalimits)
                let str = orimulti.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let multiDate = str[start...end]
                if SE_flag {
                    lblStorageDate.text = "\(multiDate)"
                }else{
                    lblStorageDate.text = "종료일 \(multiDate)"
                }
            }else{
                storageoff = 0
                btnStorage.setTitle("", for: .normal)
                btnStorage.setBackgroundImage(swOffimg, for: .normal)
                lblStorageDate.isHidden = true
            }
            
            //근로자 연차 노출 설정
            if moreCmpInfo.displayAualDate >= muticmttodayDate() {
                displayanualoff = 1
                btnDisplayAnual.setTitle("연장", for: .normal)
                btnDisplayAnual.setBackgroundImage(extensiomimg, for: .normal)
                lblDisplayAnualDate.isHidden = false
                let orimulti = setJoinDate2(timeStamp: CompanyInfo.displayAualDate)
                let str = orimulti.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let multiDate = str[start...end]
                if SE_flag {
                    lblDisplayAnualDate.text = "\(multiDate)"
                }else{
                    lblDisplayAnualDate.text = "종료일 \(multiDate)"
                }
            }else{
                displayanualoff = 0
                btnDisplayAnual.setTitle("", for: .normal)
                btnDisplayAnual.setBackgroundImage(swOffimg, for: .normal)
                lblDisplayAnualDate.isHidden = true
            }
        default:
             
            //관리자앱 배너
            
            if CompanyInfo.hidebnm >= muticmttodayDate() {
                print("\n---------- [ 444 ] ----------\n")
                bannerM = 1
                btnBannerM.setTitle("연장", for: .normal)
                btnBannerM.setBackgroundImage(extensiomimg, for: .normal)
                lblbannerMDate.isHidden = false
                let orihidebnm = setJoinDate2(timeStamp: CompanyInfo.hidebnm)
                let str = orihidebnm.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let hidebnMDate = str[start...end]
                if SE_flag {
                    lblbannerMDate.text = "\(hidebnMDate)"
                }else{
                    lblbannerMDate.text = "종료일 \(hidebnMDate)"
                }
                
            }else{
                bannerM = 0
                btnBannerM.setTitle("", for: .normal)
                btnBannerM.setBackgroundImage(swOffimg, for: .normal)
                lblbannerMDate.isHidden = true
            }
            
            //근로자앱 배너
            if CompanyInfo.hidebn >= muticmttodayDate() {
                bannner = 1
                btnBanner.setTitle("연장", for: .normal)
                btnBanner.setBackgroundImage(extensiomimg, for: .normal)
                lblbannerDate.isHidden = false
                let orihidebn = setJoinDate2(timeStamp: CompanyInfo.hidebn)
                let str = orihidebn.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let hidebnDate = str[start...end]
                if SE_flag {
                    lblbannerDate.text = "\(hidebnDate)"
                }else{
                    lblbannerDate.text = "종료일 \(hidebnDate)"
                }
                
            }else{
                bannner = 0
                btnBanner.setTitle("", for: .normal)
                btnBanner.setBackgroundImage(swOffimg, for: .normal)
                lblbannerDate.isHidden = true
            }
            
            //출퇴근
            if CompanyInfo.multicmtarea >= muticmttodayDate() {
                cmtonoff = 1
                ismulticmtarea = true
                btnCmt.setTitle("연장", for: .normal)
                btnCmt.setBackgroundImage(extensiomimg, for: .normal)
                lblMultiendDate.isHidden = false
                let orimulti = setJoinDate2(timeStamp: CompanyInfo.multicmtarea)
                let str = orimulti.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let multiDate = str[start...end]
                if SE_flag {
                    lblMultiendDate.text = "\(multiDate)"
                }else{
                    lblMultiendDate.text = "종료일 \(multiDate)"
                }
                
                
            }else{
                cmtonoff = 0
                ismulticmtarea = false
                btnCmt.setTitle("", for: .normal)
                btnCmt.setBackgroundImage(swOffimg, for: .normal)
                lblMultiendDate.isHidden = true
            }
            
            //근무내역
            if CompanyInfo.empcmt >= muticmttodayDate() {
                cmtListonoff = 1
                btnCmtList.setTitle("연장", for: .normal)
                btnCmtList.setBackgroundImage(extensiomimg, for: .normal)
                lblCmtListDate.isHidden = false
                let orimulti = setJoinDate2(timeStamp: CompanyInfo.empcmt)
                let str = orimulti.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let multiDate = str[start...end]
                if SE_flag {
                    lblCmtListDate.text = "\(multiDate)"
                }else{
                    lblCmtListDate.text = "종료일 \(multiDate)"
                }
                
                
            }else{
                cmtListonoff = 0
                btnCmtList.setTitle("", for: .normal)
                btnCmtList.setBackgroundImage(swOffimg, for: .normal)
                lblCmtListDate.isHidden = true
            }
            
            //회계년도
            if CompanyInfo.ficalyear >= muticmttodayDate() {
                ficaloff = 1
                btnFiical.setTitle("연장", for: .normal)
                btnFiical.setBackgroundImage(extensiomimg, for: .normal)
                lblFicalDate.isHidden = false
                let orimulti = setJoinDate2(timeStamp: CompanyInfo.ficalyear)
                let str = orimulti.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let multiDate = str[start...end]
                if SE_flag {
                    lblFicalDate.text = "\(multiDate)"
                }else{
                    lblFicalDate.text = "종료일 \(multiDate)"
                }
                
                
            }else{
                ficaloff = 0
                btnFiical.setTitle("", for: .normal)
                btnFiical.setBackgroundImage(swOffimg, for: .normal)
                lblFicalDate.isHidden = true
            }
            
            //데이터보관
            if moreCmpInfo.datalimits >= muticmttodayDate() {
                storageoff = 1
                btnStorage.setTitle("연장", for: .normal)
                btnStorage.setBackgroundImage(extensiomimg, for: .normal)
                lblStorageDate.isHidden = false
                let orimulti = setJoinDate2(timeStamp: CompanyInfo.datalimits)
                let str = orimulti.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let multiDate = str[start...end]
                if SE_flag {
                    lblStorageDate.text = "\(multiDate)"
                }else{
                    lblStorageDate.text = "종료일 \(multiDate)"
                }
            }else{
                storageoff = 0
                btnStorage.setTitle("", for: .normal)
                btnStorage.setBackgroundImage(swOffimg, for: .normal)
                lblStorageDate.isHidden = true
            }
            
            //근로자 연차 노출 설정
            if moreCmpInfo.displayAualDate >= muticmttodayDate() {
                displayanualoff = 1
                btnDisplayAnual.setTitle("연장", for: .normal)
                btnDisplayAnual.setBackgroundImage(extensiomimg, for: .normal)
                lblDisplayAnualDate.isHidden = false
                let orimulti = setJoinDate2(timeStamp: CompanyInfo.displayAualDate)
                let str = orimulti.replacingOccurrences(of: "-", with: ".")
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(before: str.endIndex)
                let multiDate = str[start...end]
                if SE_flag {
                    lblDisplayAnualDate.text = "\(multiDate)"
                }else{
                    lblDisplayAnualDate.text = "종료일 \(multiDate)"
                }
            }else{
                displayanualoff = 0
                btnDisplayAnual.setTitle("", for: .normal)
                btnDisplayAnual.setBackgroundImage(swOffimg, for: .normal)
                lblDisplayAnualDate.isHidden = true
            }
        }
    }
    
    // MARK: 관리자앱 배너광고 제거
    @objc func bannerMAction(_ sender: UIButton){
        switch moreCmpInfo.freetype {
        case 2,3:
            // 올프리 , 펀프리
            if moreCmpInfo.freedt >= muticmttodayDate() {
                print("\n---------- [ 올프리 , 펀프리  ] ----------\n")
            }else{
                let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                viewflag = "moreEextension"
                vc.checkEextension = bannerM
                vc.payType = 1
                self.present(vc, animated: false, completion: nil)
            }
        default:
            //핀프리 , 사용안함
            let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            viewflag = "moreEextension"
            vc.checkEextension = bannerM
            vc.payType = 1
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    // MARK: 근로자앱 배너광고 제거
    @objc func bannerAction(_ sender: UIButton){
        //핀프리 , 사용안함
        let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        viewflag = "moreEextension"
        vc.checkEextension = bannner
        vc.payType = 2
        self.present(vc, animated: false, completion: nil)
    }
    
    // MARK: 출퇴근 설정
    @objc func cmtAction(_ sender: UIButton){
        switch moreCmpInfo.freetype {
        case 2,3:
            // 올프리 , 펀프리
            if moreCmpInfo.freedt >= muticmttodayDate() {
                print("\n---------- [ 올프리 , 펀프리  ] ----------\n")
            }else{
                let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                viewflag = "moreEextension"
                vc.checkEextension = cmtonoff
                vc.payType = 3
                self.present(vc, animated: false, completion: nil)
            }
        default:
            //핀프리 , 사용안함
            let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            viewflag = "moreEextension"
            vc.checkEextension = cmtonoff
            vc.payType = 3
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    // MARK: 근무내역 설정
    @objc func cmtListAction(_ sender: UIButton){
        switch moreCmpInfo.freetype {
        case 2,3:
            // 올프리 , 펀프리
            if moreCmpInfo.freedt >= muticmttodayDate() {
                print("\n---------- [ 올프리 , 펀프리  ] ----------\n")
            }else{
                let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                viewflag = "moreEextension"
                vc.checkEextension = cmtonoff
                vc.payType = 4
                self.present(vc, animated: false, completion: nil)
            }
        default:
            //핀프리 , 사용안함
            let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            viewflag = "moreEextension"
            vc.checkEextension = cmtonoff
            vc.payType = 4
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    // MARK: 회계년도 설정
    @objc func ficalAction(_ sender: UIButton){
        changeFical() 
    }
    
    //회계연도
    fileprivate func changeFical(){
        NetworkManager.shared().Setfical(cmpsid: userInfo.cmpsid, mbrsid: userInfo.mbrsid) { (isSuccess, resCode, resData) in
            if(isSuccess){
                if resCode > 0 {
                    moreCmpInfo.ficalyear = resData
                    CompanyInfo.ficalyear = resData
                    NotificationCenter.default.post(name: .reloadList, object: nil) 
                 }else{
                    self.toast("다시 시도해 주세요")
                }
            }else{
                self.toast("다시 시도해 주세요")
            }
        }
    }
    
    // MARK: 데이터보관 설정
    @objc func storageAction(_ sender: UIButton){
        switch moreCmpInfo.freetype {
        case 2,3:
            // 올프리 , 펀프리
            if moreCmpInfo.freedt >= muticmttodayDate() {
                print("\n---------- [ 올프리 , 펀프리  ] ----------\n")
            }else{
                let vc = MoreSB.instantiateViewController(withIdentifier: "StoragePopVC") as! StoragePopVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                viewflag = "moreEextension"
                self.present(vc, animated: false, completion: nil)
            }
        default:
            //핀프리 , 사용안함
            let vc = MoreSB.instantiateViewController(withIdentifier: "StoragePopVC") as! StoragePopVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            viewflag = "moreEextension"
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    //근로자 연차 노출
    @objc func changeDiaplayAnual(_ sender: UIButton){
        switch moreCmpInfo.freetype {
        case 2,3:
            // 올프리 , 펀프리
            if moreCmpInfo.freedt >= muticmttodayDate() {
                print("\n---------- [ 올프리 , 펀프리  ] ----------\n")
            }else{
                let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                viewflag = "moreEextension"
                vc.checkEextension = displayanualoff
                vc.payType = 6
                self.present(vc, animated: false, completion: nil)
            }
        default:
            //핀프리 , 사용안함
            let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            viewflag = "moreEextension"
            vc.checkEextension = displayanualoff
            vc.payType = 6
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "MainVC" {
            var vc = UIViewController()
            if SE_flag {
                vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC") as! MainVC
            }else {
                vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            let vc = MoreSB.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
}
