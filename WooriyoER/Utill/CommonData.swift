//
//  CommonData.swift
//  PinPle
//
//  Created by seob on 2020/01/15.
//  Copyright © 2020 WRY_010. All rights reserved.
//
import UIKit
import Foundation

class GlobalShareManager{
    
    private static var sharedGlobalShareManager: GlobalShareManager = {
        let globalsharemanager = GlobalShareManager()
    
        
        return globalsharemanager
    }()
    
    private init() {

    }
    
    
    class func shared() -> GlobalShareManager {
        return sharedGlobalShareManager
    }
    
    
    func  isStartCheckToDay() -> Bool {
        let userDefaults = UserDefaults.standard
        let workStrtYmdt = userDefaults.value(forKey:"workStrtYmdt") as! String?
        if workStrtYmdt != nil
        {
            return true
            
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "ko_KR")
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: "ko_KR")
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatterGet.date(from: workStrtYmdt!)
        {
            let calendar = Calendar.current
            if calendar.isDateInToday(date as Date)
            {
                return true
            }
        }
        return false;
    }
    
    
    func setLocalData(_ value: Any?, forKey defaultName: String) -> () {
        let userDefaults = UserDefaults.standard
        userDefaults.set( value, forKey: defaultName)
        userDefaults.synchronize()
    }
    
    func getLocalData(_ forKey:String) -> Any? {
        let userDefaults = UserDefaults.standard
       // let data = userDefaults.value(forKey:forKey)
        
        if let userType = userDefaults.value(forKey: forKey){
            return userType
        }else{
            return nil
        }
        
    }
    
}
