//
//  MgrCmtVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/11/08.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class MgrCmtVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
   
    var tuple: [EmplyInfoDetail] = []
    
    //Wk52h info-----------------------------------------------------//
    var workmin: Int = 0  //근로시간(분단위)
    var maxworkmin: Int = 0 //최대 근로시간(분단위)
    //Emply info-------------------------------------------------------//
    var empsid: Int = 0  //직원번호
    var spot: String = ""  //직책/직급
    var tname: String = ""  //소속(무소속 or 팀명  or 상위팀명)
    //Mbr info---------------------------------------------------------//
    var mbrsid: Int = 0 //회원번호
    var name: String = "" //이름
    var enname: String = ""  //영문 이름
    var profimg: String = ""  //사진 URL
    
    var wk52h: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        view.backgroundColor = .white
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        empsid = SelWarningEmpInfo.empsid
        enname = SelWarningEmpInfo.enname
        maxworkmin = SelWarningEmpInfo.maxworkmin
        mbrsid = SelWarningEmpInfo.mbrsid
        name = SelWarningEmpInfo.name
        profimg = SelWarningEmpInfo.profimg
        spot = SelWarningEmpInfo.spot
        workmin = SelWarningEmpInfo.workmin
        tname = SelWarningEmpInfo.tname
        
        wk52h = moreCmpInfo.wk52h
        
        valueSetting()
        
        var titleStr = name
        if spot != "" {
            titleStr += "(" + spot + ")"
        }
        
        lblNavigationTitle.text = titleStr
        
        viewflag = "MgrCmtVC"
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "WeekHourVC") as! WeekHourVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(직원 주간, 월간 근로시간 리스트)
         Return  - 주간, 월간 근로시간 리스트
         Parameter
         WK52H        주52시간제 설정정보(0.주간 1.월간)
         EMPSID        직원번호
         */
        
        NetworkManager.shared().EmpWorkminlist(wk52h: wk52h, empsid: empsid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                self.tuple = serverData
                self.tblList.reloadData()
            }else {
               self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    func minTemp(_ time: Int) -> String {
        
        let hour = time/60
        let min = time%60
        
        var timeStr = ""
        //        if hour > 0 {
        timeStr = String(hour) + "h "
        //        }
        //        if min > 0 {
        timeStr = timeStr + String(min) + "m"
        //        }
        return timeStr
    }
    
    
}
extension MgrCmtVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tuple.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MgrCmtListCell") as!  MgrCmtListCell
        cell.selectionStyle = .none
        let enddt = tuple[indexPath.row].enddt.replacingOccurrences(of: "-", with: ".")
        let startdt = tuple[indexPath.row].startdt.replacingOccurrences(of: "-", with: ".")
        let workmin = tuple[indexPath.row].workmin
        
        let time = workmin / 60
        if time >= 45 && time < 52 {
            cell.lblDate.textColor = UIColor.init(hexString: "#2981DE")
            cell.lblWorkMin.textColor = UIColor.init(hexString: "#2981DE")
        }else if time >= 52 {
            cell.lblDate.textColor = UIColor.init(hexString: "#EF3829")
            cell.lblWorkMin.textColor = UIColor.init(hexString: "#EF3829")
        }else {
            cell.lblDate.textColor = .black
            cell.lblWorkMin.textColor = .black
        }
        
        cell.lblDate.text = startdt + " ~ " + enddt
        cell.lblWorkMin.text = minTemp(workmin)
        cell.btnCell.tag = indexPath.row
        cell.btnCell.addTarget(self, action: #selector(self.goCmtList(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func goCmtList(_ sender: UIButton) {
        var vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpCmtList") as! EmpCmtList
        if SE_flag {
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_EmpCmtList") as! EmpCmtList
        }else{
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpCmtList") as! EmpCmtList
        }
        
        vc.selempsid = empsid
        vc.selenname = enname
        vc.selmbrsid = mbrsid
        vc.selname = name
        vc.selspot = spot
        vc.selworkmin = workmin
        vc.selprofimg = profimg
        
        let timeStamp = tuple[sender.tag].startdt
        let tmpDate = setDateformat(timeStamp)
        selectedDate = tmpDate
        
        SelEmpInfo.mbrsid = mbrsid
        SelEmpInfo.sid = empsid
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    
}
