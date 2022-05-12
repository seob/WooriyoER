//
//  ContractPrintVC.swift
//  PinPle
//
//  Created by seob on 2020/09/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import PDFReader

class ContractPrintVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSenddt: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var btnNosign: UIButton!
    @IBOutlet weak var btnSign: UIButton!
    var selInfo : LcEmpInfo = LcEmpInfo()
    
    @IBOutlet weak var CustomNavigation: UINavigationItem!
    lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(backButtonPressed(_:)))
        button.tag = 1
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if SE_flag {
        //            lblNavigationTitle.font = navigationFontSE
        //        }
        viewflag = "ContractPrintMain"
        selInfo = SelLcEmpInfo
        setUi()
        //        self.navigatuionItem.title = "근로계약서 인쇄"
        
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "icon_back"), for: .normal)
        
        button.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc private func backButtonPressed(_ sender: Any)
    {
        let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_ListVC") as! Lc_ListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
    
    func setUi(){
        lblTitle.text = "\(selInfo.name) 님의 근로계약서"
        print("\n---------- [ 1 : \(selInfo.regdt) ] ----------\n")
        
        lblSenddt.text = getTodayKo(selInfo.regdt)
        
        //        if userInfo.spot != "" {
        //            lblName.text = "\(userInfo.name)(\(userInfo.spot))"
        //        }else{
        //            lblName.text = "\(userInfo.name)"
        //        }
        
        lblPhone.text = "\(selInfo.phonenum.pretty())"
        lblEmail.text = "\(selInfo.email)"
        
        var statusStr = ""
        switch selInfo.status {
        case 0:
            statusStr = "미입력"
        case 1:
            statusStr = "계약완료"
        case 2:
            statusStr = "서명요청"
        case 3:
            statusStr = "거절"
        case 4:
            statusStr = "작성중"
        default:
            break
        }
        lblStatus.text = statusStr
        navigationController?.navigationItem.title = "근로계약서 인쇄 "
        print("\n---------- [ selinfo  : \(selInfo.toJSON()) ] ----------\n")
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_ListVC") as! Lc_ListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
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
    
    
    
    /// Initializes a document with the name of the pdf in the file system
    private func document(_ name: String) -> PDFDocument? {
        guard let documentURL = Bundle.main.url(forResource: name, withExtension: "pdf") else { return nil }
        
        return PDFDocument(url: documentURL)
    }
    
    /// Initializes a document with the data of the pdf
    private func document(_ data: Data) -> PDFDocument? {
        return PDFDocument(fileData: data, fileName: "Sample PDF")
    }
    
    /// Initializes a document with the remote url of the pdf
    private func document(_ remoteURL: URL) -> PDFDocument? {
        return PDFDocument(url: remoteURL)
    }
    
    
    /// Presents a document
    ///
    /// - parameter document: document to present
    ///
    /// Add `thumbnailsEnabled:false` to `createNew` to not load the thumbnails in the controller.
    private func showDocument(_ document: PDFDocument) {
        let image = UIImage(named: "")
        let controller = PDFViewController.createNew(with: document, title: "", actionButtonImage: image, actionStyle: .activitySheet)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
//        navigationController?.pushViewController(controller, animated: true)
    }
}
