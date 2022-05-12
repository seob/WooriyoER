//
//  TtmCmpltVC.swift
//  PinPle
//
//  Created by WRY_010 on 17/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TtmCmpltVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblTTName: UILabel!
    @IBOutlet weak var tblTeamList: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    
    
    var tuple: [TemInfo] = []
    
    var ttmname: String = ""
    var ttmsid: Int = 0
    
    var curkey: Int = 0
    let listcnt: Int = 30
    var nextkey: Int = 0
    var tmpTotal: Int = 0
    var fetchingMore: Bool = false
    var teamsids: String = ""
    
    var selectedArray : [IndexPath] = [IndexPath]()
    
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
        prefs.setValue(13, forKey: "stage")
        btnSave.layer.cornerRadius = 6
        if let tmpttmsid = prefs.value(forKey: "crt_ttmsid") as? Int {
            self.ttmsid = tmpttmsid
        }
        if let tmpttmname = prefs.value(forKey: "crt_ttmname") as? String {
            self.ttmname = tmpttmname
        }        
        
        lblTTName.text = ttmname
        
        tblTeamList.delegate = self
        tblTeamList.dataSource = self
        
        tblTeamList.allowsMultipleSelectionDuringEditing = true
        tblTeamList.allowsMultipleSelection = true
        tblTeamList.setEditing(false, animated: false)
//        tblTeamList.setEditing(true, animated: false)
        tblTeamList.rowHeight = UITableView.automaticDimension
        tblTeamList.separatorStyle = .none
        
        tblTeamList.register(UINib.init(nibName: "TeamListTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamListTableViewCell")
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // 뷰가 나타나는 시점 거의 두 번째
        valueSetting()
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = TmCrtSB.instantiateViewController(withIdentifier: "TtmCrtVC") as! TtmCrtVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func next(_ sender: UIButton) {        
        if let selectRow = tblTeamList.indexPathsForSelectedRows {
            for i in 0...selectRow.count-1 {
                print(selectRow[i])
                if i == selectRow.count-1 {
                    teamsids = teamsids + "\(tuple[selectRow[i].row].sid)"
                }else{
                    teamsids = teamsids + "\(tuple[selectRow[i].row].sid)" + ","
                }
                print("teamsids = ", teamsids)
            }
             print("\n---------- [ selectedArray: \(selectedArray) ] ----------\n")
            IndicatorSetting()
            NetworkManager.shared().AddTeam(temsids: teamsids, ttmsid: ttmsid) { (isSuccess, error, result) in
                if (isSuccess) {
                    if error == 1 {
                        if result > 0 {
                            let vc = TmCrtSB.instantiateViewController(withIdentifier: "TtmListVC") as! TtmListVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false, completion: nil)
                        }
                    }else {
                       self.customAlertView("다시 시도해 주세요.")
                    }
                }else {
                    self.customAlertView("네트워크 상태를 확인해 주세요.")
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }
        }else{
//            let alert = UIAlertController(title: "알림", message: "팀을 선택하세요", preferredStyle: UIAlertController.Style.alert)
//            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//            let cancel = UIAlertAction(title: "다음에하기", style: .default, handler: { action in
//                let vc = TmCrtSB.instantiateViewController(withIdentifier: "TtmListVC") as! TtmListVC
//                vc.modalTransitionStyle = .crossDissolve
//                vc.modalPresentationStyle = .overFullScreen
//                self.present(vc, animated: false, completion: nil)
//            })
//            alert.addAction(cancel)
//            alert.addAction(okAction)
//            self.present(alert, animated: false, completion: nil)
            let vc = TmCrtSB.instantiateViewController(withIdentifier: "TtmListVC") as! TtmListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    func valueSetting() {
        let cmpsid = CompanyInfo.sid
        
        IndicatorSetting()
        NetworkManager.shared().FreeTemlist(cmpsid: cmpsid, curkey: curkey, listcnt: listcnt) { (isSuccess, error, resData, resNextkey) in
            if (isSuccess) {
                if error == 1 {
                    if let serverData = resData {
                        self.tmpTotal = serverData.count
                        if serverData.count > 0 {
                            for i in 0...serverData.count - 1{
                                self.tuple.append(serverData[i])
                            }
                        }
                        self.tblTeamList.reloadData()
                    }
                }else {
                    self.customAlertView("다시 시도해 주세요.")
                }
            }else {
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
        }
    }
}



extension TtmCmpltVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tuple.count
        }else if section == 1 && !fetchingMore {
            if tuple.count == listcnt {
                return 0
            }
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && listcnt != tmpTotal {
            return 0
        }
        return 58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListCell") as!  TeamListCell
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            let name = tuple[indexPath.row].name
            
            cell.lblTeamName.text = name
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TTCLoadingCell", for: indexPath) as! TTCLoadingCell
            if self.tuple.count == self.tmpTotal {
                cell.indicator.startAnimating()
            }else{
                let cellFrame = cell.contentView.frame
                cell.isHidden = true
                cell.contentView.frame.size = .init(width: cellFrame.width, height: 0)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       _ = tableView.cellForRow(at: indexPath) as! TeamListCell

       if(!selectedArray.contains(indexPath))
       {
           selectedArray.append(indexPath)
       }
       else
       {
           selectedArray.removeLast()
       }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableHeight = tblTeamList.frame.height
        
        if offsetY + tableHeight > contentHeight + 50 {
            
            if !fetchingMore {
                beginBatchFetch()
            }
        }
        
    }
    func beginBatchFetch() {
        fetchingMore = true
        tblTeamList.reloadSections(IndexSet(integer: 1), with: .none)
        if self.tuple.count == self.tmpTotal {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.curkey = self.nextkey
                let selectRow = self.tblTeamList.indexPathsForSelectedRows
                self.fetchingMore = false
                self.valueSetting()
                if selectRow != nil {
                    for i in 0...selectRow!.count-1{
                        self.tblTeamList.selectRow(at: selectRow![i], animated: false, scrollPosition: .none)
                    }
                }
            })
        }
    }
    
    
}
