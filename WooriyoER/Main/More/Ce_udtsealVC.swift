//
//  Ce_udtsealVC.swift
//  PinPle
//
//  Created by seob on 2020/08/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import YPImagePicker

class Ce_udtsealVC: UIViewController  , UIScrollViewDelegate , Ce_ProfileViewControllerProtocol{
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblName: AwesomeTextField!
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var chkimgseal: UIImageView!
    
    @IBOutlet weak var roundImageView: UIImageView!
    @IBOutlet weak var squareImageView: UIImageView!
    @IBOutlet weak var btnRound: UIButton!
    @IBOutlet weak var btnSquare: UIButton!
    @IBOutlet weak var lblRound: UILabel!
    @IBOutlet weak var lblSquare: UILabel!
    var cmpSealInfo : cmpSignInfo = cmpSignInfo()
    @IBOutlet weak var SealimageView:UIImageView!
    var addflag: Bool  = false
    
    @IBOutlet weak var btnDelsplit: UIButton!
    @IBOutlet weak var btnModifysplit: UIButton!
    @IBOutlet weak var btnModify: UIButton!
    let picker = UIImagePickerController()
    var cmpsealImg: UIImage!
    var cmpsealImage = ""
    var type = 0
    var issquare = 0 // 직인모양 0.원형 1.사각형
    let cropSegue = "Ce_modifyToCropSegue"
    
    var config = YPImagePickerConfiguration()
    var selectedItems = [YPMediaItem]()
    let selectedImageV = UIImageView()
    var tmpImage: UIImage!
    func setCroppedImage(_ croppedImage: UIImage) {
        self.SealimageView.image = croppedImage
    }
    
    @IBAction func RoundDidTap(_ sender: UIButton) {
        // 원형일때
        issquare = 0
        roundImageView.image = UIImage(named: "icn_lc_roundstamp_on")
        squareImageView.image = UIImage(named: "icn_lc_squarestamp_off")
        
        lblRound.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
        lblSquare.textColor = UIColor.rgb(r: 218, g: 218, b: 218)
    }
    
    @IBAction func SquareDidTap(_ sender: UIButton) {
        // 직인일때
        issquare = 1
        roundImageView.image = UIImage(named: "icn_lc_roundstamp_off")
        squareImageView.image = UIImage(named: "icn_lc_squarestamp_on")
        lblRound.textColor = UIColor.rgb(r: 218, g: 218, b: 218)
        lblSquare.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnModify.layer.cornerRadius = 6
        btnModifysplit.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        lblNavigationTitle.text = "직인 수정"
        
        
        lblName.delegate = self
        lblName.text = cmpSealInfo.name
        picker.delegate = self
        
        cropView.layer.borderWidth = 1
        cropView.layer.borderColor = UIColor.init(hexString: "#707070").cgColor
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(imagePickerDidTap(_:)))
        cropView.addGestureRecognizer(viewTap)
        cropView.backgroundColor = UIColor.clear
        issquare = cmpSealInfo.shape
        if cmpSealInfo.shape == 0 {
            roundImageView.image = UIImage(named: "icn_lc_roundstamp_on")
            squareImageView.image = UIImage(named: "icn_lc_squarestamp_off")
            
            lblRound.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
            lblSquare.textColor = UIColor.rgb(r: 218, g: 218, b: 218)
        }else{
            roundImageView.image = UIImage(named: "icn_lc_roundstamp_off")
            squareImageView.image = UIImage(named: "icn_lc_squarestamp_on")
            lblRound.textColor = UIColor.rgb(r: 218, g: 218, b: 218)
            lblSquare.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if cmpSealInfo.certflag == 1 {
            btnModify.isHidden = false
            btnModifysplit.isHidden = true
            btnDelsplit.isHidden = true
        }else{
            btnModify.isHidden = true
            btnModifysplit.isHidden = false
            btnDelsplit.isHidden = false
        }
        
        SealimageView.sd_setImage(with: URL(string: cmpSealInfo.sealimg), placeholderImage: UIImage(named: "logo_pre"))
        if lblName.text != "" {
            chkimgseal.image = chkstatusAlertpass
        }
    }
    
