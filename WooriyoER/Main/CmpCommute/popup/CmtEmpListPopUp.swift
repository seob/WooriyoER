//
//  ViewController.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/02.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class CmtEmpListPopUp: UIViewController {
    
    @IBOutlet weak var tblList: UITableView!
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    
    var teamTuple: [(Bool, String, Int)] = []
    
    var cmpsid = 1
    var ttmsid = 0
    var temsid = 0
    
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
//        let cmpsid = prefs.value(forKey: "cmpsid") as? Int ??  0
        print("\n---------- [ popup : \(userInfo.cmpsid) ] ----------\n")
        let cmpsid = userInfo.cmpsid
        let url = urlClass.cmp_ttnamelist(cmpsid: cmpsid)
        if let jsonTemp: Data = jsonClass.weather_request(setUrl: url) {
            if let jsonData: NSDictionary = jsonClass.json_parseData(jsonTemp) {
                print(url)
                print(jsonData)
                
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

extension CmtEmpListPopUp: UITableViewDelegate, UITableViewDataSource {
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "CmtCmpCell") as!  CmtCmpCell
//            let cmpname = prefs.value(forKey: "cmpname") as! String
             
            cell.lblCmp.text = CompanyInfo.name
            cell.btnSetting.tag = indexPath.row
            cell.btnSetting.addTarget(self, action: #selector(self.setting(_:)), for: .touchUpInside)
            return cell
        }else {
            if teamTuple[indexPath.row - 1].0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CmtPopUpTTMCell") as!  CmtPopUpTTMCell
                let name = teamTuple[indexPath.row - 1].1
                
                cell.lblName.text = name
                cell.btnSetting.tag = indexPath.row
                cell.btnSetting.addTarget(self, action: #selector(self.setting(_:)), for: .touchUpInside)
                
                if teamTuple[indexPath.row - 1].1 != "상위팀 미지정" {
                    cell.btnSetting.isEnabled = true
                }else {
                    cell.btnSetting.isEnabled = false
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CmtPopUpTemCell", for: indexPath) as! CmtPopUpTemCell
                let temname = teamTuple[indexPath.row - 1].1
                
                cell.lblName.text = temname
                cell.btnSetting.tag = indexPath.row
                cell.btnSetting.addTarget(self, action: #selector(self.setting(_:)), for: .touchUpInside)
                
                return cell
                
            }
        }
        
    }
    
    @objc func setting(_ sender: UIButton) {
        print("sender.tag = ", sender.tag, "teamTuple.count = ", teamTuple.count)
        if sender.tag == 0 {
            self.ttmsid = -1
            self.temsid = -1
//            let cmpname = prefs.value(forKey: "cmpname") as! String
            let cmpname = CompanyInfo.name
            prefs.setValue(cmpname, forKey: "cmt_temname")
        }else {
            let temflag = teamTuple[sender.tag - 1].0
            let temname = teamTuple[sender.tag - 1].1
            let temsid = teamTuple[sender.tag - 1].2
            
            if sender.tag == teamTuple.count {
                self.ttmsid = 0
                self.temsid = 0
            }else if temflag {
                self.ttmsid = temsid
                self.temsid = 0
            }else {
                self.ttmsid = -1
                self.temsid = temsid
            }
            prefs.setValue(temname, forKey: "cmt_temname")
            
        }
        prefs.setValue(self.ttmsid, forKey: "cmt_ttmsid")
        prefs.setValue(self.temsid, forKey: "cmt_temsid")
        
        print("ttmsid = ", self.ttmsid, "prefs = " , prefs.value(forKey: "cmt_ttmsid")!)
        print("temsid = ", self.temsid, "prefs = " , prefs.value(forKey: "cmt_temsid")!)
        
        
        var vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
        if SE_flag {
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_CmtEmpList") as! CmtEmpList
        }else{
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
    
}
