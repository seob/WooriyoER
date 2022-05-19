//  2022.05.18 정승현 작성
//  WKWebView.swift
//  WooriyoER
//
//  Created by design on 2022/05/17.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import WebKit
import UIKit

//VC view controller
class WKWebViewVC : UIViewController {
    var adURL:String = ""
    var adName:String = ""
    @IBOutlet weak var WKWebView: WKWebView!
    @IBOutlet weak var lblADName: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //버튼에 들어있는 텍스트를 지움
        btnBack.setTitle("", for: .normal)
        //print("이곳까지는 옵니까?")
        if let url = URL(string: adURL) {
            lblADName.text = adName
            let urlReq = URLRequest(url:url)
            //rint("이곳까지 도달했습니까?")
            WKWebView.load(urlReq)
        }
    }
    //뒤로가기
    @IBAction func clickBackBtn(_ sender: Any) {
        let mainVC = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        mainVC.modalTransitionStyle = .crossDissolve
        mainVC.modalPresentationStyle = .overFullScreen
        self.present(mainVC, animated: false, completion: nil)
    }
}
