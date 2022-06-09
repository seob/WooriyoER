//
//  HoldMsgVC.swift
//  PinPle
//
//  Created by WRY_010 on 22/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class HoldMsgVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tvMemo: UITextView!
    @IBOutlet weak var lblMemo: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    
    var holdTuple: [(Int, Int, Int, Int, Int, String, Int)] = []
    
    var aprsid = 0
    var empsid = 0
    var step = 0
    var ddctn = 0
    var apr = 0
    var reason = ""
    var nextEmpsid = 0
    var anlAprArr = AnualListArr()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnSave)
        tvMemo.delegate = self
        tvMemo.textContainer.maximumNumberOfLines = 0
        tvMemo.textContainer.lineFragmentPadding = 10
        tvMemo.textContainerInset = UIEdgeInsets(top: 11,left: 10,bottom: 10,right: 10)
        addToolBar(textView: tvMemo)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
        switch holdTuple[0].4 {
        case 1:
            lblMemo.text = "연차 결재 보류합니다."
        case 3:
            lblMemo.text = "연차 결재 반려합니다."
        default:
            break
        }
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        //        var vc = AnlAprSB.instantiateViewController(withIdentifier: "ProcAnlAprVC") as! ProcAnlAprVC
        //        if SE_flag {
        //            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_ProcAnlAprVC") as! ProcAnlAprVC
        //        }else{
        //            vc = AnlAprSB.instantiateViewController(withIdentifier: "ProcAnlAprVC") as! ProcAnlAprVC
        //        }
        //        vc.anlAprArr = anlAprArr
        //        vc.modalTransitionStyle = .crossDissolve
        //        vc.modalPresentationStyle = .overFullScreen
        //        self.present(vc, animated: false, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func valueSetting() {
        aprsid = holdTuple[0].0
        empsid = holdTuple[0].1
        step = holdTuple[0].2
        ddctn = holdTuple[0].3
        apr = holdTuple[0].4
        reason = holdTuple[0].5
        nextEmpsid = holdTuple[0].6
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(연차결재처리 - 보류, 승인, 반려)
         Return  - 성공:1, 실패:0, 결재권한 없는경우:-1
         Parameter
         APRSID    연차신청 번호
         EMPSID    결재자 직원번호(본인)
         STEP    결재 단계 (1.1차, 2.2차, 3.3차)
         DDCTN    연차차감 여부(0.미차감 1.차감)
         APR        처리(1.보류, 2.승인, 3.반려)
         REASON    보류/반려사유 .. URL 인코딩
         NEXT    다음 결재자 직원번호(최종 결재자의경우 0 넘김)
         */
        if var tmpTextMemo = tvMemo.text , tmpTextMemo == "" {
            switch apr {
            case 1:
                tmpTextMemo = "연차 결재 보류합니다."
                reason = httpRequest.urlEncode(tmpTextMemo)
            case 3:
                tmpTextMemo = "연차 결재 반려합니다."
                reason = httpRequest.urlEncode(tmpTextMemo)
            default:
                break
            }
        }else{
            reason = httpRequest.urlEncode(tvMemo.text!)
        }
        
        NetworkManager.shared().procAnualapr(aprsid: aprsid, empsid: empsid, step: step, ddctn: ddctn, apr: apr, reason: reason, next: nextEmpsid) { (isSuccess, resCode) in
            if(isSuccess){
                dispatchMain.async {
                    switch resCode {
                    case 1:
                        if self.apr == 2 || self.apr == 3 {
                            Mainanualaprcnt -= 1
                        }
                        var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
                        if SE_flag {
                            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
                        }else{
                            vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
                        }
                        
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    case -1 :
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

extension HoldMsgVC: UITextViewDelegate {
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
