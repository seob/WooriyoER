//
//  EmpCmtList.swift
//  PinPle
//
//  Created by WRY_010 on 14/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class EmpCmtList: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblAnl: UILabel!
    @IBOutlet weak var lblJoinDt: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var tblList: UITableView!
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    
    //    var cmtTuple: [(String, String, String, Int, String, Int, Int)] = []
    
    var cmtTuple : [EmplyInfoDetailList] = [] 
    var year: Int = 0
    var month: Int = 0
    var todayYear: Int = 0
    var todayMonth: Int = 0
    var dt = ""
    var rmnDay: Int = 0
    var rmnHour: Int = 0
    var rmnMin: Int = 0
    
    var addmin: Int = 0
    var usemin: Int = 0
    var ficalmin: Int = 0
    var joindt = ""
    var temname = ""
    // 뷰이동때문에 추가
    var moveSelCmtTuple: [(Int, String, Int, Int, String, UIImage, String, Int, String)] = []
    
    //2020.01.22 뷰 이동 변수 넘김 수정
    var selauthor: Int = 0
    var selempsid: Int = 0
    var selenddt = ""
    var selenname: String = ""
    var selmbrsid: Int = 0
    var selmemo: String = ""
    var selname: String = ""
    var selphone: String = ""
    var selphonenum: String = ""
    //    var selprofimg = UIImage()
    var selprofimg: String = ""
    var selspot: String = ""
    var selstartdt: String = ""
    var seltype: Int = 0
    var selworkmin: Int = 0
    
    var endDays = "" // 날짜비교때문에 추가
    var tmpjoindt = ""
    var disabledModifyBtn = ""
    var blDisabled = false //2년 이상이면 true 이하이면 false
    var beforeYear = 0
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    var disposeBag: DisposeBag = DisposeBag()
    var tempMbrInfo = getMbrInfo()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        btnRight.isHidden = true
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        if selectedDate == today {
            selectedDate = today
        }
        let dateString = dateFormatter.string(from: selectedDate)
        
        print("\n---------- [ selectedDate : \(selectedDate) ] ----------\n")
        lblDate.text = dateString.replacingOccurrences(of: "-", with: ".")
        dt = dateString + "-01"
        
        let todayStr = dateString.components(separatedBy: "-")
        year = Int(todayStr[0])!
        month = Int(todayStr[1])!
        todayYear = Int(todayStr[0])!
        todayMonth = Int(todayStr[1])!
        print("year = ", year, "month = ", month)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reloadCmpEmpList, object: nil)
    }
    
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    // MARK: reloadTableData
    @objc func reloadTableData(_ notification: Notification) {
        IndicatorSetting() //로딩
        valueSetting()
        getMbrinfo()
        var titleStr = selname
        if selspot != "" {
            titleStr += "(" + selspot + ")"
        }
        lblNavigationTitle.text = titleStr
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IndicatorSetting() //로딩
        valueSetting()
        getMbrinfo()
        var titleStr = selname
        if selspot != "" {
            titleStr += "(" + selspot + ")"
        }
        lblNavigationTitle.text = titleStr
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        selectedDate = Date()
        var vc = UIViewController()
        if viewflag == "MgrCmtVC" {
            vc = MoreSB.instantiateViewController(withIdentifier: "MgrCmtVC") as! MgrCmtVC
        }else if viewflag == "TemEmpList" {
            vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpList") as! TemEmpList
        }else {
            if SE_flag {
                vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_CmtEmpList") as! CmtEmpList
            }else{
                vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
            }
            
        }
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        //        dismiss(animated: true, completion: nil)
    }
    
    func checkmultiarea() -> Bool {
        switch moreCmpInfo.freetype { 
            case 2,3:
                // 올프리 , 펀프리
                if moreCmpInfo.freedt >= muticmttodayDate() {
                    return false
                }else{
                    if moreCmpInfo.datalimits >= muticmttodayDate() {
                        return false
                    }else{
                        return true
                    }
                }
            default:
                //핀프리 , 사용안함
                if moreCmpInfo.datalimits >= muticmttodayDate() {
                    return false
                }else{
                    return true
                }
        }
    }
    
    // 이번달이 입사일보다 전일경우 이전버튼 안보이게 , next버튼만 보이게
    func checkJoinDate(){
        let joinData = lblJoinDt.text!.components(separatedBy: ".")
        let joinYear = Int(joinData[0])!
        let joinMonth = Int(joinData[1])!
        if checkmultiarea() {
            print("\n---------- [ 1 ] ----------\n")
            if (month == joinMonth && year == joinYear) {
                btnLeft.isHidden = true
                btnRight.isHidden = false
            }else{
                btnRight.isHidden = false
                btnLeft.isHidden = false
            }
            
            if CompanyInfo.datalimits != "1900-01-01 00:00:00.0" {
                let strStorageDate = setDateformatTest(CompanyInfo.datalimits)
                print("\n---------- [ 22 ] ----------\n")
                if let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -6, to: strStorageDate) {
                    let testData = oneMonthAgo.toString()
                    let StorageData = testData.components(separatedBy: "-")
                    let StorageYear = Int(StorageData[0])!
                    let StorageMonth = Int(StorageData[1])!
                    print("\n---------- [ 1StorageMonth : \(StorageMonth) , StorageYear : \(StorageYear) , strStorageDate : \(strStorageDate) , ago :\(oneMonthAgo) ] ----------\n")
                    if (month == StorageMonth && year == StorageYear) {
                        btnLeft.isHidden = true
                        btnRight.isHidden = false
                    }else{
                        btnRight.isHidden = false
                        btnLeft.isHidden = false
                    }
                }
            }else{
                if let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date()) {
                    let testData = oneMonthAgo.toString()
                    let StorageData = testData.components(separatedBy: "-")
                    let StorageYear = Int(StorageData[0])!
                    let StorageMonth = Int(StorageData[1])!
                    if (month == StorageMonth && year == StorageYear) {
                        let vc = MoreSB.instantiateViewController(withIdentifier: "StoragePopVC") as! StoragePopVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        viewflag = "setempvc"
                        self.present(vc, animated: false, completion: nil)
                        btnLeft.isHidden = true
                        btnRight.isHidden = false
                    }  

                }
            }

        }else{
            print("\n---------- [ 2 ] ----------\n")
            if (month == joinMonth && year == joinYear) {
                btnLeft.isHidden = true
                btnRight.isHidden = false
            }else{
                btnRight.isHidden = false
                btnLeft.isHidden = false
            }
        }
    }
    
    @IBAction func empInfoSetting(_ sender: UIButton) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpInfoMainVC") as! EmpInfoMainVC
        vc.EmpInfo = SelEmpInfo
        vc.tempMbrInfo = tempMbrInfo
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func prvsMonth(_ sender: UIButton) {
        let joinData = lblJoinDt.text!.components(separatedBy: ".")
        print("joinData = ", joinData)
        let joinYear = Int(joinData[0])!
        print("joinYear = ", joinYear)
        let joinMonth = Int(joinData[1])!
        print("joinMonth = ", joinMonth)
        var monthStr = ""
        
        btnRight.isHidden = false
        month = month - 1
        
        if month < 1 {
            month = 12
            year = year - 1
        }
        
        if month == joinMonth && year == joinYear {
            btnLeft.isHidden = true
        }else {
            btnLeft.isHidden = false
        }
        
        if month < 10 {
            monthStr = "0" + String(month)
        }else {
            monthStr = String(month)
        }
        
        
        lblDate.text = String(year) + "." + monthStr
        dt = String(year) + "-" + monthStr + "-01"
        
        let tmpdate = setDateformatMonth(String(year) + "." + monthStr)
        selectedDate = tmpdate
        valueSetting()
        //        let indexPath = IndexPath(row: 0, section: 0)
        //        tblList.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
    
    @IBAction func nextMonth(_ sender: UIButton) {
        var monthStr = ""
        
        btnLeft.isHidden = false
        month = month + 1
        
        if month > 12 {
            month = 1
            year = year + 1
        }
        
        if month == todayMonth && year == todayYear {
            btnRight.isHidden = true
        }else {
            btnRight.isHidden = false
        }
        
        
        
        if month < 10 {
            monthStr = "0" + String(month)
        }else {
            monthStr = String(month)
        }
        
        lblDate.text = String(year) + "." + monthStr
        dt = String(year) + "-" + monthStr + "-01"
        
        let tmpdate = setDateformatMonth(String(year) + "." + monthStr)
        selectedDate = tmpdate
        valueSetting()
        
        //        let indexPath = IndexPath(row: 0, section: 0)
        //        tblList.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(직원 월별 출퇴근기록 + 연차정보(남은연차, 입사일자)) ... 페이징 없음
         Return  - 직원 출퇴근기록 + 연차정보(남은연차, 입사일자)
         Parameter
         EMPSID        직원번호
         DT            월초일(형식: 2019-10-01).. 해당년월의 1일
         */
        IndicatorSetting()
        cmtTuple.removeAll()
        print("empsid :\(SelEmpInfo.sid)  sleempsid = ", selempsid, " dt = ", dt)
        NetworkManager.shared().EmpDetailList(empsid: SelEmpInfo.sid, dt: dt) { (isSuccess, resAddmin, resjoindt, resRemainmin, resUsermin, resfical ,resData) in
            if(isSuccess){
                guard let serverData = resData else {  return  }
                let remainmin = resRemainmin
                self.joindt = resjoindt
                self.usemin = resUsermin
                self.addmin = resAddmin
                self.ficalmin = resfical
                
                SelEmpInfo.usemin = resUsermin
                SelEmpInfo.addmin = resAddmin
                if serverData.count > 0 {
                    self.cmtTuple = serverData
                }
                 
                
                var day = 0
                var hour = 0
                var min = 0
       
                
                 if CompanyInfo.stanual == 0 {
                    let tmpMin = resfical - resUsermin + resAddmin
                    day = tmpMin/(8*60)
                    hour = (tmpMin%(8*60))/60
                    min = (tmpMin%(8*60))%60
                }else{
                    day = remainmin/(8*60)
                    hour = (remainmin%(8*60))/60
                    min = (remainmin%(8*60))%60
                }
                
                
                self.lblAnl.text = String(day) + "d " + String(hour) + "h " + String(min) + "m"
                if self.tmpjoindt != "" {
                    self.lblJoinDt.text = self.tmpjoindt.replacingOccurrences(of: "-", with: ".")
                }else{
                    self.lblJoinDt.text = self.joindt.replacingOccurrences(of: "-", with: ".")
                }
                
                let testdate = Date()
                self.disabledModifyBtn = "\(self.lblJoinDt.text!)"
                let aaa = self.setDateformatTest(self.disabledModifyBtn)
                self.beforeYear  = aaa.yearsCount(from: testdate)
                if self.beforeYear == -2 {
                    self.blDisabled = true
                }else{
                    self.blDisabled = false
                }
                
                
                self.tblList.reloadData()
                //스크롤 내리고 <, > 버튼 클릭시 죽는 오류 수정
                let indexPath = IndexPath(row: 0, section: 0)
                self.tblList.scrollToRow(at: indexPath, at: .top, animated: false)
                self.checkJoinDate()
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
    
    func getMbrinfo(){
        NetworkManager.shared().GetMbrInfo(mbrsid: SelEmpInfo.mbrsid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                self.tempMbrInfo = serverData
                self.selname = serverData.name
                self.selspot = serverData.spot
                var titleStr = serverData.name
                self.selempsid = serverData.empsid
                if serverData.spot != "" {
                    titleStr += "(" + self.selspot + ")"
                }
                self.lblNavigationTitle.text = titleStr
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
        
    }
    
    func numberOfDaysBetween(_ from: String, _ to: String) -> Int {
        let date1 = setDateformat(from)
        let date2 = setDateformat(to)

        let diffs = Calendar.current.dateComponents([.day], from: date1, to: date2)
        return diffs.day!
    }
}
// MARK: - UITableViewDelegate
extension EmpCmtList: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cmtTuple.count
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "EmpCmtListCell") as! EmpCmtListCell
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EmpCmtListCell", for: indexPath) as? EmpCmtListCell {
            //            if cmtTuple.count > indexPath.row + 1 {
            let cmtIndexPath = cmtTuple[indexPath.row]
            let dayweek = cmtIndexPath.dayweek
            let dtday = cmtIndexPath.dtday
            let enddtArr = cmtIndexPath.enddt.components(separatedBy: " ")[0]
            var enddt = cmtIndexPath.enddt.components(separatedBy: " ")[1]
            let startdtArr = cmtIndexPath.startdt.components(separatedBy: " ")[0]
            var startdt = cmtIndexPath.startdt.components(separatedBy: " ")[1]
            let type = cmtIndexPath.type
            let workmin = cmtIndexPath.workmin
            let aprtype = cmtIndexPath.aprtype
            
            //근무타입(0.데이터 없음 1.정상출근 2.지각 3.조퇴 4.야근 5.휴일근로 6.출장 7.외출 8.연차 9.결근)
            //연차타입(0.연차 1.오전 2.오후 3.조퇴 4.외출 5.병가 6.공가 7.경조 8.교육 9.포상 10.공민 11.생리)
            var typeStr = ""
            var typeStrColor = UIColor.clear
            var typeImg = UIImage()
            
            if type != 8 {
                typeStr = CmtTypeArray[type]
                typeStrColor = CmtColorArray[type]
                typeImg = CmtImgArray[type]
            }else {
                typeStr = AnualTypeArray[aprtype]
                typeStrColor = AnualColorArray[aprtype]
                typeImg = AnualImgArray[aprtype]
            }
            
            cell.imgState.image = typeImg
            cell.lblState.text = typeStr
            cell.lblState.textColor = typeStrColor
            
            let hour = workmin/60
            let min = workmin%60
            var timeStr = ""
            
            timeStr = timeStr + String(hour) + "h "
            timeStr = timeStr + String(min) + "m"
            if indexPath.row > 0 {
                if cmtIndexPath.dtday == cmtTuple[indexPath.row - 1].dtday {
                    cell.lblNumber.isHidden = true
                    cell.lblWeek.isHidden = true
                }else {
                    cell.lblNumber.isHidden = false
                    cell.lblWeek.isHidden = false
                }
            }else {
                cell.lblNumber.isHidden = false
                cell.lblWeek.isHidden = false
            }
            
            
            if timeStr == "" {
                timeStr = "0h 0m"
            }
            if startdt == "" {
                startdt = "00:00"
            }
            if enddt == "" {
                enddt = "00:00"
            }
            
            cell.lblNumber.text = String(dtday)
            cell.lblWeek.text = dayweek
            
            
            if cell.lblWeek.text! == "토" {
                cell.lblWeek.textColor = .blue;
            }else if cell.lblWeek.text! == "일" {
                cell.lblWeek.textColor = .red;
            }else {
                cell.lblWeek.textColor = .black;
            }
            
            cell.lblWorkMin.text = timeStr
            cell.lblStart.text = startdt
            
            
            // 당일날짜일때는 해당 날짜 노출안되게(날짜가 다를경우에만 노출되게)
            if enddtArr != "" {
                let todayStr = enddtArr.components(separatedBy: "-")
                endDays = todayStr[2]
            }
            if (startdtArr != enddtArr && enddtArr != "" && (cmtIndexPath.dtday != endDays)){
                let endDtStr = enddtArr.components(separatedBy: "-")[1] + "." + enddtArr.components(separatedBy: "-")[2]
                let endStr = endDtStr + "\n" + enddt
                let fontSize = UIFont.systemFont(ofSize: 9)
                let attributdeStr = NSMutableAttributedString(string: endStr)
                attributdeStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String), value: fontSize, range: (endStr as NSString).range(of: endDtStr))
                cell.lblend.font = cell.lblend.font.withSize(14)
                cell.lblend.lineBreakMode = .byWordWrapping
                cell.lblend.numberOfLines = 2
                cell.lblend.attributedText = attributdeStr
            }else {
                cell.lblend.text = enddt
            }
            
            cell.btnUpdate.tag = indexPath.row 
            cell.btnUpdate.addTarget(self, action: #selector(self.update(_:)), for: .touchUpInside)
            
            
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func update(_ sender: UIButton) {
        var vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtTimeSetVC") as! CmtTimeSetVC
        if SE_flag {
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_CmtTimeSetVC") as! CmtTimeSetVC
        }else{
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtTimeSetVC") as! CmtTimeSetVC
        }
        let CmtIndexPath = cmtTuple[sender.tag]
        vc.selenddt = CmtIndexPath.enddt
        vc.selsid = CmtIndexPath.sid
        vc.selstartdt = CmtIndexPath.startdt
        vc.selempsid = selempsid
        vc.seltype = CmtIndexPath.type
        vc.seldt = lblDate.text! + "." + CmtIndexPath.dtday
        vc.startcmtarea = CmtIndexPath.startcmtarea
        vc.endcmtarea = CmtIndexPath.endcmtarea
        vc.strMemo = CmtIndexPath.memo
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    
    
}


extension Date {
    // Returns the number of years
    func yearsCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    // Returns the number of months
    func monthsCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    // Returns the number of weeks
    func weeksCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    // Returns the number of days
    func daysCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    // Returns the number of hours
    func hoursCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    // Returns the number of minutes
    func minutesCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    // Returns the number of seconds
    func secondsCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    // Returns time ago by checking if the time differences between two dates are in year or months or weeks or days or hours or minutes or seconds
    func timeAgo(from date: Date) -> String {
        if yearsCount(from: date)   > 0 { return "\(yearsCount(from: date))years ago"   }
        if monthsCount(from: date)  > 0 { return "\(monthsCount(from: date))months ago"  }
        if weeksCount(from: date)   > 0 { return "\(weeksCount(from: date))weeks ago"   }
        if daysCount(from: date)    > 0 { return "\(daysCount(from: date))days ago"    }
        if hoursCount(from: date)   > 0 { return "\(hoursCount(from: date))hours ago"   }
        if minutesCount(from: date) > 0 { return "\(minutesCount(from: date))minutes ago" }
        if secondsCount(from: date) > 0 { return "\(secondsCount(from: date))seconds ago" }
        return ""
    }
}
