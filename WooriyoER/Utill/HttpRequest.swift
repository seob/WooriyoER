//
//  HttpRequest.swift
//  PinPle
//
//  Created by WRY_010 on 13/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//  개발자 : 오대산
//  HTTPRequest 

import UIKit

class HTTPRequest{
    
    func urlEncode(_ str:String)->String{
        //- _ * . 제외 -> 특수문자 아님
        let encodedString = str.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "`~!@#$%^&()+=[]{}\\|;:'\"<>,/? ").inverted)
        return encodedString!
    }
    
    func get(urlStr:String, onCompletion: @escaping (Bool,NSDictionary) -> Void){
        //URL생성
        
        //원래 "!*'();@+$,%#[]{} ")
        guard let url = URL(string: urlStr) else {
            onCompletion(false, ["data":"url이 정확하지 않습니다."])
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET" //get : Get 방식, post : Post 방식
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            //error 일경우 종료
            guard error == nil && data != nil else {
                if let err = error {
                    print(err.localizedDescription)
                    onCompletion(false, ["data":err.localizedDescription])
                }
                return
            }
            //data 가져오기
            if let _data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: _data, options:
                        JSONSerialization.ReadingOptions.mutableContainers)
                    //return (json as? NSDictionary)
                    DispatchQueue.main.async {
                        onCompletion(true, json as! NSDictionary)
                    }
                } catch {
                    onCompletion(false, ["data":"json 을 복원하지 못했습니다."])
                    return
                }
            }else{
                onCompletion(false, ["data":"데이터를 받아오지 못했습니다."])
                return
            }
        })
        task.resume()
    }
}

