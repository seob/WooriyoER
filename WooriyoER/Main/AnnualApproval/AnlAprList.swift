//
//  AnlAprList.swift
//  PinPle
//
//  Created by WRY_010 on 14/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AnlAprList: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwNoApr: UIView!
    
    @IBOutlet weak var lblNoTitle: UILabel!
    @IBOutlet weak var tabbarCustomView: UIView! //하단 탭바뷰
    @IBOutlet weak var tabButtonPinpl: UIButton! //하단 탭바 핀플
    @IBOutlet weak var tabButtonCmt: UIButton! // 하단 탭바 출퇴근
    @IBOutlet weak var tabButtonAnnual: UIButton! // 하단 탭바 연차
    @IBOutlet weak var tabButtonApply: UIButton! // 하단 탭바 신청
    @IBOutlet weak var tabButtonMore: UIButton! // 하단 탭바 더보기
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    
    var anlAprTuple: [(String, Int, String, String, String, String, Int, Int, String, Int, Int, String, String, UIImage, Int, Int, String, Int)] = []
    var selTuple: [(String, Int, String, String, String, String, Int, Int, String, Int, Int, String, String, UIImage, Int, Int, String, Int)] = []
    
    var anlAprArr:[AnualListArr] = []
    var anAprDetail = AnualListArr()
    var curkey = 0
    var nextkey = 0
    var total = 0
    var tmpTotal = 0
    var listcnt = 30
    //    var totalcnct = 5
    
    var fetchingMore = false
    var aprflag = 0
    var fetchingPosition = 0
    var ddctn: Int = 0
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwNoApr.isHidden = true
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        tblList.backgroundColor = UIColor.init(hexString: "#F7F7FA")
        tabbarheight(tblList)   
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
       
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        anlAprTuple.removeAll()
        anlAprArr.removeAll()
        fetchingMore = false
        
        curkey = 0
