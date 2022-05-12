//
//  TemEmpCmtList.swift
//  PinPle
//
//  Created by WRY_010 on 14/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TemEmpCmtList: UIViewController {
    
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
    
    var tuple:[EmplyInfoDetail] = []
    
    var year = 0
    var month = 0
    var todayYear = 0
    var todayMonth = 0
    var dt = ""
    var rmnDay = 0
    var rmnHour = 0
    var rmnMin = 0
    
    var addmin = 0
    var usemin = 0
    
    var temname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        
        btnRight.isHidden = true
        
        checkJoinDate()
        
        let name = SelEmpInfo.name
        let spot = SelEmpInfo.spot
        
        
        var nameStr = name
        if spot != "" {
            nameStr += "(" + spot + ")"
        }
        lblNavigationTitle.text = nameStr
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let dateString = dateFormatter.string(from: today)
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
        
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpList") as! TemEmpList
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    //MARK: - navigation bar button
    @IBAction func barButton(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpInfoVC") as! TemEmpInfoVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    // 이번달이 입사일보다 전일경우 이전버튼 안보이게 , next버튼만 보이게
    func checkJoinDate(){
        let joinData = lblJoinDt.text!.components(separatedBy: ".")
        let joinYear = Int(joinData[0])!
        let joinMonth = Int(joinData[1])!
        
        if (month == joinMonth && year == joinYear) {
            btnLeft.isHidden = true
            btnRight.isHidden = false
        }else{
            btnRight.isHidden = false
            btnLeft.isHidden = false
        }
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
        
        valueSetting()
        let indexPath = IndexPath(row: 0, section: 0)
        tblList.scrollToRow(at: indexPath, at: .top, animated: false)
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
        valueSetting()
        
        let indexPath = IndexPath(row: 0, section: 0)
        tblList.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(직원 월별 출퇴근기록 + 연차정보(남은연차, 입사일자)) ... 페이징 없음
         Return  - 직원 출퇴근기록 + 연차정보(남은연차, 입사일자)
         Parameter
         EMPSID        직원번호
         DT            월초일(형식: 2019-10-01).. 해당년월의 1일
         */
        NetworkManager.shared().EmpCmtlist(empsid: SelEmpInfo.sid, dt: dt) { (isSuccess, resData, joindt, remainmin, usemin, addmin) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                self.tuple = serverData
                
                self.usemin = usemin
                self.addmin = addmin
                
                let day = remainmin/(8*60)
                let hour = (remainmin%(8*60))/60
                let min = (remainmin%(8*60))%60
                
                self.lblAnl.text = "\(day)d \(hour)h \(min)m"
                self.lblJoinDt.text = joindt.replacingOccurrences(of: "-", with: ".")
                self.tblList.reloadData()
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
}
extension TemEmpCmtList: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tuple.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemEmpCmtListCell") as! TemEmpCmtListCell
        let dayweek = tuple[indexPath.row].dayweek
        let dtday = tuple[indexPath.row].dtday
        let enddtArr = tuple[indexPath.row].enddt.components(separatedBy: " ")[0]
        var enddt = tuple[indexPath.row].enddt.components(separatedBy: " ")[1]
        let startdtArr = tuple[indexPath.row].startdt.components(separatedBy: " ")[0]
        var startdt = tuple[indexPath.row].startdt.components(separatedBy: " ")[1]
        let type = tuple[indexPath.row].type
        let workmin = tuple[indexPath.row].workmin
        
        //근무타입(0.데이터 없음 1.정상출근 2.지각 3.조퇴 4.야근 5.휴일근로 6.출장 7.외출 8.연차 9.결근)
        var typeImg = UIImage()
        switch type {
        case 1:
            typeImg = UIImage.init(named: "icon_attend")!; // 2020.01.15 seob
        case 2:
            typeImg = UIImage.init(named: "icon_late")!;
        case 3:
            typeImg = UIImage.init(named: "icon_early")!;
        case 4:
            typeImg = UIImage.init(named: "icon_night")!;
        case 5:
            typeImg = UIImage.init(named: "icon_over")!;
        case 6:
            typeImg = UIImage.init(named: "icon_outcall")!;
        case 7:
            typeImg = UIImage.init(named: "icon_out")!;
        case 8:
            typeImg = UIImage.init(named: "icon_annual")!;
        case 9:
            typeImg = UIImage.init(named: "icon_absence")!;
        default:
            break;
        }
        
        cell.imgState.image = typeImg
        
        if indexPath.row > 0 {
            if tuple[indexPath.row].dtday == tuple[indexPath.row - 1].dtday {
                cell.lblNumber.isHidden = true
            }else {
                cell.lblNumber.isHidden = false
            }
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
        
        let hour = workmin/60
        let min = workmin%60
        var timeStr = ""
        if hour > 0 {
            timeStr = String(hour) + "h"
        }
        if min > 0 {
            timeStr = timeStr + String(min) + "m"
        }
        
        if workmin == 0 {
            timeStr = "0h 0m"
            startdt = "00:00"
            enddt = "00:00"
        }
        cell.lblWorkMin.text = timeStr
        cell.lblStart.text = startdt
        
        if enddtArr != "" {
            if startdtArr != enddtArr {
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
            
        }else{
            cell.lblend.text = enddt
        }
        cell.btnUpdate.tag = indexPath.row
        cell.btnUpdate.addTarget(self, action: #selector(self.update(_:)), for: .touchUpInside)
        
        return cell
    }
    @objc func update(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "TemCmtTimeSetVC") as! TemCmtTimeSetVC
        SelCmtInfo = self.tuple[sender.tag]
        vc.seldt = lblDate.text! + "." + "\(tuple[sender.tag].dtday)"
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
}
