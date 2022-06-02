//
//  AppData.swift
//  PinPle
//
//  Created by seob on 2020/02/06.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import UIKit
import PDFKit
import StoreKit

//MARK: - Module
let appData : AppData = AppData.sharedInstance
//MARK: - Dispatch
let dispatchMain = DispatchQueue.main
let dispatchGlobal = DispatchQueue.global()

class API {
    
    static let baseURL:String = "http://app01.pinpl.biz/" // 실서버
    static let WEBbaseURL:String = "http://pinpl.biz/" //실서버(web)
    static let pinpl_header = [ "appversion" : "0.1"]
}
// MARK: - naver sdk
let NaverclientID = "qaUqXoimq9Gp6yWYaJzQ"
let NaverclientSecret = "oheowKrlCz"
var noticeType = 0 // 0 알림 , 1 사내공지 ,2 핀플공지
var noticeGidx = 0
var newNoticeCheck = 0 //메인 공지사항 new 표시여부 (최신글이 있는지)
// MARK: - storyboard
let LoginSignSB: UIStoryboard = UIStoryboard.init(name: "LoginSign", bundle: nil)
let CmpCrtSB: UIStoryboard = UIStoryboard.init(name: "CmpCrt", bundle: nil)
let TmCrtSB: UIStoryboard = UIStoryboard.init(name: "TmCrt", bundle: nil)
let IntroSB: UIStoryboard = UIStoryboard.init(name: "Intro", bundle: nil)
let MainSB: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil) //메인
let CmpCmtSB: UIStoryboard = UIStoryboard.init(name: "CmpCmt", bundle: nil) //출퇴근
let AnlAprSB: UIStoryboard = UIStoryboard.init(name: "AnlApr", bundle: nil) //연차
let AplAprSB: UIStoryboard = UIStoryboard.init(name: "AplApr", bundle: nil)
let MoreSB: UIStoryboard = UIStoryboard.init(name: "More", bundle: nil) //더보기
let ContractSB: UIStoryboard = UIStoryboard.init(name: "Contract", bundle: nil) //근로계약서
let CertifiSB : UIStoryboard = UIStoryboard.init(name: "Certificate", bundle: nil) //증명서
let SecurtSB : UIStoryboard = UIStoryboard.init(name: "SecurtContract", bundle: nil) //보안서약서

// MARK: - image
let defaultImg: UIImage = UIImage(named: "logo_pre")!   // 기본 프로필 이미지
let checkImg: UIImage = UIImage(named: "er_checkbox")!  // 체크 된 동그라미
let uncheckImg: UIImage = UIImage(named: "icon_nonecheck")! // 체크 안된 동그라미
let switchOnImg: UIImage = UIImage(named: "btn_switch_on")! // 켜진 스위치
let switchOffImg: UIImage = UIImage(named: "btn_switch_off")!   // 꺼진 스위치

let switchOnImgFree: UIImage = UIImage(named: "btn_switch_on")! // 유료 켜진 스위치
let switchOffImgFree: UIImage = UIImage(named: "y_btn_off")!   // 유료 꺼진 스위치

let roundOnImage : UIImage = UIImage(named: "btn_round_option_on")!
let roundOffImage : UIImage = UIImage(named: "btn_round_option_off")!
let images = ToggleSwitchImages(baseOnImage: UIImage(named: "btn_switch_on")!,
                                baseOffImage: UIImage(named: "btn_switch_off")!,
                                thumbOnImage: UIImage(),
                                thumbOffImage: UIImage())

let imagesFree = ToggleSwitchImages(baseOnImage: UIImage(named: "y_btn_2")!,
                                    baseOffImage: UIImage(named: "y_btn_off")!,
                                    thumbOnImage: UIImage(named: "y_btn_2")!,
                                    thumbOffImage: UIImage(named: "y_btn_off")!)


let imagesFreeFical = ToggleSwitchImages(baseOnImage: UIImage(named: "y_btn")!,
                                         baseOffImage: UIImage(named: "y_btn_off")!,
                                         thumbOnImage: UIImage(named: "y_btn")!,
                                         thumbOffImage: UIImage(named: "y_btn_off")!)



// MARK: - color
let customBlue = UIColor.init(hexString: "#043856").cgColor // 진한 블루
let customGray = UIColor.init(hexString: "#DADADA").cgColor // 연한 회색

//GPS 범위
let distanceList = [50, 100, 300 , 500]

// 디바이스 정보
let deviceInfo: DeviceInfo = DeviceInfo()

let prefs = UserDefaults.standard

var homeselsid = 0
//푸쉬알림 타입
var notitype: String = ""

