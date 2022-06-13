//
//  StepdayVC.swift
//  PinPle
//
//  Created by seob on 2020/06/12.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}

class StepdayVC: UIViewController , NVActivityIndicatorViewable {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    
    var standInfo : LcEmpInfo = LcEmpInfo()
    
    var dateFormatter = DateFormatter()
    var dateFormatter2 = DateFormatter()
    var tmflag = 0
    //    var DayTitle : [String] = ["일요일","월요일","화요일","수요일","목요일","금요일","토요일"]
    
    var workday = ""
    var arrayCnt: [String] = []
    var firstarrayCnt: [String] = []
    var startdt = "09:00"
    var enddt = "18:00"
    var bkstarttm = ""
    var bkendtm = ""
    var inputData = ""
    
    var SelMultiArr : [MultiConstractDate] = []
    var dayweek = 0
    var workmin = 0
    
    var tmpArr : [String] = []
    var serverArr: [ String] = []
    var popflag: Bool = false
    
    @IBOutlet weak var btnNext: UIButton!
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n---------- [ viewDidLoad ] ----------\n")
        EnterpriseColor.nonLblBtn(btnNext)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    
    
    
    fileprivate func getWorkDay(_ nDayWeek: Int) -> Int {
        var nResult = -1
        
        if standInfo.workdaylist.count > 0 {
            for (i,_) in standInfo.workdaylist.enumerated() {
                if (standInfo.workdaylist[i].dayweek == nDayWeek) {
                    nResult = i
                }
            }
        }
        return nResult
    }
    
    override func setNeedsFocusUpdate() {
        super.setNeedsFocusUpdate()
        self.workday = self.standInfo.workday
        SelMultiArrTemp = SelMultiArr
        //        getLCinfo()
        //        setUi()
        print("\n---------- [ SelMultiArrTemp : \(SelMultiArrTemp) ] ----------\n")
    }
    
