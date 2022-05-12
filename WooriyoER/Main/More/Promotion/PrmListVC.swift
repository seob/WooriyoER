//
//  PrmListVC.swift
//  PinPle
//
//  Created by WRY_010 on 07/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class PrmListVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var lblSEtext: UILabel!
    
    var tuple: [AnualInfo] = []
    
    var rmnDay: Int = 0
    var rmnHour: Int = 0
    var rmnMin: Int = 0    
    
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
        
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.allowsMultipleSelectionDuringEditing = true
        tblList.rowHeight = UITableView.automaticDimension
        tblList.separatorStyle = .none
        
        lblSEtext.adjustsFontSizeToFitWidth = true
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // 뷰가 나타나는 시점 거의 두 번째
        valueSetting()
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "AnlAprSetVC" {
            let vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlAprSetVC") as! AnlAprSetVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(연차촉진 관리직원 리스트 - 회사, 상위팀, 팀 같이 이용) .. 페이징 없음
         Return  - 회사 연차촉진 관리직원 리스트
         Parameter
         CMPSID        회사번호 .. 상위팀번호, 팀번호는 0 또는 안보냄
         TTMSID        상위팀번호.. 회사번호, 팀번호는 0 또는 안보냄
         TEMSID        팀번호.. 회사번호, 상위팀번호는 0 또는 안보냄
         */
        //        let author = prefs.value(forKey: "author") as! Int
        //        let cmpsid = prefs.value(forKey: "cmpsid") as! Int
        //        let ttmsid = prefs.value(forKey: "ttmsid") as! Int
        //        let temsid = prefs.value(forKey: "temsid") as! Int
        
        let author = userInfo.author
        let cmpsid = userInfo.cmpsid
        let ttmsid = userInfo.ttmsid
        let temsid = userInfo.temsid
        print("\n---------- [ cmpsid : \(userInfo.toJSON()) ] ----------\n")

        NetworkManager.shared().AnualAdviselist(author: author, cmpsid: cmpsid, ttmsid: ttmsid, temsid: temsid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                self.tuple = serverData
                self.tblList.reloadData()
                if self.tuple.count > 0 {
                    self.lblText.isHidden = true
                }else {
                    self.lblText.isHidden = false
                }
                self.tblList.reloadData()
            }else {
                self.customAlertView("네트워크 상태를 확인해주세요.")
            }
        }
    }
    
    func timeSet(_ time: Int) {
        rmnDay = time/(8*60)
        rmnHour = (time%(8*60))/60
        rmnMin = (time%(8*60))%(60)
        print(rmnDay, rmnHour, rmnMin)
        
    }
    
}

extension PrmListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tuple.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let device = deviceHeight()
        switch device {
        case 3 , 5:
            return 120
        default :
            return 115
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrmListCell") as!  PrmListCell
        
        
        
        let clearday = tuple[indexPath.row].clearday
        //                let empsid = tuple[indexPath.row].empsid
        let enname = tuple[indexPath.row].enname
        //                let joindt = tuple[indexPath.row].joindt
        //                let mbrsid = tuple[indexPath.row].mbrsid
        let name = tuple[indexPath.row].name
        let profimg = tuple[indexPath.row].profimg
        let remain = tuple[indexPath.row].remain
        //                let sid = tuple[indexPath.row].anlsid
        let spot = tuple[indexPath.row].spot
        let tname = tuple[indexPath.row].tname
        
        timeSet(remain)
    
        cell.imgProfile.sd_setImage(with: URL(string: profimg), placeholderImage: UIImage(named: "logo_pre"))
        cell.lblSpot.text = spot
        if enname == "" {
            cell.lblName.text = name
        }else {
            cell.lblName.text = name + "(" + enname + ")"
        }
        cell.lblTeam.text = tname
        cell.lblDay.text = String(rmnDay)
        cell.lblHour.text = String(rmnHour)
        cell.lblMin.text = String(rmnMin)
        cell.lblDelDay.text = String(clearday)
        cell.btnCell.tag = indexPath.row
        cell.btnCell.addTarget(self, action: #selector(selectCell(_:)), for: .touchUpInside)
        return cell
        
    }
    @objc func selectCell(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "SendMsgVC") as! SendMsgVC
        
        vc.AnualInfo = self.tuple[sender.tag]
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
}


