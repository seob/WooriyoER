//
//  Dodule+Extension.swift
//  PinPle
//
//  Created by seob on 2020/07/14.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

extension UIViewController {
    func convertToTimeInterval(_ str:String) -> TimeInterval {
           guard str != "" else {
               return 0
           }

           var interval:Double = 0

           let parts = str.components(separatedBy: ":")
           for (index, part) in parts.reversed().enumerated() {
               interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
           }
    print("\n---------- [ interval : \(interval) ] ----------\n")
           return interval
       }
}
