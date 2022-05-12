//
//  HoldAplMsgVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/10/23.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class HoldAplMsgVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblMemo: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    
    var holdTuple: [(Int, Int, Int, Int, String, Int)] = []
    
    var aprsid = 0
    var empsid = 0
    var step = 0
    var ddctn = 0
    var apr = 0
    var reason = ""
    var nextEmpsid = 0
    var ApplyArr = ApplyListArr()
    var ApplyType = 0 //신청종류 코드(0.출장 1.야간근로 2.휴일근로)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n-----------------[UIViewController : \(self) ]---------------------\n")
        btnSave.layer.cornerRadius = 6
        txtView.delegate = self
        txtView.textContainer.maximumNumberOfLines = 0
        txtView.textContainer.lineFragmentPadding = 10
        txtView.textContainerInset = UIEdgeInsets(top: 11,left: 10,bottom: 10,right: 10)
        addToolBar(textView: txtView)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
        
        var typeStr = ""
        switch ApplyType {
        case 0:
            typeStr = "출장";
        case 1:
            typeStr = "연장근로";
        case 2:
            typeStr = "휴일근로";
        default:
            break;
        }
        
        switch holdTuple[0].3 {
        case 1:
            lblMemo.text = "\(typeStr) 결재 보류합니다."
        case 3:
            lblMemo.text = "\(typeStr) 결재 반려합니다."
        default:
            break
        }
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
//        var vc = AplAprSB.instantiateViewController(withIdentifier: "ProcAplAprVC") as! ProcAplAprVC
//        if SE_flag {
//            vc = AplAprSB.instantiateViewController(withIdentifier: "SE_ProcAplAprVC") as! ProcAplAprVC
//        }else{
//            vc = AplAprSB.instantiateViewController(withIdentifier: "ProcAplAprVC") as! ProcAplAprVC
//        }
//        vc.ApplyArr = self.ApplyArr
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: false, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    func valueSetting() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        print(holdTuple)
        aprsid = holdTuple[0].0
        empsid = userInfo.empsid
        step = holdTuple[0].2
        apr = holdTuple[0].3
        reason = holdTuple[0].4
        nextEmpsid = holdTuple[0].5
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(근로신청 결재처리 - 보류, 승인, 반려)
         Return  - 성공:1, 실패:0, 결재권한 없는경우:-1
         Parameter
         APRSID    근로신청 번호
         EMPSID    결재자 직원번호(본인)
         STEP    결재 단계 (1.1차, 2.2차, 3.3차)
         APR        처리(1.보류, 2.승인, 3.반려)
         REASON    보류/반려사유 .. URL 인코딩
         NEXT    다음 결재자 직원번호(최종 결재자의경우 0 넘김)
         */
        
        var typeStr = ""
        switch ApplyType {
        case 0:
            typeStr = "출장";
        case 1:
            typeStr = "연장근로";
        case 2:
            typeStr = "휴일근로";
        default:
            break;
        }
         
        if var tmpTextMemo = txtView.text , tmpTextMemo == "" {
            switch apr {
            case 1:
                tmpTextMemo = "\(typeStr) 결재 보류합니다."
                reason = httpRequest.urlEncode(tmpTextMemo)
            case 3:
                tmpTextMemo = "\(typeStr) 결재 반려합니다."
                reason = httpRequest.urlEncode(tmpTextMemo)
            default:
                break
            }
        }else{
            reason = httpRequest.urlEncode(txtView.text!)
        }
        NetworkManager.shared().procApplyapr(aprsid: aprsid, empsid: empsid, step: step, apr: apr, reason: reason, next: nextEmpsid) { (isSuccess, resultCode) in
            
            if(isSuccess){
                dispatchMain.async {
                    switch resultCode {
                    case 1:
                        if self.apr == 2 || self.apr == 3 {
                             if self.ApplyType == 0 {
                                 //출장
                                 Mainaprtripcnt -= 1
                             }else{
                                 Mainapraddcnt -= 1
                             }
                         }
                        var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
                        if SE_flag{
                            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
                        }else{
                            vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
                        }
                        notitype = "22"
                        vc.ApplyDetail = self.ApplyArr
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    case -1:
                        self.toast("결재 권한이 없습니다.")
                        self.dismiss(animated: true, completion: nil)
                    default:
                        self.toast("다시 시도해 주세요.")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }else{
                self.toast("다시 시도해 주세요.")
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
}

extension HoldAplMsgVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        lblMemo.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            lblMemo.isHidden = false
        }
    }
    
   // MARK: - textview 문자길이 체크
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if changedText.count > 50 {
            let alert = UIAlertController(title: "알림", message: "사유는 50자 이내로 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: false, completion: nil)
        }
        
        return changedText.count <= 50
//        if(text == "\n") {
//            view.endEditing(true)
//            return false
//        }else {
//            return true
//        }
        
    }
}
