//
//  PDFMainViewController.swift
//  PinPle
//
//  Created by seob on 2020/06/26.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import TPPDF
import PDFKit

class PDFMainViewController: UIViewController {

    @IBOutlet weak var naviView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    private var pdfView = PDFView()
    
    var progressObserver: NSObjectProtocol!
    var selInfo : LcEmpInfo = LcEmpInfo()
    var viewflagType = ""
    public var exampleFactory: ExampleFactory?
    
    public var documentData: Data?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        exampleFactory = PinPlCtractView()
        
         getLCinfo()
    }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: naviView.bottomAnchor, constant: 0).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }

    func getLCinfo(){
        print("\n---------- [ getLCinfo ] ----------\n")
        NetworkManager.shared().get_LCInfo(LCTSID: selInfo.sid) { (isSuccess, resData) in
             if(isSuccess){
                 guard let serverData = resData else { return }
                self.selInfo = serverData
                SelLcEmpInfo = serverData
                
                self.generateExamplePDF()
//                self.previewPDF()
                
             }else{
                print("\n---------- [ 실패 ] ----------\n")
             }
         }
 
     }
    
    
  
    fileprivate func previewPDF(){
        if let data = documentData {
          pdfView.document = PDFDocument(data: data)
          pdfView.autoScales = true
        }
    }
    private var observer: NSObjectProtocol!

    func generateExamplePDF() {
        print("\n---------- [ SelLcEmpInfo : \(SelLcEmpInfo.toJSON()) ] ----------\n")
        switch SelLcEmpInfo.format {
        case 0:
            //핀플
            exampleFactory = PinplContract()
            break
        case 1:
            //표준
            if (SelLcEmpInfo.form == 0 || SelLcEmpInfo.form == 1){ //기간이 없는거
                exampleFactory = StdContract()
            }else if (SelLcEmpInfo.form == 2  || SelLcEmpInfo.form == 4){
                exampleFactory = StdContract()
            }else if (SelLcEmpInfo.form == 3  || SelLcEmpInfo.form == 5){
                //일욜
                exampleFactory = StdContractDay()
            }
            break
        default:
             break
        }
        
        guard let documents = exampleFactory?.generateDocument() else {
            return
        }
          
        
        var generator: PDFGeneratorProtocol
        if documents.count > 1 {
            generator = PDFMultiDocumentGenerator(documents: documents)
        } else {
            generator = PDFGenerator(document: documents.first!)
        }
//        generator.debug = ContactFactory is PinPlCtractView

        self.progressView.observedProgress = generator.progress
        observer = generator.progress.observe(\.completedUnitCount) { (p, _) in
            print(p.localizedDescription ?? "")
        }
        DispatchQueue.global(qos: .background).async {
            do {
                let url = try generator.generateURL(filename: "Example.pdf")
                
                print("Output URL:", url)  
                DispatchQueue.main.async {
                    self.progressView.isHidden = true
                    // Load PDF into a webview from the temporary file
                    

                    // Fit content in PDFView.
                    self.pdfView.autoScales = true
                    self.pdfView.backgroundColor = .white
                    self.pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                    self.pdfView.viewPrintFormatter()
                     if let document = PDFDocument(url: url) {
                        
                        document.delegate = self
                        self.pdfView.document = document
                        
                    }
                    
                    
                }
            } catch {
                print("Error while generating PDF: " + error.localizedDescription)
            }
        }
      
        
    }
     
    
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "Lc_Step7VC" {
            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step7VC") as! Lc_Step7VC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            
            if viewflagType == "stand_step5" {
                vc.viewflagType = "stand_step5"
                vc.standInfo = SelLcEmpInfo
            }else{
                vc.selInfo = SelLcEmpInfo
            }
            self.present(vc, animated: false, completion: nil)
        }else if viewflag == "ContractPrintMain" {
            let vc = ContractSB.instantiateViewController(withIdentifier: "ContractPrintMain") as! ContractPrintMain
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else{
            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
            if SE_flag {
                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
        
    }
     

}

extension PDFMainViewController : PDFDocumentDelegate {
    func classForPage() -> AnyClass {
        return WatermarkePage.self
    }
}

 
