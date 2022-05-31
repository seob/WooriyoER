//
//  CertificatePrintMain.swift
//  PinPle
//
//  Created by seob on 2020/08/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import PDFReader

class CertificatePrintMain: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSenddt: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var btnNosign: UIButton!
    @IBOutlet weak var btnSign: UIButton!
    var selInfo : CeList = CeList()
    var format = 0 //0: 재직  . 1:경력
    
    @IBOutlet weak var CustomNavigation: UINavigationItem!
    lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(backButtonPressed(_:)))
        button.tag = 1
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewflag = "ContractPrintMain"
         
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "icon_back"), for: .normal)
        
        button.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let barButton = UIBarButtonItem(customView: button)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUi()
        navigationController?.navigationBar.isHidden = true
        if format == 0 {
            lblNavigationTitle.text = "재직증명서 인쇄 "
        }else{
            lblNavigationTitle.text = "경력증명서 인쇄 "
        }
    }
    
    @objc private func backButtonPressed(_ sender: Any)
    {
        if format == 0 {
            //재직증명서
            let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_ListVC") as! Ce_ListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else{
            //경력증명서
            let vc = CertifiSB.instantiateViewController(withIdentifier: "Cc_ListVC") as! Cc_ListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    
    
    func setUi(){
        print("\n---------- [ format : \(format) ] ----------\n")
        if format == 0 {
            lblTitle.text = "\(selInfo.name) 님의 재직증명서"
        }else{
            lblTitle.text = "\(selInfo.name) 님의 경력증명서"
        }
        
        lblSenddt.text = getTodayKo(selInfo.issuedt)
        
        if selInfo.isuspot != "" {
            lblName.text = "\(selInfo.isuname)(\(selInfo.isuspot))"
        }else{
            lblName.text = "\(selInfo.isuname)"
        }
        
        lblPhone.text = "\(selInfo.phonenum.pretty())"
        lblEmail.text = "\(selInfo.email)"
        var statusStr = ""
        switch selInfo.status {
        case 0:
            statusStr = "작성중"
        case 1:
            statusStr = "신청중"
        case 2:
            statusStr = "회사발급"
        case 3:
            statusStr = "근로자 직접발급"
        default:
            break
        }
        lblStatus.text = statusStr
        
         if format == 0 {
            navigationItem.title = "재직증명서 인쇄"
            navigationController?.navigationItem.title = "재직증명서 인쇄"
            lblNavigationTitle.text = "재직증명서 인쇄"
         }else{
            navigationItem.title = "경력증명서 인쇄"
            navigationController?.navigationItem.title = "경력증명서 인쇄"
            lblNavigationTitle.text = "경력증명서 인쇄"
        }
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) { 
        if format == 0 {
            //재직증명서
            let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_ListVC") as! Ce_ListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.type = format
            self.present(vc, animated: false, completion: nil)
        }else{
            //경력증명서
            let vc = CertifiSB.instantiateViewController(withIdentifier: "Cc_ListVC") as! Cc_ListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.type = format
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func PrintNosign(_ sender: UIButton) {
        let remotePDFDocumentURLPath = selInfo.pdffile
        if let remotePDFDocumentURL = URL(string: remotePDFDocumentURLPath), let doc = document(remotePDFDocumentURL) {
            showDocument(doc)
        } else {
            self.toast("PDF 파일형식이 아닙니다.")
            print("Document named \(remotePDFDocumentURLPath) not found")
        }
    }
    
    
    @IBAction func Printsign(_ sender: UIButton) {
        let remotePDFDocumentURLPath =  "\(selInfo.pdffile.replacingOccurrences(of: ".pdf", with: "_ori.pdf"))"
        if let remotePDFDocumentURL = URL(string: remotePDFDocumentURLPath), let doc = document(remotePDFDocumentURL) {
            showDocument(doc)
        } else {
            self.toast("PDF 파일형식이 아닙니다.")
            print("Document named \(remotePDFDocumentURLPath) not found")
        }
    }
    
    
    
    // Initializes a document with the name of the pdf in the file system
    private func document(_ name: String) -> PDFDocument? {
        guard let documentURL = Bundle.main.url(forResource: name, withExtension: "pdf") else { return nil }
        
        return PDFDocument(url: documentURL)
    }
    
    // Initializes a document with the data of the pdf
    private func document(_ data: Data) -> PDFDocument? {
        return PDFDocument(fileData: data, fileName: "Sample PDF")
    }
    
    // Initializes a document with the remote url of the pdf
    private func document(_ remoteURL: URL) -> PDFDocument? {
        return PDFDocument(url: remoteURL)
    }
    
    
    // Presents a document
    //
    // - parameter document: document to present
    //
    // Add `thumbnailsEnabled:false` to `createNew` to not load the thumbnails in the controller.
    private func showDocument(_ document: PDFDocument) {
        let image = UIImage(named: "")
        let controller = PDFViewController.createNew(with: document, title: "", actionButtonImage: image, actionStyle: .activitySheet)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen 
        navigationController?.pushViewController(controller, animated: true)
    }
}
