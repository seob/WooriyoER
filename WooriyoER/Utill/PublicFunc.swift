//
//  PurblicFunc.swift
//  PinPle
//
//  Created by WRY_010 on 2019/12/02.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork

extension UIViewController {
    func downloadImage(_ urlString : String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url)
        CmpSealImage = UIImage()
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                CmpSealImage = value.image
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    
    
    // FIXME: - Bugs
    /***************************************************
     2020.01.08 seob
     - 서버에 이미지가 없을경우 nil 값 체크
     기존 소스
     func urlImage(url: String) -> UIImage{
     let url = URL(string: url)
     let data = try? Data(contentsOf: url!)
     let image = UIImage(data: data!)
     return image!
     }
     ***************************************************/
    func urlImage(url: String) -> UIImage{
        var image: UIImage!
        let url = URL(string: url)
        let data = try? Data(contentsOf: url!)
        if data != nil {
            image = UIImage(data: data!)
        }else{
            image = UIImage(named: "logo_pre")
        }
        return image!
    }
    
    func tabbarheight(_ tableView: UITableView) {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                //        case 1136:
            //            print("iPhone 5 / 5S / 5C")
            case 1334:
                //            print("iPhone 6 / 6S / 7 / 8")
                tableView.contentInset = .init(top: 0, left: 0, bottom: 94, right: 0)
            case 1792, 2208, 2436, 2688:
                //            print("iPhone XR")
                //            print("iPhone 6+ / 6S+ / 7+ / 8+")
                //            print("iPhone X / XS")
                //            print("iPhone XS MAX")
                tableView.contentInset = .init(top: 0, left: 0, bottom: 114, right: 0)
            default:
                break;
            }
        }
    }
    
    func deviceHeight() -> Int{
        let height = UIScreen.main.bounds.size.height
        //        print("device.height = ", height)
        switch height {
        case 568:
            //            print("5, 5s, 5c, se");
            return 1;
        case 667:
            //            print("6, 6s, 7, 8");
            return 2;
        case 736:
            //            print("6+, 6s+, 7+, 8+");
            return 3;
        case 812:
            //            print("11pro, X, XS");
            return 4;
        case 896:
            //            print("11, XR, 11pro Max, XS Max");
            return 5;
        case 926:
            return 6
        default:
            break;
        }
        return 0
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    func getAddr(loclat: String, loclong: String, bool: Bool) {
        let findLocation = CLLocation(latitude: Double(loclat) ?? 0.0 , longitude: Double(loclong) ?? 0.0) // 2020.01.15 seob
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko_kr")
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: { (placemarksArray, error) in
            let placemark = placemarksArray?[0]
            let address = "\(placemark?.administrativeArea ?? "") \(placemark?.locality ?? "") \(placemark?.subLocality ?? "") \(placemark?.thoroughfare ?? "") \(placemark?.subThoroughfare ?? "")"
            print("------------[loclat = \(loclat)]-----------")
            print("------------[loclong = \(loclong)]-----------")
            print("------------[getAddr = \(address)]-----------")
            if bool {
                UserDefaults.standard.setValue(address, forKey: "addrMap")
            }else {
                UserDefaults.standard.setValue(address, forKey: "mt_addrMap")
            }
            
        })
    }
    func setPushId(mbrsid: Int) {        
        if let fcmToken = UserDefaults.standard.value(forKey: "fcmToken") as? String {
            NetworkManager.shared().setPushId(mbrsid: mbrsid, pushid: fcmToken) {(isSuccess, resultCode) in
                if (isSuccess) {
                    print("------------[ resultCode = \(resultCode) ]-----------")
                }
            }
        }
    }
    
    //권한 체크
    func authorCk(msg: String) -> Bool {
        let author = userInfo.author
        print("---------------------[author = \(author)]------------------")
        if author == 3 || author == 4 {
            toast(msg)
            return false
        }else {
            return true
        }
        
        print("---------------------[author 값 없음]------------------")
        
        return true
    }
    
    // 근로계약서 인사담당자 , 마스터만 접근 가능
    func authorlcCk(msg: String) -> Bool {
        let author = userInfo.author
        print("---------------------[author = \(author)]------------------")
        if author == 0 || author == 1 {
            toast(msg)
            return false
        }else {
            return true
        }
        
        print("---------------------[author 값 없음]------------------")
        
        return true
    }
    
    
    //권한 체크
    func authorCk(view: UIView) {
        let author = userInfo.author
        print("---------------------[author = \(author)]------------------")
        if author == 3 || author == 4 {
            let alert = UIAlertController(title: "알림", message: "권한이 없습니다.\n마스터관리자와 최고관리자만 가능합니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: {action in
                view.isHidden = false
            })
            alert.addAction(okAction)
            self.present(alert, animated: false, completion: nil)
            
            
        }
        func scrollViewCustom(_ scroll: UIScrollView) {
            scroll.clipsToBounds = true
            scroll.showsHorizontalScrollIndicator = false
            scroll.showsVerticalScrollIndicator = false
        }
        
    }
    
    func moveView(storyboard: String, withIdentifier: String) {
        let viewController = UIStoryboard.init(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: "\(withIdentifier)")
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    
    func toast(_ msg: String) {
//        configureAppearance()
//        Toast(text: "\(msg)", duration: Delay.short).show()
        var style = ToastStyle()
        style.messageFont = .boldSystemFont(ofSize: 14)
        style.messageAlignment = .center
        self.view.makeToast("\(msg)", duration: 3.0, position: .bottom, style: style)
         
    }
    
    
    func todayDatetocomma() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateString = dateFormatter.string(from: today)
        
        return dateString
    }
    
    func todayDate() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: today)
        
        return dateString
    }
    
    func todayDateKo() -> String {
        let date = Date() // 현재 시간 가져오기
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko") // 로케일 변경
        formatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        return dateString
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
    
    //생년월일이 없을때 default 1996+오늘날짜 2020.09.07 seob
    func DefaultBirthDay() -> String {
        let date = Date() // 현재 시간 가져오기
        var dateComponent = DateComponents()
        dateComponent.year = -24

        let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko") // 로케일 변경
        formatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: futureDate!)
        
        return dateString
    }
    
    func setTodayKo() -> String {
        let date = Date()
        let format = DateFormatter()
        format.locale = NSLocale(localeIdentifier: "ko") as Locale
        format.timeZone = NSTimeZone(name: "KST") as TimeZone?
        format.dateFormat = "yyyy년 MM월 dd일"
        let dateString = format.string(from: date)
        
        return dateString
    }
    
    func getTodayKo(_ str:String) -> String {
        let timeStamp = str
        let getTime = timeStamp.replacingOccurrences(of: "-", with: ".")
        
        let getTimeList = getTime.split(separator: " ")
        
        let dateFormatter = DateFormatter()
        //specify the date Format
        dateFormatter.dateFormat="yyyy.MM.dd"
        //get date from string
        let dateStr = dateFormatter.date(from:  String(getTimeList[0]))
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let dateString = dateFormatter.string(from: dateStr!)
        
        return dateString
    }
    
    func setJoinDate(timeStamp: String?) -> String {
        guard let timeStamp = timeStamp else { return ""}
        let getTime = timeStamp.replacingOccurrences(of: "-", with: ".")
        let dateFormatter = DateFormatter()
        //specify the date Format
        dateFormatter.dateFormat="yyyy.MM.dd"
        //get date from string
        let dateString = dateFormatter.date(from: getTime)
        //get timestamp from Date
        let dateTimeStamp  = dateString!.timeIntervalSince1970
        
        let date = Date(timeIntervalSince1970: dateTimeStamp)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = TimeZone.current
        dateFormatter2.locale = NSLocale.current
        dateFormatter2.dateFormat = "YY.MM.dd" //Specify your format that you want
        let dateStr = dateFormatter2.string(from: date)
        return dateStr
    }
    
    
    
    
    func setJoinDate2(timeStamp: String?) -> String {
           guard let timeStamp = timeStamp else { return ""}
           let getTime = timeStamp.replacingOccurrences(of: "-", with: ".")
           
           let getTimeList = getTime.split(separator: " ")
           
           let dateFormatter = DateFormatter()
           //specify the date Format
           dateFormatter.dateFormat="yyyy.MM.dd"
           //get date from string
           return String(getTimeList[0])
       }
    
    func setJoinDate3(timeStamp: String?) -> String {
           guard let timeStamp = timeStamp else { return ""}
           let getTime = timeStamp.replacingOccurrences(of: "-", with: ".")
           
           let getTimeList = getTime.split(separator: " ")
           
           let dateFormatter = DateFormatter()
           //specify the date Format
           dateFormatter.dateFormat="yy.MM.dd"
           //get date from string
           return String(getTimeList[0])
       }
    
    func setDateDefault(timeStamp: String?) -> String {
        guard let timeStamp = timeStamp else { return ""}
        let getTime = timeStamp.replacingOccurrences(of: "-", with: ".")
        let dateFormatter = DateFormatter()
        //specify the date Format
        dateFormatter.dateFormat="yyyy.MM.dd"
        //get date from string
        let dateString = dateFormatter.date(from: getTime)
        //get timestamp from Date
        let dateTimeStamp  = dateString!.timeIntervalSince1970
        
        let date = Date(timeIntervalSince1970: dateTimeStamp)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = TimeZone.current
        dateFormatter2.locale = NSLocale.current
        dateFormatter2.dateFormat = "YYYY.MM.dd" //Specify your format that you want
        let dateStr = dateFormatter2.string(from: date)
        return dateStr
    }
    
    func setDateformat(_ text: String) -> Date {
        let getTime = text.replacingOccurrences(of: "-", with: ".")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy.MM.dd"
        let dateString = dateFormatter.date(from: getTime)
        let dateTimeStamp  = dateString!.timeIntervalSince1970
        
        let date = Date(timeIntervalSince1970: dateTimeStamp)
        return date
    }
    
    
    func setDateformatTest(_ text: String) -> Date { 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy.MM.dd"
        let dateString = dateFormatter.date(from: text)
        let dateTimeStamp  = dateString!.timeIntervalSince1970
        
        let date = Date(timeIntervalSince1970: dateTimeStamp)
        return date
    }
     
    
    func setDateformatMonth(_ text: String) -> Date {
        let getTime = text.replacingOccurrences(of: "-", with: ".")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM"
        let dateString = dateFormatter.date(from: getTime)
        let dateTimeStamp  = dateString!.timeIntervalSince1970
        
        let date = Date(timeIntervalSince1970: dateTimeStamp)
        return date
    }
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func presentDismiss(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
    
    //root navigationcntroller
    func getRootViewController() -> UIViewController {
        
        if let rootvc = self.navigationController?.viewControllers.first {
            return rootvc
        }
        return UIViewController()
    }
    
    func setDateToString(_ dateStr: Date) -> String {
        let date:Date = dateStr
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString:String =  dateFormatter.string(from: date)
        
        return dateString
    }
}


extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}


 

extension String {
    
    var md5: String? {
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }
        
        let hash = data.withUnsafeBytes { (bytes: UnsafePointer<Data>) -> [UInt8] in
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes, CC_LONG(data.count), &hash)
            return hash
        }
        
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    var sha1new: String? {
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }

        let hash = data.withUnsafeBytes { (bytes: UnsafePointer<Data>) -> [UInt8] in
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            CC_SHA1(bytes, CC_LONG(data.count), &hash)
            return hash
        }

        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    
}
 

public class DateHelper {
    public class func date(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, seconds: Int = 0) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: "\(year)-\(month)-\(day) \(hour):\(minute):\(seconds)")
    }
    
    public class func dateAfter(years: Int, from baseDate: Date) -> Date? {
        let yearsToAdd = years
        var dateComponents = DateComponents()
        dateComponents.year = yearsToAdd
        return Calendar.current.date(byAdding: dateComponents, to: baseDate)
    }
}

extension Date {
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    public var month: Int {
         return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int {
         return Calendar.current.component(.day, from: self)
    }
    
    public var monthName: String {
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "MMMM" // format January, February, March, ...
        return nameFormatter.string(from: self)
    }
}
