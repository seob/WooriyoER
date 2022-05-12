//
//  Ce_ListVC.swift
//  PinPle
//
//  Created by seob on 2020/08/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Ce_ListVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var vwNoApr: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var lcList : [CeList] = []
    var fillterData : [CeList] = []
    var searchText : String = ""
    var curkey = ""
    var listcnt = 30
    var total = 0
    var tmpTotal = 0
    var nextkey = ""
    var fetchingMore = false
    var emptyAnual = 1
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        if userInfo.author != 0 || userInfo.author != 1 {
            customAlertView("권한이 없습니다.\n마스터관리자와 인사담당자만 가능합니다.")
        }
        
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.backgroundColor = UIColor.init(hexString: "#F7F7FA")
        
        tblList.rowHeight = UITableView.automaticDimension
        tblList.separatorStyle = .none
        tblList.backgroundColor = UIColor.init(hexString: "#F7F7FA")
        tabbarheight(tblList)
        tblList.register(UINib.init(nibName: "CeListTableViewCell", bundle: nil), forCellReuseIdentifier: "CeListTableViewCell")
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = CertifiSB.instantiateViewController(withIdentifier: "CertifiCateMainVC") as! CertifiCateMainVC
        if SE_flag {
            vc = CertifiSB.instantiateViewController(withIdentifier: "SE_CertifiCateMainVC") as! CertifiCateMainVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
        searchTextField.delegate = self
        searchTextField.returnKeyType = .done
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.cornerRadius = 0
        searchTextField.layer.borderWidth = 0.0
        searchTextField.setLeftPaddingPoints(30)
        searchTextField.placeholder = "검색"
    }
    
    func valueSetting(){
        NetworkManager.shared().get_CeList(cmpsid: CompanyInfo.sid, curkey: curkey, listcnt: listcnt) { (isSuccess, resnextKey, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                if serverData.count > 0 {
                    self.nextkey = resnextKey
                    if serverData.count >= self.listcnt {
                        if serverData.count > 0 {
                            for i in 0...serverData.count-1 {
                                self.lcList.append(serverData[i])
                            }
                            self.emptyAnual = 1
                        }
                        self.total = self.lcList.count
                    }else{
                        if serverData.count > 0 {
                            for i in 0...serverData.count-1 {
                                self.lcList.append(serverData[i])
                            }
                        }
                        self.emptyAnual = 0
                        self.total = self.lcList.count
                    }
                    self.tblList.reloadData()
                }else{
                    self.tblList.reloadData()
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    // MARK: - 검색
    @IBAction func SearchDidTap(_ sender: UIButton) {
        searchAction()
    }
    fileprivate func searchAction(){
        let searchStr =  searchTextField.text ?? ""
        lcList.removeAll()
        NetworkManager.shared().searchCe_List(cmpsid: CompanyInfo.sid, curkey: curkey, listcnt: listcnt, name: searchStr.urlEncoding()) { (isSuccess, resnextKey, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                
                self.nextkey = resnextKey
                if serverData.count > 0 {
                    for i in 0...serverData.count-1 {
                        self.lcList.append(serverData[i])
                    }
                    self.total = self.lcList.count
                    self.fillterData = self.lcList
                    self.tblList.reloadData()
                }
                
                if self.lcList.count > 0 {
                    self.vwNoApr.isHidden = true
                }else {
                    self.vwNoApr.isHidden = false
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
}

// MARK:  - UITableViewDelegate , UITableViewDataSource
extension Ce_ListVC: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchText != "" {
            if self.fillterData.count == 0 {
                self.vwNoApr.isHidden = false
            }else {
                self.vwNoApr.isHidden = true
            }
            return fillterData.count
        }else{
            if self.lcList.count == 0 {
                self.vwNoApr.isHidden = false
            }else {
                self.vwNoApr.isHidden = true
            }
            return lcList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CeListTableViewCell", for: indexPath) as? CeListTableViewCell {
            cell.selectionStyle = .none
            var lcListIndexPath: CeList = CeList()
            if self.searchText != "" {
                lcListIndexPath = fillterData[indexPath.row]
            }else{
                lcListIndexPath = lcList[indexPath.row]
            }
            
            var nameLabelText = ""
            if (lcListIndexPath.isuspot != ""){
                nameLabelText = "발급자 : \(lcListIndexPath.isuname)(\(lcListIndexPath.isuspot))"
            }else{
                nameLabelText = "발급자 : \(lcListIndexPath.isuname)"
            }
            cell.lblSpot.text = nameLabelText
            
            var titleText = ""
            if lcListIndexPath.empsid > 0 {
                //직원
                if lcListIndexPath.spot != "" {
                    titleText = "\(lcListIndexPath.name) (\(lcListIndexPath.spot))"
                }else{
                    titleText = "\(lcListIndexPath.name)"
                }
            }else{
                //미직원
                if lcListIndexPath.phonenum != "" {
                    titleText = "\(lcListIndexPath.name) (\(lcListIndexPath.phonenum.pretty()))"
                }else{
                    titleText = "\(lcListIndexPath.name)"
                } 
                
            }
            cell.lblTitle.text = titleText
            var statusStr = ""
            if (lcListIndexPath.status == 2) {
                statusStr = "회사발급"
            }else if (lcListIndexPath.status == 3) {
                statusStr = "근로자 직접발급"
            }
            cell.lblDate.text = "발급 : \(setJoinDate2(timeStamp:lcListIndexPath.issuedt))"
            cell.lblStatus.text = "발급완료"
            cell.btnSel.tag = indexPath.row
            cell.btnSel.addTarget(self, action: #selector(selectedPerson(_:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func selectedPerson(_ sender: UIButton){
        var lcListIndexPath: CeList = CeList()
        
        if self.searchText != "" {
            lcListIndexPath = fillterData[sender.tag]
        }else{
            lcListIndexPath = lcList[sender.tag]
        }
        
        if SE_flag {
            if let navivc = CertifiSB.instantiateViewController(withIdentifier: "SE_CareerNavi") as? UINavigationController {
                if let vc = navivc.topViewController as? CertificatePrintMain {
                    vc.selInfo = lcListIndexPath
                    vc.format = 0
                }
                navivc.modalTransitionStyle = .crossDissolve
                navivc.modalPresentationStyle = .fullScreen
                self.present(navivc, animated: true, completion: nil)
            }
        }else{
            if let navivc = CertifiSB.instantiateViewController(withIdentifier: "CareerNavi") as? UINavigationController {
                if let vc = navivc.topViewController as? CertificatePrintMain {
                    vc.selInfo = lcListIndexPath
                    vc.format = 0
                }
                navivc.modalTransitionStyle = .crossDissolve
                navivc.modalPresentationStyle = .fullScreen
                self.present(navivc, animated: true, completion: nil)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableHeight = tblList.frame.height
        
        if offsetY + tableHeight > contentHeight + 50 {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    
    func beginBatchFetch() {
        fetchingMore = true
        
        if self.lcList.count > 0 {
            if self.lcList.count >= self.listcnt {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.curkey = self.nextkey
                    self.fetchingMore = false
                    if self.emptyAnual == 1 {
                        self.valueSetting()
                    }
                })
            }
        }
        
    }
}

// MARK: - UITextFieldDelegate
extension Ce_ListVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        searchAction()
        return true
    }
    
}
