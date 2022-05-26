//
//  WebViewVC.swift
//  WooriyoER
//
//  Created by seob on 2022/05/26.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var lblNavigationTitle: UILabel!
    var strUrl = ""
    var strTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        lblNavigationTitle.text = "\(strTitle)"
        if let url = URL(string: "\(strUrl)") {
            let request = URLRequest(url: url)
            webview.load(request)
        }
    }
     
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}
