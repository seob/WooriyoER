//
//  SeContractPrintMain.swift
//  PinPle
//
//  Created by seob on 2021/11/11.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit
import PDFReader

internal final class SeContractPrintMain: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSenddt: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var btnNosign: UIButton!
    @IBOutlet weak var btnSign: UIButton!
    var selInfo : ScEmpInfo = ScEmpInfo()
    var format = 0 //0: 재직  . 1:경력
    
    @IBOutlet weak var CustomNavigation: UINavigationItem!
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(backButtonPressed(_:)))
        button.tag = 1
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewflag = "SeContractPrintMain"
        self.navigationController?.navigationBar.topItem?.title = "보안서약서"
 
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        lblNavigationTitle.text = "보안서약서"
        setUi()
        let button = UIButton(type: .custom)

        button.setImage(UIImage(named: "icon_back"), for: .normal)

        button.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)

        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let barButton = UIBarButtonItem(customView: button)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.backButtonTitle = ""
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restoreNavigationBar()

    }
    
    private func restoreNavigationBar() {
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.layer.shadowColor = nil
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        navigationController?.navigationBar.layer.shadowOpacity = 0
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationItem.titleView = nil
        navigationController?.hidesBarsOnTap = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func backButtonPressed(_ sender: Any)
    {
        let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_ListVC") as! Sc_ListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
    
    func setUi(){
        
        lblTitle.text = "\(selInfo.name) 님의 보안서약서"
        lblSenddt.text = getTodayKo(selInfo.lcdt)
        lblPhone.text = "\(selInfo.phonenum.pretty())"
        lblEmail.text = "\(selInfo.email)"
        var statusStr = ""
        switch selInfo.status {
        case 0:
            statusStr = "미입력"
        case 1:
            statusStr = "서명완료"
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
        
        navigationItem.title = "보안서약서 인쇄"
        navigationController?.navigationItem.title = "보안서약서 인쇄"
        lblNavigationTitle.text = "보안서약서 인쇄"
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_ListVC") as! Sc_ListVC
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
//        let image = UIImage(named: "")
//        let controller = PDFViewController.createNew(with: document, title: "", actionButtonImage: image, actionStyle: .activitySheet)
//        controller.modalTransitionStyle = .crossDissolve
//        controller.modalPresentationStyle = .fullScreen
//        navigationController?.navigationBar.isHidden = false
//         navigationController?.popViewController(animated: true)
        
        let image = UIImage(named: "")
        let controller = PDFViewController.createNew(with: document, title: "", actionButtonImage: image, actionStyle: .activitySheet)
        navigationController?.pushViewController(controller, animated: true)
    }
}
