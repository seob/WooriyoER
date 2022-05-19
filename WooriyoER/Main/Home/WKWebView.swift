//
//  WKWebView.swift
//  WooriyoER
//
//  Created by design on 2022/05/17.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import Foundation
import WebKit
import UIKit

//VC view controller
class WKWebViewVC: UIViewController {
    var webView:WKWebView!
    var adURL:String = ""
    var adName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string:adURL) else {
            return
        }
        let request = URLRequest(url: url)
        webView?.load(request)
    }
}
