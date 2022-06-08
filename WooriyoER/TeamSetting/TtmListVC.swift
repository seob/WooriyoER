//
//  TtmListVC.swift
//  PinPle
//
//  Created by WRY_010 on 17/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TtmListVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblNext: UILabel!
    @IBOutlet weak var tblList: UITableView!
    
    var tuple: [Ttmlist] = []
    
    var teamTuple: [(temflag: Bool, // 상위팀, 하위팀 구분 true. 상위팀 false. 하위팀
                    selflag: Bool,  // 선택 구분 true. 선택 false. 선택안됨
                    showflag: Bool, // 화면에 보임 구분 true. 보임 false. 숨김
                    empcnt: Int,    // 팀 소속 직원 수
                    mgrcnt: Int,    // 팀 관리자 수
                    name: String,   // 팀 이름
                    ttmsid: Int,    // 상위팀 번호 0. 상위팀 미소속
                    temsid: Int     // 하위팀 번호 0. 상위팀자체일때
                    )] = []
    
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
    // MARK: - view override
    override func viewDidLoad() {
        print("\n-----------------[UIViewController : \(self) ]---------------------\n")
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        
        super.viewDidLoad()
        
        EnterpriseColor.eachLblBtn(btnNext, lblNext)
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.separatorStyle = .none
        
        viewflag = "TtmListVC"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = TmCrtSB.instantiateViewController(withIdentifier: "TtmCmpltVC") as! TtmCmpltVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func next(_ sender: UIButton) {
        let vc = TmCrtSB.instantiateViewController(withIdentifier: "ExcldWorkVC") as! ExcldWorkVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func valueSetting() {
        /*
         Pinpl Android SmartPhone APP으로부터 요청받은 데이터 처리(상위팀 리스트 - 소속팀 포함).. 페이징 없음
         Return  - 상위팀 리스트(소속팀 포함)
         Parameter
         CMPSID        회사번호
         */
        teamTuple.removeAll()
        let cmpsid = CompanyInfo.sid
        
        IndicatorSetting()
        NetworkManager.shared().CmpTtmlist(cmpsid: cmpsid) { (isSuccess, error, resData) in
            if (isSuccess) {
                if error == 1 {
                    guard let serverData = resData else { return }
                    self.tuple = serverData
                    if self.tuple.count > 0 {
                        for i in 0...self.tuple.count-1 {
                            self.teamTuple.append((temflag: true,
                                                   selflag: true,
                                                   showflag: true,
                                                   empcnt: self.tuple[i].empcnt,
                                                   mgrcnt: self.tuple[i].mgrcnt,
                                                   name: self.tuple[i].name,
                                                   ttmsid: self.tuple[i].sid,
                                                   temsid: 0))
                            
                            if self.tuple[i].temlist.count > 0 {
                                for j in 0...self.tuple[i].temlist.count - 1 {
                                    self.teamTuple.append((temflag: false,
                                                           selflag: true,
                                                           showflag: true,
                                                           empcnt: self.tuple[i].temlist[j].temempcnt,
                                                           mgrcnt: self.tuple[i].temlist[j].temmgrcnt,
                                                           name: self.tuple[i].temlist[j].temname,
                                                           ttmsid: self.tuple[i].sid,
                                                           temsid: self.tuple[i].temlist[j].temsid))
                                }
                            }
                        }
                    }
                    self.tblList.reloadData()
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

extension TtmListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamTuple.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !teamTuple[indexPath.row].showflag {
            return 0
        }
        return 78
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if teamTuple[indexPath.row].0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TTeamCell") as!  TTeamCell
            let data = teamTuple[indexPath.row]
            let empcnt = data.empcnt
            let mgrcnt = data.mgrcnt
            let name = data.name
            let selflag = data.selflag
            
            cell.lblName.text = name
            cell.lblManager.text = "\(mgrcnt)"
            cell.lblMember.text = "\(empcnt)"
            
            if selflag {
                cell.imgBox.image = UIImage.init(named: "box_team_grey")
            }else {
                cell.imgBox.image = UIImage.init(named: "box_team_white")
            }
            cell.btnCell.tag = indexPath.row
            cell.btnCell.addTarget(self, action: #selector(self.temShow(_:)), for: .touchUpInside)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamCell
            let data = teamTuple[indexPath.row]
            let temempcnt = data.empcnt
            let temmgrcnt = data.mgrcnt
            let temname = data.name
            
            cell.lblName.text = temname
            cell.lblManager.text = "\(temmgrcnt)"
            cell.lblMember.text = "\(temempcnt)"
            
            return cell
        }
    }
    @objc func temShow(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print("\n---------- [ sender.isSelected = \(sender.isSelected) ] ----------\n")
        teamTuple[sender.tag].selflag = !sender.isSelected
        let ttmsid = teamTuple[sender.tag].ttmsid
        for i in 0...teamTuple.count - 1 {
            if teamTuple[i].ttmsid == ttmsid && teamTuple[i].temsid != 0 {
                teamTuple[i].showflag = !sender.isSelected
            }
        }
        tblList.reloadData()
        
    }
    
}
