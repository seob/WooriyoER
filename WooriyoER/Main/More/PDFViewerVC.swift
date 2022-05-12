//
//  PDFViewerVC.swift
//  PinPle
//
//  Created by seob on 2020/07/10.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewerVC: UIViewController,  NVActivityIndicatorViewable {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var ContentView: PDFView!
    
    var selInfo : LcEmpInfo = LcEmpInfo()
    var standInfo: LcEmpInfo = LcEmpInfo()
    
    var viewflagType = ""
    var pdfPath = ""
    var LocalPdfDocument:PDFDocument?
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: "PDF를 불러오는 중입니다.", type: indicatorType, fadeInAnimation: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        self.getPdf()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IndicatorSetting() //로딩
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) { 
        
        switch moreCmpInfo.freetype {
            case 2,3:
                //올프리 , 펀프리
                if moreCmpInfo.freedt >= muticmttodayDate() {
                    var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step7_FreeVC") as! Lc_Step7_FreeVC
                    if SE_flag {
                        vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_Step7_FreeVC") as! Lc_Step7_FreeVC
                    }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.selInfo.pdffile = ""
                    fileExists = ""
                    if viewflagType == "stand_step5" {
                        vc.standInfo = self.selInfo
                        vc.viewflagType = "stand_step5"
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
                    self.selInfo.pdffile = ""
                    fileExists = ""
                    if viewflagType == "stand_step5" {
                        vc.standInfo = self.selInfo
                        vc.viewflagType = "stand_step5"
                    }else{
                        vc.selInfo = self.selInfo
                    }
                    self.present(vc, animated: false, completion: nil)
                }
            default :
                var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step7VC") as! Lc_Step7VC
                if SE_flag {
                    vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_Step7VC") as! Lc_Step7VC
                }
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.selInfo.pdffile = ""
                fileExists = ""
                if viewflagType == "stand_step5" {
                    vc.standInfo = self.selInfo
                    vc.viewflagType = "stand_step5"
                }else{
                    vc.selInfo = self.selInfo
                }
                self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    
    
    fileprivate func getPdf(){
        let sid = "\(selInfo.sid)"
        
        if fileExists == "" {
            // pdf 생성
            NetworkManager.shared().getLc_PDF(LCTSID: sid.base64Encoding()) { (isSuccess, resCode , respdf) in
                if(isSuccess){
                    if resCode == 1 {
                        print("\n---------- [ respdf : \(respdf) ] ----------\n")
                        fileExists = "\(respdf.replacingOccurrences(of: ".pdf", with: "_pri.pdf"))"
                        self.selInfo.pdffile = fileExists
                        if let url = URL(string: fileExists), let pdfDocument = PDFDocument(url: url) {
                            self.ContentView.autoScales = true
                            self.ContentView.displayMode = .singlePageContinuous
                            self.ContentView.displayDirection = .vertical
                            self.ContentView.document = pdfDocument
                            self.LocalPdfDocument = pdfDocument
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            self.stopAnimating(nil)
                        }
                    }else{
                        fileExists = ""
                        self.toast("PDF 정보를 불러오지 못했습니다. 다시 시도해주세요.")
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            self.stopAnimating(nil)
                        }
                    }
                }else{
                    self.toast("PDF 정보를 불러오지 못했습니다. 다시 시도해주세요.")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                }
            }
        }else{
            
            fileExists = "\(selInfo.pdffile.replacingOccurrences(of: ".pdf", with: "_pri.pdf"))"
            print("\n---------- [ fileExists : \(fileExists) ] ----------\n")
            if let url = URL(string: fileExists), let pdfDocument = PDFDocument(url: url) {
                self.ContentView.autoScales = true
                self.ContentView.displayMode = .singlePageContinuous
                self.ContentView.displayDirection = .vertical
                self.ContentView.document = pdfDocument
                
                self.LocalPdfDocument = pdfDocument
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
        }
        
    }
    
}
