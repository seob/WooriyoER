//
//  Sc_step3VC.swift
//  PinPle
//
//  Created by seob on 2021/11/15.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class Sc_step3VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tblList: UITableView!
    var selInfo : ScEmpInfo = ScEmpInfo()
    
    var data = [0: defaultArticles1, 1: defaultArticles2, 2: defaultArticles3, 3: defaultArticles4, 4: defaultArticles5]
    var dict = [1 ,2 ,2,2,2]
    
   // var dataArr : [optScInfo] = []
    var SelMultiArr : [MultiConstractDate] = []
    var m_StackCount = 0
    var regdt = ""
    var dateFormatter = DateFormatter()
    var cmpname = ""
    var lcdt = ""
    var keyHeight: CGFloat?
    var footerview: SecurtFooterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n---------- [ self :\(selInfo.toJSON()) ] ----------\n")
        btnNext.layer.cornerRadius = 6
        if selInfo.format == 0 {
            lblNavigationTitle.text = "핀플 입사 보안서약서"
        }else{
            lblNavigationTitle.text = "핀플 퇴사 보안서약서"
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
         
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true) // todo...
        }
        sender.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSCinfo()
        setUi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    fileprivate func getSCinfo(){
        NetworkManager.shared().get_SCInfo(LCTSID: selInfo.sid) { (isSuccess, resData) in
            if(isSuccess){
                self.selInfo = ScEmpInfo()
                guard let serverData = resData else { return }
                self.selInfo = serverData
                self.tblList.reloadData()
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
  
    
    
    func setUi(){
        tblList.delegate = self
        tblList.dataSource = self
        tblList.estimatedRowHeight = 100
        tblList.separatorStyle = .none
        tblList.rowHeight = UITableView.automaticDimension
        tblList.keyboardDismissMode = .onDrag
        tblList.register(UINib.init(nibName: "ScTableViewCell", bundle: nil), forCellReuseIdentifier: "ScTableViewCell")
        tblList.register(UINib.init(nibName: "ScTableViewCell2", bundle: nil), forCellReuseIdentifier: "ScTableViewCell2")
        footerview = SecurtFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: 350))
        tblList.tableFooterView = footerview
        footerview.nameTextField.delegate = self
        footerview.dataBind(selInfo)
        if selInfo.cmpname == "" {
            cmpname = CompanyInfo.name
        }else{
            cmpname = selInfo.cmpname
        }
        
        if selInfo.lcdt == "" {
            lcdt = todayDateKo().replacingOccurrences(of: "-", with: ".")
        }else{
            let dt = footerview.lblRegdt.text ?? selInfo.lcdt
            lcdt = dt.replacingOccurrences(of: "-", with: ".")
        }
        
        footerview.lblRegdt.text = lcdt
        
        footerview.nameTextField.text = cmpname
        
        footerview.addContentBtn.addTarget(self, action: #selector(addBtnAction(_:)), for: .touchUpInside)
        
         
        ScMultiArrTemp = selInfo.optList
    }
    
    
    
    @objc func addBtnAction(_ sender: UIButton) {
        popupDidTap()
    }
    
    
    fileprivate func addView(_ type:Int){
        if selInfo.optList.count > 15 {
            toast("최대 15개까지 추가 가능합니다.")
        }else{
            
            let tmpData: optScInfo = optScInfo()
            tmpData.odysid = 0
            tmpData.optname = ""
            tmpData.opttype = type
            if selInfo.optList.count > 0 {
                tmpData.optseq = selInfo.optList.last!.optseq + 1
            }else{
                tmpData.optseq = 1
            }
            
            selInfo.optList.append(tmpData)
            ScMultiArrTemp.append(tmpData)
            tblList.reloadData()
        }
    }
    
    
    func popupDidTap(){
        //본문 추가 , 조항 추가
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let mainAction = UIAlertAction(title: "본문 추가", style: .default) { action in
            self.addView(1)
        }
        
        let subAction = UIAlertAction(title: "조항 추가", style: .default) { action in
            self.addView(2)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
            print("\n---------- [ action ] ----------\n")
        }
        
        alertController.addAction(mainAction)
        alertController.addAction(subAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_Step2VC") as! Sc_Step2VC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = self.selInfo
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        lcdt = footerview.lblRegdt.text ?? ""
        cmpname = footerview.nameTextField.text ?? ""
        if cmpname == "" {
            self.toast("수신처를 입력해 주세요")
        }else{
            var param: [String: Any] = [:]
            var multiArr: [Dictionary<String, Any>] = []
            selInfo.optList.removeAll(where: { $0.optname == "" })

            if selInfo.optList.count > 0 {
                for (i, _ ) in selInfo.optList.enumerated() {
                    
                    selInfo.optList[i].optseq = i + 1
                    
                }
                 
                for model in selInfo.optList {
                    
                    let object : [String : Any] = [
                        "odysid": model.odysid,
                        "optname": model.optname,
                        "opttype": model.opttype,
                        "optseq": model.optseq
                    ]
                    multiArr.append(object)
                }
                
                
                param = ["optList" : multiArr ]
                print("\n---------- [ param : \(selInfo.toJSON()) ] ----------\n")
                
                let data = try! JSONSerialization.data(withJSONObject: param, options: [])
                let jsonBatch:String = String(data: data, encoding: .utf8)!
                NetworkManager.shared().sc_step2(lctsid: selInfo.sid, cmpnm: cmpname, lcdt: lcdt, json: jsonBatch) { isSuccess, resCode in
                    if(isSuccess){
                        DispatchQueue.main.async {
                            if resCode == 1 {
                                let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_Step4VC") as! Sc_Step4VC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                vc.selInfo = self.selInfo
                                self.present(vc, animated: false, completion: nil)
                            }else{
                                self.toast("다시 시도해 주세요.")
                            }
                        }
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }
            }else{
                
                param = ["optList" : "" ]
                
                let data = try! JSONSerialization.data(withJSONObject: param, options: [])
                let jsonBatch:String = String(data: data, encoding: .utf8)!
                NetworkManager.shared().sc_step2(lctsid: selInfo.sid, cmpnm: cmpname, lcdt: lcdt, json: jsonBatch) { isSuccess, resCode in
                    if(isSuccess){
                        DispatchQueue.main.async {
                            if resCode == 1 {
                                let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_Step4VC") as! Sc_Step4VC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                vc.selInfo = self.selInfo
                                self.present(vc, animated: false, completion: nil)
                            }else{
                                self.toast("다시 시도해 주세요.")
                            }
                        }
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }
            }
 
            
 
        }
    }
    
    //임시저장
    @IBAction func moreBtn(_ sender: UIButton) {
        lcdt = footerview.lblRegdt.text ?? ""
        cmpname = footerview.nameTextField.text ?? ""
        
        selInfo.cmpname = cmpname
        selInfo.lcdt = lcdt
        
        SelScEmpInfo.cmpname = cmpname
        SelScEmpInfo.lcdt = lcdt
        SelScEmpInfo = selInfo
        SelScEmpInfo.viewpage = "step3"
        if SE_flag {
            presentPanModal(RowType.sebasic.presentable.rowVC)
        }else{
            presentPanModal(RowType.basic.presentable.rowVC)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension Sc_step3VC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selInfo.optList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selInfo.optList[indexPath.row].opttype == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScTableViewCell") as! ScTableViewCell
            cell.selectionStyle = .none
            cell.contentTextView.text = selInfo.optList[indexPath.row].optname
            cell.delegate = self
            cell.contentTextView.delegate = self
            cell.contentTextView.tag = indexPath.row
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(_:)), for: .touchUpInside)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScTableViewCell2") as! ScTableViewCell2
            cell.selectionStyle = .none
            cell.contentTextView.text = selInfo.optList[indexPath.row].optname
            cell.lblNumber.text = "-"
            cell.delegate = self
            cell.contentTextView.delegate = self
            cell.contentTextView.tag = indexPath.row
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(_:)), for: .touchUpInside)
            return cell
        }
        
    }
    
    @objc func deleteBtnAction(_ sender: UIButton) {
//        print("\n---------- [ dataArr : \(selInfo.optList.count) ] ----------\n")
//        print("\n---------- [ dataArr : \(selInfo.optList.toJSON()) ] ----------\n")
//        print("\n---------- [ sender.tag : \(sender.tag) ] ----------\n")
        var tmpArr: optScInfo = optScInfo()
        if sender.tag >= selInfo.optList.count {
            tmpArr = selInfo.optList[sender.tag - 1]
        }else{
            tmpArr = selInfo.optList[sender.tag]
        }
 
        let point = sender.convert(CGPoint.zero, to: tblList)
        guard let indexPath = tblList.indexPathForRow(at: point) else { return }
        if tmpArr.odysid > 0 {
            NetworkManager.shared().delScOtp(lctsid: selInfo.sid, optsid: tmpArr.odysid) { isSuccess, resCode in
                if(isSuccess){
                    self.selInfo.optList.remove(at: indexPath.row)
                    ScMultiArrTemp.remove(at: indexPath.row)
                    self.tblList.deleteRows(at: [indexPath], with: .automatic)
                    UIView.setAnimationsEnabled(false)
                    self.tblList.beginUpdates()
                    self.tblList.endUpdates()
                    UIView.setAnimationsEnabled(true)
                }else{
                    self.toast("다시 시도해 주세요")
                }
            }
        }else{
            self.selInfo.optList.remove(at: indexPath.row)
            ScMultiArrTemp.remove(at: indexPath.row)
            self.tblList.deleteRows(at: [indexPath], with: .automatic)
            UIView.setAnimationsEnabled(false)
            self.tblList.beginUpdates()
            self.tblList.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension Sc_step3VC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let str = textField.text ?? ""
        cmpname = str
        selInfo.cmpname = cmpname
    }
}



extension Sc_step3VC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let str = textView.text ?? ""
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요."
            textView.textColor = UIColor.lightGray
        }
        selInfo.optList[textView.tag].optname = "\(str)"
        ScMultiArrTemp[textView.tag].optname = "\(str)"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("\n---------- [ 1111 ] ----------\n")
        let size = textView.bounds.size
        let newSize = tblList.sizeThatFits(CGSize(width: size.width,
                                                  height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tblList.beginUpdates()
            tblList.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
        
    }
 
    
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
}

