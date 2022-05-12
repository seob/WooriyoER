//
//  AddCmpMgrVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/11/08.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AddCmpMgrVC: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwNoEmp: UIView!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    //    var empTuple: [(String, Int, String, UIImage, Int, String, String)] = []
    //    var fillterData: [(String, Int, String, UIImage, Int, String, String)] = []
    var empTuple : [EmplyInfo] = []
    var fillterData : [EmplyInfo] = []
    
    var imgData: [UIImage] = []
    
    var empsids = ""
    var auth = 0
    var temsid = 0
    var ttmsid = 0
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
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
    
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        IndicatorSetting()
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
        NetworkManager.shared().getCmp_emplist(cmpsid: userInfo.cmpsid) { (isSuccess, resData) in
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
                //                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                //                    self.stopAnimating(nil)
                //                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
                //                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                //                    self.stopAnimating(nil)
                //                }
            }
        }
    }
    
}

extension AddCmpMgrVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fillterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCmpMgrListCell", for: indexPath) as! AddCmpMgrListCell
        
        let enname = fillterData[indexPath.row].enname
        let name = fillterData[indexPath.row].name
        let profimg = fillterData[indexPath.row].profimg
        let spot = fillterData[indexPath.row].spot
        let author = fillterData[indexPath.row].author
        
        let defaultProfimg = UIImage(named: "logo_pre")
        if profimg.urlTrim() != "img_photo_default.png" {
            cell.imgProfile.setImage(with: profimg)
        }else{
            cell.imgProfile.image = defaultProfimg
        }
        
        
        if spot == "" {
            cell.leadingConstraints.constant = -5
        }
        
        var authorImg = UIImage()
        switch author { 
        case 1:
            authorImg = UIImage.init(named: "master_red")!;
        case 2:
            authorImg = UIImage.init(named: "master_blue")!;
        case 3, 4:
            authorImg = UIImage.init(named: "master_green")!;
        default:
            break;
        }
        cell.imgMgr.image = authorImg
        
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
            let vc = MoreSB.instantiateViewController(withIdentifier: "AddCmpMgrPopUp") as! AddCmpMgrPopUp
            vc.name = name.postPositionText(type: 0)
            vc.empsids = empsids
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
}

// MARK:  - UISearchBarDelegate
extension AddCmpMgrVC: UISearchBarDelegate {
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
