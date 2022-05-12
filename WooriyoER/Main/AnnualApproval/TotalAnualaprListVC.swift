//
//  TotalAnualaprListVC.swift
//  PinPle
//
//  Created by seob on 2020/02/18.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class TotalAnualaprListVC: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet weak var vwNoApr: UIView!
    @IBOutlet weak var lblTitleLabel: UILabel!
    @IBOutlet private weak var lblDayTitle: UILabel!
    @IBOutlet weak var lblAnlDay: UILabel!
    @IBOutlet weak var noResultmsg: UILabel!
    
    @IBOutlet weak var btnWork: UIButton!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var btnNotWork: UIButton!
    @IBOutlet weak var lblNotWork: UILabel!
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    var anlaprTuple: [MyAnualListInfo] = [] //연차
    var applyTuple: [MyApplyListInfo] = [] // 신청
    var cmpsid = 0
    var empsid = 0
    
    var Anualnextkey = ""
    var Applynextkey = ""
    var listcnt = 30
    var total = 0
    var Applytotal = 0
    var Anualcurkey = ""
    var Applycurkey = ""
    var emptyApply = 1
    var emptyAnual = 1
    var fetchingMore = false
    var name = ""
    var enname = ""
    var wkh = 0
    var workmin = 0
    var clickFlag = true
    var remain = 0
    var rmnDay = 0
    var rmnHour = 0
    var rmnMin = 0
    var isToday = ""
    var isAnualSelected = 0
    var isApplySelected = 0
    var clickApplyCnt = 0
    var clickAnualCnt = 0
    var Anualaprsid = 0
    var Applyaprsid = 0
    
    // 2020.04.06 Multi 추가 seob
    var tmptotalDiff = 0
    var batch = 0
    var fical = 0 
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    var disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.rowHeight = UITableView.automaticDimension
        tblList.separatorStyle = .none
        tblList.backgroundColor = .clear
        tabbarheight(tblList)
        tblList.register(UINib.init(nibName: "TotalAnualLoadingCell", bundle: nil), forCellReuseIdentifier: "TotalAnualLoadingCell")
        tblList.register(UINib.init(nibName: "MyAnlListCell", bundle: nil), forCellReuseIdentifier: "MyAnlListCell")
        tblList.register(UINib.init(nibName: "MyAplListCell", bundle: nil), forCellReuseIdentifier: "MyAplListCell")
        
        vwNoApr.isHidden = true
        
