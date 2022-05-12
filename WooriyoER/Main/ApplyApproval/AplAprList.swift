//
//  AplAprList.swift
//  PinPle
//
//  Created by WRY_010 on 2019/10/23.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AplAprList: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwNoApr: UIView!
    
    @IBOutlet weak var tabbarCustomView: UIView! //하단 탭바뷰
    @IBOutlet weak var tabButtonPinpl: UIButton! //하단 탭바 핀플
    @IBOutlet weak var tabButtonCmt: UIButton! // 하단 탭바 출퇴근
    @IBOutlet weak var tabButtonAnnual: UIButton! // 하단 탭바 연차
    @IBOutlet weak var tabButtonApply: UIButton! // 하단 탭바 신청
    @IBOutlet weak var tabButtonMore: UIButton! // 하단 탭바 더보기
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    
    var aplAprTuple: [(String, Int, String, String, String, String, Int, Int, String, Int, String, String, String, UIImage, Int, Int, String, Int)] = []
    var selTuple: [(String, Int, String, String, String, String, Int, Int, String, Int, String, String, String, UIImage, Int, Int, String, Int)] = []
    
    var ApplyArr:[ApplyListArr] = []
    var ApplyDetail = ApplyListArr()
    
    var curkey = 0
    var nextkey = 0
    var total = 0
    var tmpTotal = 0
    var listcnt = 30
    //    var totalcnct = 5
    
    var fetchingMore = false
    var aprflag = 0
    
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
        print("\n-----------------[ \(#function) ]---------------------\n")
        super .viewWillAppear(animated)
        
        aplAprTuple.removeAll()
        ApplyArr.removeAll()
        fetchingMore = false
        //        IndicatorSetting() //로딩
        curkey = 0
        valueSetting()
    }
    
    
    
    //MARK: - navigation bar button
    @IBAction func barButton(_ sender: UIButton) {
        let vc = AplAprSB.instantiateViewController(withIdentifier: "AplAprSetVC") as! AplAprSetVC
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
        print("\n-----------------[ \(#function) ]---------------------\n")
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(근로신청 결재,참조 리스트)
         Return  - 근로신청 결재,참조리스트
         Parameter
         EMPSID        직원번호(본인)
         CURKEY        페이징 키(첫 페이지는 0 또는 안넘김)
         LISTCNT        리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
         */
        
        //        let empsid = prefs.value(forKey: "empsid") as! Int
        let empsid = userInfo.empsid 
        NetworkManager.shared().applyList(empsid: empsid, curkey: curkey, listcnt: listcnt) { (isSuccess, resTotal, resNextKey, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                self.nextkey = resNextKey
                self.total = resTotal
                self.tmpTotal = serverData.count
                if serverData.count > 0 {
                    for i in 0...serverData.count-1 {
                        self.ApplyArr.append(serverData[i])
                    }
                }
                
                self.lblNavigationTitle.text = "신청 결재 \(self.total)건"
                if self.ApplyArr.count > 0 {
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
        
        //        selTuple.removeAll()
        //        selTuple.append(aplAprTuple[sender.tag])
        //
        //        let refflag = aplAprTuple[sender.tag].15
        //        let aprstatus = aplAprTuple[sender.tag].17
        
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
        vc.ApplyArr = self.ApplyDetail
        vc.aprflag = aprflag
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)        
    }
    
    
}
extension AplAprList: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return ApplyArr.count
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && self.ApplyArr.count == self.total {
            return 10
        }
        return 110
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AplAprCell") as!  AplAprCell
        if indexPath.section == 0 {
            let ApplyIndexPath  =   ApplyArr[indexPath.row]
            let aprdt           =   ApplyIndexPath.aprdt
            let type            =   ApplyIndexPath.type
            let diffmin         =   ApplyIndexPath.diffmin
            let spot            =   ApplyIndexPath.spot
            let name            =   ApplyIndexPath.name
            let tname           =   ApplyIndexPath.tname
            let profimg         =   ApplyIndexPath.profimg
            let refflag         =   ApplyIndexPath.refflag
            let enname          =   ApplyIndexPath.enname
            let aprstatus       =   ApplyIndexPath.aprstatus
            
            //신청종류 코드(0.출장 1.야간근로 2.휴일근로)
            var typeImg = UIImage()
            switch type {
            case 0:
                typeImg = UIImage.init(named: "r_229d93")!;
                cell.lblType.text = "출장";
                cell.lblType.textColor = .init(hexString: "#229D93");
            case 1:
                typeImg = UIImage.init(named: "r_ea6f45")!;
                cell.lblType.text = "연장";
                cell.lblType.textColor = .init(hexString: "#EA6F45");
            case 2:
                typeImg = UIImage.init(named: "r_ea6f45")!;
                cell.lblType.text = "특근";
                cell.lblType.textColor = .init(hexString: "#EA6F45");
            default:
                break;
            }
            
            let hour = (diffmin%(8*60))/60
            let min = (diffmin%(8*60))%60
            
            var timeStr = ""
            
            if diffmin >= 480 {
                timeStr = "1d "
            }else {
                if hour > 0 {
                    timeStr = String(hour) + "h "
                }
                if min > 0 {
                    timeStr = timeStr + String(min) + "m"
                }
            }
            
            var refflagStr = ""
            //            if aprstatus == 1 {
            //                aprflag = 2
            //                refflagStr = "보류"
            //                cell.imgBtn.image = UIImage.init(named: "gray_btn_50")!;
            //            }else if refflag == 0 {
            //                aprflag = 0
            //                refflagStr = "결재"
            //                cell.imgBtn.image = UIImage.init(named: "line_btn_50")!;
            //            }else if refflag == 1 {
            //                aprflag = 1
            //                refflagStr = "참조"
            //                cell.imgBtn.image = UIImage.init(named: "gray_btn_50")!;
            //            }
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
            
            let str = aprdt.replacingOccurrences(of: "-", with: ".")
            let start = str.index(str.startIndex, offsetBy: 2)
            let end = str.index(before: str.endIndex)
            let aprdtStr = str[start...end]
            
            
            cell.lblContent.text = " / " + timeStr + " / " + aprdtStr + setWeek(aprdt)
            cell.lblBtnType.text = refflagStr
            
            cell.btnApr.tag = indexPath.row
            cell.btnApr.addTarget(self, action: #selector(self.anlApr(_:)), for: .touchUpInside)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AplLoadingCell", for: indexPath) as! AplLoadingCell
            
            if self.tmpTotal > 1 {
                if (self.ApplyArr.count != self.total) {
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
        print("beginBatchFetch!")
        tblList.reloadSections(IndexSet(integer: 1), with: .none)
        //        if self.aplAprTuple.count == self.totalcnct {
        if self.ApplyArr.count != self.total {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.curkey = self.nextkey
                print(self.nextkey)
                self.fetchingMore = false
                if self.tmpTotal > 1 {
                    self.valueSetting()
                }
            })
        }
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
