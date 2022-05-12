//
//  CmpTtmListVC.swift
//  PinPle
//
//  Created by WRY_010 on 05/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmpTtmListVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwNoEmp: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    var tuple: [EmplyInfo] = []
    var selTuple: [EmplyInfo] = []
    
    var curkey: Int = 0
    var nextkey: Int = 0
    var listcnt: Int = 30
    var totalcnct: Int = 30
    
    var code: String = ""
    var fetchingMore: Bool = false
    var empsids: String = ""
    var selectedArray : [IndexPath] = [IndexPath]()
    
    // MARK: - IndicatorSetting
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    fileprivate func IndicatorSetting() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefs.setValue(6, forKey: "stage")
        btnSave.layer.cornerRadius = 6
        tblList.delegate = self
        tblList.dataSource = self
        
        lblCode.adjustsFontSizeToFitWidth = true
        
        //        tblList.allowsMultipleSelectionDuringEditing = true
        //        tblList.allowsSelection = false
        //        tblList.setEditing(true, animated: false)
        tblList.separatorStyle = .none
        tblList.register(UINib.init(nibName: "FreeEmpListCellNew", bundle: nil), forCellReuseIdentifier: "FreeEmpListCellNew")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCode() {
            self.lblCode.text = self.code
            self.valueSetting()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = CmpCrtSB.instantiateViewController(withIdentifier: "RegMgrVC") as! RegMgrVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func codeCopy(_ sender: UIButton) {
        UIPasteboard.general.string = lblCode.text
        self.customAlertView("합류 코드를 복사 했습니다.\n 코드를 직원에게 공지하세요.")
    }
    
    @IBAction func listRefresh(_ sender: UIButton) {
        print("ListRefresh")
        curkey = 0
        tuple.removeAll()
        totalcnct = listcnt
        valueSetting()
        fetchingMore = false
        tblList.contentOffset = .zero
        let selectRow = self.tblList.indexPathsForSelectedRows
        tblList.reloadData()
        if selectRow != nil{
            for i in 0...selectRow!.count-1{
                self.tblList.selectRow(at: selectRow![i], animated: false, scrollPosition: .none)
            }
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        if let selectedRows = tblList.indexPathsForSelectedRows {
            let count = selectedRows.count - 1
            selTuple.removeAll()
            
            for i in 0...Int(count) {
                selTuple.append(tuple[selectedRows[i].row])
            }
  
            
            let vc = CmpCrtSB.instantiateViewController(withIdentifier: "CmpTtmListPopUp") as! CmpTtmListPopUp
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.tuple = selTuple
            self.present(vc, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "알림", message: "관리자를 선택하세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        let vc = CmpCrtSB.instantiateViewController(withIdentifier: "WTInfoVC") as! WTInfoVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    func valueSetting() {
        let cmpsid = CompanyInfo.sid
        IndicatorSetting() 
        NetworkManager.shared().JoinEmplist(cmpsid: cmpsid, curkey: curkey, listcnt: listcnt) { (isSuccess, error, resData, resNextkey) in
            if(isSuccess){
                guard let serverData = resData else { return }
                if serverData.count > 0 {
                    self.nextkey = resNextkey
                    if serverData.count > 0 {
                        for i in 0...serverData.count-1 {
                            self.tuple.append(serverData[i])
                        }
                        self.vwNoEmp.isHidden = true
                    }else{
                        self.vwNoEmp.isHidden = false
                    }
                    self.tblList.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                }else{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                }
                
            }else{
                self.customAlertView("다시 시도해 주세요.")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }
        }
    }
    
    func getCode(finished : @escaping ()->Void) {
        let cmpsid = CompanyInfo.sid
        
        NetworkManager.shared().getCmpJoincode(cmpsid: cmpsid) { (isSuccess, resCode) in
            if(isSuccess){
                let base64Encoded = resCode
                let decodedData = Data(base64Encoded: base64Encoded)!
                let decodedString = String(data: decodedData, encoding: .utf8)!
               
                self.code = decodedString
                
                finished()
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
            
        }
    }
    
    
    
}
//MARK:- UITableViewMethods
extension CmpTtmListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblList {
            if section == 0 {
                return tuple.count
            } else if section == 1 && fetchingMore {
                return 1
            }
            return 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CmpTTMListCell") as!  CmpTTMListCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeEmpListCellNew", for: indexPath) as! FreeEmpListCellNew
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            let data = tuple[indexPath.row]
            let enname = data.enname
            let name = data.name
            let profimg = data.profimg
            let spot = data.spot
            
//            if profimg.urlTrim() != "img_photo_default.png" {
//                cell.imgProfile.setImage(with: profimg)
//            }else{
//                cell.imgProfile.image = defaultImg
//            }
            
            cell.imgProfile.sd_setImage(with: URL(string: profimg), placeholderImage: UIImage(named: "no_picture"))
            
            cell.lblName.text = name
           if enname != "" {
               cell.lblEname.text = "(" + enname + ")"
           }else {
               cell.lblEname.text = ""
           }
            cell.lblSpot.text = spot
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            if self.tuple.count == self.totalcnct {
                cell.indicator.startAnimating()
            }else{
                let cellFrame = cell.contentView.frame
                cell.isHidden = true
                cell.contentView.frame.size = .init(width: cellFrame.width, height: 0)
            }
            return cell
        }
    }
  

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       _ = tableView.cellForRow(at: indexPath) as! FreeEmpListCellNew

       if(!selectedArray.contains(indexPath))
       {
           selectedArray.append(indexPath)
       }
       else
       {
           selectedArray.removeLast()
       }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tblList {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let tableHeight = tblList.frame.height
            
            if offsetY + tableHeight > contentHeight + 50 {
                
                if !fetchingMore {
                    beginBatchFetch()
                }
            }
        }
    }
    func beginBatchFetch() {
        fetchingMore = true 
        
        if self.tuple.count > 0 {
            if self.tuple.count >= self.listcnt {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.curkey = self.nextkey
                    self.fetchingMore = false
                    self.valueSetting()
                })
            }
        }
        
    }
    
}


 
