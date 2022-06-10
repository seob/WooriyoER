//
//  ProfileVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/12/09.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import Alamofire

class ProfileVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var vwBox1: UIView!
    @IBOutlet weak var vwBox2: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblSave: UILabel!
    
    let picker = UIImagePickerController()
    let setWidth = UIScreen.main.bounds.size.width
    let imageView = UIImageView()
    let scrollView = KACircleCropScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
    
    var profileImg: UIImage!
    var profimg = ""
    
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.eachLblBtn(btnSave, lblSave)
        picker.delegate = self
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imgSetting()
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "UdtMbrInfoVC") as! UdtMbrInfoVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    //MARK: @IBAction
    @IBAction func btnCamera(_ sender: UIButton) {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }else {
            print("Camera not available")
        }
    }
    
    @IBAction func btnAlbum(_ sender: UIButton) {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    @IBAction func imgSave(_ sender: UIButton) {
        var saveImg: UIImage!
        croppingImgSet()
        saveImg = resizeImage(image: profileImg, target: 640)
        NetworkManager.shared().Uploadimage(sid: userInfo.mbrsid, image: saveImg , type: 1) { (isSuccess, resCode, resImg) in
            if(isSuccess){
                if (resCode == 0){
                    //이미지 업로드 실패
                    self.customAlertView("다시 시도해 주세요.")
                }else{
//                    prefs.setValue(resImg, forKey: "profimg")
                    let temp_img = self.profileImg.jpegData(compressionQuality: 0.1)
                    prefs.setValue(temp_img, forKey: "mbr_profile")
                    userInfo.profimg = resImg ?? API.baseURL
                    let vc = MoreSB.instantiateViewController(withIdentifier: "UdtMbrInfoVC") as! UdtMbrInfoVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false, completion: nil)
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
 
        
    }
    //MARK: func
    func imgSetting() {
        print("imgSetting : \(setWidth)")
        if profimg.urlTrim() == "img_photo_default.png" {
            print("1")
            profileImg = UIImage(named: "logo_pre")
            profileImg = resizeImage(image: profileImg, target: setWidth)
            scrollView.isScrollEnabled = false
            scrollView.bouncesZoom = false
        }else {
            print("2")
            scrollView.isScrollEnabled = true
            scrollView.bouncesZoom = true
        }
        
        scrollView.zoomScale = 1.0
        imageView.image = profileImg
        imageView.frame = CGRect(origin: CGPoint.zero, size: profileImg.size)
        scrollView.addSubview(imageView)
        
        if setWidth > profileImg.size.width || setWidth > profileImg.size.height {
            print("\n---------- [ setWidth : \(setWidth) ] ----------\n")
            profileImg = profileImg.resizeImage(target: setWidth)
        }
        if profileImg.size.width > profileImg.size.height {
            scrollView.contentSize = .init(width: profileImg.size.height, height: profileImg.size.height)
        }else {
            scrollView.contentSize = .init(width: profileImg.size.width, height: profileImg.size.width)
        }
        
        let scaleWidth = scrollView.frame.size.width / scrollView.contentSize.width
        scrollView.minimumZoomScale = scaleWidth
        
                print("\n---------- [ scrollwidth : \(scrollView.frame.size.width) , logo width : \(profileImg.size.width) , imageview : \(imageView.frame.size.width)] ----------\n")
        
        if imageView.frame.size.width < scrollView.frame.size.width {
            print("We have the case where the frame is too small")
            scrollView.maximumZoomScale = scaleWidth * 3
        } else {
            scrollView.maximumZoomScale = 1.5
        }
        scrollView.zoomScale = scaleWidth
        
        //Center vertically
        scrollView.contentOffset = CGPoint(x: 0, y: (scrollView.contentSize.height - scrollView.frame.size.height)/2)
        cropView.addSubview(scrollView)
    }
  
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    

    func croppingImgSet(){
        let newSize = CGSize(width: profileImg.size.width*scrollView.zoomScale, height: profileImg.size.height*scrollView.zoomScale)
        
        let offset = scrollView.contentOffset
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: setWidth, height: setWidth), false, 0)
        var sharpRect = CGRect(x: -offset.x, y: -offset.y, width: newSize.width, height: newSize.height)
        sharpRect = sharpRect.integral
        
        profileImg.draw(in: sharpRect)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let imageData = finalImage!.pngData() {
            if let pngImage = UIImage(data: imageData) {
                profileImg = pngImage
            }
        }
    }
    
    func resizeImage(image: UIImage, target: CGFloat) -> UIImage {
        let size = image.size
        
        let widthRatio  = target  / size.width
        let heightRatio = target / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
extension ProfileVC : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        
        if let image = info[.originalImage] as? UIImage {
            print("originalImage")
            newImage = image
        } else {
            return
        }
        profileImg = newImage
        profimg = ""
        imgSetting()
        dismiss(animated: true, completion: nil)
    }
}
