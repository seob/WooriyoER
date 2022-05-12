//
//  SetCodeVC.swift
//  PinPle
//
//  Created by WRY_010 on 26/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class SetCodeVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    @IBOutlet weak var tblCode: UITableView!
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    
    var codeTuple: [(Int, String, Int, String, Int, Int, Int)] = []
    var popCodesid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()       
        
        tblCode.delegate = self
        tblCode.dataSource = self
        tblCode.separatorStyle = .none
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
    }
    // MARK: reloadTableData
    @objc func reloadTableData(_ notification: Notification) {
        valueSetting()
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "MainVC" {
            var vc = UIViewController()
            if SE_flag {
                vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC") as! MainVC
            }else {
                vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else{
            let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(회사-상위팀,팀 포함 합류코드 리스트).. 페이징 없음
         Return  - 합류코드정보 리스트
         Parameter
         CMPSID        회사번호
         */
        let url = urlClass.cmp_joincodelist(cmpsid: userInfo.cmpsid)
        if let jsonTemp: Data = jsonClass.weather_request(setUrl: url) {
            if let jsonData: NSDictionary = jsonClass.json_parseData(jsonTemp) {
                print(url)
                print(jsonData)
                
                let codeData = jsonData["joincode"] as! NSArray
                if codeData.count > 0 {
                    for i in 0...codeData.count - 1 {
                        self.codeTuple.append(((codeData[i] as AnyObject).object(forKey: "cmpsid") as! Int,
                                               (codeData[i] as AnyObject).object(forKey: "code") as! String,
                                               (codeData[i] as AnyObject).object(forKey: "line") as! Int,
                                               (codeData[i] as AnyObject).object(forKey: "name") as! String,
                                               (codeData[i] as AnyObject).object(forKey: "sid") as! Int,
                                               (codeData[i] as AnyObject).object(forKey: "temsid") as! Int,
                                               (codeData[i] as AnyObject).object(forKey: "ttmsid") as! Int
                        ))
                    }
                    print("codeTuple = ", codeTuple)
                }
            }
        }else {
            self.customAlertView("다시 시도해 주세요.")
        }
    }
    
    
    @objc func change(_ sender:UIButton) {
        var flag = true
        let name = codeTuple[sender.tag].3
        let codesid = codeTuple[sender.tag].4
        let temsid = codeTuple[sender.tag].5
        let ttmsid = codeTuple[sender.tag].6
        
        //        if let author = prefs.value(forKey: "author") as? Int {
        let author = userInfo.author
//        if author == 1 || author == 2 {
        if author <= 2 {
            flag = true
        }else {
            let ttmsidTemp = userInfo.ttmsid
            let temsidTemp = userInfo.temsid
            
            print("ttmsid = ", ttmsid, "temsid = ", temsid, "ttmsidTemp = ", ttmsidTemp, "temsidTemp = ", temsidTemp)
            if ttmsidTemp == ttmsid && temsidTemp == temsid {
                flag = true
            }else {
                flag = false
            }
            //                if let ttmsidTemp = prefs.value(forKey: "ttmsid") as? Int, let temsidTemp = prefs.value(forKey: "temsid") as? Int {
            //                print("ttmsid = ", ttmsid, "temsid = ", temsid, "ttmsidTemp = ", ttmsidTemp, "temsidTemp = ", temsidTemp)
            //                if ttmsidTemp == ttmsid && temsidTemp == temsid {
            //                    flag = true
            //                }else {
            //                    flag = false
            //                }
            //            }
        }
        
        if flag {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetCodePopUp") as! SetCodePopUp
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.name = name
            vc.codesid = codesid
            self.present(vc, animated: true, completion: nil)
        }else {
            self.customAlertView("권한이 없습니다.\n 팀을 확인해주세요.")
        }
        //        }
        
    }
    
    @objc func codeCopy(_ sender: UIButton) {
        let code = codeTuple[sender.tag].1
        let cmpNM = codeTuple[sender.tag].3
        UIPasteboard.general.string = code
        //        let alert = UIAlertController(title: "알림", message: "\(cmpNM)\n합류 코드(\(code))를 복사 했습니다.\n 코드를 직원에게 공지하세요.", preferredStyle: UIAlertController.Style.alert)
        //        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
        //        alert.addAction(okAction)
        //        self.present(alert, animated: false, completion: nil)
        self.customAlertView("\(cmpNM)\n합류 코드(\(code))를 복사 했습니다.\n 코드를 직원에게 공지하세요.")
    }
}

//MARK: extension - UITableViewMethods
extension SetCodeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codeTuple.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodeListCell") as!  CodeListCell
        let line = codeTuple[indexPath.row].2
        let code = codeTuple[indexPath.row].1
        let cmpNM = codeTuple[indexPath.row].3
        if line == 0 {
            cell.vwLine.isHidden = true
        }else {
            cell.vwLine.isHidden = false
        }
        
        cell.lblCode.text = code
        cell.lblCmpNM.text = cmpNM
        cell.btnCopy.tag = indexPath.row
        cell.btnChange.tag = indexPath.row
        cell.btnCopy.addTarget(self, action: #selector(self.codeCopy(_:)), for: .touchUpInside)
        cell.btnChange.addTarget(self, action: #selector(self.change(_:)), for: .touchUpInside)
        
        return cell
    }
}
