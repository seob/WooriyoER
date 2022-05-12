//
//  PinPlNoticeVC.swift
//  PinPle
//
//  Created by seob on 2022/01/26.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit

class PinPlNoticeVC: UIViewController {
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet weak var vwNoApr: UIView!
    @IBOutlet weak var noResultmsg: UILabel!
    
    @IBOutlet weak var btnWork: UIButton!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var btnNotWork: UIButton!
    @IBOutlet weak var lblNotWork: UILabel!
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    var clickFlag: Bool = false
    var isWooriyoSelected: Int = 0
    var isPinPlSelected: Int = 0
    var wooriyoList : [NoticeListInfo] = []
    var pinplList : [NoticeListInfo] = []
    var fetchingMore = false
    var noticeoff = 0
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btn_plus"), for: .normal)
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func fabTapped(_ sender: UIButton){
        
        if checkmultiarea(){ 
            let vc = MainSB.instantiateViewController(withIdentifier: "NoticeMonthPopVC") as! NoticeMonthPopVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            viewflag = "moreEextension"
            vc.checkEextension = noticeoff
            self.present(vc, animated: false, completion: nil)
        }else{
            faButton.removeFromSuperview()
            let vc = MainSB.instantiateViewController(withIdentifier: "RegNoticeVC") as! RegNoticeVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
            
        }
        
    }
    