    fileprivate func getLCinfo(){
        SelMultiArr.removeAll()
        IndicatorSetting()
        NetworkManager.shared().get_LCInfo(LCTSID: standInfo.sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                self.standInfo = serverData
                SelLcEmpInfo = self.standInfo
                self.setUi()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }else{
                self.toast("다시 시도해 주세요.")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }
        }
    }
    
    func setUi(){
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.rowHeight = UITableView.automaticDimension
        tblList.separatorStyle = .none
        tblList.backgroundColor = .clear
        tabbarheight(tblList)
        tblList.register(UINib.init(nibName: "DayViewTableViewCell", bundle: nil), forCellReuseIdentifier: "DayViewTableViewCell")
        
        workday = standInfo.workday
        
        arrayCnt = workday.components(separatedBy: ",")
        arrayCnt = arrayCnt.filter({ !$0.isEmpty })
        
        
        var workdayList = MultiConstractDate()
        for ( i , _) in arrayCnt.enumerated() {
            if (getWorkDay(Int(arrayCnt[i]) ?? 0)  == -1 ){
                workdayList.wdysid = 0
                workdayList.starttm = startdt
                workdayList.endtm = enddt
                workdayList.brkstarttm = bkstarttm
                workdayList.brkendtm = bkendtm
                workdayList.dayweek = Int(arrayCnt[i]) ?? 0
                workdayList.workmin = 480
                print("\n---------- [ 11 1 i :\(i) ] ----------\n")
            }else{
                let a = getWorkDay(Int(arrayCnt[i]) ?? 0)
                workdayList.wdysid = standInfo.workdaylist[a].wdysid
                workdayList.starttm = standInfo.workdaylist[a].starttm
                workdayList.endtm = standInfo.workdaylist[a].endtm
                workdayList.brkstarttm = standInfo.workdaylist[a].brkstarttm
                workdayList.brkendtm = standInfo.workdaylist[a].brkendtm
                workdayList.dayweek = standInfo.workdaylist[a].dayweek
                workdayList.workmin = standInfo.workdaylist[a].workmin
            }
            
            SelMultiArr.append(workdayList)
            print("\n---------- [ arraycnt : \(arrayCnt[i]) , testArr : \(SelMultiArr)] ----------\n")
        }
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) 
        getLCinfo()
        
        var formTitle = ""
        switch standInfo.form  {
        case 0:
            formTitle = "표준 정규직 근로"
        case 1:
            formTitle = "표준 계약직 근로"
        case 2:
            formTitle = "표준 시급/소정 근로"
        case 3:
            formTitle = "표준 시급/일별 근로"
        case 4:
            formTitle = "표준 일급/소정 근로"
        case 5:
            formTitle = "표준 일급/일별 근로"
        default:
            break
        }
        
        
        lblNavigationTitle.text = formTitle
        //setUi()
    }
    
    
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        
        if(standInfo.format == 1 && (standInfo.form == 3 || standInfo.form == 5)) {
            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step2VC") as! Lc_Default_Step2VC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.standInfo = standInfo
            self.present(vc, animated: false, completion: nil)
        }else{
            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step2_1VC") as! Lc_Default_Step2_1VC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.standInfo = standInfo
            self.present(vc, animated: false, completion: nil)
        }
        
        
    }
    @IBAction func NextDidTap(_ sender: Any) {
        
        var param: [String: Any] = [:]
        var multiArr: [Dictionary<String, Any>] = []
        
        
        //        print("\n---------- [ SelMultiArr : \(SelMultiArr) ] ----------\n")
        for model in SelMultiArr {
            
            let object : [String : Any] = [
                "wdysid": model.wdysid,
                "dayweek": model.dayweek,
                "starttm": model.starttm,
                "endtm": model.endtm,
                "brkstarttm": model.brkstarttm,
                "brkendtm": model.brkendtm,
                "workmin": model.workmin
            ]
            multiArr.append(object)
        }
        
        
        param = ["workday" : multiArr ]
        
        let data = try! JSONSerialization.data(withJSONObject: param, options: [])
        let jsonBatch:String = String(data: data, encoding: .utf8)!
        
        NetworkManager.shared().lc_std_step2_1(lctsid: standInfo.sid, json: jsonBatch) { (isSuccess, resCode) in
            if(isSuccess){
                DispatchQueue.main.async {
                    if resCode == 1 {
                        let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step3VC") as! Lc_Default_Step3VC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.standInfo = self.standInfo
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
    
    //MARK: - pop버튼
    @IBAction func moreBtn(_ sender: UIButton) {
        SelLcEmpInfo = standInfo
        SelLcEmpInfo.viewpage = "std_step2_1"
        if SE_flag {
            presentPanModal(RowType.sebasic.presentable.rowVC)
        }else{
            presentPanModal(RowType.basic.presentable.rowVC)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension StepdayVC {
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
            var viewpage: String = "std_step2_1"
            let rowVC: PanModalPresentable.LayoutType = ContractInfoPopup()
        }
        
        struct SEBsic: RowPresentable {
            var viewpage: String = "step1"
            let rowVC: PanModalPresentable.LayoutType = SE_ContractInfoPopup()
            
        }
        
    }
}

// MARK: - UITableViewDataSource , UITableViewDelegate
extension StepdayVC: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelMultiArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DayViewTableViewCell", for: indexPath) as? DayViewTableViewCell {
            cell.selectionStyle = .none
            var selIndexPath =  MultiConstractDate()
            var strDayTitle = ""
            var dayweek = 0
            selIndexPath = SelMultiArr[indexPath.row]
            var Cellworkmin = 0
            if (selIndexPath.starttm.timeTrim() != "" && selIndexPath.endtm.timeTrim() != ""){
                Cellworkmin = calTotalTime(selIndexPath.starttm.timeTrim(), selIndexPath.endtm.timeTrim(), selIndexPath.brkstarttm.timeTrim(), selIndexPath.brkendtm.timeTrim())
            }else{
                Cellworkmin = 0
            }
            
            selIndexPath.workmin = Cellworkmin
            
            switch selIndexPath.dayweek {
            case 2:
                strDayTitle = "월요일"
                dayweek = 2
            case 3:
                strDayTitle = "화요일"
                dayweek = 3
            case 4:
                strDayTitle = "수요일"
                dayweek = 4
            case 5:
                strDayTitle = "목요일"
                dayweek = 5
            case 6:
                strDayTitle = "금요일"
                dayweek = 6
            case 7:
                strDayTitle = "토요일"
                dayweek = 7
            case 1:
                strDayTitle = "일요일"
                dayweek = 1
            default:
                break
            }
          
            
            if #available(iOS 11.0, *) {
                cell.updateContentViews()
            } else {
                // Fallback on earlier versions
            }
            
            cell.celuvList = selIndexPath
            
            startdt = (selIndexPath.starttm.timeTrim() == "00:00" ? "09:00" : selIndexPath.starttm.timeTrim())
            enddt = (selIndexPath.endtm.timeTrim() == "00:00" ? "18:00" : selIndexPath.endtm.timeTrim())
            bkstarttm = (selIndexPath.brkstarttm.timeTrim() == "00:00" ? "12:00" : selIndexPath.brkstarttm.timeTrim())
            bkendtm = (selIndexPath.brkendtm.timeTrim() == "00:00" ? "13:00" : selIndexPath.brkendtm.timeTrim())
            
            cell.TextFieldStartTime.text = startdt
            cell.TextFieldEndTime.text = enddt
            cell.TextFieldbkStartTime.text = bkstarttm
            cell.TextFieldbkEndTime.text = bkendtm
            
            
            cell.lblTitleDay.text = strDayTitle
            cell.lblTaskTime.text =  "\(strDayTitle) 근로시간은 \(workmin) 입니다."
            var starttm:Int = 0
            var endtm:Int = 0
            var bkstm:Int = 0
            var bketm:Int = 0
            starttm = startdt != "" ? calTime(startdt.timeTrim()) : 0
            endtm = enddt != "" ? calTime(enddt.timeTrim()) : 0
            bkstm = bkstarttm != "" ? calTime(bkstarttm.timeTrim()) : 0
            bketm = bkendtm != "" ? calTime(bkendtm.timeTrim()) : 0

            var nDistance:uint = 0
            if (starttm > 0 && endtm > 0){
                if endtm > starttm {
                    if endtm > starttm {
                        if bketm == 0 {
                            print("\n---------- [ 1 starttm : \(starttm) , bketm :\(bketm) , bketm :\(bketm) ] ----------\n")
                            nDistance = uint((endtm - starttm) - (bketm - bkstm))
                        }else if bkstm == 0 {
                            print("\n---------- [ 2 starttm : \(starttm) , bketm :\(bketm) , bketm :\(bketm) ] ----------\n")
                            nDistance = uint((endtm - starttm) - (bkstm - bketm))
                        }else{
                            if bketm > bkstm {
                                if bkstm > bketm {
                                    print("\n---------- [ 3 starttm : \(starttm) , bketm :\(bketm) , bketm :\(bketm) ] ----------\n")
                                    nDistance = uint((endtm - starttm) - (bketm - bkstm))
                                }else{
                                    print("\n---------- [ 4 starttm : \(starttm) , bketm :\(bketm) , bketm :\(bketm) ] ----------\n")
                                    nDistance = uint((endtm - starttm) - (bketm - bkstm))
                                }
                            }else{
                                if bkstm > bketm {
                                    print("\n---------- [ 5 starttm : \(starttm) , bketm :\(bketm) , bketm :\(bketm) ] ----------\n")
                                    nDistance = uint((endtm - starttm) - (bketm - bkstm))
                                }else{
                                    print("\n---------- [ 6 starttm : \(starttm) , bketm :\(bketm) , bketm :\(bketm) ] ----------\n")
                                    nDistance = uint((endtm - starttm) - (bkstm - bketm))
                                }

                            }
                        }

                    }else{
                        if bketm > bkstm {
                            print("\n---------- [ 7 starttm : \(starttm) , bketm :\(bketm) , bketm :\(bketm) ] ----------\n")
                            nDistance = uint((starttm - endtm) - (bketm - bkstm))
                        }else{
                            print("\n---------- [ 8 starttm : \(starttm) , bketm :\(bketm) , bketm :\(bketm) ] ----------\n")
                            nDistance = uint((starttm - endtm) - (bkstm - bketm))
                        }
                    }

                }else{
                    if endtm > starttm {
                        print("\n---------- [ 9 starttm : \(starttm) , bketm :\(bketm) , bketm :\(bketm) ] ----------\n")
                        nDistance = uint((starttm - endtm) - (bketm - bkstm))
                    }else{
                        print("\n---------- [ 10 starttm : \(starttm) , bketm :\(bketm) , bketm :\(bketm) ] ----------\n")
                        nDistance = uint((starttm - endtm) - (bkstm - bketm))
                    }
                }
//
//                let workmin = getMinTohm(Int(nDistance.magnitude))
//
//                selIndexPath.workmin = Int(nDistance)
//                cell.lblTaskTime.text =  "\(strDayTitle) 근로시간은 \(workmin) 입니다."
            }else{
                nDistance = 0
            }
            
            let workmin = getMinTohm(Int(nDistance.magnitude))
            selIndexPath.workmin = Int(nDistance)
            cell.lblTaskTime.text =  "\(strDayTitle) 근로시간은 \(workmin) 입니다."
            
            cell.onClick = { vod in
                self.newWatchCast(of: vod, index: indexPath)
                cell.lblTaskTime.text =  "\(strDayTitle) 근로시간은 \(self.getMinTohm(vod.workmin)) 입니다."
                if indexPath.row > 0 {
                    let selectedIndexPath = IndexPath(item:indexPath.row , section: 0)
                    self.tblList.reloadRows(at: [selectedIndexPath], with: .none)
                    
                }
                
            }
            
            
            var textfields : [AwesomeTextField] = []
            textfields = [cell.TextFieldStartTime , cell.TextFieldEndTime , cell.TextFieldbkStartTime, cell.TextFieldbkEndTime]
            addToolBar(textFields: textfields)
            for textfield in textfields {
                textfield.delegate = self
            }
            
            
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    func newWatchCast(of cast: MultiConstractDate, index: IndexPath) {
        print("\n---------- [ newWatchCast : \(cast) , SelMultiArr : \(SelMultiArr.count)] ----------\n")
        
        if SelMultiArr.count > 0 {
            SelMultiArr[index.row].starttm = cast.starttm
            SelMultiArr[index.row].endtm = cast.endtm
            SelMultiArr[index.row].brkstarttm = cast.brkstarttm
            SelMultiArr[index.row].brkendtm = cast.brkendtm
            if cast.wdysid > 0 {
                SelMultiArr[index.row].wdysid = cast.wdysid
            }
            
            SelMultiArr[index.row].dayweek = cast.dayweek
            SelMultiArr[index.row].workmin = cast.workmin
            
            //        SelMultiArr.append(cast)
            SelMultiArrTemp.removeAll()
            SelMultiArrTemp = SelMultiArr
        }
    }
    
}




// MARK: - UITextFieldDelegate
extension StepdayVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cell = tblList.dequeueReusableCell(withIdentifier: "DayViewTableViewCell") as! DayViewTableViewCell
        if textField == cell.TextFieldStartTime {
            cell.TextFieldEndTime.becomeFirstResponder()
        }else if textField == cell.TextFieldEndTime {
            cell.TextFieldbkStartTime.becomeFirstResponder()
        }else if textField == cell.TextFieldbkStartTime {
            cell.TextFieldbkEndTime.becomeFirstResponder()
        }
        return true
    }
}

extension RangeReplaceableCollection where Element: Hashable {
    var orderedSet: Self {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    mutating func removeDuplicates() {
        var set = Set<Element>()
        removeAll { !set.insert($0).inserted }
    }
}