//        IndicatorSetting() //로딩
        valueSetting()
        
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
    func valueSetting() {
        /*
         Pinpl Android SmartPhone APP으로부터 요청받은 데이터 처리(연차신청 결재,참조 리스트)
         Return  - 연차신청 결재,참조리스트
         Parameter
         EMPSID        직원번호(본인)
         CURKEY        페이징 키(첫 페이지는 0 또는 안넘김)
         LISTCNT        리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
         */
        //        let empsid = prefs.value(forKey: "empsid") as! Int
        
        let empsid = userInfo.empsid
        print("AnlAprList : 78 empsid = ", empsid) 
        
        NetworkManager.shared().anualaprList(empsid: empsid, curkey: curkey, listcnt: listcnt) { (isSuccess, resTotal, resNextKey, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                self.nextkey = resNextKey
                self.total = resTotal
                self.tmpTotal = serverData.count
                if serverData.count > 0 {
                    for i in 0...serverData.count-1 {
                        self.anlAprArr.append(serverData[i])
                    }
                }
                self.lblNavigationTitle.text = "연차 결재 \(self.total)건"
                
                if self.anlAprArr.count > 0 {
                    self.vwNoApr.isHidden = true
                }else {
                    self.vwNoApr.isHidden = false
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
}

extension AnlAprList: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return anlAprArr.count
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && self.anlAprArr.count == self.total {
            return 10
        }
        return 110
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnlAprCell") as!  AnlAprCell
        if indexPath.section == 0 {
            let anlAprIndexPath  = anlAprArr[indexPath.row]
            let type    =   anlAprIndexPath.type
            let diffmin =   anlAprIndexPath.diffmin
            let spot    =   anlAprIndexPath.spot
            let ddctn   =   anlAprIndexPath.ddctn
            let name    =   anlAprIndexPath.name
            let tname   =   anlAprIndexPath.tname
            let profimg =   anlAprIndexPath.profimg
            let refflag =   anlAprIndexPath.refflag
            let enname  =   anlAprIndexPath.enname
            let aprstatus = anlAprIndexPath.aprstatus
            
            //연차종류코드(0.연차 1.오전반차 2.오후반차 3.조퇴 4.외출 5.병가 6.공가 7.경조 8.교육훈련 9.포상 10.공민권 11.생리)
            var typeImg = UIImage()
            if anlAprIndexPath.anualaprsub.count > 0 {
                typeImg = UIImage.init(named: "r_45a7cb")!;
                cell.lblType.text = "일괄연차";
                cell.lblType.textColor = .init(hexString: "#45A7CD");
            }else{
                switch type {
                case 0:
                    typeImg = UIImage.init(named: "r_45a7cb")!;
                    cell.lblType.text = "연차";
                    cell.lblType.textColor = .init(hexString: "#45A7CD");
                case 1:
                    typeImg = UIImage.init(named: "r_am_45a7cb")!;
                    cell.lblType.text = "오전반차";
                    cell.lblType.textColor = .init(hexString: "#45A7CD");
                case 2:
                    typeImg = UIImage.init(named: "r_pm_45a7cb")!;
                    cell.lblType.text = "오후반차";
                    cell.lblType.textColor = .init(hexString: "#45A7CD");
                case 3:
                    typeImg = UIImage.init(named: "r_6849af")!;
                    cell.lblType.text = "조퇴";
                    cell.lblType.textColor = .init(hexString: "#6849AF");
                case 4:
                    typeImg = UIImage.init(named: "r_6849af")!;
                    cell.lblType.text = "외출";
                    cell.lblType.textColor = .init(hexString: "#6849AF");
                case 5:
                    typeImg = UIImage.init(named: "r_grey")!;
                    cell.lblType.text = "병가";
                    cell.lblType.textColor = .gray;
                case 6:
                    typeImg = UIImage.init(named: "r_384dad")!;
                    cell.lblType.text = "공가";
                    cell.lblType.textColor = .init(hexString: "#384DAD");
                case 7:
                    typeImg = UIImage.init(named: "r_384dad")!;
                    cell.lblType.text = "경조사";
                    cell.lblType.textColor = .init(hexString: "#384DAD");
                case 8:
                    typeImg = UIImage.init(named: "r_384dad")!;
                    cell.lblType.text = "교육/훈련";
                    cell.lblType.textColor = .init(hexString: "#384DAD");
                case 9:
                    typeImg = UIImage.init(named: "r_45a7cb")!;
                    cell.lblType.text = "포상휴가";
                    cell.lblType.textColor = .init(hexString: "#45A7CD");
                case 10:
                    typeImg = UIImage.init(named: "r_384dad")!;
                    cell.lblType.text = "공민권";
                    cell.lblType.textColor = .init(hexString: "#384DAD");
                case 11:
                    typeImg = UIImage.init(named: "r_eb5e89")!;
                    cell.lblType.text = "생리휴가";
                    cell.lblType.textColor = .init(hexString: "#EB5E89");
                default:
                    break;
                }
            }

            
            let hour = (diffmin%(8*60))/60
            let min = (diffmin%(8*60))%60
            
            var timeStr = ""
            
            // schdl 여부에 따른 오전반차 오후반차 인경우 고정 4h - 2020.03.24 osan
            if diffmin >= 480 {
                timeStr = "1d "
            }else {
                switch (type, moreCmpInfo.schdl) {
                case (0, 0), (0, 1): // 연차
                    timeStr = "1d"
                case (1, 1) , (2, 1) : //오전 오후 반차
                    timeStr =  "4h"
                default:
                    if hour > 0 {
                        timeStr = String(hour) + "h "
                    }
                    if min > 0 {
                        timeStr = timeStr + String(min) + "m"
                    }
                }
            }
            
            var ddctnStr = ""
            if ddctn == 0 {
                ddctnStr = "미차감"
            }else {
                ddctnStr = "차감"
            }
            var refflagStr = ""
             
            if refflag == 0 { // 결재자
                switch aprstatus {
                case 1:
                    aprflag = 2
                    refflagStr = "보류"
                    cell.imgBtn.image = UIImage.init(named: "line_btn_50")!;
                default:
                    aprflag = 0
                    refflagStr = "결재"
                    cell.imgBtn.image = UIImage.init(named: "line_btn_50")!;
                }
            }else{ //참조자
                aprflag = 1
                refflagStr = "참조"
                cell.imgBtn.image = UIImage.init(named: "gray_btn_50")!;
            }
            
            
//            let defaultProfimg = UIImage(named: "logo_pre")
//            if profimg.urlTrim() != "img_photo_default.png" {
//                cell.imgProfile.setImage(with: profimg)
//            }else{
//                cell.imgProfile.image = defaultProfimg
//            }
            
            cell.imgProfile.sd_setImage(with: URL(string: profimg), placeholderImage: UIImage(named: "no_picture"))
            
            cell.imgType.image = typeImg
            cell.lblSpot.text = spot
            
            var nameStr = name
            if enname != "" {
                nameStr += "(" + enname + ")"
            }
            
            cell.lblName.text = nameStr
            cell.lblTemName.text = tname
            // 멀티 신청 시 2020.04.02 seob
            if anlAprArr[indexPath.row].anualaprsub.count > 0 {
                var batchdiff = 0 // h
                var remainder = 0 // m
                var multiStr = ""
                if anlAprArr[indexPath.row].batchdiff > 0 {
                    batchdiff = (anlAprArr[indexPath.row].batchdiff / 8)
                    remainder = (anlAprArr[indexPath.row].batchdiff % 8)
                }
                
                if batchdiff > 0 && remainder > 0 {
                    multiStr = "\(batchdiff)d \(remainder)h"
                }else if batchdiff > 0 && remainder == 0 {
                    multiStr = "\(batchdiff)d"
                }else if batchdiff == 0 && remainder > 0 {
                    multiStr = "\(remainder)h"
                }
                cell.lblContent.text = " / " + multiStr 
            }else{
                cell.lblContent.text = " / " + timeStr + " / " + ddctnStr
            }
            
            cell.lblBtnType.text = refflagStr
            
            cell.btnApr.tag = indexPath.row
            cell.btnApr.addTarget(self, action: #selector(self.anlApr(_:)), for: .touchUpInside)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnlLoadingCell", for: indexPath) as! AnlLoadingCell
            
            if self.tmpTotal > 1 {
                if (self.anlAprArr.count != self.total) {
                    cell.indicator.startAnimating()
                    cell.indicator.isHidden = false
                }else{
                    cell.indicator.stopAnimating()
                    cell.indicator.isHidden = true
                }
            }else{
                cell.isHidden = true
            }
            return cell
            
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
        tblList.reloadSections(IndexSet(integer: 1), with: .none)
        if (self.anlAprArr.count != self.total){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.curkey = self.nextkey
                self.fetchingMore = false
                if self.tmpTotal > 1 {
                    self.valueSetting()
                }
            })
        }
    }
}

