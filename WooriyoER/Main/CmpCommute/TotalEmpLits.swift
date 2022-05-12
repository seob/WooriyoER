//
//  TotalEmpLits.swift
//  PinPle
//
//  Created by seob on 2020/02/18.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class TotalEmpLits: UIViewController , NVActivityIndicatorViewable {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet weak var vwNoApr: UIView!
    @IBOutlet weak var tabbarCustomView: UIView! //하단 탭바뷰
    @IBOutlet weak var tabButtonPinpl: UIButton! //하단 탭바 핀플
    @IBOutlet weak var tabButtonCmt: UIButton! // 하단 탭바 출퇴근
    @IBOutlet weak var tabButtonAnnual: UIButton! // 하단 탭바 연차
    @IBOutlet weak var tabButtonApply: UIButton! // 하단 탭바 신청
    @IBOutlet weak var tabButtonMore: UIButton! // 하단 탭바 더보기
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var lblTem: UILabel! // 팀명
    
    var curkey = 0
    var nextkey = 0
    var total = 0
    var listcnt = 30
    
    var empTuple : [TotalAnualInfo] = []
    var totalArr : [TotalAnualInfo] = []
    var rmnDay = 0
    var rmnHour = 0
    var rmnMin = 0
    var fetchingMore = false
    
    var cmpsid: Int = 0
    var ttmsid: Int = -1
    var temsid: Int = -1
    var tname: String = ""
    
    var temselflag: Bool = false
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.rowHeight = UITableView.automaticDimension
        tblList.separatorStyle = .none
        tblList.backgroundColor = .clear
        tabbarheight(tblList)
        tblList.register(UINib.init(nibName: "TotalEmpListCell", bundle: nil), forCellReuseIdentifier: "TotalEmpListCell")
        tblList.register(UINib.init(nibName: "TotalLoadingCell", bundle: nil), forCellReuseIdentifier: "TotalLoadingCell")
        vwNoApr.isHidden = true
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViewData), name: .reloadTotalList, object: nil)
     }
    
    // MARK: reloadViewData
    @objc func reloadViewData(_ notification: Notification) {
        print("\n---------- [ temsid:\(temsid) , ttmsid :\(ttmsid) , user:\(userInfo.ttmsid) user2:\(userInfo.temsid)] ----------\n")
    }
    
  
    
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        curkey = 0
        fetchingMore = false
 
        
        cmpsid = userInfo.cmpsid
        
        if let cmt_popflag = prefs.value(forKey: "cmt_popflag") {
            temselflag = cmt_popflag as! Bool
        }
        //        let author = prefs.value(forKey: "author") as! Int
        let author = userInfo.author
        if temselflag {
            ttmsid = prefs.value(forKey: "cmt_ttmsid") as! Int
            temsid = prefs.value(forKey: "cmt_temsid") as! Int
            if let tmptname = prefs.value(forKey: "cmt_temname") as? String {
                tname  = tmptname
            } // 2020.01.20 seob
        }else {
            switch author {
            case 1, 2:
                tname = CompanyInfo.name
            case 3:
                ttmsid = prefs.value(forKey: "cmt_ttmsid") as! Int;
                temsid = prefs.value(forKey: "cmt_temsid") as! Int;
                tname = userInfo.ttmname
            case 4:
                ttmsid = prefs.value(forKey: "cmt_ttmsid") as! Int;
                temsid = prefs.value(forKey: "cmt_temsid") as! Int;
                tname = userInfo.temname
            default:
                tname = CompanyInfo.name
                break;
            }
        }
        lblTem.text = tname
        getTotalList()
         
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "AnlAprSetVC" {
            let vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlAprSetVC") as! AnlAprSetVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else if viewflag == "AplAprSetVC" {
            let vc = AplAprSB.instantiateViewController(withIdentifier: "AplAprSetVC") as! AplAprSetVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            var vc = UIViewController()
            if SE_flag {
                vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC") as! MainVC
            }else {
                vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    //MARK: - Tabbar
    @IBAction func pinplTab(_ sender: UIButton) {
        var vc = UIViewController()
        if SE_flag {
            vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC") as! MainVC
        }else {
            vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func cmtTab(_ sender: UIButton) {
        var vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
        if SE_flag {
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_CmtEmpList") as! CmtEmpList
        }else{
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func anlTab(_ sender: UIButton) {
        var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        if SE_flag {
            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
        }else{
            vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func aplTab(_ sender: UIButton) {
        var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
        if SE_flag {
            vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
        }else{
            vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
        }
        isTap = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func moreTab(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    
    func timeSet(_ time: Int) {
        rmnDay = time/(8*60)
        rmnHour = (time%(8*60))/60
        rmnMin = (time%(8*60))%(60)
        print(rmnDay, rmnHour, rmnMin)
        
    }
    
    
    
    func getTotalList() {
        NetworkManager.shared().totalEmpList(author: userInfo.author, cmpsid: cmpsid, ttmsid: ttmsid, temsid: temsid, curkey: curkey, listcnt: listcnt) { (isSuccess, resNextKey, resData) in
            if(isSuccess){
                guard let serverData = resData else { return self.tblList.reloadData() }
                print("\n---------- [ serverData : \(serverData.count) ] ----------\n")
                if serverData.count > 0 {
                    self.nextkey = resNextKey                    
                    
                    for i in 0...serverData.count-1 {
                        self.empTuple.append(serverData[i])
                    }
                    if self.empTuple.count > 0 {
                        self.vwNoApr.isHidden = true
                    }else {
                        self.vwNoApr.isHidden = false
                    }
                    self.total = self.empTuple.count
                    self.tblList.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                }else{
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                }
                if self.empTuple.count > 0 {
                    self.vwNoApr.isHidden = true
                }else {
                    self.vwNoApr.isHidden = false
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
                
            }
        }
        
    }
    
    // 팀선택
    @IBAction func selTem(_ sender: UIButton) {
        let vc = MainSB.instantiateViewController(withIdentifier: "TotalCmtEmpListPopUp") as! TotalCmtEmpListPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension TotalEmpLits: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
//            if (empTuple.count == 0){
//                vwNoApr.isHidden = false
//            }else{
//                vwNoApr.isHidden = true
//            }
            
            return empTuple.count
        }else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && self.empTuple.count == self.total {
            return 0
        }
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TotalEmpListCell", for: indexPath) as? TotalEmpListCell {
                
                let empListIndexPath = empTuple[indexPath.row]
                 
                cell.imgProfile.sd_setImage(with: URL(string: empListIndexPath.profimg), placeholderImage: UIImage(named: "no_picture"))
                
                if empListIndexPath.enname != "" {
                    cell.lblName.text = empListIndexPath.name + "(\(empListIndexPath.enname))"
                }else{
                    cell.lblName.text = empListIndexPath.name
                }
                
                cell.lblSpot.text = empListIndexPath.spot
                if (empListIndexPath.ttname != "" || empListIndexPath.ttname != "" ){
                    cell.lblTemName.text = "\(empListIndexPath.ttname) \(empListIndexPath.tname)"
                }else{
                    cell.lblTemName.text = "무소속"
                }
                if empListIndexPath.joindt == "1900-01-01" {
                    cell.lblType.text = "연차정보 미입력"
                    cell.lblremain.text = ""
                }else{
                    let joindt = setJoinDate(timeStamp: empListIndexPath.joindt)
                    cell.lblType.text = "\(joindt)(\(empListIndexPath.joinyear)년차)"
                    if CompanyInfo.stanual == 0 {
                        //회계연도
                        timeSet(empListIndexPath.fical)
                    }else{
                        //입사일자
                        timeSet(empListIndexPath.remain)
                    }
                     
                    cell.lblremain.text = "/ \(String(rmnDay))d \(String(rmnHour))h \(String(rmnMin))m"
                }
                
                
                cell.btnApr.tag = indexPath.row
                cell.btnApr.addTarget(self, action: #selector(selectCell(_:)), for: .touchUpInside)
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TotalLoadingCell", for: indexPath) as? TotalLoadingCell {
                if !fetchingMore {
                    if self.empTuple.count > 0 {
                        if self.empTuple.count >= self.listcnt {
                            cell.indicator.startAnimating()
                        }
                    }else{
                        let cellFrame = cell.contentView.frame
                        cell.isHidden = true
                        cell.contentView.frame.size = .init(width: cellFrame.width, height: 0)
                    }
                }else{
                    let cellFrame = cell.contentView.frame
                    cell.isHidden = true
                    cell.contentView.frame.size = .init(width: cellFrame.width, height: 0)
                }
                return cell
            }
        }
        
        
        return UITableViewCell()
    }
    
    @objc func selectCell(_ sender: UIButton) {
        
            if empTuple[sender.tag].joindt == "1900-01-01" {
                let vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpInfoVC") as! EmpInfoVC
                vc.viewflag2 =  "TotalEmpLits"
                vc.selempsid = empTuple[sender.tag].empsid
                vc.selname = empTuple[sender.tag].name
                vc.selspot = empTuple[sender.tag].spot
                vc.selmbrsid = empTuple[sender.tag].mbrsid
                SelEmpInfo.sid = empTuple[sender.tag].empsid
                SelEmpInfo.mbrsid = empTuple[sender.tag].mbrsid
                print("\n---------- [ selectCell empsid : \(empTuple[sender.tag].empsid) , mbrsid : \(empTuple[sender.tag].mbrsid) ] ----------\n")
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                if authCheckAdministrator(ttmsid , temsid) {
                    self.present(vc, animated: true, completion: nil)
                }else{
                    self.customAlertView("해당 팀 관리자가 아닙니다.")
                }
                
                
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TotalAnualaprListVC") as! TotalAnualaprListVC
                print("\n---------- [ ttmsid  : \(ttmsid) , temsid : \(temsid) , tname : \(tname)] ----------\n")
                vc.cmpsid = userInfo.cmpsid
                vc.empsid = empTuple[sender.tag].empsid
                vc.name = empTuple[sender.tag].name
                vc.remain = empTuple[sender.tag].remain
                vc.batch = empTuple[sender.tag].batch
                vc.tmptotalDiff = empTuple[sender.tag].batchdiff
                vc.fical = empTuple[sender.tag].fical
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                
                if authCheckAdministrator(ttmsid , temsid) {
                    self.present(vc, animated: true, completion: nil)
                }else{
                    self.customAlertView("해당 팀 관리자가 아닙니다.")
                }
            }
        
    }
    
    
    fileprivate func authCheckAdministrator(_ ttmsid: Int , _ temsid: Int)-> Bool{
        var blResult : Bool = false
        if userInfo.author <= 2 {
            blResult =  true
        }else {
            if ttmsid == userInfo.ttmsid  {
                blResult =  true
            }else {
                blResult =  false
            }
        }
        return blResult
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
        
        if self.empTuple.count > 0 { 
            if self.empTuple.count >= self.listcnt {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.curkey = self.nextkey
                    self.fetchingMore = false
                    self.getTotalList()
                })
            }
        }
        
    }
    
}
