//
//  AddMgrVC.swift
//  PinPle
//
//  Created by WRY_010 on 30/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AddMgrVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwNoEmp: UIView!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var tuple: [EmplyInfo] = []
    var empTuple: [(enname: String, mbrsid: Int, name: String, profimg: String, sid: Int, spot: String)] = []
    var fillterData: [(enname: String, mbrsid: Int, name: String, profimg: String, sid: Int, spot: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.delegate = self
        tblList.dataSource = self
        searchbar.delegate = self
        
        tblList.separatorStyle = .none
        tblList.rowHeight = UITableView.automaticDimension
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViewData), name: .reloadList, object: nil)
    }
    // MARK: reloadViewData
    @objc func reloadViewData(_ notification: Notification) {
        empTuple.removeAll()
        valueSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        valueSetting()
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        //        let vc = MoreSB.instantiateViewController(withIdentifier: "SetMgrVC") as! SetMgrVC
        //        vc.modalTransitionStyle = .crossDissolve
        //        vc.modalPresentationStyle = .overFullScreen
        //        self.present(vc, animated: false, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    func valueSetting() {        
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(상위팀원 리스트 - 관리자제외)
         Return  - 상위팀원 리스트(관리자 제외) .. 페이징 없음(검색처리를 위해 모든데이터 한번에 줌) .. Sorting 이름 가나다 순
         Parameter
         TTMSID(TEMSID)        상위팀번호(팀번호)
         */
        NetworkManager.shared().TemEmplist(temflag: SelTemFlag, ttmsid: SelTtmSid, temsid: SelTemSid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                self.tuple = serverData
                if self.tuple.count > 0 {
                    self.vwNoEmp.isHidden = true
                    for i in 0...self.tuple.count - 1 {
                        self.empTuple.append((self.tuple[i].enname,
                                              self.tuple[i].mbrsid,
                                              self.tuple[i].name,
                                              self.tuple[i].profimg,
                                              self.tuple[i].sid,
                                              self.tuple[i].spot))
                    }
                    self.fillterData = self.empTuple
                }else {
                    self.vwNoEmp.isHidden = false
                }
                self.tblList.reloadData()
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
}

extension AddMgrVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fillterData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddMgrListCell", for: indexPath) as! AddMgrListCell
        
        let enname = fillterData[indexPath.row].enname
        let name = fillterData[indexPath.row].name
        let profimg = fillterData[indexPath.row].profimg
        let spot = fillterData[indexPath.row].spot
        
        if profimg.urlTrim() != "img_photo_default.png" {
            cell.imgProfile.setImage(with: profimg)
        }else {
            cell.imgProfile.image = UIImage(named: "logo_pre")!
        }
        
        cell.lblInfo.text = name
        if enname == "" {
            cell.lblEname.text = ""
        }else {
            cell.lblEname.text = " (" + enname + ")"
        }
        cell.lblSpot.text = spot
        cell.btnCell.tag = indexPath.row
        cell.btnCell.addTarget(self, action: #selector(selectCell(_:)), for: .touchUpInside)
        return cell
    }
    @objc func selectCell(_ sender: UIButton) {
        SelEmpInfo = tuple[sender.tag]
        let vc = MoreSB.instantiateViewController(withIdentifier: "AddMgrPopUp") as! AddMgrPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}

extension AddMgrVC: UISearchBarDelegate {
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
