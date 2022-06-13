//
//  AnlMainList.swift
//  PinPle
//
//  Created by seob on 2020/07/23.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class AnlMainList: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet weak var btnWork: UIButton!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var btnNotWork: UIButton!
    @IBOutlet weak var lblNotWork: UILabel!
    @IBOutlet weak var vwNoApr: UIView!
    @IBOutlet weak var lblNoTitle: UILabel!
    
    @IBOutlet weak var tabbarCustomView: UIView! //하단 탭바뷰
    @IBOutlet weak var tabButtonPinpl: UIButton! //하단 탭바 핀플
    @IBOutlet weak var tabButtonCmt: UIButton! // 하단 탭바 출퇴근
    @IBOutlet weak var tabButtonAnnual: UIButton! // 하단 탭바 연차
    @IBOutlet weak var tabButtonApply: UIButton! // 하단 탭바 신청
    @IBOutlet weak var tabButtonMore: UIButton! // 하단 탭바 더보기
    
    var anlAprArr: [AnualListArr] = [] //연차
    var ApplyArr: [ApplyListArr] = [] // 신청
    
    var Anualnextkey = 0
    var Applynextkey = 0
    var listcnt = 30
    var total = 0
    var Applytotal = 0
    var Anualcurkey = 0
    var Applycurkey = 0
    var emptyApply = 1
    var emptyAnual = 1
    var fetchingMore = false
    var clickFlag = true
    var aprflag = 0
    var anAprDetail = AnualListArr()
    var ApplyDetail = ApplyListArr()
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnWork.backgroundColor = EnterpriseColor.btnColor
        lblWork.textColor = EnterpriseColor.lblColor
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
//        btnWork.setImage(UIImage(named: "btn_tab_select"), for: .selected)
//        btnWork.setImage(UIImage(named: "btn_tab_normal"), for: .normal)
//        btnNotWork.setImage(UIImage(named: "btn_tab_select"), for: .selected)
//        btnNotWork.setImage(UIImage(named: "btn_tab_normal"), for: .normal)
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        tblList.backgroundColor = UIColor.init(hexString: "#F7F7FA")
        tblList.register(UINib.init(nibName: "AplAprCell2", bundle: nil), forCellReuseIdentifier: "AplAprCell2") //신청결재 cell
        tblList.register(UINib.init(nibName: "AplAprCell_comfrim", bundle: nil), forCellReuseIdentifier: "AplAprCell_comfrim") // 신청 결재완료 cell
        
        tblList.register(UINib.init(nibName: "AnlAprCell", bundle: nil), forCellReuseIdentifier: "AnlAprCell") // 연차 결재 cell
        tblList.register(UINib.init(nibName: "AnlAprCell_comfrim", bundle: nil), forCellReuseIdentifier: "AnlAprCell_comfrim") // 연차 결재완료 cell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
        //푸시 왔을때
        switch notitype {
            case "20", "21": //연차
                clickFlag = true
                btnWork.isSelected = true
                btnNotWork.isSelected = false
                
                lblWork.textColor = EnterpriseColor.lblColor
                lblNotWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
                anlAprArr.removeAll()
                getAnualList()
                notitype = ""
            case "22", "23", "24", "25" : //신청
                clickFlag = false
                ApplyArr.removeAll()
                getApplyList()
                btnWork.isSelected = false
                btnNotWork.isSelected = true
                notitype = ""
                
                lblWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
            lblNotWork.textColor = EnterpriseColor.lblColor
            default:
                clickFlag = true
                anlAprArr.removeAll()
                getAnualList()
                btnWork.isSelected = true
                btnNotWork.isSelected = false
                notitype = ""
                lblWork.textColor = EnterpriseColor.lblColor
                lblNotWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        }
        
        
    }
    
    // 연차 & 신청 카운트 갱신때문에 호출. 2020.07.24
    func valueSetting() {
        NetworkManager.shared().GetMain(empsid: userInfo.empsid , auth: userInfo.author, cmpsid: userInfo.cmpsid, ttmsid: userInfo.ttmsid, temsid: userInfo.temsid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                self.lblNavigationTitle.text = "결재 대기 \(serverData.anualaprcnt + serverData.aprtripcnt + serverData.apraddcnt)건"
                self.lblWork.text = "연차 결재 (\(serverData.anualaprcnt))"
                self.lblNotWork.text = "신청 결재 (\(serverData.aprtripcnt + serverData.apraddcnt))"
                
            }else{
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
        }
    }
    
    // 연차내역 리스트
    @IBAction func offShow(_ sender: UIButton) {
        Anualcurkey = 0
        anlAprArr.removeAll()
        getAnualList()
        clickFlag = true
        btnWork.isSelected = true
        btnNotWork.isSelected = false
        valueSetting()
        lblWork.textColor = EnterpriseColor.lblColor
        lblNotWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        btnWork.backgroundColor = EnterpriseColor.btnColor
        btnNotWork.backgroundColor = UIColor.rgb(r: 247, g: 247, b: 250)
        print("\n---------- [ anlAprArr : \(anlAprArr.count) ] ----------\n")
        if anlAprArr.count == 0 {
            vwNoApr.isHidden = false
            self.lblNoTitle.text = "연차 결재 건이 없습니다."
        }else {
            vwNoApr.isHidden = true
            
        }
    }
    
    // 신청내역 리스트
    @IBAction func onShow(_ sender: UIButton) {
        Applycurkey = 0
        ApplyArr.removeAll()
        getApplyList()
        clickFlag = false
        btnWork.isSelected = false
        btnNotWork.isSelected = true
        valueSetting()
        
        lblWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        lblNotWork.textColor = EnterpriseColor.lblColor
        btnNotWork.backgroundColor = EnterpriseColor.btnColor
        btnWork.backgroundColor = UIColor.rgb(r: 247, g: 247, b: 250)
        if ApplyArr.count == 0 {
            vwNoApr.isHidden = false
            self.lblNoTitle.text = "신청 결재 건이 없습니다."
        }else {
            vwNoApr.isHidden = true
            
        }
        
    }
    
    //MARK: - navigation bar button
    @IBAction func barButton(_ sender: UIButton) {
        let vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlAprSetVC") as! AnlAprSetVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
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
    
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    //연차 리스트
    fileprivate func getAnualList(){
        let empsid = userInfo.empsid
        IndicatorSetting()
        NetworkManager.shared().anualaprList_New(empsid: empsid, curkey: Anualcurkey, listcnt: listcnt) { (isSuccess,  resData) in
            if(isSuccess){
                guard let serverData = resData else { return self.tblList.reloadData() }
                print("\n---------- [ sever : \(serverData.count) ] ----------\n")
                if serverData.count > 0 {
                    if serverData.count >= self.listcnt {
                        if serverData.count > 0 {
                            for i in 0...serverData.count-1 {
                                self.anlAprArr.append(serverData[i])
                            }
                            self.emptyAnual = 1
                        }
                        self.total = self.anlAprArr.count
                    }else{
                        if serverData.count > 0 {
                            for i in 0...serverData.count-1 {
                                self.anlAprArr.append(serverData[i])
                            }
                        }
                        self.emptyAnual = 0
                        self.total = self.anlAprArr.count
                    }
                    
                    
                    
                    self.tblList.reloadData()
                }else{
                    self.tblList.reloadData()
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
                
            }else{
                self.customAlertView("다시 시도해 주세요.")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }
        }
    }
    
    //신청 리스트
    fileprivate func getApplyList(){
        let empsid = userInfo.empsid
        NetworkManager.shared().applyList_New(empsid: empsid, curkey: Applycurkey, listcnt: listcnt) { (isSuccess,  resData) in
            if(isSuccess){
                guard let serverData = resData else { return }

                if serverData.count > 0 {
                    for i in 0...serverData.count-1 {
                        self.ApplyArr.append(serverData[i])
                    }
                }
                
                
                if self.ApplyArr.count > 0 {
                    self.vwNoApr.isHidden = true
                }else {
                    self.vwNoApr.isHidden = false
                    self.lblNoTitle.text = "신청 결재 건이 없습니다."
                }
                self.tblList.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate , UITableViewDataSource
extension AnlMainList: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if clickFlag{
            if anlAprArr.count == 0 {
                vwNoApr.isHidden = false
            }else {
                vwNoApr.isHidden = true
                
            }
            return anlAprArr.count
        }else{
            if ApplyArr.count == 0 {
                vwNoApr.isHidden = false
                
            }else {
                vwNoApr.isHidden = true
                
            }
            return ApplyArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if clickFlag{
            //연차
            let anlAprIndexPath  = anlAprArr[indexPath.row]
            let complateType = anlAprIndexPath.complete // 2021.01.25 추가 0 : 미결재 , 1: 완료
            
            if complateType == 0 {  // 미결재
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnlAprCell") as!  AnlAprCell
                cell.bindData(data: anlAprIndexPath)
                cell.btnApr.tag = indexPath.row
                cell.btnApr.addTarget(self, action: #selector(self.anlApr(_:)), for: .touchUpInside)
                return cell
            }else{ // 결재완료
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnlAprCell_comfrim") as!  AnlAprCell_comfrim
                cell.bindData(data: anlAprIndexPath)
                cell.btnApr.isEnabled = false
                return cell
            }
            
        }else{
            //신청
            let ApplyIndexPath  =   ApplyArr[indexPath.row]
            let complateType    = ApplyIndexPath.complete // 2021.01.25 추가 0 : 미결재 , 1: 완료
            
            if complateType == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AplAprCell2", for: indexPath) as! AplAprCell2
                cell.bindData(data: ApplyIndexPath)
                cell.btnApr.tag = indexPath.row
                cell.btnApr.addTarget(self, action: #selector(self.applyApr(_:)), for: .touchUpInside)
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AplAprCell_comfrim", for: indexPath) as! AplAprCell_comfrim
                cell.bindData(data: ApplyIndexPath)
                cell.btnApr.tag = indexPath.row
                cell.btnApr.addTarget(self, action: #selector(self.applyApr(_:)), for: .touchUpInside)
                
                return cell
            }

            
        }
        
        return UITableViewCell()
        
    }
    
    @objc func anlApr(_ sender: UIButton) {
        let refflag = anlAprArr[sender.tag].refflag
        let aprstatus = anlAprArr[sender.tag].aprstatus
        
        if refflag == 0 {
            if aprstatus == 1 {
                aprflag = 2
            }else {
                aprflag = 0
            }
        }else if refflag == 1 {
            aprflag = 1
        }
        
        anAprDetail = anlAprArr[sender.tag]
        
        
        if anlAprArr[sender.tag].anualaprsub.count > 0 { //멀티
            var vc = AnlAprSB.instantiateViewController(withIdentifier: "ProcAnlAprMultiVC") as! ProcAnlAprMultiVC
            if SE_flag {
                vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_ProcAnlAprMultiVC") as! ProcAnlAprMultiVC
            }else{
                vc = AnlAprSB.instantiateViewController(withIdentifier: "ProcAnlAprMultiVC") as! ProcAnlAprMultiVC
            }
            
            
            AnlMultiArr.removeAll()
            for (_ , key) in anlAprArr[sender.tag].anualaprsub.enumerated() {
                AnlMultiArr.append(MultiSelectedDate.init(key.subaprdt, key.subtype, key.subddctn, key.subwd, key.subsid))
            }
            
            
            SelDdcnt = anAprDetail.ddctn
            vc.anlAprArr = self.anAprDetail
            vc.aprflag = aprflag
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: false, completion: nil)
        }else{ //기존
            var vc = AnlAprSB.instantiateViewController(withIdentifier: "ProcAnlAprVC") as! ProcAnlAprVC
            if SE_flag {
                vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_ProcAnlAprVC") as! ProcAnlAprVC
            }else{
                vc = AnlAprSB.instantiateViewController(withIdentifier: "ProcAnlAprVC") as! ProcAnlAprVC
            }
            
            print("\n---------- [ ddctn : \(anAprDetail.ddctn) ] ----------\n")
            SelDdcnt = anAprDetail.ddctn
            vc.anlAprArr = self.anAprDetail
            vc.aprflag = aprflag
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @objc func applyApr(_ sender: UIButton) {
        let refflag = ApplyArr[sender.tag].refflag
        let aprstatus = ApplyArr[sender.tag].aprstatus
        
        if refflag == 0 {
            if aprstatus == 1 {
                aprflag = 2
            }else {
                aprflag = 0
            }
        }else if refflag == 1 {
            aprflag = 1
        }
        
        ApplyDetail = ApplyArr[sender.tag]
        
        var vc = AplAprSB.instantiateViewController(withIdentifier: "ProcAplAprVC") as! ProcAplAprVC
        if SE_flag {
            vc = AplAprSB.instantiateViewController(withIdentifier: "SE_ProcAplAprVC") as! ProcAplAprVC
        }else{
            vc = AplAprSB.instantiateViewController(withIdentifier: "ProcAplAprVC") as! ProcAplAprVC
        }
        
        print("\n---------- [ ddctn : \(anAprDetail.ddctn) ] ----------\n")
        SelDdcnt = anAprDetail.ddctn
        vc.ApplyArr = ApplyDetail
        vc.aprflag = aprflag
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
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
//
//        if self.clickFlag{
//            if self.anlAprArr.count > 0 {
//                if self.anlAprArr.count >= self.listcnt {
//                    print("\n---------- [ self.emptyAnual : \(self.emptyAnual) ] ----------\n")
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                        self.Anualcurkey = self.Anualnextkey
//                        self.fetchingMore = false
//                        if self.emptyAnual == 1 {
//                            self.getAnualList()
//                        }
//
//                    })
//                }
//            }
//        }else{
//            if self.ApplyArr.count > 0 {
//                if self.ApplyArr.count >= self.listcnt {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                        self.Applycurkey = self.Applynextkey
//                        self.fetchingMore = false
//                        if self.emptyApply == 1{
//                            self.getApplyList()
//                        }
//
//                    })
//                }
//            }
//
//        }
//
    }
    
    func setWeek(_ str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: str)
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday], from: date!)
        var week = ""
        
        switch comps.weekday {
            case 1:
                week = "일";
            case 2:
                week = "월";
            case 3:
                week = "화";
            case 4:
                week = "수";
            case 5:
                week = "목";
            case 6:
                week = "금";
            case 7:
                week = "토";
            default:
                break;
        }
        
        return "(" + week + ")"
    }
    
    
}
