//
//  AflTemVC.swift
//  PinPle
//
//  Created by WRY_010 on 08/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AflTemVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblTTName: UILabel!
    @IBOutlet weak var tblTeamList: UITableView!
    @IBOutlet weak var btnOk: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var tuple: [TemInfo] = []
    
    var tname: String = ""
    var ttmsid: Int = 0
    
    var curkey = 0
    let listcnt = 30
    var totalcnct = 10
    var nextkey = 0
    let cellHeight = 48
    var fetchingMore = false
    var teamsids = ""
    var selectedArray : [IndexPath] = [IndexPath]()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOk.layer.cornerRadius = 6
        lblTTName.text = tname
        
        tblTeamList.delegate = self
        tblTeamList.dataSource = self
        
        tblTeamList.allowsMultipleSelectionDuringEditing = true
        tblTeamList.allowsMultipleSelection = true
        tblTeamList.setEditing(false, animated: false)
//        tblTeamList.setEditing(true, animated: false)
        tblTeamList.rowHeight = UITableView.automaticDimension
        tblTeamList.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // 뷰가 나타나는 시점 거의 두 번째
        valueSetting()
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(상위팀에 소속되지않은 팀리스트.. 상위팀에서 팀추가 할 때 목록)
         Return  - 팀정보
         Parameter
         CMPSID        회사번호
         CURKEY        페이징 키(첫 페이지는 0 또는 안넘김)
         LISTCNT        리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
         */
        NetworkManager.shared().FreeTemlist(cmpsid: userInfo.cmpsid, curkey: curkey, listcnt: listcnt) { (isSuccess, error, resData, resKey) in
            if (isSuccess) {
                if error == 1 {
                    guard let serverData = resData else { return }
                    self.tuple = serverData
                    self.nextkey = resKey
                    self.tblTeamList.reloadData()
                }else {
                    self.customAlertView("다시 시도해 주세요.")
                }
            }else {
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(상위팀 소속팀 추가)
         Return  - 성공:설정완료 카운트, 실패:0
         Parameter
         TEMSIDS        팀번호들(구분자',')
         TTMSID        상위팀번호
         */
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
            NetworkManager.shared().AddTeam(temsids: teamsids, ttmsid: ttmsid) { (isSuccess, error, resultCode) in
                if (isSuccess) {
                    if error == 1 {
                        if resultCode > 0 {
                            let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false, completion: nil)
                        }else {
                            self.customAlertView("잠시 후, 다시 시도해 주세요.")
                        }
                    }else {
                        self.customAlertView("다시 시도해 주세요.")
                    }
                }else{
                    self.customAlertView("네트워크 상태를 확인해 주세요.")
                }                
            }
        }else{
//            let alert = UIAlertController(title: "알림", message: "팀을 선택하세요", preferredStyle: UIAlertController.Style.alert)
//            let okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
//            alert.addAction(okAction)
//            self.present(alert, animated: false, completion: nil)
            let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    
}



extension AflTemVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return tuple.count
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListCell") as!  TeamListCell
        if indexPath.section == 0 {
            let name = tuple[indexPath.row].name
            cell.lblTeamName.text = name
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TTCLoadingCell", for: indexPath) as! TTCLoadingCell
            if self.tuple.count == self.totalcnct {
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
        print("beginBatchFetch!")
        tblTeamList.reloadSections(IndexSet(integer: 1), with: .none)
        if self.tuple.count == self.totalcnct {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.curkey = self.nextkey
                self.valueSetting()
                print("willDisplay-------------nextkey------------")
                print(self.nextkey)
                self.totalcnct = self.totalcnct + self.listcnt
                let selectRow = self.tblTeamList.indexPathsForSelectedRows
                self.fetchingMore = false
                self.tblTeamList.reloadData()
                if selectRow != nil {
                    for i in 0...selectRow!.count-1{
                        self.tblTeamList.selectRow(at: selectRow![i], animated: false, scrollPosition: .none)
                    }
                }
            })
        }
    }
    
    
}
