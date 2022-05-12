//
//  SetCodePopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class SetCodePopUp: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    
    var name = ""
    var codesid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = name
        
    }
    // FIXME: 팝업창 닫기
    /***************************************************
     2020.01.14 seob
     기존 소스
     let url = urlClass.udt_joincode(codesid: codesid)
     if let jsonTemp: Data = jsonClass.weather_request(setUrl: url){
     if let jsonData: NSDictionary = jsonClass.json_parseData(jsonTemp) {
     print(url)
     print(jsonData)
     
     let nc = self.storyboard?.instantiateViewController(withIdentifier: "MoreNC") as! UINavigationController
     let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetCodeVC") as! SetCodeVC
     nc.modalTransitionStyle = .crossDissolve
     nc.modalPresentationStyle = .overCurrentContext
     nc.pushViewController(vc, animated: true)
     self.present(nc, animated: true, completion: nil)
     }
     }
     ***************************************************/
    @IBAction func okClick(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(합류코드 변경)
         Return  - 성공:변경된 합류코드, 실패:""
         Parameter
         CODESID        합류코드번호
         */
        NetworkManager.shared().UpdateJoinCode(codesid: codesid) { (isSuccess, resCode) in
            if(isSuccess){
                if (resCode != "") {
                    let vc = MoreSB.instantiateViewController(withIdentifier: "SetCodeVC") as! SetCodeVC
                    
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
