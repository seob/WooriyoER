//
//  MgmtMgrVC.swift
//  PinPle
//
//  Created by WRY_010 on 30/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class MgmtMgrVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwNoEmp: UIView!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var tuple: [EmplyInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.separatorStyle = .none
        tblList.rowHeight = UITableView.automaticDimension
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViewData), name: .reloadList, object: nil)
    }
    // MARK: reloadViewData
    @objc func reloadViewData(_ notification: Notification) {
        valueSetting()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblTeamName.text =  "'\(SelTemInfo.name)' 관리자"
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
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(상위팀관리자 리스트)
         Return  - 팀관리자 리스트 .. 페이징 없음(검색처리를 위해 모든데이터 한번에 줌) .. Sorting 이름 가나다 순
         Parameter
         TTMSID(TEMSID)        상위팀번호(팀번호)
         */
        NetworkManager.shared().TemMgrlist(temflag: SelTemFlag, ttmsid: SelTtmSid, temsid: SelTemSid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                self.tuple = serverData
                if serverData.count > 0 {
                    self.vwNoEmp.isHidden = true
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
extension MgmtMgrVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tuple.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MgrListCell", for: indexPath) as! MgrListCell
        let author = tuple[indexPath.row].author
        let enname = tuple[indexPath.row].enname
        let name = tuple[indexPath.row].name
        let profimg = tuple[indexPath.row].profimg
        let spot = tuple[indexPath.row].spot
        
        
        if spot == "" {
            cell.leadingConstraints.constant = -5
        }
        
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
        
        if profimg.urlTrim() != "img_photo_default.png" {
            cell.imgProfile.setImage(with: profimg)
        }else {
            cell.imgProfile.image = UIImage(named: "logo_pre")
        }
        
        cell.lblName.text = name
        
        if enname == "" {
            cell.lblEname.text = ""
        }else {
            cell.lblEname.text = " (" + enname + ") "
        }
        cell.imgMgr.image = authorImg
        cell.lblSpot.text = spot
        
        cell.btnCell.tag = indexPath.row
        cell.btnCell.addTarget(self, action: #selector(selectCell(_:)), for: .touchUpInside)
        return cell
    }
    @objc func selectCell(_ sender: UIButton) {
        SelEmpInfo = tuple[sender.tag]
        let vc = MoreSB.instantiateViewController(withIdentifier: "MgmtMgrPopUp") as! MgmtMgrPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
}
