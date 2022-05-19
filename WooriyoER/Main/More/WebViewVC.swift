//
//  more webview
//  WooriyoER
//
//  Created by 정승현 on 2022/05/19.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import WebKit
import UIKit

class WebViewVC : UIViewController {
    var adURL:String = ""
    var adName:String = ""
    @IBOutlet weak var WKWebView: WKWebView!
    @IBOutlet weak var lblADName: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.setTitle("", for: .normal)
        if let url = URL(string: adURL) {
            lblADName.text = adName
            let urlReq = URLRequest(url:url)
            WKWebView.load(urlReq)
        }
    }
    //뒤로가기
    @IBAction func clickBackBtn(_ sender: Any) {
        let mainVC = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        mainVC.modalTransitionStyle = .crossDissolve
        mainVC.modalPresentationStyle = .overFullScreen
        self.present(mainVC, animated: false, completion: nil)
    }
    
}
