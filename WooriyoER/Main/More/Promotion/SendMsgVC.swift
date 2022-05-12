//
//  SendMsgVC.swift
//  PinPle
//
//  Created by WRY_010 on 07/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class SendMsgVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblDelDay: UILabel!
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var txtMsg: UITextView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    
    var AnualInfo: AnualInfo!
    
    var rmnDay = 0
    var rmnHour = 0
    var rmnMin = 0
    var msgStr = ""
    
    var clearday = 0
    var rcvsid = 0
    var enname = ""
    var joindt = ""
    var mbrsid = 0
    var name = ""
    var profimg = UIImage()
    var remain = 0
    var sid = 0
    var spot = ""
    var tname = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSend.layer.cornerRadius = 6
        txtMsg.delegate = self
        addToolBar(textView: txtMsg)
        txtMsg.textContainerInset = UIEdgeInsets(top: 11, left: 10, bottom: 10, right: 10)
        
        imgProfile.makeRounded()
       
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearday = AnualInfo.clearday
        rcvsid = AnualInfo.empsid
        enname = AnualInfo.enname
        joindt = AnualInfo.joindt
        mbrsid = AnualInfo.mbrsid
        name = AnualInfo.name
        remain = AnualInfo.remain
        sid = AnualInfo.anlsid
        spot = AnualInfo.spot
        tname = AnualInfo.tname
        
//        if AnualInfo.profimg.urlTrim() != "img_photo_default.png" {
//            profimg = self.urlImage(url: AnualInfo.profimg)
//        }else {
//            profimg = UIImage(named: "logo_pre")!
//        }
        imgProfile.sd_setImage(with: URL(string: AnualInfo.profimg), placeholderImage: UIImage(named: "logo_pre"))
        lblPosition.text = spot
        if enname != "" {
            lblName.text = name + "(" + enname + ")"
        }else {
            lblName.text = name
        }
        
        lblTeam.text = tname
        timeSet(remain)
        lblDay.text = String(rmnDay)
        lblHour.text = String(rmnHour)
        lblMin.text = String(rmnMin)
        lblDelDay.text = String(clearday)
        lblMsg.text = String(rmnDay) + "일 " + String(rmnHour) + "시간 " + String(rmnMin) + "분 연차는 " + String(clearday) + "일 후에 소멸될 예정입니다.해당 연차 소멸 이전에 연차를 신청해 주십시오."
        msgStr = lblMsg.text!
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "PrmListVC") as! PrmListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    func timeSet(_ time: Int) {
        rmnDay = time/(8*60)
        rmnHour = (time%(8*60))/60
        rmnMin = (time%(8*60))%(60)
        print(rmnDay, rmnHour, rmnMin)
        
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
        let sndsid = userInfo.empsid
        let sndnm = userInfo.name.urlEncoding()
        let rcvsid = self.rcvsid
        let msg = msgStr.urlEncoding()
        print("------------[msgStr =\(msgStr)]----------------")
        //        let url = urlClass.send_empmsg(type: 0, sndsid: sndsid, sndnm: sndnm, rcvsid: rcvsid, msg: msg)
        //        if let jsonTemp = jsonClass.weather_request(setUrl: url) {
        //            if let jsonData = jsonClass.json_parseData(jsonTemp) {
        //                print(url)
        //                print(jsonData)
        //
        //                let result = jsonData["result"] as! Int
        //                switch result {
        //                case 0:
        //                    self.customDefaultAlertView("다시 시도해 주세요.")
        //                case 1:
        //                    let sb = UIStoryboard.init(name: "More", bundle: nil)
        //                    let nc = sb.instantiateViewController(withIdentifier: "MoreNC") as! UINavigationController
        //                    let vc = sb.instantiateViewController(withIdentifier: "PrmListVC") as! PrmListVC
        //                    nc.modalTransitionStyle = .crossDissolve
        //                    nc.modalPresentationStyle = .overFullScreen
        //                    nc.pushViewController(vc, animated: true)
        //                    self.present(nc, animated: true, completion: nil)
        //                default:
        //                    break;
        //                }
        //            }
        //        }else {
        //            self.customDefaultAlertView("다시 시도해 주세요.")
        //        }
        
        print("\n---------- [ sndsid : \(sndsid) ,  sndnm : \(sndnm) , rcvsid : \(rcvsid) ,  msg : \(msg) ] ----------\n")
        
        NetworkManager.shared().SendPushMsg(type: 0, sndsid: sndsid, sndnm: sndnm, rcvsid: rcvsid, msg: msg) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode > 0 {
                    let vc = MoreSB.instantiateViewController(withIdentifier: "PrmListVC") as! PrmListVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)

                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
}
extension SendMsgVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        lblMsg.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            lblMsg.isHidden = false
            msgStr = lblMsg.text!
        }else {
            msgStr = txtMsg.text!
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


