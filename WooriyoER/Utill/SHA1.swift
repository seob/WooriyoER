//
//  SHA1.swift
//  PinPle
//
//  Created by WRY_010 on 19/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//  개발자 : 오대산
//  패스워드  SHA1 암호화
//

import UIKit
import CommonCrypto

extension String {
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
}

