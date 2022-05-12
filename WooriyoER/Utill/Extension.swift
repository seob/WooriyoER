//
//  Extension.swift
//  PinPle_EE
//
//  Created by seob on 2020/01/09.
//  Copyright © 2020 WRY_010. All rights reserved.
//
import Foundation
import UIKit

protocol CmpInfoDelegate {
    var CmpInfo: CmpInfo! { get set }
}

extension Date {
    
    func offset(from: Date) -> (Calendar.Component, Int)? {
        let descendingOrderedComponents = [Calendar.Component.year, .month, .day, .hour, .minute]
        let dateComponents = Calendar.current.dateComponents(Set(descendingOrderedComponents), from: from, to: self)
        let arrayOfTuples = descendingOrderedComponents.map { ($0, dateComponents.value(for: $0)) }
        
        for (component, value) in arrayOfTuples {
            if let value = value, value > 0 {
                return (component, value)
            }
        }
        
        return nil
    }
    
}



extension UIViewController {
    
    func getDiff(_ strStartTm: String , _ strEndTm: String) -> Int {
        var diff = 0
        let calendar = Calendar.current
        let today = Date()
        
        let startArr = strStartTm.components(separatedBy: ":")
        let selHour: Int  = Int(startArr[0]) ?? 0
        let selMin:Int  = Int(startArr[1]) ?? 0
        
        let endArr = strEndTm.components(separatedBy: ":")
        let endHour: Int  = Int(endArr[0]) ?? 0
        let endMin:Int  = Int(endArr[1]) ?? 0
        
        guard let calStart = calendar.date(bySettingHour: selHour, minute: selMin, second: 0, of: today) else { return 0}
        guard let calEnd = calendar.date(bySettingHour: endHour, minute: endMin, second: 0, of: today) else { return 0 }
        print("\n---------- [ calStart : \(calStart) , calEnd : \(calEnd)] ----------\n")
        //        if (calStart.compare(calEnd).rawValue == 1){
        //             diff = 0
        //        }
        
        //today.timeIntervalSince1970
        diff = Int(calStart.timeIntervalSince1970 - calEnd.timeIntervalSince1970)
        diff = diff / (60*1000)
        
        print("\n---------- [ diff : \(diff) ] ----------\n")
        return diff
    }
    
    func getValidTm(_ strStartTm:String , _ strEndTm: String) -> Bool {
        var bValid : Bool = false
        //        //날짜비교    (calStart > calEnd 인경우 1리턴)
        let calendar = Calendar.current
        let today = Date()
        
        let startArr = strStartTm.components(separatedBy: ":")
        let selHour: Int  = Int(startArr[0]) ?? 0
        let selMin:Int  = Int(startArr[1]) ?? 0
        
        let endArr = strEndTm.components(separatedBy: ":")
        let endHour: Int  = Int(endArr[0]) ?? 0
        let endMin:Int  = Int(endArr[1]) ?? 0
        
        
        
        guard let calStart = calendar.date(bySettingHour: selHour, minute: selMin, second: 0, of: today) else { return false }
        guard let calEnd = calendar.date(bySettingHour: endHour, minute: endMin, second: 0, of: today) else { return false }
        
        let localDate = Date(timeInterval: TimeInterval(calendar.timeZone.secondsFromGMT()), since: calStart)
        
        print("\n---------- [ calStart : \(calStart) , calEnd : \(calEnd)] ----------\n")
        //        if calendar.compare(today, to: localDate, toGranularity: .day) == .orderedSame {
        //            print("This is True")
        //        } else {
        //            print("This is False")
        //        }
        //        if(strStartTm > strEndTm){
        //            bValid = false
        //        }
        
        //        if (strStartTm && strEndTm) {
        //            bValid = true
        //        }
        return bValid
    }
    
    
    //분을 4h 40m 으로 환산
    func getMinTohm(_ nDistance: Int) -> String {
        var strbDhm: String = ""
        if (nDistance == 0) {
            strbDhm = "0시간"
        } else {
            var nHour = 0
            var nMin = 0
            nHour = (nDistance) / 60
            nMin = (nDistance) % 60
            
            if (nMin != 0){
                
                strbDhm = "\(nHour)시간 \(nMin)분"
            } else {
                strbDhm = "\(nHour)시간"
            }
        }
        return strbDhm
    }
    
    
    // MARK: - configureAppearance
    /***************************************************
     Toast 디자인 설정
     ***************************************************/
//    func configureAppearance() {
//        let appearance = ToastView.appearance()
//        appearance.backgroundColor = .black
//        appearance.textColor = .white
//        appearance.font = .boldSystemFont(ofSize: 14)
//        appearance.textInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
//        appearance.bottomOffsetPortrait = 100
//        appearance.cornerRadius = 20
      
//     }
    
