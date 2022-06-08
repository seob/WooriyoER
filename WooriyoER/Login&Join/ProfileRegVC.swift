//
//  ProfileRegVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/12/10.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import Alamofire

class ProfileRegVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var vwBox1: UIView!
    @IBOutlet weak var vwBox2: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    let picker = UIImagePickerController()
    let setWidth = UIScreen.main.bounds.size.width
    let imageView = UIImageView()
    let scrollView = KACircleCropScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
    
    var profileImg: UIImage = UIImage(named: "logo_pre")!
    var profimg: String = ""
    
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
    
    //MARK: - view override
    override func viewDidLoad() {
        print("\n-----------------[UIViewController : \(self) ]---------------------\n")
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnSave)
        
        picker.delegate = self
        scrollView.delegate = self
        scrollView.clipsToBounds = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        if userInfo.profimg != "" {
            if userInfo.profimg.urlTrim() != "img_photo_default.png" {
                profileImg = self.urlImage(url: userInfo.profimg)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewWillAppear(animated)
        imgSetting()
    }
    // - MARK: @IBAction
    // MARK: navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddInfo") as! AddInfo
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    // MARK: camera button
    @IBAction func btnCamera(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }else {
            print("Camera not available")
        }
    }
    // MARK: album button
    @IBAction func btnAlbum(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    // MARK: 저장 button
    @IBAction func imgSave(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        var saveImg: UIImage!
        croppingImgSet()
        saveImg = resizeImage(image: profileImg, target: 640)
        IndicatorSetting()
        NetworkManager.shared().Uploadimage(sid: userInfo.mbrsid, image: saveImg, type: 1) { (isSuccess, resCode, resImg) in
            if(isSuccess){
                print("\n---------- [ resCode : \(resCode) ] ----------\n")
                if (resCode == 0){
                    //이미지 업로드 실패
                    self.customAlertView("다시 시도해 주세요.")
                }else{
                    userInfo.profimg = resImg!
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddInfo") as! AddInfo
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
        }
        
    }
    // MARK: - @func
    // MARK: 이미지 cropview 세팅
    func imgSetting() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        if profileImg == UIImage(named: "logo_pre") {
            profileImg = resizeImage(image: profileImg, target: setWidth)
            scrollView.isScrollEnabled = false
            scrollView.bouncesZoom = false
        }else {
            scrollView.isScrollEnabled = true
            scrollView.bouncesZoom = true
        }
        
        scrollView.zoomScale = 1.0
        imageView.image = profileImg
        imageView.frame = CGRect(origin: CGPoint.zero, size: profileImg.size)
        scrollView.addSubview(imageView)
        
        if setWidth > profileImg.size.width || setWidth > profileImg.size.height {
            profileImg = profileImg.resizeImage(target: setWidth)
        }
        if profileImg.size.width > profileImg.size.height {
            scrollView.contentSize = .init(width: profileImg.size.height, height: profileImg.size.height)
        }else {
            scrollView.contentSize = .init(width: profileImg.size.width, height: profileImg.size.width)
        }
        
        let scaleWidth = scrollView.frame.size.width / scrollView.contentSize.width
        scrollView.minimumZoomScale = scaleWidth
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
    // MARK: croppingImgSet
    func croppingImgSet() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
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
    // MARK: 이미지 사이즈 조정
    func resizeImage(image: UIImage, target: CGFloat) -> UIImage {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
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
// MARK: - extension UIImagePickerControllerDelegate
extension ProfileRegVC : UIImagePickerControllerDelegate,
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
        imgSetting()
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - extension UIScrollViewDelegate
extension ProfileRegVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