// 이전 뷰 정보
var viewflag: String = ""
// e2c56db5-dffb-48d2-b060-d0f5a71096e0
// 구글맵 key
let googlePlaceAPIKey = "AIzaSyDFAEZJVm5MM2NodofAEZHtEpXXMrQYYJQ"
var userInfo: MbrInfo = MbrInfo() // 회원정보
var MainCount: MainInfo = MainInfo() //메인 카운트
var CompanyInfo: CmpInfo = CmpInfo() //회사정보
var ContractEmpinfo : LcEmpInfo = LcEmpInfo() //근로계약서 현재 선택된 직원정보
var CertifiEmpinfo : Ce_empInfo = Ce_empInfo() //증명서 현재 선택된 직원정보
var shortUrl = "" //짧은주소변환 - 근로계약서 관련
var ContractStep : [String] = ["step1","step2","step3","step4","step5","step6","step7"]
var SE_flag: Bool = false   // se 구별자 true. se false se이외 
var moreCmpInfo: CmpInfo = CmpInfo() //더보기 회사정보
var SelTemInfo: TemInfo = TemInfo() //선택 팀정보
var SelCmtareainfo: Addcmtarea = Addcmtarea() //선택 팀정보
var SelEmpInfo: EmplyInfo = EmplyInfo() //선택 직원정보
var SelCmtInfo: EmplyInfoDetail =  EmplyInfoDetail() //선택 근무정보
var SelCeEmpInfo: CeMgrList = CeMgrList() //선택 증명서 발급담당자 직원정보
var Sel_CeEmpInfo: Ce_empInfo = Ce_empInfo() //선택된 재직증명서 직원정보

var Mainanualaprcnt = 0
var Mainaprtripcnt = 0
var Mainapraddcnt = 0

var SelAprInfo: AprInfo = AprInfo() //선택 결재라인 정보
var SelWarningEmpInfo: WarningEmpInfo = WarningEmpInfo()

var SelLcEmpInfo: LcEmpInfo = LcEmpInfo() //선택한 표준근로계약서 직원 (임시저장용으로 사용하기위해 )
var SelPinplLcEmpInfo: LcEmpInfo = LcEmpInfo() //선택한 핀플근로계약서 직원 (임시저장용으로 사용하기위해 )
var SelScEmpInfo: ScEmpInfo = ScEmpInfo() //선택한 보안서약서 직원 (임시저장용으로 사용하기위해 )
var SmsScEmpInfo : ScEmpInfo = ScEmpInfo() // sms 전송위해 따로 모델저장
var SmsEmpInfo : LcEmpInfo = LcEmpInfo() // sms 전송위해 따로 모델저장
var SmsCertEmpInfo : Ce_empInfo = Ce_empInfo() // sms 전송위해 따로 모델저장
var SelMultiArrTemp : [MultiConstractDate] = []
var ScMultiArrTemp : [optScInfo] = []
var CmpSealImage :  UIImage = UIImage()
var PrintsFileImage:UIImage!
var PrintFileImage:UIImage!

var PDFnoSealFile:Data!
var PDFSealFile:Data!

var SelTemFlag: Bool = false // 선택팀 상위팀, 하위팀 구분
var SelTtmSid: Int = 0 // 선택팀 상위팀번호
var SelTemSid: Int = 0 // 선택팀 하위팀번호
var fileExists : String = "" //pdf 파일 존재 여부 
var SelDdcnt: Int = 0 // 팝업 닫은후 연차 차감/미차감 데이터 전달 2020.03.25 osan

var resultParam: String = "" //증명서 결과값 0:실패 , 1:성공

var isTap: Bool = false //전자문서 탭 인지 아닌지 에 따라 탭바 숨기기 default : false:탭바 숨기기 , true: 탭바 노출
var inAppproductsArray = [SKProduct]()

let CheckimgOn = UIImage(named: "er_checkbox")
let CheckimgOff = UIImage(named: "icon_nonecheck")

let swOnimg = UIImage.init(named: "btn_switch_on")
let swOffimg = UIImage.init(named: "btn_switch_off")

let swyOnimg = UIImage.init(named: "y_btn") 

let confirmSignimg : UIImage = UIImage.init(named: "icn_lc_confirm_36")! //서명완료
let waitSignimg : UIImage = UIImage.init(named: "icn_lc_wait_36")! //서명 대기중

let chkstatusAlertpass : UIImage = UIImage(named: "icn_status_alert_pass_14")!
let chkstatusAlert : UIImage = UIImage(named: "icn_status_alert_14")!

let btnRoundOn : UIImage = UIImage(named: "btn_roundoption_large_on")!
let btnRoundOff : UIImage = UIImage(named: "btn_roundoption_large_off")!

