//
//  Lc_SendMsg.swift
//  PinPle
//
//  Created by seob on 2020/06/05.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import PDFKit
import TPPDF
import MessageUI

class Lc_SendMsg: UIViewController , NVActivityIndicatorViewable{
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
    
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var lblPointText: UILabel!
    
    @IBOutlet weak var vwAgree: UIView!
    var selInfo : LcEmpInfo = LcEmpInfo()
    var standInfo : LcEmpInfo = LcEmpInfo()
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
        lblPointText.isHidden = true
        btnpoint.isHidden = true
        pointImageView.isHidden = true
        btnSend.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        
//        btnSend.isEnabled = false
        if viewflagType == "stand_step5" {
            //표준
            lbltitle.text = "'\(standInfo.name)'님께 발송합니다."
            lblphone.text = "\(standInfo.phonenum.pretty())"
            lblemail.text = "\(standInfo.email)"
        }else{
            lbltitle.text = "'\(selInfo.name)'님께 발송합니다."
            lblphone.text = "\(selInfo.phonenum.pretty())"
            lblemail.text = "\(selInfo.email)"
        }
        
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
        getLCinfo()
        switch moreCmpInfo.freetype {
        case 2,3:
            //올프리 , 펀프리
            if moreCmpInfo.freedt >= muticmttodayDate() {
                lblPointText.isHidden = true
                btnpoint.isHidden = true
                pointImageView.isHidden = true
            }else{
                vwAgree.isHidden = false
            }
        default :
            vwAgree.isHidden = false
            lblPointText.isHidden = true
            btnpoint.isHidden = true
            pointImageView.isHidden = true
        }
    }
    
    fileprivate func getLCinfo(){
        var sid = 0
        if viewflagType == "stand_step5" {
            sid = standInfo.sid
        }else{
            sid = selInfo.sid
        }
        NetworkManager.shared().get_LCInfo(LCTSID: sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                if self.viewflagType == "stand_step5" {
                    self.standInfo = serverData
                }else{
                    self.selInfo = serverData
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
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
                if (btncheck.isSelected == true){
                    btnSend.isEnabled = true
                }else{
                    btnSend.isEnabled = false
                }
            }else{
                if (btncheck.isSelected == true){
                    btnSend.isEnabled = true
                }else{
                    btnSend.isEnabled = false
                }
            }
        default :
            if (btncheck.isSelected == true){
                btnSend.isEnabled = true
            }else{
                btnSend.isEnabled = false
            }
        }
    }
    
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "Lc_Step7_FreeVC" {
            var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step7_FreeVC") as! Lc_Step7_FreeVC
            if SE_flag {
                vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_Step7_FreeVC") as! Lc_Step7_FreeVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            if viewflagType == "stand_step5" {
                vc.viewflagType = "stand_step5"
                vc.standInfo = self.standInfo
            }else{
                vc.selInfo = self.selInfo
            }
            self.present(vc, animated: false, completion: nil)
        }else{
            var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step7VC") as! Lc_Step7VC
            if SE_flag {
                vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_Step7VC") as! Lc_Step7VC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            if viewflagType == "stand_step5" {
                vc.viewflagType = "stand_step5"
                vc.standInfo = self.standInfo
            }else{
                vc.selInfo = self.selInfo
            }
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func cancelDidTap(_ sender: UIButton) {
        var vc = ContractSB.instantiateViewController(withIdentifier: "CmpContractPopUp") as! CmpContractPopUp
        if SE_flag {
            vc = ContractSB.instantiateViewController(withIdentifier: "SE_CmpContractPopUp") as! CmpContractPopUp
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
                    if self.viewflagType == "stand_step5" {
                        sid = "\(self.standInfo.sid)"
                        SmsEmpInfo = self.standInfo
                    }else{
                        sid = "\(self.selInfo.sid)"
                        SmsEmpInfo = self.selInfo
                    }
                    
                    // pdf 생성
                    NetworkManager.shared().getLc_PDF(LCTSID: sid.base64Encoding()) { (isSuccess, resCode , respdf) in
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
                    self.customAlertView("확인사항에 동의하여 주시기 바랍니다.")
                }
            }else{
                if (btncheck.isSelected == true && btnpoint.isSelected == true) {
                    var sid = ""
                    if self.viewflagType == "stand_step5" {
                        sid = "\(self.standInfo.sid)"
                        SmsEmpInfo = self.standInfo
                    }else{
                        sid = "\(self.selInfo.sid)"
                        SmsEmpInfo = self.selInfo
                    }
                    
                    // pdf 생성
                    NetworkManager.shared().getLc_PDF(LCTSID: sid.base64Encoding()) { (isSuccess, resCode , respdf) in
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
                    self.customAlertView("모두 체크시 전송 가능합니다.")
                }
            }
        default :
            if (btncheck.isSelected == true) {
                var sid = ""
                if self.viewflagType == "stand_step5" {
                    sid = "\(self.standInfo.sid)"
                    SmsEmpInfo = self.standInfo
                }else{
                    sid = "\(self.selInfo.sid)"
                    SmsEmpInfo = self.selInfo
                }
                
                // pdf 생성
                NetworkManager.shared().getLc_PDF(LCTSID: sid.base64Encoding()) { (isSuccess, resCode , respdf) in
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
                self.customAlertView("모두 체크시 전송 가능합니다.")
            }
        }
        
        
    }
    
    // MARK: - 미합류일땐 sms , 핀플직원이면 푸시 발송 후 근로계약서 리스트로 이동
    fileprivate func NetworkSend() {
        IndicatorSetting()
        NetworkManager.shared().lc_send(LCTSID: SmsEmpInfo.sid, EMPSID: userInfo.empsid, MBRSID: userInfo.mbrsid) { (isSuccess, resCode) in
            if(isSuccess){
                PrintsFileImage = nil
                PrintFileImage = nil
                print("\n---------- [ resCode : \(resCode) ] ----------\n")
                switch resCode {
                case 1:
                    let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_ListVC") as! Lc_ListVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                case 2:
                    //미합류 직원일때 sms 으로
                    print("\n---------- [ SmsEmpInfo.empsid : \(SmsEmpInfo.empsid) ] ----------\n")
                    if SmsEmpInfo.empsid == 0 {
                        
                        var sid = 0
                        if self.viewflagType == "stand_step5" {
                            sid = self.standInfo.sid
                        }else{
                            sid = self.selInfo.sid
                        }
                        
                        let extsid = "\(sid)"
                        let strUrl = "\(API.WEBbaseURL)labor/lc.jsp?LC=\(extsid.base64Encoding())"
                        shortUrl = strUrl
                        var vc = ContractSB.instantiateViewController(withIdentifier: "ContractSMSPopup") as! ContractSMSPopup
                        if SE_flag {
                            vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractSMSPopup") as! ContractSMSPopup
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            self.stopAnimating(nil)
                        }
                    }else{
                        let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_ListVC") as! Lc_ListVC
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
        Alamofire.request(urlString
                          , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headerInfo).responseJSON { (response) in
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
    
    
    fileprivate func uploadLabor(completion: @escaping (_ resultCode :Int) ->()){
        var sid = 0
        if viewflagType == "stand_step5" {
            sid = standInfo.sid
        }else{
            sid = selInfo.sid
        }
        
        let extsid = "\(sid)"
        let strUrl = "\(API.WEBbaseURL)labor/lc.jsp?LC=\(extsid.base64Encoding())"
        self.getShortUrl(strUrl) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                shortUrl = serverData.result.url
                print("\n---------- [ shortUrl : \(shortUrl) ] ----------\n")
            }else{
                print("\n---------- [ 짧은주소 변환 실패  ] ----------\n")
            }
        }
        
        
    }
    
}

extension Lc_SendMsg {
    func generateExamplePDF(completion: @escaping (_ resultCode :Int) ->()){
        switch SelLcEmpInfo.format {
        case 0:
            //핀플
            exampleFactory = PinplContract()
            exampleFactory2 = PinplContract_noSeal()
            break
        case 1:
            //표준
            if (SelLcEmpInfo.form == 0 || SelLcEmpInfo.form == 1){ //기간이 없는거
                exampleFactory = StdContract()
                exampleFactory2 = StdContract_noSeal()
            }else if (SelLcEmpInfo.form == 2  || SelLcEmpInfo.form == 4){
                exampleFactory = StdContract()
                exampleFactory2 = StdContract_noSeal()
            }else if (SelLcEmpInfo.form == 3  || SelLcEmpInfo.form == 5){
                //일욜
                exampleFactory = StdContractDay()
                exampleFactory2 = StdContractDay_noSeal()
            }
            break
        default:
            break
        }
        
        guard let documents = exampleFactory?.generateDocument() else {
            return
        }
        
        guard let documents2 = exampleFactory2?.generateDocument() else {
            return
        }
        
        var generator: PDFGeneratorProtocol
        if documents.count > 1 {
            generator = PDFMultiDocumentGenerator(documents: documents)
        } else {
            generator = PDFGenerator(document: documents.first!)
        }
        
        var generator2: PDFGeneratorProtocol
        if documents2.count > 1 {
            generator2 = PDFMultiDocumentGenerator(documents: documents2)
        } else {
            generator2 = PDFGenerator(document: documents2.first!)
        }
        //        generator.debug = ContactFactory is PinPlCtractView
        
        
        DispatchQueue.global(qos: .background).async {
            do {
                let url = try generator.generateURL(filename: "Seal_Contract.pdf")
                let responData = try Data(contentsOf: url)
                
                let url2 = try generator2.generateURL(filename: "noSeal_Contract.pdf")
                let responData2 = try Data(contentsOf: url2)
                
                PDFSealFile = responData // 직인이 있는  pdf
                PDFnoSealFile = responData2 // 직인이 없는  pdf
                completion(1)
            } catch {
                completion(0)
                print("Error while generating PDF: " + error.localizedDescription)
            }
        }
        
    }
    
    
    func getLCinfo(_ sid: Int , completion: @escaping (_ resultCode :Int) ->()){
        NetworkManager.shared().get_LCInfo(LCTSID: sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                SelLcEmpInfo = serverData
                self.generateExamplePDF(completion:{ res in
                    if res == 1 {
                        completion(1)
                    }else{
                        completion(0)
                    }
                })
            }else{
                completion(0)
            }
        }
    }
}


