//
//  ProcAnlAprMultiPopUpDdctn.swift
//  PinPle
//
//  Created by seob on 2020/04/06.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class ProcAnlAprMultiPopUpDdctn: UIViewController {

     @IBOutlet weak var btnDdctn: UIButton!
        @IBOutlet weak var btnUnDdctn: UIButton!
        
        var selTuple: [(String, Int, String, String, String, String, Int, Int, String, Int, Int, String, String, UIImage, Int, Int, String, Int)] = []
        var anlAprArr = AnualListArr()
        var ddctn = 1
        var text = ""
         
        var selIndexPathRow : Int = 0
        var subsid:Int = 0
        override func viewDidLoad() {
            super.viewDidLoad()
            if ddctn == 1 {
                btnDdctn.backgroundColor = .init(hexString: "#F7F7FA")
                btnUnDdctn.backgroundColor = .white
            }else {
                btnDdctn.backgroundColor = .white
                btnUnDdctn.backgroundColor = .init(hexString: "#F7F7FA")
            }
            print("\n---------- [ subsid : \(subsid) , subddctn : \(ddctn) ] ----------\n")
        }
        
        @IBAction func ddctnClick(_ sender: UIButton) {
    //        ddctn = 1
            SelDdcnt = 1
            btnDdctn.backgroundColor = .init(hexString: "#F7F7FA")
            btnUnDdctn.backgroundColor = .white
            
            NetworkManager.shared().udt_anualaprsub_ddctn(subsid: subsid, ddctn: SelDdcnt) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        AnlMultiArr[self.selIndexPathRow].ddctn = SelDdcnt
                        NotificationCenter.default.post(name: .reloadList, object: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        @IBAction func unDdctnClick(_ sender: UIButton) {
    //        ddctn = 0
            SelDdcnt = 0
            btnDdctn.backgroundColor = .white
            btnUnDdctn.backgroundColor = .init(hexString: "#F7F7FA")
 
            NetworkManager.shared().udt_anualaprsub_ddctn(subsid: subsid, ddctn: SelDdcnt) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        AnlMultiArr[self.selIndexPathRow].ddctn = SelDdcnt
                        NotificationCenter.default.post(name: .reloadList, object: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
            NotificationCenter.default.post(name: .reloadList, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