    func openLibrary(){
//        picker.sourceType = .photoLibrary
//        present(picker, animated: false, completion: nil)
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.video.compression = AVAssetExportPresetMediumQuality
        config.startOnScreen = .library
        config.library.itemOverlayType = .grid
        config.screens = [.library, .photo]
        config.video.libraryTimeLimit = 60.0
        
        config.showsCrop = .none
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.library.preselectedItems = selectedItems
        config.hidesCancelButton = true
        config.library.maxNumberOfItems = 1
        
        let picker = YPImagePicker(configuration: config)
        
        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            
            self.selectedItems = items
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    self.cmpsealImg = photo.image
                    self.SealimageView.image = photo.image
                    picker.dismiss(animated: true, completion: nil)
                case .video( _):
                    print("\n---------- [ video ] ----------\n")
                }
            }
        }
        
        present(picker, animated: true, completion: nil)
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
            
            self.openLibrary()
            
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_sealListVC") as! Ce_sealListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //삭제
    @IBAction func delCmpsealDidTap(_ sender: UIButton) {
        if cmpSealInfo.certflag == 1 {
            toast("재직증명서 혹은 경력증명서에 사용 중 입니다.")
            return
        }else{
            let alertController = UIAlertController(title: "알림", message: "직인을 삭제하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                NetworkManager.shared().delCmpseal(cslsid: self.cmpSealInfo.sid, sealimg: self.cmpSealInfo.sealimg) { (isSuccess, resCode) in
                    if(isSuccess){
                        switch resCode {
                            case 1:
                                let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_sealListVC") as! Ce_sealListVC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: false, completion: nil)
                            case -1 :
                                self.toast("재직증명서 혹은 경력증명서에 사용 중 입니다.")
                            case 0 :
                                self.toast("죄송합니다. 예상치 못한 상황으로 결과를 전송하지 못하였습니다. 잠시 후 다시 시도해 주시길 바랍니다.")
                            default:
                                break
                        }
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .destructive) { (action) in
                print("\n---------- [ 취소 ] ----------\n")
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    // 수정
    @IBAction func uptCmpsealDidTap(_ sender: UIButton) {
        let name = lblName.text ?? ""
        if name == "" {
            if cmpSealInfo.type == 0 {
                self.toast("직인명을 입력해 주세요.")
            }else{
                self.toast("서명을 입력해 주세요.")
            }
        }else if cmpsealImg == UIImage(named: "logo_pre") {
            toast("직인 사진을 등록해 주세요.")
            return
        }else{
            if cmpsealImage == "" {
                //이미지 변경
                var saveImg: UIImage!
                saveImg = cmpsealImg.Newresize(image: cmpsealImg, targetSize: CGSize(width: 300, height: 300))
                NetworkManager.shared().udtCmpseal(cmpsid: userInfo.cmpsid, cslsid: cmpSealInfo.sid, image: saveImg, name: name.urlEncoding(), oldfilename: cmpSealInfo.sealimg, shape: issquare) { (isSuccess, resCode) in
                    if(isSuccess){
                        if resCode == 1 {
                            let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_sealListVC") as! Ce_sealListVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false, completion: nil)
                        }else{
                            self.toast("다시 시도해 주세요.")
                        }
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }
            }else{
                //이름만 변경
                NetworkManager.shared().udtCmpsealName(cslsid: cmpSealInfo.sid, name: name.urlEncoding() , shape: issquare) { (isSuccess, resCode) in
                    if(isSuccess){
                        if resCode == 1 {
                            let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_sealListVC") as! Ce_sealListVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false, completion: nil)
                        }else{
                            self.toast("다시 시도해 주세요.")
                        }
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }
                
            }
        }
    }
    
    
}

// MARK: - UITextFieldDelegate
extension Ce_udtsealVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == lblName {
            textField.becomeFirstResponder()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let str = textField.text ?? ""
        if textField == lblName {
            if str != "" {
                chkimgseal.image = chkstatusAlertpass
            }else{
                chkimgseal.image = chkstatusAlert
            }
        }
        
    }
}

// MARK: - UIImagePickerControllerDelegate
extension Ce_udtsealVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        if let image = info[.originalImage] as? UIImage {
            print("originalImage")
            newImage = image
        }else{
            return
        }
        
        cmpsealImage = ""
        self.cmpsealImg = newImage
        
        self.dismiss(animated: false, completion: {
            self.performSegue(withIdentifier: self.cropSegue, sender: nil)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cropViewController = segue.destination as? Ce_CropVC,
           segue.identifier == self.cropSegue {
            cropViewController.modalPresentationStyle = .fullScreen
            cropViewController.initialImage = self.cmpsealImg
            cropViewController.delegate = self
        }
    }
    
    
}
