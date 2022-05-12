//
//  Lc_ListVC.swift
//  PinPle
//
//  Created by seob on 2020/06/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Lc_ListVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var vwNoApr: UIView!
     
    @IBOutlet weak var searchTextField: UITextField!
    var lcList : [LcEmpInfo] = []
    var fillterData : [LcEmpInfo] = []
    var searchText : String = ""
    var curkey = ""
    var listcnt = 30
    var total = 0
    var tmpTotal = 0
    var nextkey = ""
    var fetchingMore = false
    var emptyAnual = 1
    var isEditSearch: Bool = false
    
    @IBAction func SearchDidTap(_ sender: UIButton) {
        searchAction()
    }
    fileprivate func searchAction(){
        let searchStr =  searchTextField.text ?? ""
         lcList.removeAll()
         NetworkManager.shared().searchLc_List(cmpsid: userInfo.cmpsid, curkey: curkey, listcnt: listcnt, name: searchStr.urlEncoding()) { (isSuccess, resnextKey, resData) in
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
        tblList.register(UINib.init(nibName: "LcListTableViewCell", bundle: nil), forCellReuseIdentifier: "LcListTableViewCell")
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
        if SE_flag {
            vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        curkey = ""
        valueSetting()
        searchTextField.delegate = self
        searchTextField.returnKeyType = .done
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.cornerRadius = 6
        searchTextField.layer.borderWidth = 0.0
        searchTextField.setLeftPaddingPoints(15)
        searchTextField.placeholder = "검색"
    }
    
    func valueSetting(){
       // lcList.removeAll()
        NetworkManager.shared().getLc_List(cmpsid: userInfo.cmpsid, curkey: curkey, listcnt: listcnt) { (isSuccess, resnextKey, resData) in
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
}

// MARK:  - UITableViewDelegate , UITableViewDataSource
extension Lc_ListVC: UITableViewDataSource , UITableViewDelegate{
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LcListTableViewCell", for: indexPath) as? LcListTableViewCell {
            cell.selectionStyle = .none
            var lcListIndexPath: LcEmpInfo = LcEmpInfo()
            if self.searchText != "" {
                lcListIndexPath = fillterData[indexPath.row]
            }else{
                lcListIndexPath = lcList[indexPath.row]
            }
            //급여선택 0.월급 1.연봉 2.시급
            var slytypeStr = ""
            
            //계약서포맷 0.핀플근로계약서 1.표준근로계약서
            var formatStr = ""
            switch lcListIndexPath.format {
            case 0:
                formatStr = "핀플근로계약서"
            case 1:
                formatStr = "표준근로계약서"
            default:
                break
            }
            //고용형태 0.정규직 1.계약직 2.수습직
            
            var formStr = ""
            var nameLabelText = ""
            if (lcListIndexPath.format == 0){ //핀플
                switch lcListIndexPath.form {
                case 0:
                    formStr = "정규직"
                case 1:
                    formStr = "계약직"
                case 2:
                    formStr = "수습"
                default:
                    break
                }
                
                switch lcListIndexPath.slytype {
                case 0:
                    slytypeStr = "월급"
                case 1:
                    slytypeStr = "연봉"
                case 2:
                    slytypeStr = "시급"
                default:
                    break
                }
               nameLabelText =  "\(formStr) | \(slytypeStr) | \(formatStr)"
            }else{ //표준
                switch lcListIndexPath.form {
                case 0:
                    formStr = "정규직,무기계약직"
                case 1:
                    formStr = "계약직"
                case 2:
                    formStr = "소정시간,아르바이트"
                case 3:
                    formStr = "근로일별,아르바이트"
                case 4:
                    formStr = "소정시간"
                case 5:
                    formStr = "근로일별"
                default:
                    break
                }
                switch lcListIndexPath.form {
                case 0:
                    slytypeStr = "월급"
                case 1:
                    slytypeStr = "월급"
                case 2:
                    slytypeStr = "시급"
                case 3:
                    slytypeStr = "시급"
                case 4:
                    slytypeStr = "일급"
                case 5:
                    slytypeStr = "일급"
                default:
                    break
                }
                nameLabelText =  "\(formStr) | \(slytypeStr) | \(formatStr)"
            }
            
            cell.lblSpot.text = nameLabelText
            
            var dateStr = "계약: \(setJoinDate2(timeStamp: lcListIndexPath.lcdt))"
            
            //계약상태 0.미입력 1.계약완료 2.서명요청 3.거절 4.작성중
            var statusStr = ""
            switch lcListIndexPath.status {
            case 0:
                statusStr = "미입력"
            case 1:
                statusStr = "계약완료"
                dateStr += "/ 서명: \(setJoinDate2(timeStamp:lcListIndexPath.sgntrdt))"
                cell.SealimageView.image = confirmSignimg
            case 2:
                statusStr = "서명요청"
                cell.SealimageView.image = waitSignimg
            case 3:
                statusStr = "거절"
            case 4:
                statusStr = "작성중"
                cell.SealimageView.image = waitSignimg
            default:
                cell.SealimageView.image = waitSignimg
                break
            }
            cell.lblDate.text = dateStr
 
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
            cell.lblStatus.text = statusStr
            cell.btnSel.tag = indexPath.row
            cell.btnSel.addTarget(self, action: #selector(selectedPerson(_:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func selectedPerson(_ sender: UIButton){
        var lcListIndexPath: LcEmpInfo = LcEmpInfo()
        
        if self.searchText != "" {
            lcListIndexPath = fillterData[sender.tag]
        }else{
            lcListIndexPath = lcList[sender.tag]
        }
        SelLcEmpInfo = lcListIndexPath
        
        if SE_flag {
            if let navivc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractNavi") as? UINavigationController {
                if let vc = navivc.topViewController as? ContractPrintMain {
                    vc.selInfo = lcListIndexPath
                }
                navivc.modalTransitionStyle = .crossDissolve
                navivc.modalPresentationStyle = .fullScreen
                self.present(navivc, animated: true, completion: nil)
            }
        }else{
            if let navivc = ContractSB.instantiateViewController(withIdentifier: "ContractNavi") as? UINavigationController {
                if let vc = navivc.topViewController as? ContractPrintMain {
                    vc.selInfo = lcListIndexPath
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
extension Lc_ListVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        searchAction()
        return true
    }
     
}
 
