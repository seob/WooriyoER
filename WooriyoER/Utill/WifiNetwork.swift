//
//  WifiNetwork.swift
//  PinPle_ER
//
//  Created by WRY_010 on 2019/11/19.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

open class WifiNetwork {
    
    func getWifiInfo() -> NSDictionary {
        let interfaces = CNCopySupportedInterfaces() as NSArray?
        var interfaceInfo: NSDictionary?
        if let tmpinterfaces = interfaces {
            for interface in tmpinterfaces {
                interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary?
                if let tempinterfaceInfo = interfaceInfo {
                    let isNotEmpty: Bool = (tempinterfaceInfo.count > 0)
                    if (isNotEmpty) {
                        break;
                    }
                }
 
            }
        }
        
         
        return interfaceInfo ?? [:]
 
    }
    
    func connecteToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if isReachable && isWWAN {
            return false
        }
        
        if isReachable && !isWWAN {
            return true
        }
        
        return false
    }
    
}
