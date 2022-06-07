//
//  Ce_Step3_FreeVC.swift
//  PinPle
//
//  Created by seob on 2021/04/15.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class Ce_Step3_FreeVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vwFreeTop: UIView!
    @IBOutlet weak var lblFirstText: UILabel!
    @IBOutlet weak var lblSecondText: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblTextInfo: UILabel!
    
    @IBOutlet weak var FreeLeadingConstraint: NSLayoutConstraint!
    var selInfo : Ce_empInfo = Ce_empInfo()
    var viewflagType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        setUi()
        if view.bounds.width == 414 {
            FreeLeadingConstraint.constant = 100
        }else if view.bounds.width == 375 {
            FreeLeadingConstraint.constant = 75
        }else if view.bounds.width == 390 {
            // iphone 12 pro
            FreeLeadingConstraint.constant = 95
        }
    }
    
 
    
    func setUi(){
        selInfo = Sel_CeEmpInfo
        if selInfo.format == 0  {
            lblNavigationTitle.text = "재직증명서 작성 완료"
            lblName.text = "\(self.selInfo.name)님의 재직증명서"
            
        }else{
            lblNavigationTitle.text = "경력증명서 작성 완료"
            lblName.text = "\(selInfo.name)님의 경력증명서"
        }
        switch moreCmpInfo.freetype {
            case 2,3:
                //올프리 , 펀프리
                if moreCmpInfo.freedt >= muticmttodayDate() {
                    vwFreeTop.isHidden = false
                    lblFirstText.text = PayTypeEnArray[moreCmpInfo.freetype]
                    lblSecondText.text = PayTypeKoArray[moreCmpInfo.freetype]
                    lblTextInfo.text = "\(PayTypeInfoArray[moreCmpInfo.freetype]) 요금제 사용중에는 핀을 소모하지 않고 증명서를 출력 및 근로자에게 전송하실 수 있습니다."
                }else{
                    vwFreeTop.isHidden = true
                }
            default :
                vwFreeTop.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //포인트 충전버튼
    @objc func pointCharge(_ sender: UITapGestureRecognizer) {
//        let vc = CertifiSB.instantiateViewController(withIdentifier: "InApp_CeVC") as! InApp_CeVC
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overFullScreen
//        vc.selInfo  = Sel_CeEmpInfo
//        self.present(vc, animated: false, completion: nil)
//        self.toast("핀포인트 충전은 웹에서만 가능합니다.")
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step2VC") as! Ce_Step2VC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = Sel_CeEmpInfo
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_SendVC") as! Ce_SendVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = Sel_CeEmpInfo
        self.present(vc, animated: false, completion: nil)
    }
    
}
