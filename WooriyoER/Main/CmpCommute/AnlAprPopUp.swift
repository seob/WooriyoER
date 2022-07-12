//
//  AnlAprPopUp.swift
//  WooriyoER
//
//  Created by design on 2022/07/07.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit

class AnlAprPopUp: UIViewController {
    @IBOutlet weak var btnAnl: UIButton!
    @IBOutlet weak var btnFirstHalf: UIButton!
    @IBOutlet weak var btnAfternoon: UIButton!
    @IBOutlet weak var btnEarly: UIButton!
    @IBOutlet weak var btnGoingOut: UIButton!
    @IBOutlet weak var btnSick: UIButton!
    @IBOutlet weak var btnOfficial: UIButton!
    @IBOutlet weak var btnCongratulations: UIButton!
    @IBOutlet weak var btnEducation: UIButton!
    @IBOutlet weak var btnRewards: UIButton!
    @IBOutlet weak var btnCitizenship: UIButton!
    @IBOutlet weak var btnPhysical: UIButton!
    @IBOutlet weak var vwPhysical: UIView!
    @IBOutlet weak var vwHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var EarlyView: UIView!
    @IBOutlet weak var GoingOutView: UIView!
     
    var ddctn: Int = 0 // 1: 차감 , 2: 미차감
    var popflag:Int = 0
    var isMulti:Int = 0 // 0 : 싱글 1:멀티
    var dateArr: [String] = []
    var selIndexPathRow : Int = 0
    var reason = ""
    
    //1.버튼 색깔
    let btnColor = UIColor.init(hexString: "#043956")
    //2.글자 색깔
    let lblColor = UIColor.init(hexString: "#FFFFFF")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAnl.layer.cornerRadius = 18
        btnFirstHalf.layer.cornerRadius = 18
        btnAfternoon.layer.cornerRadius = 18
        btnEarly.layer.cornerRadius = 18
        btnGoingOut.layer.cornerRadius = 18
        btnSick.layer.cornerRadius = 18
        btnOfficial.layer.cornerRadius = 18
        btnCongratulations.layer.cornerRadius = 18
        btnEducation.layer.cornerRadius = 18
        btnRewards.layer.cornerRadius = 18
        btnCitizenship.layer.cornerRadius = 18
        btnPhysical.layer.cornerRadius = 18
         
        vwPhysical.isHidden = false
        vwHeight.constant = 36
        
//        if userInfo.gender == 0 {
//            vwPhysical.isHidden = true
//            vwHeight.constant = 0
//        }else {
//            vwPhysical.isHidden = false
//            vwHeight.constant = 36
//        }
        
//        switch anlType {
//        case 0:
//            btnAnl.isSelected = true
//        case 1:
//            btnFirstHalf.isSelected = true
//        case 2:
//            btnAfternoon.isSelected = true
//        case 3:
//            btnEarly.isSelected = true
//        case 4:
//            btnGoingOut.isSelected = true
//        case 5:
//            btnSick.isSelected = true
//        case 6:
//            btnOfficial.isSelected = true
//        case 7:
//            btnCongratulations.isSelected = true
//        case 8:
//            btnEducation.isSelected = true
//        case 9:
//            btnRewards.isSelected = true
//        case 10:
//            btnCitizenship.isSelected = true
//        case 11:
//            btnPhysical.isSelected = true
//        default:
//            break;
//        }
        
        switch anlType {
        case 0:
            btnAnl.isSelected = true
            btnAnl.backgroundColor = btnColor
            btnAnl.setTitleColor(lblColor, for: .normal)
        case 1:
            btnFirstHalf.isSelected = true
            btnFirstHalf.backgroundColor = btnColor
            btnFirstHalf.setTitleColor(lblColor, for: .normal)
        case 2:
            btnAfternoon.isSelected = true
            btnAfternoon.backgroundColor = btnColor
            btnAfternoon.setTitleColor(lblColor, for: .normal)
        case 3:
            btnEarly.isSelected = true
            btnEarly.backgroundColor = btnColor
            btnEarly.setTitleColor(lblColor, for: .normal)
        case 4:
            btnGoingOut.isSelected = true
            btnGoingOut.backgroundColor = btnColor
            btnGoingOut.setTitleColor(lblColor, for: .normal)
        case 5:
            btnSick.isSelected = true
            btnSick.backgroundColor = btnColor
            btnSick.setTitleColor(lblColor, for: .normal)
        case 6:
            btnOfficial.isSelected = true
            btnOfficial.backgroundColor = btnColor
            btnOfficial.setTitleColor(lblColor, for: .normal)
        case 7:
            btnCongratulations.isSelected = true
            btnCongratulations.backgroundColor = btnColor
            btnCongratulations.setTitleColor(lblColor, for: .normal)
        case 8:
            btnEducation.isSelected = true
            btnEducation.backgroundColor = btnColor
            btnEducation.setTitleColor(lblColor, for: .normal)
        case 9:
            btnRewards.isSelected = true
            btnRewards.backgroundColor = btnColor
            btnRewards.setTitleColor(lblColor, for: .normal)
        case 10:
            btnCitizenship.isSelected = true
            btnCitizenship.backgroundColor = btnColor
            btnCitizenship.setTitleColor(lblColor, for: .normal)
        case 11:
            btnPhysical.isSelected = true
            btnPhysical.backgroundColor = btnColor
            btnPhysical.setTitleColor(lblColor, for: .normal)
        default:
            btnAnl.isSelected = true
            btnAnl.backgroundColor = btnColor
            btnAnl.setTitleColor(lblColor, for: .normal)
        }
    }
    
    // MARK: Actions
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func anlTypeClick(_ sender: UIButton) {
        print(sender)
        btnSetting(sender);
        
        switch sender {
        case btnAnl:
            anlType = 0
        case btnFirstHalf:
            anlType = 1
        case btnAfternoon:
            anlType = 2
        case btnEarly:
            anlType = 3
        case btnGoingOut:
            anlType = 4
        case btnSick:
            anlType = 5
        case btnOfficial:
            anlType = 6
        case btnCongratulations:
            anlType = 7
        case btnEducation:
            anlType = 8
        case btnRewards:
            anlType = 9
        case btnCitizenship:
            anlType = 10
        case btnPhysical:
            anlType = 11
        default:
            break;
        }
         
        dismiss(animated: true) {
            NotificationCenter.default.post(name: .reloadAddAnual, object: nil)
        }
    }
    
    func btnSetting(_ sender: UIButton) {
        btnAnl.isSelected = false
        btnFirstHalf.isSelected = false
        btnAfternoon.isSelected = false
        btnEarly.isSelected = false
        btnGoingOut.isSelected = false
        btnSick.isSelected = false
        btnOfficial.isSelected = false
        btnCongratulations.isSelected = false
        btnEducation.isSelected = false
        btnRewards.isSelected = false
        btnCitizenship.isSelected = false
        btnPhysical.isSelected = false
        
        sender.isSelected = true
        sender.backgroundColor = btnColor
        sender.setTitleColor(lblColor, for: .normal)
    }
}