var isVersionCheck: Bool = false // 버전 최신버전일 경우 true 아니면 false
var isVersionCnt:Int = 0
var isReviewStatus:Int = 0 // 리뷰기간동안은 1 , 상용일땐 0
var ismulticmtarea : Bool = false
let PayTypeKoArray: [String] = [ "","핀프리","펀프리","올프리"]
let PayTypeEnArray: [String] = [ "","PIN","FUN","ALL"]
let PayTypeInfoArray: [String] = [ "","핀(PIN)","펀(FUN)","올(ALL)"]
var AnlMultiArr: [MultiSelectedDate] = []
let AnualTypeArray: [String] = [ "연차","오전","오후","조퇴","외출","병가","공가","경조","교육","포상","공민","생리"]
let AnualColorArray: [UIColor] = [ UIColor.init(hexString: "#45A7CD"),
                                   UIColor.init(hexString: "#45A7CD"),
                                   UIColor.init(hexString: "#45A7CD"),
                                   UIColor.init(hexString: "#6849AF"),
                                   UIColor.init(hexString: "#6849AF"),
                                   UIColor.init(hexString: "#808080"),
                                   UIColor.init(hexString: "#384DAD"),
                                   UIColor.init(hexString: "#384DAD"),
                                   UIColor.init(hexString: "#384DAD"),
                                   UIColor.init(hexString: "#45A7CD"),
                                   UIColor.init(hexString: "#384DAD"),
                                   UIColor.init(hexString: "#EB5E89") ]

let AnualImgArray : [UIImage] = [ UIImage(named: "r_45a7cb")!,
                                  UIImage(named: "r_am_45a7cb")!,
                                  UIImage(named: "r_pm_45a7cb")!,
                                  UIImage(named: "r_6849af")!,
                                  UIImage(named: "r_6849af")!,
                                  UIImage(named: "r_grey")!,
                                  UIImage(named: "r_384dad")!,
                                  UIImage(named: "r_384dad")!,
                                  UIImage(named: "r_384dad")!,
                                  UIImage(named: "r_45a7cb")!,
                                  UIImage(named: "r_384dad")!,
                                  UIImage(named: "r_eb5e89")! ]

let CmtTypeArray: [String] = [ "데이터없음","출근","지각","조퇴","연장","특근","출장","외출","연차","결근"]
let CmtColorArray: [UIColor] = [ UIColor.clear,
                                 UIColor.init(hexString: "#043956"),
                                 UIColor.init(hexString: "#EF3829"),
                                 UIColor.init(hexString: "#6849AF"),
                                 UIColor.init(hexString: "#EA6F45"),
                                 UIColor.init(hexString: "#EA6F45"),
                                 UIColor.init(hexString: "#229D93"),
                                 UIColor.init(hexString: "#6849AF"),
                                 UIColor.init(hexString: "#45A7CB"),
                                 UIColor.init(hexString: "#EF3829") ]

let CmtImgArray : [UIImage] = [ UIImage(),
                                UIImage(named: "r_043956")!,
                                UIImage(named: "r_red")!,
                                UIImage(named: "r_6849af")!,
                                UIImage(named: "r_ea6f45")!,
                                UIImage(named: "r_ea6f45")!,
                                UIImage(named: "r_229d93")!,
                                UIImage(named: "r_6849af")!,
                                UIImage(named: "r_45a7cb")!,
                                UIImage(named: "r_red")! ]



let dot_start_active = UIImage(named: "icn_dot_start_active")
let dot_start_visit = UIImage(named: "icn_dot_start_visit")
let dot_start_undiscovered = UIImage(named: "icn_dot_start_undiscovered")
let dot_start_complete = UIImage(named: "icn_dot_start_complete")


let dot_mid_active = UIImage(named: "icn_dot_mid_active")
let dot_mid_visit = UIImage(named: "icn_dot_mid_visit")
let dot_mid_undiscovered = UIImage(named: "icn_dot_mid_undiscovered")
let dot_mid_complete = UIImage(named: "icn_dot_mid_complete")


let dot_end_active = UIImage(named: "icn_dot_end_active")
let dot_end_visit = UIImage(named: "icn_dot_end_visit")
let dot_end_undiscovered = UIImage(named: "icn_dot_end_undiscovered")
let dot_end_complete = UIImage(named: "icn_dot_end_complete")


let defaultContractText = "\"갑\"은 근로계약서를 체결함과 동시에본 계약서를 사본하여 \"을\"의 교부요구와 관계없이 \"을\"에게 교부함 (근로기준법 17조 이행)"
let defaultAnualText = "취업규칙 및 근로기준법에서 정하는 바에 따라 부여함."

let defaultPayDayText = "다음달 10일 지급 (전월 1일부터 말일까지 산정, 휴일의 경우 전일지급) 근로자 명의 예금통장에 입금"
let defaultEtcText = "이 계약에 정함이 없는 사항은 \(CompanyInfo.name) 취업규칙을 우선으로 하며, 취업규칙에 없는 사항은 근로기준법에 의함."

