//
//  CmtAbsVC.swift
//  WooriyoER
//
//  Created by design on 2022/07/07.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit

class CmtAbsVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var textMemo: UITextView!
    @IBOutlet weak var lbltextlimit: UILabel!
    @IBOutlet weak var lblMemo: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var saveButtonView: UIView!
    @IBOutlet weak var vwBtn: UIStackView!
    
    let httpRequest = HTTPRequest()
    var startDt: String = ""
    var endDt: String = ""
    var selempsid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnAdd)
        addToolBar(textView: textMemo)
        
        textMemo.delegate = self
        textMemo.layer.cornerRadius = 6
        textMemo.layer.borderWidth = 1
        textMemo.layer.borderColor = UIColor.init(hexString: "#EDEDF2").cgColor
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSave(_ sender: UIButton) {
        let startTmpArr = CompanyInfo.starttm.components(separatedBy: ":")
        let endTmpArr = CompanyInfo.endtm.components(separatedBy: ":")
 
        
        let sdt = httpRequest.urlEncode(startDt.replacingOccurrences(of: ".", with: "-") + " \(startTmpArr[0]):\(startTmpArr[1])")
        let edt = httpRequest.urlEncode(endDt.replacingOccurrences(of: ".", with: "-") + " \(endTmpArr[0]):\(endTmpArr[1])")
        let memo = textMemo.text ?? ""
        NetworkManager.shared().Ins_cmtmgrAbs(empsid: selempsid, sdt: sdt, edt: edt , memo: memo.urlEncoding()) { (isSuccess, resCode) in
            DispatchQueue.main.async {
                if(isSuccess){
                    switch resCode {
                    case -1:
                        self.customAlertView("시간이 중복 됩니다.\n 다시 확인해주세요")
                    case 0:
                        self.customAlertView("출근 퇴근이 모두 입력 시\n 수정 가능합니다.")
                    case 1:
                        self.toast("등록되었습니다.")
                        NotificationCenter.default.post(name: .reloadCmpEmpList, object: nil)
                        var vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpCmtList") as! EmpCmtList
                        if SE_flag {
                            vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_EmpCmtList") as! EmpCmtList
                        }else{
                            vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpCmtList") as! EmpCmtList
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true, completion: nil)
                    default:
                        break;
                    }
                    
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
        }
    }
}


// MARK: - UITextViewDelegate
extension CmtAbsVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        lblMemo.isHidden = true
        textView.layer.borderColor = UIColor.init(hexString: "#043856").cgColor
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            lblMemo.isHidden = false
        }
        textView.layer.borderColor = UIColor.init(hexString: "#DADADA").cgColor
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textLength = textView.text.count
        lbltextlimit.text = "(\(textLength)/100)"
        if textView.text.count > 99 {
            textView.text.removeLast()
            let alert = UIAlertController(title: "알림", message: "메모는 100자 이내로 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: false, completion: nil)
        }
        if(text == "\n") {
            view.endEditing(true)
            return false
        }else {
            return true
        }
    }
    
}