    func minSave(_ time: Int) -> Int {
        return (time%(8*60))%60
    }
    
    
    func timeStr(_ time: Int) -> [String] {
        
        let day = time / 480
        let hour = (time % 480) / 60
        let min = (time%(8*60))%60
        
        var timeArr: [String] = []
        
        if day < 10 {
            timeArr.append("0" + String(day))
        }else {
            timeArr.append(String(day))
        }
        if hour < 10 {
            timeArr.append("0" + String(hour))
        }else {
            timeArr.append(String(hour))
        }
        if min < 10 {
            timeArr.append("0" + String(min))
        }else {
            timeArr.append(String(min))
        }
        return timeArr
    }
    
    
    func timeStrtodayh(_ time: Int) -> [String] {
        
        let day = time / 480
        let hour = (time % 480) / 60 
        
        var timeArr: [String] = []
        
        if day < 10 {
            timeArr.append("0" + String(day))
        }else {
            timeArr.append(String(day))
        }
        if hour < 10 {
            timeArr.append("0" + String(hour))
        }else {
            timeArr.append(String(hour))
        }
        return timeArr
    }
    
    //연차정보관리에서만 사용
    func anualtimeStr(_ time: Int) -> [String] {
        
        let day = time / 480
        let hour = (time % 480) / 60
        let min = (time%(8*60))%60
        
        var timeArr: [String] = []
        
        if day < 10 {
            timeArr.append(String(day))
        }else {
            timeArr.append(String(day))
        }
        if hour < 10 {
            timeArr.append(String(hour))
        }else {
            timeArr.append(String(hour))
        }
        if min < 10 {
            timeArr.append(String(min))
        }else {
            timeArr.append(String(min))
        }
        return timeArr
    }
    
    func strTime(_ day: Int, _ hour: Int, _ min: Int) -> Int {
        return (day * 8 * 60) + (hour * 60) + min
    }
    
    func pushVC(_ identifier: String , storyboard: String , animated: Bool){
        let nav: UINavigationController! = self.navigationController
        let storyboard: UIStoryboard! = UIStoryboard.init(name: storyboard, bundle: nil)
        
        let vc = (storyboard.instantiateViewController(withIdentifier: identifier))
        
        nav.setViewControllers([vc], animated: animated)
    }
    
    func popVC(_ backStep: Int32 = -1){
        let nav: UINavigationController! = self.navigationController
        var viewVCs : [UIViewController] = nav.viewControllers
        for _ in 1...(0 - backStep) {
            viewVCs.removeLast()
        }
        nav.setViewControllers(viewVCs, animated: true)
        
    }
    