//        btnWork.setImage(UIImage(named: "btn_tab_select"), for: .selected)
//        btnWork.setImage(UIImage(named: "gray_square"), for: .normal)
//        btnNotWork.setImage(UIImage(named: "btn_tab_select"), for: .selected)
//        btnNotWork.setImage(UIImage(named: "gray_square"), for: .normal)
        
        btnWork.isSelected = true
        btnNotWork.isSelected = false
         
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    
    func timeSet(_ time: Int) {
        rmnDay = time/(8*60)
        rmnHour = (time%(8*60))/60
        rmnMin = (time%(8*60))%(60)
        
    }
    
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    
    func updateLayoutTitleLable() {
        if clickFlag {
            self.lblTitleLabel.text = "남은 연차:"
            
            if CompanyInfo.stanual == 0 {
                //회계연도
                timeSet(self.fical)
            }else{
                //입사일자
                timeSet(self.remain)
            }
            
            self.lblAnlDay.text = " \(String(rmnDay))d \(String(rmnHour))h \(String(rmnMin))m"
        }else{
            if self.wkh == 1 {
                self.lblTitleLabel.text = "근로합계(이번달):"
            }else{
                self.lblTitleLabel.text = "근로합계(이번주):"
            }
            print("\n---------- [ self.workmin : \(self.workmin) ] ----------\n")
            let workminStr = self.workTimeStr(self.workmin)
            self.lblAnlDay.text = " \(workminStr[0])h \(workminStr[1])m"
        }
        
        self.lblAnlDay.layoutIfNeeded()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        IndicatorSetting()
        lblNavigationTitle.text = "\(name) 내역"
        clickFlag = true
        lblWork.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
        lblNotWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        if Anualcurkey == "" && isAnualSelected == 0 {
            getApplyList()
            getAnualList()
        }else  if Applycurkey == "" && isApplySelected == 0 {
            getApplyList()
        }else{
            getApplyList()
        }
        isToday = todayDate()
        applyTuple.removeAll()
        anlaprTuple.removeAll()
        
        updateLayoutTitleLable()
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        //        let vc = MainSB.instantiateViewController(withIdentifier: "TotalEmpLits") as! TotalEmpLits
        //        vc.modalTransitionStyle = .crossDissolve
        //        vc.modalPresentationStyle = .overFullScreen
        //        self.present(vc, animated: false, completion: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // 연차내역 리스트
    @IBAction func offShow(_ sender: UIButton) {
        Anualcurkey = ""
        Anualaprsid = 0
        isAnualSelected = 1
        if Anualcurkey == "" && isAnualSelected == 1 {
            anlaprTuple.removeAll()
        }
        clickAnualCnt += 1
        getAnualList()
        clickFlag = true
        btnWork.isSelected = true
        btnNotWork.isSelected = false
        
        lblWork.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
        lblNotWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        btnWork.backgroundColor = UIColor.rgb(r: 252, g: 202, b: 0)
        btnNotWork.backgroundColor = UIColor.rgb(r: 247, g: 247, b: 250)
        updateLayoutTitleLable()
    }
    
    // 신청내역 리스트
    @IBAction func onShow(_ sender: UIButton) {
        Applycurkey = ""
        Applyaprsid = 0
        isApplySelected = 1
        
        if Applycurkey == "" && isApplySelected == 1 {
            applyTuple.removeAll()
        }
        clickApplyCnt += 1
        
        getApplyList()
        clickFlag = false
        btnWork.isSelected = false
        btnNotWork.isSelected = true
        
        
        lblNotWork.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
        lblWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        btnNotWork.backgroundColor = UIColor.rgb(r: 252, g: 202, b: 0)
        btnWork.backgroundColor = UIColor.rgb(r: 247, g: 247, b: 250)
        updateLayoutTitleLable()
        
    }
    
    //연차 리스트 
    func getAnualList(){
        isAnualSelected = 1
        NetworkManager.shared().myAnualList(empsid: empsid, curkey: Anualcurkey.urlEncoding(), listcnt: listcnt , aprsid : Anualaprsid) { (isSuccess, resNextKey, resData, resaprsid) in
            if(isSuccess){
                guard let serverData = resData else { return self.tblList.reloadData() }
                print("\n---------- [ serverData : \(serverData.count) ] ----------\n")
                if serverData.count > 0 {
                    self.Anualnextkey = resNextKey
                    self.Anualaprsid = resaprsid
                    if serverData.count >= self.listcnt {
                        if serverData.count > 0 {
                            for i in 0...serverData.count-1 {
                                self.anlaprTuple.append(serverData[i])
                            }
                            self.emptyAnual = 1
                        }
                        self.total = self.anlaprTuple.count
                    }else{
                        if serverData.count > 0 {
                            for i in 0...serverData.count-1 {
                                self.anlaprTuple.append(serverData[i])
                            }
                        }
                        self.emptyAnual = 0
                        self.total = self.anlaprTuple.count
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
    
    //출장/연장 근로
    func getApplyList(){
        isApplySelected = 1
        NetworkManager.shared().myApplyList(cmpsid: cmpsid, empsid: empsid, curkey: Applycurkey.urlEncoding(), listcnt: listcnt ,  aprsid : Applyaprsid) { (isSuccess, resNextKey, reswkh, resWorkmin,resData, resaprsid) in
            if(isSuccess){
                if self.clickApplyCnt == 0 {
                    self.wkh = reswkh
                    self.workmin = resWorkmin
                }
                guard let serverData = resData else { return self.tblList.reloadData() }
                if serverData.count > 0 {
                    self.Applynextkey = resNextKey
                    self.Applyaprsid = resaprsid
                    
                    if serverData.count >= self.listcnt {
                        for i in 0...serverData.count-1 {
                            self.applyTuple.append(serverData[i])
                        }
                        self.emptyApply = 1
                        self.Applytotal = self.anlaprTuple.count
                    }else{
                        for i in 0...serverData.count-1 {
                            self.applyTuple.append(serverData[i])
                        }
                        self.emptyApply = 0
                        self.Applytotal = self.applyTuple.count
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
}

// MARK: - UITableViewDelegate
extension TotalAnualaprListVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if clickFlag{
                if anlaprTuple.count == 0 {
                    vwNoApr.isHidden = false
                }else {
                    vwNoApr.isHidden = true
                }
                return anlaprTuple.count
            }else{
                if applyTuple.count == 0 {
                    vwNoApr.isHidden = false
                    
                }else {
                    vwNoApr.isHidden = true
                }
                return applyTuple.count
            }
        }else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if clickFlag{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "MyAnlListCell", for: indexPath) as? MyAnlListCell {
                    let AnualIndexPath = anlaprTuple[indexPath.row]
                    var str = AnualIndexPath.aprdt.replacingOccurrences(of: "-", with: ".")
                    str += "(" + AnualIndexPath.aprwd + ") "
                    
                    if AnualIndexPath.batch == 1 {
                        str += "일괄연차 ";
                    }else{
                        switch AnualIndexPath.type {
                            case 0:
                                str += "연차 ";
                            case 1:
                                str += "오전반차 ";
                            case 2:
                                str += "오후반차 ";
                            case 3:
                                str += "조퇴 ";
                            case 4:
                                str += "외출 ";
                            case 5:
                                str += "병가 ";
                            case 6:
                                str += "공가 ";
                            case 7:
                                str += "경조 ";
                            case 8:
                                str += "교육 및 훈련 ";
                            case 9:
                                str += "포상휴가 ";
                            case 10:
                                str += "공민권행사 ";
                            case 11:
                                str += "생리휴가 ";
                            default:
                                break;
                        }
                    }
                    
                    
                    
                    let hour = (AnualIndexPath.diffmin%(8*60))/60
                    let min = (AnualIndexPath.diffmin%(8*60))%60
                    
                    var timeStr = ""
                    // schdl 여부에 따른 오전반차 오후반차 인경우 고정 4h - 2020.03.24 osan
                    if AnualIndexPath.diffmin >= 480 {
                        timeStr = "1d "
                    }else {
                        switch (AnualIndexPath.type, moreCmpInfo.schdl) {
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
                    
                    if AnualIndexPath.batch == 1 {
                        var batchdiff = 0 // h
                        var remainder = 0 // m
                        var multiStr = ""
                        
                        batchdiff = (AnualIndexPath.batchdiff / 8)
                        remainder = (AnualIndexPath.batchdiff % 8)
                        if batchdiff > 0 && remainder > 0 {
                            multiStr = "\(batchdiff)d \(remainder)h"
                        }else if batchdiff > 0 && remainder == 0 {
                            multiStr = "\(batchdiff)d"
                        }else if batchdiff == 0 && remainder > 0 {
                            multiStr = "\(remainder)h"
                        }
                        cell.lblTitle.text = str + multiStr
                    }else{
                        cell.lblTitle.text = str + timeStr
                    }
                    
                    
                    
                    //최종 결재승인상태(0.대기 1.보류 2.승인 3.반려)
                    var statuStr = ""
                    var statuColor = UIColor.init(hexString: "#606060");
                    
                    if isToday > AnualIndexPath.aprdt {
                        
                        switch AnualIndexPath.aprstatus {
                            case 0:
                                statuStr = "결재중";
                            case 1:
                                statuStr = "보류";
                            case 2:
                                statuStr = "사용완료";
                            case 3:
                                statuStr = "반려";
                            default:
                                break;
                        }
                        statuColor = UIColor.init(hexString: "#606060");
                        cell.lblType.textColor = statuColor
                    }else{
                        
                        switch AnualIndexPath.aprstatus {
                            case 0:
                                statuStr = "결재중";
                                statuColor = UIColor.init(hexString: "#043956");
                            case 1:
                                statuStr = "보류";
                                statuColor = UIColor.init(hexString: "#043956");
                            case 2:
                                statuStr = "결재완료";
                                statuColor = UIColor.init(hexString: "#45A7CB");
                            case 3:
                                statuStr = "반려";
                                statuColor = UIColor.init(hexString: "#EF3829");
                            default:
                                break;
                        }
                        
                        cell.lblType.textColor = statuColor
                    }
                    
                    cell.lblType.text = statuStr
                    cell.btnCell.tag = indexPath.row 
                    return cell
                }
            }else{
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "MyAplListCell", for: indexPath) as? MyAplListCell {
                    let ApplyIndexPath = applyTuple[indexPath.row]
                    //근로신청 종류(0.출장 1.야간근로 2.휴일근로)
                    var str = ApplyIndexPath.aprdt.replacingOccurrences(of: "-", with: ".")
                    str += "(" + ApplyIndexPath.aprwd + ") "
                    
                    switch ApplyIndexPath.type {
                        case 0:
                            str += "출장 ";
                        case 1:
                            str += "연장근로 ";
                        case 2:
                            str += "휴일근로 ";
                        default:
                            break;
                    }
                    
                    cell.lblTitle.text = str
                    //최종 결재승인상태(0.대기 1.보류 2.승인 3.반려)
                    var statuStr = ""
                    var statuColor = UIColor.init(hexString: "#606060");
                    if isToday > ApplyIndexPath.aprdt {
                        switch ApplyIndexPath.aprstatus {
                            case 0:
                                statuStr = "대기";
                            case 1:
                                statuStr = "보류";
                            case 2:
                                statuStr = "사용완료";
                            case 3:
                                statuStr = "반려";
                            default:
                                break;
                        }
                        statuColor = UIColor.init(hexString: "#606060");
                        cell.lblType.textColor = statuColor
                    }else{
                        switch ApplyIndexPath.aprstatus {
                            case 0:
                                statuStr = "대기";
                                statuColor = UIColor.init(hexString: "#043956");
                            case 1:
                                statuStr = "보류";
                                statuColor = UIColor.init(hexString: "#043956");
                            case 2:
                                statuStr = "승인";
                                statuColor = UIColor.init(hexString: "#45A7CB");
                            case 3:
                                statuStr = "반려";
                                statuColor = UIColor.init(hexString: "#EF3829");
                            default:
                                break;
                        }
                        cell.lblType.textColor = statuColor
                    }
                    cell.lblType.text = statuStr
                    cell.btnCell.tag = indexPath.row
                    return cell
                }
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TotalAnualLoadingCell", for: indexPath) as? TotalAnualLoadingCell {
                if !fetchingMore {
                    if self.clickFlag{
                        if self.anlaprTuple.count > 0 {
                            cell.indicator.startAnimating()
                        }else{
                            cell.indicator.stopAnimating()
                        }
                        
                    }else{
                        if self.applyTuple.count > 0 {
                            cell.indicator.startAnimating()
                        }else{
                            cell.indicator.stopAnimating()
                        } 
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
        
        if self.clickFlag{
            if self.anlaprTuple.count > 0 {
                if self.anlaprTuple.count >= self.listcnt {
                    print("\n---------- [ self.emptyAnual : \(self.emptyAnual) ] ----------\n")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.Anualcurkey = self.Anualnextkey
                        self.fetchingMore = false
                        if self.emptyAnual == 1 {
                            self.getAnualList()
                        }
                        
                    })
                }
            }
        }else{
            if self.applyTuple.count > 0 {
                if self.applyTuple.count >= self.listcnt {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.Applycurkey = self.Applynextkey
                        self.fetchingMore = false
                        if self.emptyApply == 1{
                            self.getApplyList()
                        }
                        
                    })
                }
            }
            
        }
        
    }
    
}
