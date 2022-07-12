//
//  Date+Extension.swift
//  WooriyoER
//
//  Created by design on 2022/07/07.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit

extension Date {
    /// Returns a Date with the specified amount of components added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    /// Returns a Date with the specified amount of components subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
    
    
    
    
    func toString() ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_kr")

        let dateString:String = dateFormatter.string(from: self)
        return dateString
    }
    
    static func getDate(withYear year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: nil, year: year, month: month, day: day, hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        return components.date!
    }
    
    static func dateCheck(goDateStr:String, leaveDateStr:String) -> Int
    {
        let goStr1:[Substring] = goDateStr.split(separator: "-")
        guard let year1:Int = Int(goStr1[0]), let month1:Int = Int(goStr1[1]), let day1:Int = Int(goStr1[2]) else{
            return -2
        }
        let goDate = Date.getDate(withYear: year1, month: month1, day: day1)
        
        let leaveStr1:[Substring] = leaveDateStr.split(separator: "-")
        guard let year2:Int = Int(leaveStr1[0]), let month2:Int = Int(leaveStr1[1]), let day2:Int = Int(leaveStr1[2]) else{
            return -2
        }
        let leaveDate = Date.getDate(withYear: year2, month: month2, day: day2)
        
        let result:ComparisonResult =  goDate.compare(leaveDate)
        
        return result.rawValue
    }
}