    func checkmultiarea() -> Bool {
        switch moreCmpInfo.freetype {
        case 2,3:
            // 올프리 , 펀프리
            if moreCmpInfo.freedt >= muticmttodayDate() {
                return false
            }else{
                if moreCmpInfo.notice >= muticmttodayDate() {
                    return false
                }else{
                    return true
                }
            }
        default:
            //핀프리 , 사용안함
            if moreCmpInfo.notice >= muticmttodayDate() {
                return false
            }else{
                return true
            }
        }
    }
    
    
    func setupButton() {
        NSLayoutConstraint.activate([
            faButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            faButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            faButton.heightAnchor.constraint(equalToConstant: 60),
            faButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        faButton.layer.cornerRadius = 30
        faButton.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CompanyInfo.notice >= muticmttodayDate() {
            noticeoff = 1
        }else{
            noticeoff = 0
        }
        setUi()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reloadNotice, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let view = UIApplication.shared.keyWindow {
            view.addSubview(faButton)
            setupButton()
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let view = UIApplication.shared.keyWindow, faButton.isDescendant(of: view) {
            faButton.removeFromSuperview()
        }
    }
    
    // MARK: reloadTableData
    @objc func reloadTableData(_ notification: Notification) {
        clickFlag = true
        lblWork.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
        lblNotWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        
        if noticeType == 0 {
            if isWooriyoSelected == 0 {
                getWooriyoNotice()
                getPinPlNotice()
            }else  if isPinPlSelected == 0 {
                getWooriyoNotice()
            }else{
                getPinPlNotice()
            }
        }else{
            if noticeType == 1 {
                isWooriyoSelected = 1
                getWooriyoNotice()
            }else if noticeType == 2 {
                isPinPlSelected = 1
                getPinPlNotice()
            }
        }
    }
    
    func setUi(){
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.rowHeight = UITableView.automaticDimension
        tblList.separatorStyle = .none
        tblList.backgroundColor = .clear
        tabbarheight(tblList)
        tblList.register(UINib.init(nibName: "NoticeListTableViewCell", bundle: nil), forCellReuseIdentifier: "NoticeListTableViewCell")
        
        
        vwNoApr.isHidden = true
        
//        btnWork.setImage(UIImage(named: "btn_tab_select"), for: .selected)
//        btnWork.setImage(UIImage(named: "gray_square"), for: .normal)
//        btnNotWork.setImage(UIImage(named: "btn_tab_select"), for: .selected)
//        btnNotWork.setImage(UIImage(named: "gray_square"), for: .normal)
        
        btnWork.isSelected = true
        btnNotWork.isSelected = false
        
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clickFlag = true
        lblWork.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
        lblNotWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        
        if noticeType == 0 {
            if isWooriyoSelected == 0 {
                getWooriyoNotice()
                getPinPlNotice()
            }else  if isPinPlSelected == 0 {
                getWooriyoNotice()
            }else{
                getPinPlNotice()
            }
        }else{
            if noticeType == 1 {
                isWooriyoSelected = 1
                getWooriyoNotice()
            }else if noticeType == 2 {
                isPinPlSelected = 1
                getPinPlNotice()
            }
        }
        
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    // MARK: - 사내 공지
    func getWooriyoNotice(){
        NetworkManager.shared().getNotice(empsid: userInfo.empsid) { isSuccess, resData in
            if isSuccess {
                guard let serverData = resData else { return }
                self.pinplList = serverData
                self.tblList.reloadData()
            }
        }
    }
    
    // MARK: - 핀플 공지
    func getPinPlNotice(){
        
        NetworkManager.shared().getMasterNotice(empsid: userInfo.empsid) { isSuccess, resData in
            if isSuccess {
                guard let serverData = resData else { return }
                self.wooriyoList = serverData
                self.tblList.reloadData()
            }
        }
    }
    
    // 사내 공지
    @IBAction func offShow(_ sender: UIButton) {
        isWooriyoSelected = 1
        if isWooriyoSelected == 1 {
            wooriyoList.removeAll()
        }
        
        getWooriyoNotice()
        clickFlag = true
        btnWork.isSelected = true
        btnNotWork.isSelected = false
        lblWork.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
        lblNotWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        btnWork.backgroundColor = UIColor.rgb(r: 252, g: 202, b: 0)
        btnNotWork.backgroundColor = UIColor.rgb(r: 247, g: 247, b: 250)
        faButton.isHidden = false
    }
    
    // 핀플공지
    @IBAction func onShow(_ sender: UIButton) {
        isPinPlSelected = 1
        
        if isPinPlSelected == 1 {
            pinplList.removeAll()
        }
        
        getPinPlNotice()
        clickFlag = false
        btnWork.isSelected = false
        btnNotWork.isSelected = true
        
        faButton.isHidden = true
        lblNotWork.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
        lblWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        btnNotWork.backgroundColor = UIColor.rgb(r: 252, g: 202, b: 0)
        btnWork.backgroundColor = UIColor.rgb(r: 247, g: 247, b: 250)
    }
}


// MARK: - UITableViewDelegate
extension PinPlNoticeVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if clickFlag{
            if pinplList.count == 0 {
                vwNoApr.isHidden = false
                
            }else {
                vwNoApr.isHidden = true
            }
            return pinplList.count
            
        }else{
            if wooriyoList.count == 0 {
                vwNoApr.isHidden = false
            }else {
                vwNoApr.isHidden = true
            }
            return wooriyoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if clickFlag{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListTableViewCell", for: indexPath) as? NoticeListTableViewCell {
                cell.selectionStyle = .none
                let indexInfo = pinplList[indexPath.row]
                cell.lblTitle.text = "\(indexInfo.title)"
                cell.lblRegdt.text = "\(setJoinDate2(timeStamp: indexInfo.regdt))" + "\(setWeek(indexInfo.regdt))"
                if indexInfo.regdt >= todayDateKo() {
                    cell.newImageView.isHidden = false
                }else{
                    cell.newImageView.isHidden = true
                }
                return cell
            }
        }else{
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListTableViewCell", for: indexPath) as? NoticeListTableViewCell {
                cell.selectionStyle = .none
                let indexInfo = wooriyoList[indexPath.row]
                cell.lblTitle.text = "\(indexInfo.title)"
                cell.lblRegdt.text = "\(setJoinDate2(timeStamp: indexInfo.regdt))" + "\(setWeek(indexInfo.regdt))"
                if indexInfo.regdt >= todayDateKo() {
                    cell.newImageView.isHidden = false
                }else{
                    cell.newImageView.isHidden = true
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if clickFlag{
            let selinfo = pinplList[indexPath.row]
            let vc = MainSB.instantiateViewController(withIdentifier: "NoticeDetailVC") as! NoticeDetailVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.noticeDetail = selinfo
            vc.type = 1
            self.present(vc, animated: false, completion: nil)
        }else{
            let selinfo = wooriyoList[indexPath.row]
            let vc = MainSB.instantiateViewController(withIdentifier: "NoticeDetailVC") as! NoticeDetailVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.noticeDetail = selinfo
            vc.type = 2
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    func setWeek(_ str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: str)
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday], from: date!)
        var week = ""
        
        switch comps.weekday {
        case 1:
            week = "일";
        case 2:
            week = "월";
        case 3:
            week = "화";
        case 4:
            week = "수";
        case 5:
            week = "목";
        case 6:
            week = "금";
        case 7:
            week = "토";
        default:
            break;
        }
        
        return "(" + week + ")"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableHeight = tblList.frame.height
        
        if offsetY + tableHeight == contentHeight  {
            faButton.removeFromSuperview()
        }else{
            view.addSubview(faButton)
            setupButton()
        }
    }
}
