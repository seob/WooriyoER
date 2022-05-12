//
//  JsonClass.swift
//  PinPle
//
//  Created by WRY_010 on 05/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import Foundation

class JsonClass
{
    func weather_request(setUrl: String) -> Data? {
        
        //guard let url = URL(string: setUrl.addingPercentEscapes(using: String.Encoding.utf8)!) else {
        //    return nil
        //}
        let encodedString = setUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();@+$,%#[]{} ").inverted)
        if let url = URL(string: encodedString!) {
            guard let data = try? Data(contentsOf: url) else {
                return nil
            }
            //svn test
            return data
        }
        return nil
        
        
        
    }
    
    func json_parseData(_ data: Data) -> NSDictionary? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return (json as? NSDictionary)
        } catch _ {
            return nil
        }
    }
}
