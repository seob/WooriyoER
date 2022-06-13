//
//  AddMemberVC.swift
//  PinPle
//
//  Created by WRY_010 on 27/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AddMemberVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var vwNoEmp: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var tuple: [EmplyInfo] = []
    var empTuple: [(String, Int, String, UIImage, Int, String)] = []
    var fillterData: [(String, Int, String, UIImage, Int, String)] = []
    
    var selectedArray : [IndexPath] = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnSave)
        tblList.delegate = self
        tblList.dataSource = self
        searchbar.delegate = self
        
        vwNoEmp.isHidden = true
        
        tblList.allowsMultipleSelectionDuringEditing = false
        tblList.allowsMultipleSelection = true
        tblList.setEditing(false, animated: false)
        tblList.separatorStyle = .none
         
        tblList.rowHeight = UITableView.automaticDimension
        
        tblList.register(UINib.init(nibName: "FreeEmpListCellNew", bundle: nil), forCellReuseIdentifier: "FreeEmpListCellNew")
         if SE_flag {
             lblNavigationTitle.font = navigationFontSE
         }
         
    }
      
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
//        let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: false, completion: nil)
        NotificationCenter.default.post(name: .reloadTem, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(상위팀번호로 합류코드 조회)
         Return  - 조회결과 있는경우 : 합류코드(Base64), 조회결과 없는경우 : ""
         Parameter
         TTMSID(TEMSID)        상위팀번호(팀번호)
         */
        NetworkManager.shared().GetTmJoincode(temflag: SelTemFlag, ttmsid: SelTtmSid, temsid: SelTemSid) { (isSuccess, result) in
            if (isSuccess) {
                self.lblCode.text = result.base64Decoding()
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(무소속 직원리스트)
         Return  - 무소속 직원리스트(대표 제외) .. 페이징 없음(검색처리를 위해 모든데이터 한번에 줌) .. Sorting 이름 가나다 순
         Parameter
         CMPSID        회사번호
         */
        NetworkManager.shared().FreeEmplist(cmpsid: userInfo.cmpsid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                self.tuple = serverData
                
                if self.tuple.count > 0 {
                    self.vwNoEmp.isHidden = true
                    for i in 0...self.tuple.count - 1 {
                        var profimg = UIImage(named: "logo_pre")
                        let profimgUrl = self.tuple[i].profimg
                        
                        if profimgUrl.urlTrim() != "img_photo_default.png" {
                            profimg = self.urlImage(url: profimgUrl)
                        }
                        self.empTuple.append((self.tuple[i].enname,
                                              self.tuple[i].mbrsid,
                                              self.tuple[i].name,
                                              profimg!,
                                              self.tuple[i].sid,
                                              self.tuple[i].spot ))
                         
                    }
                    self.fillterData = self.empTuple
                }else {
                    self.vwNoEmp.isHidden = false
                }
                self.tblList.reloadData()
                
            }
        }
        
    }
    
    @IBAction func save(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(상위팀 팀원(직속)추가)
         Return  - 성공:추가된 팀원수, 실패:0
         Parameter
         TTMSID(TEMSID)        상위팀번호(팀번호)
         EMPSIDS        직원번호들(구분자',')
         */
        var empsids = ""
        print("\n---------- [ selectedArray : \(selectedArray) ] ----------\n")
        if let indexPath = tblList.indexPathsForSelectedRows {
            for i in 0...indexPath.count - 1 {
                let sid = fillterData[indexPath[i].row].4
                if i == indexPath.count - 1 {
                    empsids = empsids + String(sid)
                }else {
                    empsids = empsids + String(sid) + ","
                }
            }

            NetworkManager.shared().TmAddemply(temflag: SelTemFlag, ttmsid: SelTtmSid, temsid: SelTemSid, empsids: empsids) { (isSuccess, result) in
                if (isSuccess) {
                    guard let resultCode = result else { return }

                    if resultCode > 0 {
//                        let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
//                        vc.modalTransitionStyle = .crossDissolve
//                        vc.modalPresentationStyle = .overFullScreen
//                        self.present(vc, animated: false, completion: nil)
                        NotificationCenter.default.post(name: .reloadTem, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }else {
                        self.customAlertView("잠시 후, 다시 시도해 주세요.")
                    }
                }else {
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
        }else {
            customAlertView("선택 직원이 없습니다.")
        }
        
    }
    
    @IBAction func copyCode(_ sender: UIButton) {
        //        let alert = UIAlertController(title: "알림", message: "합류 코드(\(lblCode.text!))를 복사 했습니다.\n 코드를 직원에게 공지하세요.", preferredStyle: UIAlertController.Style.alert)
        //        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
        //        alert.addAction(okAction)
        //        self.present(alert, animated: false, completion: nil)
        self.customAlertView("합류 코드(\(lblCode.text!))를 복사 했습니다.\n 코드를 직원에게 공지하세요.")
    }
    
}

extension AddMemberVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fillterData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeEmpListCell", for: indexPath) as! FreeEmpListCell
//
//        let enname = fillterData[indexPath.row].0
//        let name = fillterData[indexPath.row].2
//        let profimg = fillterData[indexPath.row].3
//        let spot = fillterData[indexPath.row].5
//        cell.imgProfile.image = profimg
//        cell.lblName.text = name
//        if enname != "" {
//            cell.lblEname.text = "(" + enname + ")"
//        }else {
//            cell.lblEname.text = ""
//        }
//        cell.lblSpot.text = spot
//        return cell
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FreeEmpListCellNew", for: indexPath) as? FreeEmpListCellNew {
                cell.selectionStyle = .none
                let enname = fillterData[indexPath.row].0
                let name = fillterData[indexPath.row].2
                let profimg = fillterData[indexPath.row].3
                let spot = fillterData[indexPath.row].5
                cell.imgProfile.image = profimg
                cell.lblName.text = name
                if enname != "" {
                    cell.lblEname.text = "(" + enname + ")"
                }else {
                    cell.lblEname.text = ""
                }
                cell.lblSpot.text = spot
             
            
             return cell
        }
        
        return UITableViewCell()
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.cellForRow(at: indexPath) as! FreeEmpListCellNew

        if(!selectedArray.contains(indexPath))
        {
            selectedArray.append(indexPath)
        }
        else
        {
            selectedArray.removeLast()
        }
     }
       
}


 

extension AddMemberVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fillterData = searchText.isEmpty ? empTuple : empTuple.filter({ (arg0) -> Bool in
            
            let (_, _, name, _, _, _) = arg0
            return name.range(of: searchText, options: .caseInsensitive) != nil
        })
        print("fillterData = ", fillterData)
        DispatchQueue.main.async {
            self.tblList.reloadData()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchbar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchbar.showsCancelButton = false
        self.searchbar.text = ""
        self.searchbar.resignFirstResponder()
        self.fillterData = self.empTuple
        self.tblList.reloadData()        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search text = ", self.searchbar.text!)
        self.searchbar.showsCancelButton = false
        self.searchbar.resignFirstResponder()
    }
}
