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
import Foundation

  
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
     
    
    
    //url 유효성 검사
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    // MARK: 영어이름 유무 판별
    func ennameCheck(enname: String) -> String {
        var str = self
        if enname != "" {
            str += "(" + enname + ")"
        }
        return str
    }
    
    func httpTrim() -> String {
        let arr = self.components(separatedBy: ["/"])
        let start = self.index(self.firstIndex(of: "/")!, offsetBy: 2)
        let end = self.index(before: self.endIndex)
        let subUrl = self[start...end]
        
        if arr[0] == "http:" || arr[0] == "https:" {
            return String(subUrl)
        }
        return self
    }
    func timeTrim() -> String {
        if self.count >= 8 {
            let start = self.startIndex
            let end = self.index(self.lastIndex(of: ":")!, offsetBy: -1)
            let subTime = self[start...end]
            return String(subTime)
        }else {
            return self
        }
        
    }
    func ipTrim() -> String {
        if self != "" {
            let start = self.startIndex
            let end = self.index(self.lastIndex(of: ".")!, offsetBy: -1)
            let subTime = self[start...end]
            return String(subTime)
        }
        return ""
    }
    func urlTrim() -> String {
        let arr = self.components(separatedBy: "/")
        let str = arr.last!
        //        print(str)
        return str
    }
    func urlBase64Encoding() -> String {
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "`~!@#$%^&()+=[]{}\\|;:'\"<>,/? ").inverted)
        let baseString = encodedString!.data(using: .utf8)?.base64EncodedString()
        return baseString!
    }
    func base64Encoding() -> String {
        let baseString = self.data(using: .utf8)?.base64EncodedString()
        return baseString!
    }
    func base64Decoding() -> String {
        let decodedData = Data(base64Encoded: self)!
        let decodedString = String(data: decodedData, encoding: .utf8)!
        return decodedString
    }
    func urlEncoding() -> String {
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "`~!@#$%^&()+=[]{}\\|;:'\"<>,/? ").inverted)
        return encodedString!
    }
    //입력값 체크
    public func validate(_ type: String) -> Bool {
        var regEx = ""
        
        if type == "email"
        {
            regEx = "^[_a-zA-Z0-9-\\.]+@[\\.a-zA-Z0-9-]+\\.[a-zA-Z]+$"
        }
        else if type == "pass"
        {
            regEx = "^[a-zA-Z0-9!@#$%^*+=-]{6,50}$"
            //특수문자 숫자 필수 입력
            //            regEx = "^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,15}$"
        }
        else if type == "phone"
        {
            regEx = "^01([0|1|6|7|8|9]?)([0-9]{3,4})([0-9]{4})$"
        }
        else if type == "name"
        {
            regEx = "^[가-힣]*$"
        }
        else if type == "enname"
        {
            regEx = "^[A-Za-z\\s]*$"
        }
        else if type == "tele"
        {
            regEx = "^([0-9]{2,3})([0-9]{3,4})([0-9]{4})$"
        }else if type == "excHng"
        {
            regEx = "^[A-Za-z0-9]*$"
        }else if type == "nil"
        {
            regEx = "^[ ]*$"
        }else if type == "koeng"
        {
            regEx = "^[가-힣a-zA-Z]+$"
        }
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
    
    func postPositionText(type: Int, single: Bool = false) -> String {
        /*
         Parameter
         type       0. 을/를,  1.이/가
         single     true. 조사만 사용,   false. 문자포함
         */
        guard let lastText = self.last else { return self }     // 글자의 마지막 부분을 가져옴
        let unicodeVal = UnicodeScalar(String(lastText))?.value // 유니코드 전환
        guard let value = unicodeVal else { return self }
        if (value < 0xAC00 || value > 0xD7A3) { return self }   // 한글아니면 반환
        let last = (value - 0xAC00) % 28// 종성인지 확인
        if type == 0 {
            let str = last > 0 ? "을 " : "를 "      // 받침있으면 을 없으면 를 반환
            if single {
                return str
            }else {
                return self + str
            }
        }else {
            let str = last > 0 ? "이 " : "가 "      // 받침있으면 을 없으면 를 반환
            if single {
                return str
            }else {
                return self + str
            }
        }
    }
    
    
}

extension UILabel {
    enum fontType {
        case medium
        case regular
        case demiLight
    }
    
    func seFont(font: fontType, size: CGFloat) {
        switch font {
        case .medium:
            self.font = UIFont(name: "NotoSansCJKkr-Medium", size: size)
        case .regular:
            self.font = UIFont(name: "NotoSansCJKkr-Regular", size: size)
        case .demiLight:
            self.font = UIFont(name: "NotoSansCJKkr-DemiLight", size: size)       
        }
    }
}

extension String {

    init(withInt int: Int, leadingZeros: Int = 2) {
        self.init(format: "%0\(leadingZeros)d", int)
    }

    func leadingZeros(_ zeros: Int) -> String {
        if let int = Int(self) {
            return String(withInt: int, leadingZeros: zeros)
        }
        print("Warning: \(self) is not an Int")
        return ""
    }

}

extension String {
    func pretty() -> String {
        let _str = self.replacingOccurrences(of: "-", with: "") // 하이픈 모두 빼준다
        let arr = Array(_str)
        if arr.count > 3 {
            let prefix = String(format: "%@%@", String(arr[0]), String(arr[1]))
            if prefix == "02" { // 서울지역은 02번호
                if let regex = try? NSRegularExpression(pattern: "([0-9]{2})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive) {
                    let modString = regex.stringByReplacingMatches(in: _str, options: [], range: NSRange(_str.startIndex..., in: _str), withTemplate: "$1-$2-$3")
                    return modString
                    
                }
                
            } else if prefix == "15" || prefix == "16" || prefix == "18" { // 썩을 지능망...
                if let regex = try? NSRegularExpression(pattern: "([0-9]{4})([0-9]{4})", options: .caseInsensitive) {
                    let modString = regex.stringByReplacingMatches(in: _str, options: [], range: NSRange(_str.startIndex..., in: _str), withTemplate: "$1-$2")
                    return modString
                    
                }
                
            } else { // 나머지는 휴대폰번호 (010-xxxx-xxxx, 031-xxx-xxxx, 061-xxxx-xxxx 식이라 상관무)
                if let regex = try? NSRegularExpression(pattern: "([0-9]{3})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive) {
                    let modString = regex.stringByReplacingMatches(in: _str, options: [], range: NSRange(_str.startIndex..., in: _str), withTemplate: "$1-$2-$3")
                    return modString
                    
                }
                
            }
            
        }
        return self
        
    }
    
}
 