    func presentVC(_ identifier: String , storyboard: String , animated: Bool){
        let storyboard: UIStoryboard! = UIStoryboard.init(name: storyboard, bundle: nil)
        
        let vc = (storyboard.instantiateViewController(withIdentifier: identifier))
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: animated, completion: nil)
    }
    
    func setWeek(_ date: Date) -> String {
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday], from: date)
        var week = ""
        
        switch comps.weekday {
        case 1:
            week = "일";
        case 2:
            week = "월";
        case 3:
            week = "화";
        case 4:
            week = "수";
        case 5:
            week = "목";
        case 6:
            week = "금";
        case 7:
            week = "토";
        default:
            break;
        }
        
        return "(" + week + ")"
    }
    
    func workTimeStr(_ time: Int) -> [String] {
        
        let hour = time/60
        let min = (time%(8*60))%60
        
        var timeArr: [String] = []
        if hour < 10 && hour > 0 {
            timeArr.append("0" + String(hour))
        }else {
            timeArr.append(String(hour))
        }
        if min < 10 && min > 0{
            timeArr.append("0" + String(min))
        }else {
            timeArr.append(String(min))
        }
        return timeArr
    }
    
    
    func anlTimeStr(_ time: Int) -> [String] {
        
        let day = time/(8*60)
        let hour = (time%(8*60))/60
        let min = (time%(8*60))%60
        
        var timeArr: [String] = []
        if day < 10 && day > 0 {
            timeArr.append("0" + String(day))
        }else {
            timeArr.append(String(day))
        }
        if hour < 10 && hour > 0 {
            timeArr.append("0" + String(hour))
        }else {
            timeArr.append(String(hour))
        }
        if min < 10 && min > 0 {
            timeArr.append("0" + String(min))
        }else {
            timeArr.append(String(min))
        }
        return timeArr
    }
    // LoginVC 이동 se 대응
    func SE_LoginVC() {
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
    }
    func viewMove(joindt: String, cmpsid: Int) {
        
        var vc = UIViewController()
        if joindt == "1900-01-01" {
            if let stage = prefs.value(forKey: "stage") as? Int {  
                if cmpsid == 0 && stage == 1 {
                    vc = LoginSignSB.instantiateViewController(withIdentifier: "SelMgrEmp")
                }else if cmpsid == 0 && stage == 2 {
                    vc = LoginSignSB.instantiateViewController(withIdentifier: "AddInfo")
                }else if cmpsid == 0 && stage == 3 {
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
            }else if cmpsid == 0 {
                vc = LoginSignSB.instantiateViewController(withIdentifier: "SelMgrEmp")
            }else {
                if SE_flag {
                    vc = TmCrtSB.instantiateViewController(withIdentifier: "SE_InfoSet")
                }else {
                    vc = TmCrtSB.instantiateViewController(withIdentifier: "InfoSet")
                }
                //                if prefs.value(forKey: "intro") != nil {
                //                    if SE_flag {
                //                        vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC")
                //                    }else {
                //                        vc = MainSB.instantiateViewController(withIdentifier: "MainVC")
                //                    }
                //                }else {
                //                    if SE_flag {
                //                        vc = IntroSB.instantiateViewController(withIdentifier: "SE_IntroVC1")
                //                    }else {
                //                        vc = IntroSB.instantiateViewController(withIdentifier: "IntroVC1")
                //                    }
                //                }
            }
        }else if cmpsid == 0 {
            vc = LoginSignSB.instantiateViewController(withIdentifier: "SelMgrEmp")
        }else {
            if prefs.value(forKey: "intro") != nil {
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
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil);
    }
    
    
    // MARK: - 연차구하기(일수)
    func getAnualDay(strJoinDt: String) -> Int {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        print("\n---------- [ strJoinDt: \(strJoinDt) ] ----------\n")
        let arr = getDateArray(strJoinDt)
        let nJoinYear: Int = arr[0]
        let nJoinMonth: Int = arr[1]
        let nJoinDay: Int = arr[2]
        print("\n---------- [ arr: \(arr) ] ----------\n")
        
        print("\n---------- [ nJoinYear : \(nJoinYear) , nJoinMonth : \(nJoinMonth) ,nJoinDay : \(nJoinDay) ] ----------\n")
        let nWorkYear: Int = getWorkYear(nJoinYear, nJoinMonth, nJoinDay)
        
        var nAnualDay: Int = 0;
        if(nWorkYear < 2) {
            let nWorkMonth: Int = getWorkMonth(nJoinYear, nJoinMonth, nJoinDay)
            if(nWorkYear < 1) {
                nAnualDay = nWorkMonth;
            }else {
                nAnualDay = 26;
            }
        } else {
            switch(nWorkYear) {
            case 2:
                nAnualDay = 15;
                break;
            case 3:
                nAnualDay = 16;
                break;
            case 4:
                nAnualDay = 16;
                break;
            case 5:
                nAnualDay = 17;
                break;
            case 6:
                nAnualDay = 17;
                break;
            case 7:
                nAnualDay = 18;
                break;
            case 8:
                nAnualDay = 18;
                break;
            case 9:
                nAnualDay = 19;
                break;
            case 10:
                nAnualDay = 19;
                break;
            case 11:
                nAnualDay = 20;
                break;
            case 12:
                nAnualDay = 20;
                break;
            case 13:
                nAnualDay = 21;
                break;
            case 14:
                nAnualDay = 21;
                break;
            case 15:
                nAnualDay = 22;
                break;
            case 16:
                nAnualDay = 22;
                break;
            case 17:
                nAnualDay = 23;
                break;
            case 18:
                nAnualDay = 23;
                break;
            case 19:
                nAnualDay = 24;
                break;
            case 20:
                nAnualDay = 24;
                break;
            default:
                nAnualDay = 25;
                break;
            }
        }
        //연차하루 8시간 계산
        print("\n---------- [ nAnualDay : \(nAnualDay) ] ----------\n")
        return nAnualDay;
    }
    
    
    // MARK: - 근속월 구하기
    func getWorkMonth(_ nJoinYear: Int, _ nJoinMonth: Int, _ nJoinDay: Int ) -> Int {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        
        var nWorkMonth: Int = 0
        var joinCal = Date()
        if nJoinMonth == 1 {
            joinCal = dateFormatter.date(from: "\(nJoinYear-1)-\(12)-\(nJoinDay)")!
        }else {
            joinCal = dateFormatter.date(from: "\(nJoinYear)-\(nJoinMonth-1)-\(nJoinDay)")!
        }
        let nowCal = dateFormatter.date(from: dateFormatter.string(from: today))
        
        let nWorkDay: Int = Int(((joinCal.timeIntervalSince(nowCal!))) / (24*60*60*1000))
        
        let nTmpkMonth: Int = (nWorkDay+1)/30 //총개월수(대략 30으로 나눠서 계산)
        var nChkNum: Int = 0
        
        for i in 0...nTmpkMonth {
            if i == 0 {
                for j in nJoinMonth...12 {
                    if (j==1 || j==3 || j==5 || j==7 || j==8 || j==10 || j==12 ) {
                        nChkNum += 31
                    }else if (j==4 || j==6 || j==9 || j==11 ) {
                        nChkNum += 30
                    }

                    if(j==2) {
                        //윤달체크
                        if((nJoinMonth%400) == 0) {
                            nChkNum+=29
                        } else {
                            nChkNum+=28
                        }
                    }
                }
            }else {
                for j in 1...12 {
                    if (j==1 || j==3 || j==5 || j==7 || j==8 || j==10 || j==12 ) {
                        nChkNum += 31
                    }else if (j==4 || j==6 || j==9 || j==11 ) {
                        nChkNum += 30
                    }

                    if(j==2) {
                        //윤달체크
                        if((nJoinMonth%400) == 0) {
                            nChkNum+=29
                        } else {
                            nChkNum+=28
                        }
                    }
                }
            }
        } 
        
        nWorkMonth = (nChkNum+1)/30 //진짜 총개월수
        
        if(nWorkDay <= nChkNum) {
            nWorkMonth = nWorkMonth - 1 //대략 구한 개월수가 많을경우 -1처리 진짜 개월수 보정
        }
        
        if(nWorkMonth < 0) {
            nWorkMonth = 0
        }
        return nWorkMonth
    }
    // MARK: - 근속년 구하기
    func getWorkYear(_ nJoinYear: Int , _ nJoinMonth: Int , _ nJoinDay: Int ) -> Int {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        var nWorkYear: Int = 0
        
        let arr = dateFormatter.string(from: today).components(separatedBy: "-")
        let nNowYear: Int  = Int(arr[0])!
        let nNowMonth: Int = Int(arr[1])!
        let nNowDay: Int   = Int(arr[2])!
        
        nWorkYear = nNowYear - nJoinYear
        
        // 입사일이 안 지난 경우 -1
        if (nJoinMonth * 100 + nJoinDay > nNowMonth * 100 + nNowDay) {
            nWorkYear = nWorkYear - 1
        }
        
        print("\n---------- [ nWorkYear : \(nWorkYear) ] ----------\n")
        return nWorkYear;
    }
    
    // MARK: - 숫자 콤마 
    func DecimalWon(value: Int) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: value))!
        
        return result
    }
    
    func getDateArray(_ regdt: String) -> Array<Int> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        
        
        let dateString = dateFormatter.date(from: regdt)
        let dateTimeStamp  = dateString!.timeIntervalSince1970
        
        let date = Date(timeIntervalSince1970: dateTimeStamp)
        
        let arr = dateFormatter.string(from: date).components(separatedBy: "-")
        
        let nYear: Int  = Int(arr[0])!
        let nMonth: Int = Int(arr[1])!
        let nDay: Int   = Int(arr[2])!
        
        var tmparray: [Int] = []
        tmparray.append(nYear)
        tmparray.append(nMonth)
        tmparray.append(nDay)
        return tmparray
    }
    
    func stringTodate(_ str: String) ->Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        let dateString = dateFormatter.date(from: str)
        let dateTimeStamp  = dateString!.timeIntervalSince1970
        
        let date = Date(timeIntervalSince1970: dateTimeStamp)
        
        return date
    }
    
    
    func hash(name:String, data:Data) -> Data? {
        let algos = ["MD2":    (CC_MD2,    CC_MD2_DIGEST_LENGTH),
                     "MD4":    (CC_MD4,    CC_MD4_DIGEST_LENGTH),
                     "MD5":    (CC_MD5,    CC_MD5_DIGEST_LENGTH),
                     "SHA1":   (CC_SHA1,   CC_SHA1_DIGEST_LENGTH),
                     "SHA224": (CC_SHA224, CC_SHA224_DIGEST_LENGTH),
                     "SHA256": (CC_SHA256, CC_SHA256_DIGEST_LENGTH),
                     "SHA384": (CC_SHA384, CC_SHA384_DIGEST_LENGTH),
                     "SHA512": (CC_SHA512, CC_SHA512_DIGEST_LENGTH)]
        guard let (hashAlgorithm, length) = algos[name]  else { return nil }
        var hashData = Data(count: Int(length))
        
        _ = hashData.withUnsafeMutableBytes {digestBytes in
            data.withUnsafeBytes {messageBytes in
                hashAlgorithm(messageBytes, CC_LONG(data.count), digestBytes)
            }
        }
        return hashData
    }
    
}

