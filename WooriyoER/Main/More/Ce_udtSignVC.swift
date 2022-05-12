//
//  Ce_udtSignVC.swift
//  PinPle
//
//  Created by seob on 2020/08/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

extension Ce_udtSignVC: SwiftyDrawViewDelegate {
    func swiftyDraw(shouldBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) -> Bool { return true }
    func swiftyDraw(didBeginDrawingIn    drawingView: SwiftyDrawView, using touch: UITouch) { updateHistoryButtons() }
    func swiftyDraw(isDrawingIn          drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(didFinishDrawingIn   drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(didCancelDrawingIn   drawingView: SwiftyDrawView, using touch: UITouch) {  }
}

class Ce_udtSignVC: UIViewController , UIScrollViewDelegate{
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblName: AwesomeTextField!
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var chkimgseal: UIImageView!
    var cmpSealInfo : cmpSignInfo = cmpSignInfo()
    var addflag: Bool  = false
    
    let picker = UIImagePickerController()
    let setWidth = UIScreen.main.bounds.size.width - 40
    let imageView = UIImageView()
    var scrollView: KACircleCropScrollView!
    @IBOutlet weak var btnModify: UIButton!
    
    var cmpsealImg: UIImage!
    var cmpsealImage = ""
    var type = 0
    var signView: SwiftyDrawView!
    var issquare = 0 // 직인모양 0.원형 1.사각형
    override func viewDidLoad() {
        super.viewDidLoad()
        btnModify.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        lblName.delegate = self
        lblName.text = cmpSealInfo.name
        
        cropView.backgroundColor = UIColor.clear
        cropView.layer.borderWidth = 1
        cropView.layer.borderColor = UIColor.init(hexString: "#707070").cgColor
        signView = SwiftyDrawView(frame: CGRect(x: 0, y: 0, width: cropView.bounds.width, height: cropView.bounds.height))
        cropView.addSubview(signView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        signView.delegate = self
        signView.brush.width = 2
        signView.drawMode = .draw
        if #available(iOS 9.1, *) {
            signView.allowedTouchTypes = [.finger, .pencil]
        }
        
        if lblName.text != "" {
            chkimgseal.image = chkstatusAlertpass
        }
    }
    
    //드로잉 초기화
    @IBAction func clearCanvas() {
        signView.clear()
        signView.brush.blendMode = .normal
    }
    
    func updateHistoryButtons() {
        print("\n---------- [ updateHistoryButtons ] ----------\n")
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
        if cmpSealInfo.useflag == 1 {
            toast("재직증명서 혹은 경력증명서에 사용 중 입니다.")
        }else{
            let alertController = UIAlertController(title: "알림", message: "서명을 삭제하시겠습니까?", preferredStyle: .alert)
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
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // 수정
    @IBAction func uptCmpsealDidTap(_ sender: UIButton) {
        let name = lblName.text ?? ""
        if name == "" {
            self.toast("서명을 입력해 주세요.")
            return
        }else if (signView.drawItems.count == 0 ){
            self.toast("서명을 입력해 주세요.")
            return
        }else{
            var saveImg: UIImage!
            let signImg = signView.screenshot()
            
            saveImg = signImg.Newresize(image: signImg, targetSize: CGSize(width: 300, height: 300))
            
            
            
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
        }
        
        
        
    }
}

// MARK: - UITextFieldDelegate
extension Ce_udtSignVC: UITextFieldDelegate {
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

