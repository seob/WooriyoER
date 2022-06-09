//
//  Ce_SettingVC.swift
//  PinPle
//
//  Created by seob on 2020/08/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import Photos
import PhotosUI 

protocol Certi_ProfileViewControllerProtocol {
    func setCroppedImage(_ croppedImage: UIImage)
}

class Ce_SettingVC: UIViewController , Certi_ProfileViewControllerProtocol{
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoimageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    let picker = UIImagePickerController()
    var issquare = 0 // 직인모양 0.원형 1.사각형
    var profileImg: UIImage = UIImage(named: "logo_pre")!
    let cropSegue = "Cert_profileToCropSegue"
    var setInfo : Ce_certiSetinfo = Ce_certiSetinfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnSave)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        setUi()
    }
    
    func setUi(){
        logoimageView.image = profileImg
        picker.delegate = self
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(imagePickerDidTap(_:)))
        logoView.addGestureRecognizer(viewTap)
        logoView.backgroundColor = UIColor.clear
        
//        let lblnameTap = UITapGestureRecognizer(target: self, action: #selector(nameDidTap(_:)))
//        nameView.addGestureRecognizer(lblnameTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        get_certsetinfo()
    }
    
    //증명서발급 담당자, 증명서 삽입로고 조회
    func get_certsetinfo(){
        NetworkManager.shared().getCerSetinfo(cmpsid: CompanyInfo.sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                self.setInfo = serverData
//                if self.setInfo.empsid > 0 {
//                    self.lblName.text = serverData.name
//                }else{
//                    self.lblName.text = "미설정"
//                }
                
                self.logoimageView.sd_setImage(with: URL(string: serverData.logo), placeholderImage: UIImage(named: "logo_pre"))
                SelCeEmpInfo.sid = serverData.empsid
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    @objc func nameDidTap(_ sender: UITapGestureRecognizer){
        let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_mghrListVC") as! Ce_mghrListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func setCroppedImage(_ croppedImage: UIImage) {
        self.logoimageView.image = croppedImage
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = CertifiSB.instantiateViewController(withIdentifier: "CertifiCateMainVC") as! CertifiCateMainVC
        if SE_flag {
            vc = CertifiSB.instantiateViewController(withIdentifier: "SE_CertifiCateMainVC") as! CertifiCateMainVC
        }else{
            vc = CertifiSB.instantiateViewController(withIdentifier: "CertifiCateMainVC") as! CertifiCateMainVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        var vc = CertifiSB.instantiateViewController(withIdentifier: "CertifiCateMainVC") as! CertifiCateMainVC
        if SE_flag {
            vc = CertifiSB.instantiateViewController(withIdentifier: "SE_CertifiCateMainVC") as! CertifiCateMainVC
        }else{
            vc = CertifiSB.instantiateViewController(withIdentifier: "CertifiCateMainVC") as! CertifiCateMainVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera(){
        
        if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }else {
            print("Camera not available")
        }
    }
    
    
    @objc func imagePickerDidTap(_ sender: UITapGestureRecognizer){
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// MARK: - UIImagePickerControllerDelegate , UINavigationControllerDelegate
extension Ce_SettingVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        if let image = info[.originalImage] as? UIImage {
            print("originalImage")
            newImage = image
        }else{
            return
        }
        
        self.profileImg = newImage
        
        self.dismiss(animated: false, completion: {
            self.performSegue(withIdentifier: self.cropSegue, sender: nil)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cropViewController = segue.destination as? Ce_CertifiCrop,
            segue.identifier == self.cropSegue {
            cropViewController.modalPresentationStyle = .fullScreen
            cropViewController.initialImage = self.profileImg
            cropViewController.delegate = self
        }
    }
}
