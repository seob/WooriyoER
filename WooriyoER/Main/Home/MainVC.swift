//
//  MainVC.swift
//  PinPle
//
//  Created by WRY_010 on 18/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import ImageSlideshow
import AlamofireImage


class MainVC: UIViewController, NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var lblLeave: UILabel!
    @IBOutlet weak var lblAnl: UILabel!
    @IBOutlet weak var lblBsns: UILabel!
    @IBOutlet weak var lblAplAnl: UILabel!
    @IBOutlet weak var lblAplBsns: UILabel!
    @IBOutlet weak var lblAplOver: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBelong: UILabel!
    @IBOutlet weak var vwSlide: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var vwBannerView: CustomView! //배너
    @IBOutlet weak var vwBannerViewHeight: NSLayoutConstraint! //배너 높이
    
    @IBOutlet weak var slideHeight: NSLayoutConstraint!
    @IBOutlet weak var slideTop: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var tabbarCustomView: UIView! //하단 탭바뷰
    @IBOutlet weak var tabButtonPinpl: UIButton! //하단 탭바 핀플
    @IBOutlet weak var tabButtonCmt: UIButton! // 하단 탭바 출퇴근
    @IBOutlet weak var tabButtonAnnual: UIButton! // 하단 탭바 연차
    @IBOutlet weak var tabButtonApply: UIButton! // 하단 탭바 신청
    @IBOutlet weak var tabButtonMore: UIButton! // 하단 탭바 더보기
    
    @IBOutlet weak var quickBox1Height: NSLayoutConstraint!
    @IBOutlet weak var quickBox2Height: NSLayoutConstraint!
    @IBOutlet weak var quickBox3Height: NSLayoutConstraint!
    
    @IBOutlet weak var newImageView: UIImageView!
    
    let appDelegate : AppDelegate = AppDelegate().shardInstance() // seob
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).magnitude,
        preferredMemoryUsageAfterPurge: UInt64(60).magnitude
    )

    var MbrInfo:getMbrInfo!
    var MainInfo:MainInfo!
    
    var anualaprcnt = 0
    var anualcnt = 0
    var apraddcnt = 0
    var aprtripcnt = 0
    var cmtoffcnt = 0
    var cmtoncnt = 0
    var empcnt = 0
    var tripcnt = 0
    
    var device = 0
    
    var cmpsid: Int = 0    //회사번호
    var cmpname: String = ""    //회사이름
    var spot: String = ""   //직급
    var temsid: Int = 0    //팀번호
    var author: Int = 0    //권한
    var ttmname: String = ""    //상위팀이름
    var ttmsid: Int = 0    //상위팀번호
    var name: String = ""   //이름
    var profimg: String = ""    //사진 URL
    var empsid: Int = 0    //직원번호
    var temname: String = ""   //팀이름
    var enname: String = "" //영문이름
    
    var adView: ImageSlideshow! //광고
    
    var height: CGFloat = 0 //배너 높이

    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.checkWifi()
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.layer.borderWidth = 2
        imgProfile.layer.borderColor = UIColor.clear.cgColor
        imgProfile.clipsToBounds = true
        
        vwSlide.clipsToBounds = true
        vwSlide.layer.cornerRadius = 44
        vwSlide.layer.maskedCorners = [.layerMinXMinYCorner]
        
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        
        device = self.deviceHeight()
        switch device {
        case 1:
            slideHeight.constant = UIScreen.main.bounds.size.height + 300
            slideTop.constant = 180
        case 2:
            slideHeight.constant = UIScreen.main.bounds.size.height + 222
            slideTop.constant = 240
            quickBox1Height.constant = quickBox1Height.constant - 10
            quickBox2Height.constant = quickBox2Height.constant - 10
            quickBox3Height.constant = quickBox3Height.constant - 10
        case 3:
            slideHeight.constant = UIScreen.main.bounds.size.height + 204
            slideTop.constant = 222
        default:
            slideHeight.constant = UIScreen.main.bounds.size.height + 127
            slideTop.constant = 195
        }
        viewflag = "MainVC"
         
    }
    
    func layoutBannerHeight(){
        let device = deviceHeight()
        switch device {
        case 1:
            height = 100
            break
        case 2, 3 :
            height = 150
            break
        case 4:
            height = 115
            break
        case 5:
            height = 120
            break
        default:
            break
        }
        vwBannerViewHeight.constant = height
    }
    
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    func checkhideM() -> Bool {
        switch moreCmpInfo.freetype {
            case 3:
                // 올프리
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appData.adMainImages.removeAll()
        
         self.getMbrInfo()
        if isVersionCnt == 0 {
            if !isVersionCheck {
                self.versionCheck()
            }else{
                self.getMbrInfo()
            }
        }else{
            self.getMbrInfo()
        }
        
    }
    //공지사항
    @IBAction func goToNotice(_ sender: UIButton) {
        let vc = MainSB.instantiateViewController(withIdentifier: "PinPlNoticeVC") as! PinPlNoticeVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    // FIXME: -  버전체크(서버에서 버전체크하게 수정) - 2020.03.27 seob
    func versionCheck(){
        isVersionCnt += 1
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String 
        NetworkManager.shared().AppVersionCheck(mode: 1, appvs: deviceInfo.APPVS) { (isSuccess, update, updatemsg, curver , review) in
            if(isSuccess){
                guard let verSion = version else { return }
                if review == 0 {
                    // 상용
                    if verSion != curver {
                        self.customActionAlertView("Ver \(curver)\n최신 버전을 앱스토어에서 \n다운 받으시겠습니까?")
                        isVersionCheck = false
                         self.getMbrInfo()
                    }else{
                        isVersionCheck = true
                        self.getMbrInfo()
                    }
                }else{
                    // 리뷰기간
                    isVersionCheck = true
                    self.getMbrInfo()
                }
            }
        }
    }
    
    // MARK: 광고
    private func setupAdView(){
        
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
        if appData.adMainImages.count > 0 {
            for index in 0...appData.adMainImages.count-1 {
                source.append(KingfisherSource(urlString: appData.adMainImages[index].img)!)
//                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
//                adView.addGestureRecognizer(gestureRecognizer)
            }
            
            if(source.count > 0){
                adView.setImageInputs(source)
            }
        }else{
            adView.setImageInputs([
                ImageSource(image: UIImage(named: "mainDefault")!)
            ])
//            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
//            adView.addGestureRecognizer(gestureRecognizer)
        }
        
        //배너 배너뷰 노출
        self.vwBannerView.isHidden = false
        self.vwBannerView.addSubview(self.adView)
    }
    // MARK: 광고 클릭시
    @objc func didTap(){
        if appData.adMainImages.count > 0 {
            if  appData.adMainImages[self.adView.currentPage].link != ""{
                // safari --
                let weburl =  appData.adMainImages[self.adView.currentPage].link.replacingOccurrences(of: "\\", with: "")
                UIApplication.shared.open(URL(string: weburl)!, options: [:], completionHandler: nil)
                // -- safari
            }
        }else{
            //배너가 없을경우 기본
            //KPFPlusFriend.init(id: "_LaxoExb").chat()
        }
        
    }
    
    // MARK: Top View Click Event 
    //직원 추가
    @IBAction func addEmpButtonDidTap(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "SetCodeVC") as! SetCodeVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    // 근로계약서 
    @IBAction func managerButtonDidTap(_ sender: UIButton) {
        
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
    //결재 라인
    @IBAction func aplLineButtonDidTap(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "CmpAprSelVC") as! CmpAprSelVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    // 출퇴근 영역
    @IBAction func areaButtonDidTap(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "SetCmtVC") as! SetCmtVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // 출퇴근 리스트
    @IBAction func ButtonDidTap5(_ sender: Any) {
        var vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
        if SE_flag {
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_CmtEmpList") as! CmtEmpList
        }else{
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func ButtonDidTap2(_ sender: Any) {
        var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        if SE_flag {
            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
        }else{
            vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        }
        notitype = "20"
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func ButtonDidTap3(_ sender: Any) {
        var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        if SE_flag {
            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
        }else{
            vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        }
        notitype = "22"
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func ButtonDidTap4(_ sender: Any) {
        var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        if SE_flag {
            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
        }else{
            vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        }
        notitype = "22"
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func profileClick(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "UdtMbrInfoVC") as! UdtMbrInfoVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func totalEmply(_ sender: UIButton) {
        let vc = MainSB.instantiateViewController(withIdentifier: "TotalEmpLits") as! TotalEmpLits
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Tabbar
    @IBAction func pinplTab(_ sender: UIButton) {
        let vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
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
    
    
    // 회사 정보 불러오기
     func getCmpInfo(){
        NetworkManager.shared().getCmpInfo(cmpsid: userInfo.cmpsid) { (isSuccess,errCode , resData) in
            if(isSuccess){
                if errCode == 99 {
                    self.customAlertView("다시 시도해 주세요.")
                }else{
                    guard let serverData = resData else { return }
                    CompanyInfo = serverData
                    moreCmpInfo = serverData
                }
            }else{
                self.customAlertView("네트워크 상태를 확인해 주세요.")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }
        }
    }
    
    //증명서 카운트 정보
    func getCertCnt(){
        NetworkManager.shared().GetCertmain(cmpsid: userInfo.cmpsid) { (isSuccess, empCnt, carCnt) in
            if(isSuccess){
                Emplycnt = empCnt
                Careercnt = carCnt
            }
        }
    }
    
    
    // 회원 정보 불러오기
    func getMbrInfo() {
            prefs.setValue(false, forKey: "cmt_popflag")
            let mbrsid = userInfo.mbrsid
            NetworkManager.shared().GetMbrInfo(mbrsid: mbrsid) { (isSuccess, resData) in
                if (isSuccess) {
                    guard let serverData = resData else { return }
                    self.MbrInfo = serverData
                    self.setPushId(mbrsid: mbrsid)
    //                userInfo = serverData
                    userInfo.mbrsid = serverData.mbrsid
                    userInfo.author = serverData.author
                    userInfo.cmpsid = serverData.cmpsid
                    userInfo.joindt = serverData.joindt
                    userInfo.empsid = serverData.empsid
      
                     
                    self.cmpsid = serverData.cmpsid
                     
                    self.cmpname = self.MbrInfo.cmpname
                    self.spot = self.MbrInfo.spot
                    self.temsid = self.MbrInfo.temsid
                    self.author = self.MbrInfo.author
                    self.ttmname = self.MbrInfo.ttmname
                    self.ttmsid = self.MbrInfo.ttmsid
                    self.name = self.MbrInfo.name
                    self.profimg = self.MbrInfo.profimg
                    self.empsid = self.MbrInfo.empsid
                    self.temname = self.MbrInfo.temname
                    self.enname = self.MbrInfo.enname
                    
                    SelTtmSid = self.MbrInfo.ttmsid
                    SelTemSid = self.MbrInfo.temsid
                    
                    prefs.setValue(self.author, forKey: "author")
                    
                    if self.enname == "" {
                        self.lblName.text = self.name
                    }else {
                        self.lblName.text = self.name + "(" + self.enname + ")"
                    }
                                     
//                    let defaultProfimg = UIImage(named: "logo_pre")
//                    if self.profimg.urlTrim() != "img_photo_default.png" {
//                        self.imgProfile.setImage(with: self.profimg)
//                    }else{
//                        self.imgProfile.image = defaultProfimg
//                    }
                    
                    self.imgProfile.sd_setImage(with: URL(string: self.profimg), placeholderImage: UIImage(named: "no_picture"))
                    
                    self.lblSpot.text = self.spot
                    
                    
                    
                    var temStr = ""
                    switch self.author {
                    case 1, 2:
                        temStr = self.cmpname
                    case 3:
                        temStr = self.ttmname
                    default:
                        temStr = self.temname
                    }
                    
                    self.lblBelong.text = temStr
                    self.valueSetting()
                    self.getCmpInfo()
                    self.getCertCnt()
                    self.getTemLine() // 팀 연차/신청 결재라인 2020.03.09 seob
                    
                    self.loadMainAdImages{
                        if !self.checkhideM() {
                            self.setupAdView()
                            self.vwBannerViewHeight.constant = 100
                        }else{
                            self.vwBannerViewHeight.constant = 0
                        }
                    } //메인 광고
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                    
                }
                

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.stopAnimating(nil)
                }
            }
        }
    
    func valueSetting() {
        
        NetworkManager.shared().GetMain(empsid: empsid, auth: author, cmpsid: cmpsid, ttmsid: ttmsid, temsid: temsid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                self.MainInfo = serverData
                self.anualaprcnt = serverData.anualaprcnt
                self.anualcnt = serverData.anualcnt
                self.apraddcnt = serverData.apraddcnt
                self.aprtripcnt = serverData.aprtripcnt
                self.cmtoffcnt = serverData.cmtoffcnt
                self.cmtoncnt = serverData.cmtoncnt
                self.empcnt = serverData.empcnt
                self.tripcnt = serverData.tripcnt
                
                self.lblWork.text = "\(self.empcnt)"
                self.lblLeave.text = "\(self.cmtoffcnt)"
                self.lblAnl.text = "\(self.anualcnt)"
                self.lblBsns.text = "\(self.tripcnt)"
                self.lblAplAnl.text = "\(self.anualaprcnt)"
                self.lblAplBsns.text = "\(self.aprtripcnt)"
                self.lblAplOver.text = "\(self.apraddcnt)"
                Mainanualaprcnt = self.anualaprcnt
                Mainaprtripcnt = self.aprtripcnt
                Mainapraddcnt = self.apraddcnt
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
                
            }else{
                self.customAlertView("네트워크 상태를 확인해 주세요.")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                     self.stopAnimating(nil)
                 }
            }
        }
        
        NetworkManager.shared().checkNewNotice(cmpsid: cmpsid) { isSuccess, resCode in
            if isSuccess {
                newNoticeCheck = resCode
                if resCode > 0 {
                    self.newImageView.isHidden = false
                }else{
                    self.newImageView.isHidden = true
                }
            }
        }
    }
    
    
    func getTemLine(){
        NetworkManager.shared().GetTemInfo(temflag: SelTemFlag, ttmsid: SelTtmSid, temsid: SelTemSid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                SelTemInfo = serverData
            }else {
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
}
extension MainVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print("offsetY1 = ", offsetY)
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        //                print("offsetY2 = ", offsetY)
        
        if offsetY < -100 && (device == 1 || device == 2 || device == 3){
            IndicatorSetting()
            valueSetting()
        }
        
        if offsetY < -150 && (device == 4 || device == 5){
            IndicatorSetting()
            valueSetting()
        }
    }
    
}

// MARK: - 광고
extension MainVC { 
    func loadMainAdImages(finished : @escaping ()->Void) {
        
        let downloadImages = {
            let myGroup = DispatchGroup.init()
            
            for info in appData.adMainImages {
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
        NetworkManager.shared().BannerListRx(1, 0)
            .subscribe(onNext: { (isSuccess, resData) in
                if(isSuccess){
                    guard let serverData = resData else { return }
                    appData.adMainImages = serverData
                }
            }, onError: { (err) in
                print("\n---------- [ 이미지 불러오기 실패 ] ----------\n")
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
