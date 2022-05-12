//
//  Sc_SendVC.swift
//  PinPle
//
//  Created by seob on 2021/11/11.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit
import MessageUI

class Sc_SendVC: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblsenddt: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblphone: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    
    
    @IBOutlet weak var btncheck: UIButton!
    @IBOutlet weak var btnpoint: UIButton!
    
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var pointImageView: UIImageView!
    @IBOutlet weak var lblPdfTitle: UILabel!
    
    @IBOutlet weak var lblCheckTitle: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var vwAgree: UIView!
    @IBOutlet weak var lblPointText: UILabel!
    var selInfo : ScEmpInfo = ScEmpInfo()
    var checked:String = ""
    var viewflagType = ""
    var progressObserver: NSObjectProtocol!
    public var exampleFactory: ExampleFactory?
    
    public var exampleFactory2: ExampleFactory?
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSend.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        if selInfo.format == 0 {
            lblNavigationTitle.text = "입사 보안서약서 발송"
        }else{
            lblNavigationTitle.text = "퇴사 보안서약서 발송"
        }
 
         
        btnSend.isEnabled = false
        lbltitle.text = "'\(selInfo.name)'님께 발송합니다."
        lblphone.text = "\(selInfo.phonenum.pretty())"
        lblemail.text = "\(selInfo.email)"
        
        lblsenddt.text = setTodayKo()
        
        if userInfo.spot != "" {
            lblName.text = "\(userInfo.name)(\(userInfo.spot))"
        }else{
            lblName.text = "\(userInfo.name)"
        }
        
        btncheck.addTarget(self, action: #selector(selPointDidTap(_:)), for: .touchUpInside)
        btnpoint.addTarget(self, action: #selector(selPointDidTap(_:)), for: .touchUpInside)
        
        checkImageView.image = uncheckImg
        pointImageView.image = uncheckImg
        
        btncheck.tag = 0
        btnpoint.tag = 1
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblCheckTitle.text = "작성된 보안서약서는 전송 이후 수정할 수 없습니다."
        lblPdfTitle.text = "보안서약서는 PDF파일로 변환되어 근로자 이메일로 전송됩니다."
        
        
        switch moreCmpInfo.freetype {
        case 2,3:
            //올프리 , 펀프리
            if moreCmpInfo.freedt >= muticmttodayDate() {
                btnpoint.isHidden = true
                pointImageView.isHidden  = true
                lblPointText.isHidden = true
            }else{
                vwAgree.isHidden = false
            }
        default :
            vwAgree.isHidden = false
        }
    }
    
    
    @objc func selPointDidTap(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.tag {
        case 0:
            if sender.isSelected {
                checkImageView.image = checkImg
            }else{
                checkImageView.image = uncheckImg
            }
        case 1:
            if sender.isSelected {
                pointImageView.image = checkImg
            }else{
                pointImageView.image = uncheckImg
            }
        default:
            checkImageView.image = uncheckImg
            pointImageView.image = uncheckImg
        }
        
        
        switch moreCmpInfo.freetype {
        case 2,3:
            //올프리 , 펀프리
            if moreCmpInfo.freedt >= muticmttodayDate() {
                if (btncheck.isSelected == true) {
                    btnSend.isEnabled = true
                }else{
                    btnSend.isEnabled = false
                }
            }else{
                if (btncheck.isSelected == true && btnpoint.isSelected == true){
                    btnSend.isEnabled = true
                }else{
                    btnSend.isEnabled = false
                }
            }
        default :
            if (btncheck.isSelected == true && btnpoint.isSelected == true){
                btnSend.isEnabled = true
            }else{
                btnSend.isEnabled = false
            }
        }
        
    }
    
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_Step4VC") as! Sc_Step4VC
        if SE_flag {
            vc = SecurtSB.instantiateViewController(withIdentifier: "SE_Sc_Step4VC") as! Sc_Step4VC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = self.selInfo
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func cancelDidTap(_ sender: UIButton) {
        var vc = SecurtSB.instantiateViewController(withIdentifier: "CmpSecurtPopUp") as! CmpSecurtPopUp
        if SE_flag {
            vc = SecurtSB.instantiateViewController(withIdentifier: "SE_CmpSecurtPopUp") as! CmpSecurtPopUp
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func sendDidTap(_ sender: UIButton) {
        
        if btncheck.isSelected == true {  checked = "1,"  }
        if btnpoint.isSelected == true {  checked += "2," }
        
        
        switch moreCmpInfo.freetype {
            case 2,3:
                //올프리 , 펀프리
                if moreCmpInfo.freedt >= muticmttodayDate() {
                    if (btncheck.isSelected == true){
                        var sid = ""
                        sid = "\(self.selInfo.sid)"
                        SmsScEmpInfo = self.selInfo
                        if fileExists == "" {
                            // pdf 생성
                            NetworkManager.shared().getSc_PDF(LCTSID: sid.base64Encoding()) { (isSuccess, resCode , respdf) in
                                if(isSuccess){
                                    if resCode == 1 {
                                        print("\n---------- [ respdf : \(respdf) ] ----------\n")
                                        fileExists = "\(respdf)"
                                        self.selInfo.pdffile = fileExists
                                        self.NetworkSend()
                                    }else{
                                        fileExists = ""
                                        self.toast("PDF 정보를 불러오지 못했습니다. 다시 시도해주세요.")
                                    }
                                }else{
                                    self.toast("PDF 정보를 불러오지 못했습니다. 다시 시도해주세요.")
                                }
                            }
                        }else{
                             NetworkSend()
                        }
                    }else{
                        self.customAlertView("확인사항에 동의하여 주시기 바랍니다.")
                    }
                }else{
                    if (btncheck.isSelected == true && btnpoint.isSelected == true) {
                        var sid = ""
                        sid = "\(self.selInfo.sid)"
                        SmsScEmpInfo = self.selInfo
                        if fileExists == "" {
                            // pdf 생성
                            NetworkManager.shared().getSc_PDF(LCTSID: sid.base64Encoding()) { (isSuccess, resCode , respdf) in
                                if(isSuccess){
                                    if resCode == 1 {
                                        print("\n---------- [ respdf : \(respdf) ] ----------\n")
                                        fileExists = "\(respdf)"
                                        self.selInfo.pdffile = fileExists
                                        self.NetworkSend()
                                    }else{
                                        fileExists = ""
                                        self.toast("PDF 정보를 불러오지 못했습니다. 다시 시도해주세요.")
                                    }
                                }else{
                                    self.toast("PDF 정보를 불러오지 못했습니다. 다시 시도해주세요.")
                                }
                            }
                        }else{
                             NetworkSend()
                        }
             
                    }else{
                        self.customAlertView("모두 체크시 전송 가능합니다.")
                    }
                }
            default :
                if (btncheck.isSelected == true && btnpoint.isSelected == true) {
                    var sid = ""
                    sid = "\(self.selInfo.sid)"
                    SmsScEmpInfo = self.selInfo
                    if fileExists == "" {
                        // pdf 생성
                        NetworkManager.shared().getSc_PDF(LCTSID: sid.base64Encoding()) { (isSuccess, resCode , respdf) in
                            if(isSuccess){
                                if resCode == 1 {
                                    print("\n---------- [ respdf : \(respdf) ] ----------\n")
                                    fileExists = "\(respdf)"
                                    self.selInfo.pdffile = fileExists
                                    self.NetworkSend()
                                }else{
                                    fileExists = ""
                                    self.toast("PDF 정보를 불러오지 못했습니다. 다시 시도해주세요.")
                                }
                            }else{
                                self.toast("PDF 정보를 불러오지 못했습니다. 다시 시도해주세요.")
                            }
                        }
                    }else{
                         NetworkSend()
                    }
         
                }else{
                    self.customAlertView("모두 체크시 전송 가능합니다.")
                }
        }
        
    }
     
    
    // MARK: - 미합류일땐 sms , 핀플직원이면 푸시 발송 후 보안서약서 리스트로 이동
    fileprivate func NetworkSend() {
        IndicatorSetting()
        SmsScEmpInfo = self.selInfo
        
        NetworkManager.shared().Sc_send(LCTSID: self.selInfo.sid, EMPSID: userInfo.empsid, MBRSID: userInfo.mbrsid) { (isSuccess, resCode) in
            if(isSuccess){
                PrintsFileImage = nil
                PrintFileImage = nil
                resultParam = ""
                print("\n---------- [ resCode : \(resCode) ] ----------\n")
                switch resCode {
                case 1:
                    let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_ListVC") as! Sc_ListVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                case 2:
                    //미합류 직원일때 sms 으로
                    if SmsScEmpInfo.empsid == 0 {
                        
                        var sid = 0
                        sid = self.selInfo.sid
                        
                        let extsid = "\(sid)"
                        let strUrl = "\(API.WEBbaseURL)labor/sc.jsp?LC=\(extsid.base64Encoding())"
                        shortUrl = strUrl
                        var vc = SecurtSB.instantiateViewController(withIdentifier: "SecurtSMSPopup") as! SecurtSMSPopup
                        if SE_flag {
                            vc = SecurtSB.instantiateViewController(withIdentifier: "SE_SecurtSMSPopup") as! SecurtSMSPopup
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            self.stopAnimating(nil)
                        }
//                        self.getShortUrl(strUrl) { (isSuccess, resData) in
//                             if(isSuccess){
//                                guard let serverData = resData else { return }
//                                shortUrl = serverData.result.url
//                                var vc = SecurtSB.instantiateViewController(withIdentifier: "SecurtSMSPopup") as! SecurtSMSPopup
//                                if SE_flag {
//                                    vc = SecurtSB.instantiateViewController(withIdentifier: "SE_SecurtSMSPopup") as! SecurtSMSPopup
//                                }
//                                vc.modalTransitionStyle = .crossDissolve
//                                vc.modalPresentationStyle = .overCurrentContext
//                                self.present(vc, animated: true, completion: nil)
//                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//                                    self.stopAnimating(nil)
//                                }
//                            }else{
//                                print("\n---------- [ 짧은주소 변환 실패  ] ----------\n")
//                                self.toast("다시 시도해 주세요.")
//                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//                                    self.stopAnimating(nil)
//                                }
//                            }
//                        }
                        
                    }else{
                        let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_ListVC") as! Sc_ListVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            self.stopAnimating(nil)
                        }
                    }
                case 0 :
                    self.toast("다시 시도해 주세요.")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                case -1 :
                    self.toast("회사직인 미설정")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                case -2 :
                    self.toast("근로계약서 없음")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                case -3:
                    self.toast("잔여 포인트 부족")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                default:
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                    break
                    
                }
            }else{
                self.toast("다시 시도해 주세요.")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }
        }
        
    }
    
    // 네이버 api 를 이용한 짧은 주소 변환 - 2020.07.08
    fileprivate func getShortUrl(_ strUrl:String, completion: @escaping (_ success:Bool , _ resData:NaverShortInfo?) ->()) {
        let strShortUrl = strUrl
        print("\n---------- [ strShorUrl : \(strUrl) ] ----------\n")
        let urlString = "https://openapi.naver.com/v1/util/shorturl?url=\(strShortUrl)"
        let headerInfo = [
            "X-Naver-Client-Id": NaverclientID ,
            "X-Naver-Client-Secret": NaverclientSecret
        ]
        
        print("\n---------- [ urlString : \(urlString) ] ----------\n")
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headerInfo).responseJSON { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<NaverShortInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                }
            case .failure( _):
                completion(false , nil)
            }
        }
    } 
}