extension Sc_step3VC:TableViewCellDelegate {
    func updateTextViewHeight(_ cell: ScTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tblList.sizeThatFits(CGSize(width: size.width,
                                                  height: CGFloat.greatestFiniteMagnitude))
        print("\n---------- [ 1111 ] ----------\n")
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tblList.beginUpdates()
            tblList.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}



extension Sc_step3VC:TableViewCellDelegate2 {
    func updateTextViewHeight2(_ cell: ScTableViewCell2, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tblList.sizeThatFits(CGSize(width: size.width,
                                                  height: CGFloat.greatestFiniteMagnitude))
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tblList.beginUpdates()
            tblList.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}


private extension Sc_step3VC {
    enum RowType: Int, CaseIterable {
        case basic
        case sebasic
        
        var presentable: RowPresentable {
            switch self {
            case .basic: return Basic()
            case .sebasic: return SEBsic()
            }
        }
        
        struct Basic: RowPresentable {
            var viewpage: String = "step3"
            let rowVC: PanModalPresentable.LayoutType = SecurtInfoPopup()
            
        }
        
        struct SEBsic: RowPresentable {
            var viewpage: String = "step3"
            let rowVC: PanModalPresentable.LayoutType = SE_SecurtInfoPopup()
            
        }
        
    }
}
