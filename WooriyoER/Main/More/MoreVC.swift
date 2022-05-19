//
//  MoreVC.swift
//  PinPle
//
//  Created by WRY_010 on 25/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import KakaoPlusFriend
import ImageSlideshow
import AlamofireImage

class MoreVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddr: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    @IBOutlet weak var btnCmt: UIButton!
    @IBOutlet weak var btnArea: UIButton!
    @IBOutlet weak var btnAnl: UIButton!
    @IBOutlet weak var btnPrmt: UIButton!
    @IBOutlet weak var btnWeek: UIButton!
    @IBOutlet weak var btnTem: UIButton!
    @IBOutlet weak var btnMgr: UIButton!
    @IBOutlet weak var btnHoliday: UIButton!
    @IBOutlet weak var btnLine: UIButton!
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var vwBannerView: CustomView! //배너
    @IBOutlet weak var vwBannerViewHeight: NSLayoutConstraint!
    

    @IBOutlet weak var tabbarCustomView: UIView! //하단 탭바뷰
    @IBOutlet weak var tabButtonPinpl: UIButton! //하단 탭바 핀플
    @IBOutlet weak var tabButtonCmt: UIButton! // 하단 탭바 출퇴근
    @IBOutlet weak var tabButtonAnnual: UIButton! // 하단 탭바 연차
    @IBOutlet weak var tabButtonApply: UIButton! // 하단 탭바 신청
    @IBOutlet weak var tabButtonMore: UIButton! // 하단 탭바 더보기
    @IBOutlet weak var btnManual: UIButton!
    @IBOutlet weak var btnManualWork: UIButton!
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).magnitude,
        preferredMemoryUsageAfterPurge: UInt64(60).magnitude
    )
       
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var author = 0
    var adView: ImageSlideshow! //광고
    var height: CGFloat = 0 //배너 높이
    var disposeBag: DisposeBag = DisposeBag()
    var ismulticmtarea : Bool = false { // 출퇴근 영역 복수 설정 추가 21.02.16 seob
        didSet{
            print(ismulticmtarea)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btnManual.layer.cornerRadius = 6
        btnManualWork.layer.cornerRadius = 6
        switch deviceHeight() {
        case 1:
            contentHeight.constant = 530
        case 2:
            contentHeight.constant = 529
            scrollView.isScrollEnabled = true
        case 3:
            contentHeight.constant = 598
            scrollView.isScrollEnabled = true
        case 4:
            contentHeight.constant = 630
            scrollView.isScrollEnabled = true
        case 5:
            contentHeight.constant = 714
            scrollView.isScrollEnabled = true
        default:
            contentHeight.constant = 630
            scrollView.isScrollEnabled = true
        }
        
        imgProfile.makeRounded()
        
//        author = prefs.value(forKey: "author") as! Int
        author = userInfo.author        
//        setupAdView()
        
        viewflag = "MoreVC"
    }
    // MARK: 광고
    private func setupAdView() {
        let imgWidth = 375
        let imgHeight = 100
        let screenWidth = Int(UIScreen.main.bounds.size.width)
        

        height = CGFloat((screenWidth * imgHeight) / imgWidth)
        
        vwBannerViewHeight.constant = height
        
        adView = ImageSlideshow(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: Int(vwBannerViewHeight.constant)))
        
        adView.backgroundColor = UIColor.white
        adView.slideshowInterval = 6.0
        adView.pageIndicator = nil 
        adView.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        
        var source = [InputSource]()
        if appData.adMoreImages.count > 0 {
            for index in 0...appData.adMoreImages.count-1 {
                source.append(KingfisherSource(urlString: appData.adMoreImages[index].img)!)
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
                adView.addGestureRecognizer(gestureRecognizer)
            }
            
            if(source.count > 0){
                adView.setImageInputs(source)
            }
        }else{
            adView.setImageInputs([
                ImageSource(image: UIImage(named: "moreDefault")!)
            ])
            adView.contentScaleMode = UIViewContentMode.scaleAspectFill
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
            adView.addGestureRecognizer(gestureRecognizer)
        }
        
        //배너뷰 노출
        self.vwBannerView.isHidden = false
        self.vwBannerView.addSubview(self.adView)
    }
    // MARK: 광고 클릭시
    @objc func didTap(_ sender: UITapGestureRecognizer){
        if appData.adMoreImages.count > 0 {
            if  appData.adMoreImages[self.adView.currentPage].link != ""{
                // safari --
                let weburl =  appData.adMoreImages[self.adView.currentPage].link.replacingOccurrences(of: "\\", with: "")
//                print("\n---------- [ weburl : \(weburl) , banner : \(appData.adMoreImages[self.adView.currentPage].name)] ----------\n")
//                UIApplication.shared.open(URL(string: weburl)!, options: [:], completionHandler: nil)
//                // -- safari
                let vc = MoreSB.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
                vc.adURL = weburl
                vc.adName = appData.adMainImages[self.adView.currentPage].name
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }else{
            //배너가 없을경우 기본
            //KPFPlusFriend.init(id: "_LaxoExb").chat()
        }
        
    }
     
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appData.adMoreImages.removeAll()
        loadMoreAdImages {
            if !self.checkhideM() {
                self.vwBannerViewHeight.constant = 100
                self.setupAdView()
            }else{
                self.vwBannerViewHeight.constant = 0
            }
            
        }
        valueSetting()
        getMbrInfo()
    }
   // 회원 정보 불러오기
   func getMbrInfo() {
           prefs.setValue(false, forKey: "cmt_popflag")
           let mbrsid = userInfo.mbrsid
           NetworkManager.shared().GetMbrInfo(mbrsid: mbrsid) { (isSuccess, resData) in
               if (isSuccess) {
                   guard let serverData = resData else { return }
                   userInfo.mbrsid = serverData.mbrsid
                   userInfo.author = serverData.author
                   userInfo.empsid = serverData.empsid
           }
       }
    }
   
   //MARK: - Tabbar
    @IBAction func pinplTab(_ sender: UIButton) {
        var vc = UIViewController()
        if SE_flag {
            vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC") as! MainVC
        }else {
            vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func cmtTab(_ sender: UIButton) {
        var vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
        if SE_flag {
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_CmtEmpList") as! CmtEmpList
        }else{
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func anlTab(_ sender: UIButton) {
        var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        if SE_flag {
            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
        }else{
            vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func aplTab(_ sender: UIButton) {
        var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
        if SE_flag {
            vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
        }else{
            vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
        }
        isTap = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func moreTab(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    //MARK: - @IBAction
    //사용 광고 문의
   
    //회사정보수정
    @IBAction func CmpInfoClick(_ sender: UIButton) {
        if author == 3 || author == 4 {
            customAlertView("권한이 없습니다.\n마스터관리자와 최고관리자만 가능합니다.")
        }else {
            let vc = MoreSB.instantiateViewController(withIdentifier: "SetCmpInfoVC") as! SetCmpInfoVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: false, completion: nil)
        }
    }
    //핀플 사용 설명서
    @IBAction func manualClcik(_ sender: UIButton) {
        // 2020.07.22 web에서 파일명 변경
        if let url = URL(string: "http://pinpl.biz/guide.jsp") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    //근로계약서
    @IBAction func tipClick(_ sender: UIButton) {
 
        if let url = URL(string: "http://pinpl.biz/00_pinpl_guide.jsp") {
            UIApplication.shared.open(url, options: [:])
        }
  
    }
    
    //근로시간
    @IBAction func CmtTimeClick(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "CmtTimeVC") as! CmtTimeVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    //출퇴근 영역
    @IBAction func CmtAreaClick(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "SetCmtVC") as! SetCmtVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_SetCmtVC") as! SetCmtVC
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    //연차설정
    @IBAction func AnlSettingClick(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "SetAnlVC") as! SetAnlVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    //연차촉진
    @IBAction func AnlPrmClick(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "PrmListVC") as! PrmListVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    //주52시간
    @IBAction func WeekHourClick(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "WeekHourVC") as! WeekHourVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    //팀관리
    @IBAction func TemMgmtClick(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    //관리자 관리
    @IBAction func CmpMgrClick(_ sender: UIButton) {
        if author == 3 || author == 4 {
            customAlertView("권한이 없습니다.\n마스터관리자와 최고관리자만 가능합니다.")
        }else {
            var vc = UIViewController()
            if SE_flag {
                vc = MoreSB.instantiateViewController(withIdentifier: "SE_CmpMgrVC") as! CmpMgrVC
            }else {
                vc = MoreSB.instantiateViewController(withIdentifier: "CmpMgrVC") as! CmpMgrVC
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: false, completion: nil)
        }
    }
    //휴무일 설정
    @IBAction func CmpHolidayClick(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "HolidayListVC") as! HolidayListVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_HolidayListVC") as! HolidayListVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "HolidayListVC") as! HolidayListVC
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    //결재라인
    @IBAction func AprLineClick(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "CmpAprSelVC") as! CmpAprSelVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    //합류코드
    @IBAction func CodeClick(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "SetCodeVC") as! SetCodeVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    //사용문의
    @IBAction func pcClick(_ sender: UIButton) {
        KPFPlusFriend.init(id: "_xgEMxkT").chat()
    }
    //설정
    @IBAction func SettingClick(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_SettingVC") as! SettingVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    // 증명서
    @IBAction func CertificateClick(_ sender: UIButton) {
//        if userInfo.author == 0 || userInfo.author == 1 {
            var vc = CertifiSB.instantiateViewController(withIdentifier: "CertifiCateMainVC") as! CertifiCateMainVC
            if SE_flag {
                vc = CertifiSB.instantiateViewController(withIdentifier: "SE_CertifiCateMainVC") as! CertifiCateMainVC
            }else{
                vc = CertifiSB.instantiateViewController(withIdentifier: "CertifiCateMainVC") as! CertifiCateMainVC
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: false, completion: nil)
//        }else{
//            customAlertView("권한이 없습니다.\n마스터관리자와 인사담당자만 가능합니다.")
//        }
 
    }
    
    // 재택출퇴근
    @IBAction func HomecmtClick(_ sender: UIButton) {
        if checkmultiarea() {
            let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            viewflag = "moremainhomecmt"
            self.present(vc, animated: false, completion: nil)
        }else{
            let vc = MoreSB.instantiateViewController(withIdentifier: "HomeMTTListVC") as! HomeMTTListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    //재택 출퇴근 - 핀체크 (muticmtarea date 사용유무)
    func checkmultiarea() -> Bool {
        switch moreCmpInfo.freetype {
            case 2,3:
                // 올프리 , 펀프리
                if moreCmpInfo.freedt >= muticmttodayDate() {
                    return false
                }else{
                    if moreCmpInfo.multicmtarea >= muticmttodayDate() {
                        return false
                    }else{
                        return true
                    }
                }
            default:
                //핀프리 , 사용안함
                if moreCmpInfo.multicmtarea >= muticmttodayDate() {
                    return false
                }else{
                    return true
                }
        }
    }
    
    func checkhideM() -> Bool {        
        switch moreCmpInfo.freetype {
            case 2,3:
                // 올프리 , 펀프리
                if moreCmpInfo.freedt >= muticmttodayDate() {
                    return true
                }else{
                    if moreCmpInfo.hidebnm >= muticmttodayDate() {
                        return true
                    }else{
                        return false
                    }
                }
            default:
                //핀프리 , 사용안함
                if moreCmpInfo.hidebnm >= muticmttodayDate() {
                    return true
                }else{
                    return false
                }
        }
    }
    
    func valueSetting() {
        NetworkManager.shared().getCmpInfo(cmpsid: userInfo.cmpsid) { (isSuccess, errCode, resData) in
            if(isSuccess){
                if errCode == 99 {
                    self.toast("다시 시도해 주세요.")
                }else{
                    guard let serverData = resData else { return }
                    moreCmpInfo = serverData
                    CompanyInfo = moreCmpInfo
                    moreCmpInfo.starttm = moreCmpInfo.starttm.timeTrim()
                    moreCmpInfo.endtm = moreCmpInfo.endtm.timeTrim()
                    
                    let defaultProfimg = UIImage(named: "logo_pre")
                    if serverData.logo.urlTrim() != "img_logo_default.png" {
                        self.imgProfile.setImage(with: serverData.logo)
                    }else{
                        self.imgProfile.image = defaultProfimg
                    }
                    
                    if moreCmpInfo.enname != "" {
                        self.lblName.text = moreCmpInfo.name + " / " + moreCmpInfo.enname
                    }else {
                        self.lblName.text = moreCmpInfo.name
                    }
                    if moreCmpInfo.addr != "" {
                        self.lblAddr.text = "주소 : " + moreCmpInfo.addr
                    }else {
                        self.lblAddr.text = "주소 : 미입력"
                    }
                    if moreCmpInfo.phone != "" {
                        self.lblPhone.text = "대표번호 : " + moreCmpInfo.phone.pretty()
                    }else {
                        self.lblPhone.text = "대표번호 : 미입력"
                    }
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
}


// MARK: - 광고
extension MoreVC { 
    //MARK: Load More AD images
    func loadMoreAdImages(finished : @escaping ()->Void) {
        
        let downloadImages = {
            let myGroup = DispatchGroup.init()
            
            for info in appData.adMoreImages {
                myGroup.enter()
                 let cachedImg = self.cachedImage(for: info.img)
                 if cachedImg != nil {
                     info.image = cachedImg
                 }
                myGroup.leave()
            }
            
            myGroup.notify(queue: DispatchQueue.main) {
                
                finished()
            }
        }
        
        NetworkManager.shared().BannerListRx(1, 1)
            .subscribe(onNext: { (isSuccess, resData) in
                if(isSuccess){
                    guard let serverData = resData else { return }
                    appData.adMoreImages = serverData
                }
            }, onError: { (err) in
                print("\n---------- [ 이미지 불러오기 실패 ] ----------\n")
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }, onCompleted: {
                downloadImages()
            }).disposed(by: disposeBag)
        
    }
    
    func cache(_ image: KFCrossPlatformImage, for url: String) {
        imageCache.add(image, withIdentifier: url)
    }
    
    func cachedImage(for url: String) -> KFCrossPlatformImage? {
        return imageCache.image(withIdentifier: url)
    }
}
