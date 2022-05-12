//
//  CmpSealView.swift
//  PinPle
//
//  Created by seob on 2020/06/09.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class CmpSealView: UIViewController , UIScrollViewDelegate {
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var TextName: SkyFloatingLabelTextField!
    
    
    let picker = UIImagePickerController()
    let setWidth = UIScreen.main.bounds.size.width
    let imageView = UIImageView()
    let scrollView = KACircleCropScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
    
    var profileImg: UIImage = UIImage(named: "logo_pre")!
    var profimg = ""
    var type = 0
    
    override func viewDidLoad() {
        picker.delegate = self
        scrollView.delegate = self
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(imagePickerDidTap(_:)))
        cropView.addGestureRecognizer(viewTap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imgSetting()
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
    
    //MARK: func
    func imgSetting() {
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
    
    //등록 버튼
    @IBAction func NextDidTap(_ sender: Any) {
        var saveImg: UIImage!
        croppingImgSet()
        var name = ""
        if type == 0 {
            name = TextName.text ?? ""
            if name == "" {
                toast("직인명을 입력해 주세요.")
            }
            saveImg = resizeImage(image: profileImg, target: 640)
        }else if type == 1 {
//            name = lblSignName.text ?? ""
//            if name == "" {
//                toast("서명을 입력해 주세요.")
//            }
//            let signImg = cropView2.screenshot()
//            saveImg = resizeImage(image: signImg, target: 640)
        }else if profileImg == UIImage(named: "logo_pre") {
            toast("직인을 등록해주세요.")
        }else{
            
            print("\n---------- [ name : \(name) , type : \(type) , image : \(saveImg) ] ----------\n")
            //            NetworkManager.shared().uploadCmpseal(cmpsid: userInfo.cmpsid, type: type, image: saveImg, name: name.urlEncoding()) { (isSuccess, resCode) in
            //                if(isSuccess){
            //                    if resCode == 1 {
            //                        let vc = ContractSB.instantiateViewController(withIdentifier: "CmpsealVC") as! CmpsealVC
            //                        vc.modalTransitionStyle = .crossDissolve
            //                        vc.modalPresentationStyle = .overFullScreen
            //                        self.present(vc, animated: false, completion: nil)
            //                    }else{
            //                        self.toast("다시 시도해 주세요.")
            //                    }
            //                }else{
            //                    self.toast("다시 시도해 주세요.")
            //                }
            //            }
        }
    }
}


extension CmpSealView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
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
