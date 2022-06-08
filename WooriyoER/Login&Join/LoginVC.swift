//
//  LoginVC.swift
//  PinPle
//
//  Created by WRY_010 on 12/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Alamofire
import AuthenticationServices
import SnapKit
import CryptoKit
import NVActivityIndicatorView

class LoginVC: UIViewController, NVActivityIndicatorViewable {
        
    
    @IBOutlet weak var logoImageView: UIImageView!
    fileprivate var currentNonce: String?
    var userID = String()
    
    // MARK: - IndicatorSetting
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    fileprivate func IndicatorSetting() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    // MARK: - view override
    override func viewDidLoad() {
        super.viewDidLoad()
           
        let tapGestureRecognizer = UILongPressGestureRecognizer(target:self, action:#selector(imageTapped))
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(tapGestureRecognizer)
 
    }
  
    @objc func imageTapped(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
           self.becomeFirstResponder()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.isMster = 1
            self.present(vc, animated: false, completion: nil)
        }
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         
        Spinner.stop()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Spinner.stop()
    }
    
    
    // MARK: - @IBAction
    // MARK: 이용약관
    @IBAction func termsClick(_ sender: UIButton) {
        if let url = URL(string: "http://pinpl.biz/serviceprovision.jsp") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    // MARK: 개인정보 취급방침
    @IBAction func policy(_ sender: UIButton) {
        if let url = URL(string: "http://pinpl.biz/privacypolicy.jsp") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    // MAKR: 이메일로 시작
    @IBAction func emailLoginClick(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
       
}
 