extension Notification.Name {
    static let reloadTotalList = Notification.Name("reloadTotalList")
    static let reloadTem = Notification.Name("reloadTem")
    static let reloadTemSetting = Notification.Name("reloadTemSetting")
    static let reload = Notification.Name("reload")
    static let reloadList = Notification.Name("reloadList")
    static let reloadCmpEmpList = Notification.Name("reloadCmpEmpList")
    static let reloadNotice = Notification.Name("reloadNotice")
    static let popView = Notification.Name("popView")
    static let reloadBannerM = Notification.Name("reloadBannerM")
    static let reloadBanner = Notification.Name("reloadBanner")
    static let reloadListFical = Notification.Name("reloadListFical")
    
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
    static let IAPHelperRestoreNotification = Notification.Name("IAPHelperRestoreNotification")
    static let IAPHelperFailNotification = Notification.Name("IAPHelperFailNotification")
    
    static let IAPHelperPurchaseNotificationInapp = Notification.Name("IAPHelperPurchaseNotificationInapp")
    static let IAPHelperRestoreNotificationInapp = Notification.Name("IAPHelperRestoreNotificationInapp")
    static let IAPHelperFailNotificationInapp = Notification.Name("IAPHelperFailNotificationInapp")
    
}

extension String {
    //문자열 공백 제거
    func strinTrim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

extension CALayer {
    // Sketch 스타일의 그림자를 생성하는 유틸리티 함수
    func ApplyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
    
}

extension UIView {
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    
}



extension UIImage {
    // MARK: 이미지 사이즈 조정
    func resizeImage(target: CGFloat) -> UIImage {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let size = self.size
        
        let widthRatio  = target  / size.width
        let heightRatio = target / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        } else {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    class func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    class func scale(image: UIImage, by scale: CGFloat) -> UIImage? {
        let size = image.size
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        return UIImage.resize(image: image, targetSize: scaledSize)
    }
    
    //워터마크
    //    func addWatermark(on origin: UIImage?, with template: UIImage?) -> UIImage? {
    //        if origin == nil || template == nil {
    //            return UIImage()
    //        }
    //
    //        let width = Double(origin?.size.width ?? 0.0)
    //        let height = Double(origin?.size.height ?? 0.0)
    //
    //        UIGraphicsBeginImageContext(CGSize(width: CGFloat(width), height: CGFloat(height)))
    //        origin?.draw(in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
    //        template?.draw(in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
    //        newImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //
    //        return newImage
    //    }
    //
    //    func drawText(_ text: String?, in image: UIImage?) -> UIImage? {
    //        if image == nil {
    //            return UIImage()
    //        }
    //
    //        let font = UIFont.boldSystemFont(ofSize: 40)
    //        let textsize = text?.size(with: font)
    //        let margin = CGPoint(x: 20, y: 20)
    //        // draw text at bottom-right
    //        let textrect = CGRect(
    //            x: (image?.size.width ?? 0.0) - 0.7 * (textsize?.width ?? 0.0) + 0.3 * (textsize?.width ?? 0.0) - margin.x,
    //            y: (image?.size.height ?? 0.0) - (textsize?.height ?? 0.0) - margin.y,
    //            width: textsize?.width ?? 0.0,
    //            height: textsize?.height ?? 0.0)
    //
    //        UIGraphicsBeginImageContext(image?.size ?? CGSize.zero)
    //        // draw image
    //        image?.draw(in: CGRect(x: 0, y: 0, width: image?.size.width ?? 0.0, height: image?.size.height ?? 0.0))
    //        // draw rotated text
    //        UIColor.lightGray.set()
    //        text?.draw(withBasePoint: textrect.origin, andAngle: -M_PI_4, andFont: font)
    //        // get new image
    //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //
    //        return newImage
    //    }
    
    
} 





extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
