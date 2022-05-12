//
//  TotalCmtEmpListPopUp.swift
//  PinPle
//
//  Created by seob on 2020/02/19.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class TotalCmtEmpListPopUp: UIViewController {
    @IBOutlet weak var tblList: UITableView!
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    
    var teamTuple: [(temflag: Bool, name: String, sid: Int)] = []
    
    var cmpsid: Int = 0
    var ttmsid: Int = 0
    var temsid: Int = 0
    var tname: String = ""
    
    var temselflag: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.rowHeight = UITableView.automaticDimension
        tblList.separatorStyle = .none
        
         prefs.setValue(true, forKey: "cmt_popflag")
        ttmlist()
    }
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    func ttmlist() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(회사 팀리스트-상위팀그룹-소속팀포함)..상위팀 미지정, 팀 미지정 포함... 페이징 없음
         Return  - 회사 팀 리스트(상위팀, 소속팀, 상위팀 미지정, 팀 미지정 포함)
         Parameter
         CMPSID        회사번호
         */
        teamTuple.removeAll()
//        let cmpsid = prefs.value(forKey: "cmpsid") as? Int ?? 0
        print("\n---------- [ TotalCmtEmpListPopUp : \(userInfo.cmpsid) ] ----------\n")
        let cmpsid = userInfo.cmpsid
        let url = urlClass.cmp_ttnamelist(cmpsid: cmpsid)
        if let jsonTemp: Data = jsonClass.weather_request(setUrl: url) {
            if let jsonData: NSDictionary = jsonClass.json_parseData(jsonTemp) {
                let topteamData = jsonData["topteam"] as? NSArray
                guard let serverData = topteamData else { return }
                if serverData.count > 0 {
                    for i in 0...serverData.count-1 {
                        teamTuple.append((true,
                                          (serverData[i] as AnyObject).object(forKey: "name") as! String,
                                          (serverData[i] as AnyObject).object(forKey: "sid") as! Int))

                        if let teamData = (serverData[i] as AnyObject).object(forKey: "team") {
                            let team = teamData as! NSArray
                            for j in 0...team.count - 1 {
                                teamTuple.append((false,
                                                  (team[j] as AnyObject).object(forKey: "temname") as! String,
                                                  (team[j] as AnyObject).object(forKey: "temsid") as! Int))
                            }
                        }
                    }
                }
                 
            }
        }else {
            self.customAlertView("다시 시도해 주세요.")
        }
        
   
    }
}

// MARK: UITableViewDelegate
extension TotalCmtEmpListPopUp: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamTuple.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCmtCmpCell") as!  TotalCmtCmpCell
//            let cmpname = prefs.value(forKey: "cmpname") as! String
            let cmpname = CompanyInfo.name
            cell.lblCmp.text = cmpname
            cell.btnSetting.tag = indexPath.row
            cell.btnSetting.addTarget(self, action: #selector(self.setting(_:)), for: .touchUpInside)
            return cell
        }else {
            if teamTuple[indexPath.row - 1].temflag {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCmtPopUpTTMCell") as!  TotalCmtPopUpTTMCell
                let name = teamTuple[indexPath.row - 1].name
                
                cell.lblName.text = name
                cell.btnSetting.tag = indexPath.row
                cell.btnSetting.addTarget(self, action: #selector(self.setting(_:)), for: .touchUpInside)
                
                if teamTuple[indexPath.row - 1].name != "상위팀 미지정" {
                    cell.btnSetting.isEnabled = true
                }else {
                    cell.btnSetting.isEnabled = false
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCmtPopUpTemCell", for: indexPath) as! TotalCmtPopUpTemCell
                let temname = teamTuple[indexPath.row - 1].name
                
                cell.lblName.text = temname
                cell.btnSetting.tag = indexPath.row
                cell.btnSetting.addTarget(self, action: #selector(self.setting(_:)), for: .touchUpInside)
                
                return cell
                
            }
        }
        
    }
    
    @objc func setting(_ sender: UIButton) {
 
        if sender.tag == 0 {
            //회사
            self.ttmsid = -1
            self.temsid = -1
            self.tname = CompanyInfo.name
            
            let cmpname = CompanyInfo.name
            prefs.setValue(cmpname, forKey: "cmt_temname")
        }else {
            let temflag = teamTuple[sender.tag - 1].temflag
            let temname = teamTuple[sender.tag - 1].name
            let temsid = teamTuple[sender.tag - 1].sid
            
            if sender.tag == teamTuple.count {
                //팀미지정
                self.ttmsid = 0
                self.temsid = 0
            }else if temflag {
                //상위팀
                self.ttmsid = temsid
                self.temsid = 0
            }else {
                //하위팀
                self.ttmsid = -1
                self.temsid = temsid
            }
            self.tname = temname
            prefs.setValue(temname, forKey: "cmt_temname")
        }
        
        prefs.setValue(self.ttmsid, forKey: "cmt_ttmsid")
        prefs.setValue(self.temsid, forKey: "cmt_temsid")
        
    
        print("\n---------- [ self.ttmsid : \(self.ttmsid), self.temsid : \(self.temsid) , userInfo.ttmsid:\(userInfo.ttmsid) , userInfo.temsid:\(userInfo.temsid) ] ----------\n")
//        if userInfo.author <= 2 {
//            goToTotalEmpList()
//        }else {
//            switch userInfo.author {
//            case 3:
//                if userInfo.ttmsid == teamTuple[sender.tag].sid {
//                    if (ttmsid == 0){ //상위팀
//                        goToTotalEmpList()
//                    } else if (ttmsid == -1){  //하위팀
//                        goToTotalEmpList()
//                    } else {
//                        self.customAlertView("해당 팀 관리자가 아닙니다.")
//                    }
//                } else {
//                    self.customAlertView("해당 팀 관리자가 아닙니다.")
//                }
//            case 4:
//                if userInfo.temsid == temsid {
//                    goToTotalEmpList()
//                } else {
//                    self.customAlertView("해당 팀 관리자가 아닙니다.")
//                }
//            default:
//                print("\n---------- [ 1 ] ----------\n")
//                if (ttmsid == 0){
//                    goToTotalEmpList()
//                }else if (temsid == -1){
//                    goToTotalEmpList()
//                }else if (ttmsid == -1 && temsid == -1){
//                    goToTotalEmpList()
//                }else if (ttmsid == 0 && temsid == 0){
//                    goToTotalEmpList()
//                }
//            }
//        }
        goToTotalEmpList()
    }
    
    fileprivate func goToTotalEmpList(){
        let vc = MainSB.instantiateViewController(withIdentifier: "TotalEmpLits") as! TotalEmpLits
        vc.temselflag = self.temselflag
        vc.ttmsid = self.ttmsid
        vc.temsid = self.temsid
        vc.tname = self.tname
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        NotificationCenter.default.post(name: .reloadTotalList, object: nil)
        self.present(vc, animated: false, completion: nil)
    }
    
}
