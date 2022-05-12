//
//  ProcAnlAprPopUpDdctn.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class ProcAnlAprPopUpDdctn: UIViewController {
    
    @IBOutlet weak var btnDdctn: UIButton!
    @IBOutlet weak var btnUnDdctn: UIButton!
    
    var selTuple: [(String, Int, String, String, String, String, Int, Int, String, Int, Int, String, String, UIImage, Int, Int, String, Int)] = []
    var anlAprArr = AnualListArr()
    var ddctn = 1
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ddctn == 1 {
            btnDdctn.backgroundColor = .init(hexString: "#F7F7FA")
            btnUnDdctn.backgroundColor = .white
        }else {
            btnDdctn.backgroundColor = .white
            btnUnDdctn.backgroundColor = .init(hexString: "#F7F7FA")
        }
    }
    
    @IBAction func ddctnClick(_ sender: UIButton) {
//        ddctn = 1
        SelDdcnt = 1
        btnDdctn.backgroundColor = .init(hexString: "#F7F7FA")
        btnUnDdctn.backgroundColor = .white
//
//
//        var vc = AnlAprSB.instantiateViewController(withIdentifier: "ProcAnlAprVC") as! ProcAnlAprVC
//        if SE_flag {
//            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_ProcAnlAprVC") as! ProcAnlAprVC
//        }else{
//            vc = AnlAprSB.instantiateViewController(withIdentifier: "ProcAnlAprVC") as! ProcAnlAprVC
//        }
//        //        selTuple[0].10 = ddctn
//        anlAprArr.ddctn = ddctn
//        vc.anlAprArr = anlAprArr
//        vc.selTuple = selTuple
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        NotificationCenter.default.post(name: .reloadList, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func unDdctnClick(_ sender: UIButton) {
//        ddctn = 0
        SelDdcnt = 0
        btnDdctn.backgroundColor = .white
        btnUnDdctn.backgroundColor = .init(hexString: "#F7F7FA")
//
//        var vc = AnlAprSB.instantiateViewController(withIdentifier: "ProcAnlAprVC") as! ProcAnlAprVC
//        if SE_flag {
//            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_ProcAnlAprVC") as! ProcAnlAprVC
//        }else{
//            vc = AnlAprSB.instantiateViewController(withIdentifier: "ProcAnlAprVC") as! ProcAnlAprVC
//        }
//        //        selTuple[0].10 = ddctn
//        anlAprArr.ddctn = ddctn
//        vc.anlAprArr = anlAprArr
//        vc.selTuple = selTuple
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        NotificationCenter.default.post(name: .reloadList, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
}
