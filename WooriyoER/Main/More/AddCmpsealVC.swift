//
//  AddCmpsealVC.swift
//  PinPle
//
//  Created by seob on 2020/06/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import YPImagePicker

protocol ProfileViewControllerProtocol {
    func setCroppedImage(_ croppedImage: UIImage)
}

extension AddCmpsealVC: SwiftyDrawViewDelegate {
    func swiftyDraw(shouldBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) -> Bool { return true }
    func swiftyDraw(didBeginDrawingIn    drawingView: SwiftyDrawView, using touch: UITouch) { updateHistoryButtons() }
    func swiftyDraw(isDrawingIn          drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(didFinishDrawingIn   drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(didCancelDrawingIn   drawingView: SwiftyDrawView, using touch: UITouch) {  }
}


class AddCmpsealVC: UIViewController, UIScrollViewDelegate  , ProfileViewControllerProtocol{
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblName: AwesomeTextField!
    @IBOutlet weak var lblSignName: AwesomeTextField!
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var cropView2: UIView!
    @IBOutlet weak var vwBox1: UIView!
    @IBOutlet weak var vwBox2: UIView!
    
    @IBOutlet weak var btnWork: UIButton!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var btnNotWork: UIButton!
    @IBOutlet weak var lblNotWork: UILabel!
    
    
    @IBOutlet weak var SealimageView:UIImageView!
    
    @IBOutlet weak var chkimgseal: UIImageView!
    @IBOutlet weak var chkimgsign: UIImageView!
    
    @IBOutlet weak var roundImageView: UIImageView!
    @IBOutlet weak var squareImageView: UIImageView!
    @IBOutlet weak var btnRound: UIButton!
    @IBOutlet weak var btnSquare: UIButton!
    @IBOutlet weak var lblRound: UILabel!
    @IBOutlet weak var lblSquare: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    let picker = UIImagePickerController()
    let setWidth = UIScreen.main.bounds.size.width
    var config = YPImagePickerConfiguration()
    var selectedItems = [YPMediaItem]()
    let selectedImageV = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    //    var scrollView: KACircleCropScrollView!
    
    var profileImg: UIImage = UIImage(named: "logo_pre")!
    var profimg = ""
    var type = 0
    var clickFlag = true
    var signView: SwiftyDrawView!
    var issquare = 0 // 직인모양 0.원형 1.사각형
    let cropSegue = "profileToCropSegue"
    
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
        btnAdd.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        } 
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(imagePickerDidTap(_:)))
        cropView.addGestureRecognizer(viewTap)
        
//        btnWork.setImage(UIImage(named: "btn_tab_select"), for: .selected)
//        btnWork.setImage(UIImage(named: "btn_tab_normal"), for: .normal)
//        btnNotWork.setImage(UIImage(named: "btn_tab_select"), for: .selected)
//        btnNotWork.setImage(UIImage(named: "btn_tab_normal"), for: .normal)
        
        btnWork.isSelected = true
        btnNotWork.isSelected = false
        vwBox2.isHidden = true
        
        cropView.layer.borderWidth = 1
        cropView.layer.borderColor = UIColor.init(hexString: "#707070").cgColor
        
        cropView2.layer.borderWidth = 1
        cropView2.layer.borderColor = UIColor.init(hexString: "#707070").cgColor
        
        signView = SwiftyDrawView(frame: CGRect(x: 0, y: 0, width: cropView2.bounds.width, height: cropView2.bounds.height))
        cropView2.addSubview(signView)
        
        addToolBar(textFields: [lblName , lblSignName])
        lblName.delegate = self
        lblSignName.delegate = self
        
