//
//  WaringMsgVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/11/08.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class WaringMsgVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblDelDay: UILabel!
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var tvMemo: UITextView!
    @IBOutlet weak var lblMsg: UILabel!       
    @IBOutlet weak var btnSaveSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSaveSend.layer.cornerRadius = 6
        tvMemo.delegate = self
        addToolBar(textView: tvMemo)
        tvMemo.textContainerInset = UIEdgeInsets(top: 11, left: 10, bottom: 10, right: 10)
        imgProfile.makeRounded()
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profimg = SelWarningEmpInfo.profimg
         if profimg.urlTrim() != "img_photo_default.png" {
            imgProfile.image = self.urlImage(url: profimg)
        }else {
            imgProfile.image = UIImage(named: "logo_pre")
        }
        
        lblPosition.text = SelWarningEmpInfo.spot
        var nameStr = SelWarningEmpInfo.name
        if SelWarningEmpInfo.enname != "" {
            nameStr += "(" + SelWarningEmpInfo.enname + ")"
        }
        lblName.text = nameStr
        lblTeam.text = SelWarningEmpInfo.tname
        lblHour.text = String(SelWarningEmpInfo.workmin / 60)
        lblMin.text = String(SelWarningEmpInfo.workmin % 60) 
//        lblDelDay.text = String(SelWarningEmpInfo.maxworkmin / 60)
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "WeekHourVC") as! WeekHourVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func sendMsg(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(직원 메시지 전송 - 연차촉진메시지, 주52시간경고메시지)
         Return  - 성공:1, 실패:0
         Parameter
         TYPE        타입(0.연차촉진메시지 1.주52시간경고메시지)
         SNDSID        발신자 직원번호
         SNDNM        발신자 이름 - URL 인코딩
         RCVSID        수신자 직원번호
         MSG            메시지 - URL 인코딩
         */
        //        let sndsid = prefs.value(forKey: "empsid") as! Int
        //        let sndnm = (prefs.value(forKey: "name") as! String).urlEncoding()
        guard let MemoMsg = tvMemo.text , MemoMsg != "" else { return self.toast("내용을 입력하세요.")}
        let sndsid = userInfo.empsid
        let sndnm = userInfo.name.urlEncoding()
        let rcvsid = SelWarningEmpInfo.empsid 
        let msg = MemoMsg.urlEncoding()
        
        NetworkManager.shared().SendPushMsg(type: 1, sndsid: sndsid, sndnm: sndnm, rcvsid: rcvsid, msg: msg) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode > 0 {
                    let vc = MoreSB.instantiateViewController(withIdentifier: "WeekHourVC") as! WeekHourVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                }else{
                    self.customAlertView("잠시 후, 다시 시도해 주세요.")
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
}
extension WaringMsgVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        lblMsg.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            lblMsg.isHidden = false
        }
    }
    
    // MARK: - textview 문자길이 체크
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let currentText = textView.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
//
//        if changedText.count > 50 {
//            let alert = UIAlertController(title: "알림", message: "출장 목적은 50자 이내로 입력하세요.", preferredStyle: UIAlertController.Style.alert)
//            let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
//            alert.addAction(okAction)
//            self.present(alert, animated: false, completion: nil)
//        }
        
//        return changedText.count <= 50
        if(text == "\n") {
            view.endEditing(true)
            return false
        }else {
            return true
        }
        
    }
}
