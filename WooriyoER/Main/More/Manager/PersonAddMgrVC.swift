//
//  PersonAddMgrVC.swift
//  PinPle
//
//  Created by seob on 2020/06/02.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class PersonAddMgrVC: UIViewController {
    
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwNoEmp: UIView!
     
    //    var empTuple: [(String, Int, String, UIImage, Int, String, String)] = []
    //    var fillterData: [(String, Int, String, UIImage, Int, String, String)] = []
    var empTuple : [PersonInfo] = []
    var fillterData : [PersonInfo] = []
    
    var imgData: [UIImage] = []
    
    var empsids = ""
    var auth = 0
    var temsid = 0
    var ttmsid = 0
     
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
        
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
        
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "CmpMgrVC") as! CmpMgrVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_CmpMgrVC") as! CmpMgrVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(회사 일반직원 리스트 - 관리자 제외)
         Return  - 회사 일반직원 리스트
         Parameter
         CMPSID        회사번호
         */
        empTuple.removeAll()
        NetworkManager.shared().getPerson_emplist(cmpsid: userInfo.cmpsid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                if serverData.count > 0 {
                    self.empTuple = serverData
                    self.fillterData = serverData
                    self.vwNoEmp.isHidden = true
                    
                }else {
                    self.vwNoEmp.isHidden = false
                }
                self.tblList.reloadData()
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
}

extension PersonAddMgrVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fillterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonMgrListCell", for: indexPath) as! PersonMgrListCell
        
        let enname = fillterData[indexPath.row].enname
        let name = fillterData[indexPath.row].name
        let profimg = fillterData[indexPath.row].profimg
        let spot = fillterData[indexPath.row].spot
        let author = fillterData[indexPath.row].author
        
//        let defaultProfimg = UIImage(named: "logo_pre")
//        if profimg.urlTrim() != "img_photo_default.png" {
//            cell.imgProfile.setImage(with: profimg)
//        }else{
//            cell.imgProfile.image = defaultProfimg
//        }
        
        cell.imgProfile.sd_setImage(with: URL(string: profimg), placeholderImage: UIImage(named: "logo_pre"))
//        if spot == "" {
//            cell.leadingConstraint.constant = -5
//        }
         
        
        if enname == "" {
            cell.lblName.text = name
        }else {
            cell.lblName.text = name + "(" + enname + ") "
        }
        cell.lblSpot.text = spot
        cell.btnCell.tag = indexPath.row
        cell.btnCell.addTarget(self, action: #selector(selectCell(_:)), for: .touchUpInside)
        
        return cell
    }
    // FIXME: 팝업
    @objc func selectCell(_ sender: UIButton) {
        let name = fillterData[sender.tag].name
        let empsids = String(fillterData[sender.tag].sid)
        
        DispatchQueue.main.async {
            let vc = MoreSB.instantiateViewController(withIdentifier: "PersonAddMgrPopup") as! PersonAddMgrPopup
            vc.name = name.postPositionText(type: 0)
            vc.empsids = empsids
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
}

    // MARK:  - UISearchBarDelegate
extension PersonAddMgrVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fillterData = searchText.isEmpty ? empTuple : empTuple.filter({ (res) -> Bool in
            return res.name.range(of: searchText, options: .caseInsensitive) != nil
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