        cropView.backgroundColor = UIColor.clear
        cropView2.backgroundColor = UIColor.clear
    }
    
    //드로잉 초기화
    @IBAction func clearCanvas() {
        signView.clear()
        signView.brush.blendMode = .normal
    }
    
    func updateHistoryButtons() {
        print("\n---------- [ updateHistoryButtons ] ----------\n")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        imgSetting()
    }
    
    //직인 선택시
    @IBAction func PinpleSelButton(_ sender: UIButton) {
        print("\n---------- [ PinpleSelButton ] ----------\n")
        clickFlag = true
        btnWork.isSelected = true
        btnNotWork.isSelected = false
        
        vwBox2.isHidden = true
        vwBox1.isHidden = false
        type = 0
        lblWork.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
        lblNotWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        btnWork.backgroundColor = UIColor.rgb(r: 252, g: 202, b: 0)
        btnNotWork.backgroundColor = UIColor.rgb(r: 247, g: 247, b: 250)
         scrollView.isScrollEnabled = true
    }
    
    //서명 선택시
    @IBAction func PinpleNoneButton(_ sender: UIButton) {
        print("\n---------- [ PinpleNoneButton ] ----------\n")
        clickFlag = false
        btnWork.isSelected = false
        btnNotWork.isSelected = true
        
        vwBox1.isHidden = true
        vwBox2.isHidden = false
        type = 1
        lblWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        lblNotWork.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
        btnNotWork.backgroundColor = UIColor.rgb(r: 252, g: 202, b: 0)
        btnWork.backgroundColor = UIColor.rgb(r: 247, g: 247, b: 250)
        signView.delegate = self
        signView.brush.width = 2
        signView.drawMode = .draw
        if #available(iOS 9.1, *) {
            signView.allowedTouchTypes = [.finger, .pencil]
        }
        scrollView.isScrollEnabled = false
        scrollView.setContentOffset(CGPoint(x: 0, y: -self.scrollView.contentInset.top), animated: false)
        
    }
    
    @objc func openLibrary() {
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
        config.hidesCancelButton = false
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
                    self.profileImg = photo.image
                    self.SealimageView.image = photo.image
                    picker.dismiss(animated: true, completion: nil)
                case .video(let _):
                    print("\n---------- [ video ] ----------\n")
                }
            }
        }
         
        present(picker, animated: true, completion: nil)
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
        let vc = ContractSB.instantiateViewController(withIdentifier: "CmpsealVC") as! CmpsealVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    //등록 버튼
    @IBAction func uploadDidTap(_ sender: Any) {
        var saveImg: UIImage!
        var name = ""
        print("\n---------- [ profileImg : \(profileImg) ] ----------\n")
        switch type {
        case 0:
            name = lblName.text ?? ""
            if name == "" {
                toast("직인명을 입력해 주세요.")
                return
            }else if profileImg == UIImage(named: "logo_pre") {
                toast("직인 사진을 등록해 주세요.")
                return
            }
            saveImg = profileImg.Newresize(image: profileImg, targetSize: CGSize(width: 300, height: 300))
        case 1:
            name = lblSignName.text ?? ""
            if name == "" {
                toast("서명을 입력해 주세요.")
                return
            }else if (signView.drawItems.count == 0 ){
                self.toast("서명을 입력해 주세요.")
            }
            let signImg = signView.screenshot()
            saveImg = signImg.Newresize(image: signImg, targetSize: CGSize(width: 300, height: 300))
        default:
            break
        }
        
        NetworkManager.shared().uploadCmpseal(cmpsid: userInfo.cmpsid, type: type, image: saveImg, name: name.urlEncoding() , shape:issquare, cert: 0) { (isSuccess, resCode , resImg) in
            if(isSuccess){
                if resCode == 1 {
                    let vc = ContractSB.instantiateViewController(withIdentifier: "CmpsealVC") as! CmpsealVC
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
 
// MARK: - UITextFieldDelegate
extension AddCmpsealVC :  UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let str = textField.text ?? ""
        if textField == lblName {
            if str != "" {
                chkimgseal.image = chkstatusAlertpass
            }else{
                chkimgseal.image = chkstatusAlert
            }
        }
        
        if textField == lblSignName {
            if str != "" {
                chkimgsign.image = chkstatusAlertpass
            }else{
                chkimgsign.image = chkstatusAlert
            }
        }
        
    }
    
}