let defaultArticles1 = "상기 본인은 주식회사 우리요의 직원으로 근무함에 있어서 회사의 보안관리 지침에서 정 하는 바에 따라 상기 사항을 준수하고, 성실한 자세로 근무에 임할 것이며, 본인의 고의 또는 과실로 인한 문제발생 및 회사의 재산상의 손해가 발생할 경우에는 본인이 법에 따 른 책임을 지고, 근로계약 및 사업 지침에 따른 불이익도 감수할 것을 서약합니다."
let defaultArticles2 = "근무 중에 습득한 직무상의 기술, 기밀에 속하는 사항, 개인정보 등 비공개 정보와 보 안사항 등 회사의 경영에 불이익을 초래할 가능성이 있는 여타한 정보도 사적으로 사 용하거나 외부에 공개하거나 누설하지 않겠습니다."
let defaultArticles3 = "근무 중 보유하게 된 개인정보는 업무상 보유 필요성이 없는 경우에는 즉시 파기하고, 회사에서 근무 중 작성한 각종 서류 및 PC에 보관된 일체의 자료를 허가 없이 외부로 유출 또는 일시 반출 하지 않겠습니다."
let defaultArticles4 = "회사에서 구매한 응용프로그램 및 회사에서 개발한 프로그램을 회사 밖으로 일체 유 출하지 않겠습니다."
let defaultArticles5 = "회사의 대표와 부대표 및 팀장의 지시에 따라 업무를 성실히 수행하여야 하며, 회사에 해가 되는 행위를 하지 않겠습니다."

//퇴직자
let e_defaultArticles1 = "상기 본인은 주식회사 우리요의 보안관리 지침에서 정하는 바에 따라 상기 사항을 준수 하고, 본인의 고의 또는 과실로 인한 문제발생 및 회사의 재산상의 손해가 발생할 경우에 는 본인이 법에 따른 책임을 지고, 근로계약 및 사업 지침에 따른 불이익도 감수할 것을 서약합니다."
let e_defaultArticles2 = "근무 중에 습득한 직무상의 기술, 기밀에 속하는 사항, 개인정보 등 비공개 정보와 보 안사항 등 회사의 경영에 불이익을 초래할 가능성이 있는 여타한 정보도 사적으로 사 용하거나 외부에 공개하거나 누설하지 않겠습니다."
let e_defaultArticles3 = "근무 중 보유하게 된 개인정보는 업무상 보유 필요성이 없는 경우에는 즉시 파기하고, 회사에서 근무 중 작성한 각종 서류 및 PC에 보관된 일체의 자료를 허가 없이 외부로 유출 또는 일시 반출 하지 않겠습니다."
let e_defaultArticles4 = "회사에서 구매한 응용프로그램 및 회사에서 개발한 프로그램을 회사 밖으로 일체 유 출하지 않겠습니다."
let e_defaultArticles5 = "퇴사한 이후에도 회사에 해가 되는 행위를 하지 않겠습니다."

let headerString = "<meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1.0, minimum-scale=1, user-scalable=0 , viewport-fit=cover'>"

let navigationFontSE = UIFont(name: "NotoSansCJKkr-Regular", size: 19)
var selectedDate = Date() // 주 52시간에서 직원내역 리스트 불러올때 오류로 인해 추가 (직원내역리스트에서 상단 날짜)

var Emplycnt: Int = 0 // 재직증명서 신청직원 카운트
var Careercnt: Int = 0 // 경력증명서 신청신원 카운트

class AppData
{
    static let sharedInstance = AppData()
    
    var adMainImages : [BannerList] = [] //메인 배너 리스트
    var adMoreImages : [BannerList] = [] //더보기 배너 리스트
    
    var version : String = "" //앱스토어 버전
    var update : Int = 0 // 1: 강제 , 0 :권장
    var updateMsg : String = "" //업데이트 메세지
    
    var currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String //현재 빌드 버전
    
    var needUpdate : Bool {
        get {
            if version.compare(self.currentVersion, options: String.CompareOptions.numeric) == ComparisonResult.orderedDescending {
                return true
            }else {
                return false
            }
        }
        
    }
    
    var updateURL: String = "https://apps.apple.com/kr/app/apple-store/id1493505553" //앱스토어 링크
    
}

let preferredLanguage = NSLocale.preferredLanguages[0] as String
var dateFormatter_HeaderYMD : DateFormatter = {
    let tempFormat = DateFormatter()
    tempFormat.timeZone = NSTimeZone.local
    if preferredLanguage.contains("ko") {
        tempFormat.dateFormat = "yyyy년 M월 dd일"
    } else {
        tempFormat.dateFormat = "MMM. dd."
    }
    return tempFormat
}()


protocol RowPresentable {
    var viewpage: String { get }
    var rowVC: UIViewController & PanModalPresentable { get }
}

extension String {
    func toDate() -> Date? {
        //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return
        dateFormatter.string(from: self)
    }
}

