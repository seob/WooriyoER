//
//  DeviceInfo.swift
//  PinPle
//
//  Created by WRY_010 on 20/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//  개발자 : 오대산
//  디바이스 정보 저장 DTO
//

import Foundation
import UIKit

struct DeviceInfo {
    var OSVS: String //ios 버젼
    var APPVS: String //앱 버젼
    var MD: String //단말기 모델명
    
    init(){
        self.OSVS = UIDevice.current.systemVersion
        self.APPVS = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        self.MD = ((UIDevice.current.modelName).data(using: .utf8)?.base64EncodedString())!
        
    }
    
}
