//
//  CmpAprMgrListVC.swift
//  PinPle
//
//  Created by WRY_010 on 01/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmpAprMgrListVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var btnOk: UIButton!
    
    var empTuple: [(author: Int, enname: String, mbrsid: Int, name: String, profimg: String, sid: Int, spot: String, tname:String)] = []
    var fillterData: [(author: Int, enname: String, mbrsid: Int, name: String, profimg: String, sid: Int, spot: String, tname:String)] = []
    
    var selflag:Int = 0
    var selApr: Bool = false // true. 연차 false. 근로
    
    // MARK: - IndicatorSetting
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    fileprivate func IndicatorSetting() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnOk)
        tblList.delegate = self
        tblList.dataSource = self
        searchbar.delegate = self
        
        tblList.separatorStyle = .none
        tblList.allowsSelection = true
        tblList.allowsSelectionDuringEditing = true
        tblList.rowHeight = UITableView.automaticDimension
        
        tblList.register(UINib.init(nibName: "CommonCmpAprMgrListNewCell", bundle: nil), forCellReuseIdentifier: "CommonCmpAprMgrListNewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
        
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "CmpAnlAprVC") as!CmpAnlAprVC
        vc.selApr = self.selApr
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(회사전채 관리자리스트 - 대표포함)
         Return  - 무소속 직원리스트(대표 제외) .. 페이징 없음(검색처리를 위해 모든데이터 한번에 줌) .. Sorting 권한 순
         Parameter
         CMPSID        회사번호
         */
        empTuple.removeAll()
//        IndicatorSetting()
        NetworkManager.shared().CmpMgrlist(cmpsid: userInfo.cmpsid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else {
                    return
                }
                if serverData.count > 0 {
                    for i in 0...serverData.count - 1 {
                        self.empTuple.append((serverData[i].author,
                                              serverData[i].enname,
                                              serverData[i].mbrsid,
                                              serverData[i].name,
                                              serverData[i].profimg,
                                              serverData[i].sid,
                                              serverData[i].spot,
                                              serverData[i].tname))
                    }
                }
                self.fillterData = self.empTuple
                self.tblList.reloadData()
            }else {
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//                self.stopAnimating(nil)
//            }
        }
    }
    @IBAction func save(_ sender: UIButton) {
        var empsid = 0
        var name = ""
        var spot = ""
 
        if tblList.indexPathForSelectedRow?.row != nil {
            empsid = fillterData[tblList.indexPathForSelectedRow!.row].sid
            name = fillterData[tblList.indexPathForSelectedRow!.row].name
            spot = fillterData[tblList.indexPathForSelectedRow!.row].spot
        }
               
        switch selflag {
        case 1:
            SelAprInfo.apr1empsid = empsid
            SelAprInfo.apr1name = name
            SelAprInfo.apr1spot = spot
        case 2:
            SelAprInfo.apr2empsid = empsid
            SelAprInfo.apr2name = name
            SelAprInfo.apr2spot = spot
        case 3:
            SelAprInfo.apr3empsid = empsid
            SelAprInfo.apr3name = name
            SelAprInfo.apr3spot = spot
        case 4:
            SelAprInfo.ref1empsid = empsid
            SelAprInfo.ref1name = name
            SelAprInfo.ref1spot = spot
        case 5:
            SelAprInfo.ref2empsid = empsid
            SelAprInfo.ref2name = name
            SelAprInfo.ref2spot = spot
        default:
            break
        }
        
        let vc = MoreSB.instantiateViewController(withIdentifier: "CmpAnlAprVC") as!CmpAnlAprVC
        vc.selApr = self.selApr
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}

extension CmpAprMgrListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fillterData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CmpAprMgrListCell", for: indexPath) as! CmpAprMgrListCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonCmpAprMgrListNewCell", for: indexPath) as! CommonCmpAprMgrListNewCell
        cell.selectionStyle = .none
        let EmpIndexPath = fillterData[indexPath.row]
        let author = EmpIndexPath.author
        let enname = EmpIndexPath.enname
        let name = EmpIndexPath.name
        let profimg = EmpIndexPath.profimg
        let sid = EmpIndexPath.sid
        let spot = EmpIndexPath.spot
        
        var aprEmpsid = 0
        
        if spot == "" {
            cell.leadingConstraints.constant = -5
        }
        
        
        switch selflag {
        case 1:
            aprEmpsid = SelAprInfo.apr1empsid
        case 2:
            aprEmpsid = SelAprInfo.apr2empsid
        case 3:
            aprEmpsid = SelAprInfo.apr3empsid
        case 4:
            aprEmpsid = SelAprInfo.ref1empsid
        case 5:
            aprEmpsid = SelAprInfo.ref2empsid
        default:
            break
        }
        
        if sid == aprEmpsid {
            tblList.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            prefs.setValue(indexPath.row, forKey: "indexPath")
        }
        
//        if profimg.urlTrim() != "img_photo_default.png" {
//            cell.imgProfile.setImage(with: profimg)
//        }else {
//            cell.imgProfile.image = UIImage(named: "logo_pre")
//        }
        
        
        cell.imgProfile.sd_setImage(with: URL(string: profimg), placeholderImage: UIImage(named: "logo_pre"))
        
        var authorImg = UIImage()
        switch author {
        case  0 :
            authorImg = UIImage.init(named: "master_puple")!
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
          
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selIndexPath = -1
        if prefs.value(forKey: "indexPath") != nil {
            selIndexPath = prefs.value(forKey: "indexPath") as! Int
        }

        if selIndexPath == indexPath.row {
            tableView.deselectRow(at: indexPath, animated: false)
            prefs.removeObject(forKey: "indexPath")
        }else {
            prefs.setValue(indexPath.row, forKey: "indexPath")
        }
 
    }
    
    
}

extension CmpAprMgrListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fillterData = searchText.isEmpty ? empTuple : empTuple.filter({ (arg0) -> Bool in
            
            let (_, _, _, name, _, _, _, _) = arg0
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
