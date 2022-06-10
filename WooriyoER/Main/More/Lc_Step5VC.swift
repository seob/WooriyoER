//
//  Lc_Step5VC.swift
//  PinPle
//
//  Created by seob on 2020/06/09.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Lc_Step5VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    
    @IBOutlet weak var oneSection: UIView!
    @IBOutlet weak var twoSection: UIView!
    @IBOutlet weak var threeSection: UIView!
    @IBOutlet weak var fourSection: UIView!
    @IBOutlet weak var fiveSection: UIView!
    @IBOutlet weak var sixSection: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollinView: UIView!
    
    //mainTextView
    @IBOutlet weak var firstTextView: UITextView!
    @IBOutlet weak var twoTextView: UITextView!
    @IBOutlet weak var threeTextView: UITextView!
    @IBOutlet weak var fourTextView: UITextView!
    
    //uiswitch
    @IBOutlet weak var oneSwitch: UISwitch!
    @IBOutlet weak var twoSwitch: UISwitch!
    @IBOutlet weak var threeSwitch: UISwitch!
    @IBOutlet weak var fourSwitch: UISwitch!
    
    //sixSection btn
    @IBOutlet weak var directBtn: UIButton!
    @IBOutlet weak var IndirectBtn: UIButton!
    @IBOutlet weak var directBtnImg: UIImageView!
    @IBOutlet weak var IndirectBtnImg: UIImageView!
    
    @IBOutlet weak var btnnatinal: UIButton!
    @IBOutlet weak var btnhealth: UIButton!
    @IBOutlet weak var btnfour: UIButton!
    @IBOutlet weak var btnindustrial: UIButton!
    
    @IBOutlet weak var stepDot1: UIImageView!
    @IBOutlet weak var stepDot2: UIImageView!
    @IBOutlet weak var stepDot3: UIImageView!
    @IBOutlet weak var stepDot4: UIImageView!
    @IBOutlet weak var stepDot5: UIImageView!
    @IBOutlet weak var stepDot6: UIImageView!
    
    //bottom btn
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    var isdelivery : Bool = true
    var isanual : Bool = true
    var isother : Bool = true
    var issocial : Bool = true
    var socialinsrn: String = "1,2,3,4" //사회보험
    var selInfo : LcEmpInfo = LcEmpInfo()
    
    var delivery = "" //근로계약서 교뷰
    var anual = "" //연차유급 휴가
    var other = "" // 기타사항
    var payday = "" // 임금 지급일
    
    let toggleTwo = ToggleSwitch(with: images) //연차유급휴가 스위치
    let toggleThree = ToggleSwitch(with: images) //근로계약서 스위치
    let toggleFour = ToggleSwitch(with: images) //기타 스위치
    var switchYposition:CGFloat = 0
    
    fileprivate func setUi() {
        
        if view.bounds.width == 414 {
            switchYposition = 340
        }else if view.bounds.width == 375 {
            switchYposition = 300
        }else if view.bounds.width == 390 {
            // iphone 12 pro
            switchYposition = 310
        }else if view.bounds.width == 320 {
            // iphone se
            switchYposition = 240
        }else {
            switchYposition = 340
        }
        toggleTwo.frame.origin.x = switchYposition
        toggleTwo.frame.origin.y = -5
         
        toggleThree.frame.origin.x = switchYposition
        toggleThree.frame.origin.y = -5
        
        toggleFour.frame.origin.x = switchYposition
        toggleFour.frame.origin.y = -5
        
        self.threeSection.addSubview(toggleTwo)
        self.fourSection.addSubview(toggleThree)
        self.fiveSection.addSubview(toggleFour)
        
        toggleTwo.addTarget(self, action: #selector(toggleTwoChanged), for: .valueChanged)
        toggleThree.addTarget(self, action: #selector(toggleThreeChanged), for: .valueChanged)
        toggleFour.addTarget(self, action: #selector(toggleFourChanged), for: .valueChanged)
        
        addToolBar(textViews: [firstTextView , twoTextView , threeTextView , fourTextView])
        
        btnnatinal.setBackgroundImage(btnRoundOn, for: .selected)
        btnnatinal.setBackgroundImage(btnRoundOff, for: .normal)
        
        
        btnhealth.setBackgroundImage(btnRoundOn, for: .selected)
        btnhealth.setBackgroundImage(btnRoundOff, for: .normal)
        
        
        btnfour.setBackgroundImage(btnRoundOn, for: .selected)
        btnfour.setBackgroundImage(btnRoundOff, for: .normal)
        
        
        btnindustrial.setBackgroundImage(btnRoundOn, for: .selected)
        btnindustrial.setBackgroundImage(btnRoundOff, for: .normal)
        
        
        delivery = selInfo.delivery
        anual = selInfo.anual
        other = selInfo.other
        payday = selInfo.payday
        
        if delivery == "" {
            if twoTextView.text == "" {
                twoTextView.text = defaultContractText
            }
            
            twoSwitch.isOn = false
            toggleTwo.setOn(on: false, animated: true)
        }else{
            twoTextView.text = delivery
        }
        
        
        if anual == "" {
            if threeTextView.text == "" {
                threeTextView.text = defaultAnualText
            }
            threeSwitch.isOn = false
            toggleThree.setOn(on: false, animated: true)
        }else{
            threeTextView.text = anual
        }
        
        if other == "" {
            if fourTextView.text == "" {
                fourTextView.text = defaultEtcText
            }
            fourSwitch.isOn = false
            toggleFour.setOn(on: false, animated: true)
        }else{
            fourTextView.text = other
        }
        
        
        if payday == "" {
            if firstTextView.text == "" {
                firstTextView.text = defaultPayDayText
            }
        }else{
            firstTextView.text = payday
        }
        
        var color: UIColor!
        if isdelivery{
            delivery = twoTextView.text ?? defaultContractText
            color = UIColor.black
            twoTextView.isEditable = true
            twoTextView.textColor = color
        }else{
            delivery = ""
            color = UIColor.gray
            twoTextView.isEditable = false
            twoTextView.textColor = color
        }
        
        if isanual{
            anual = threeTextView.text ?? defaultAnualText
            color = UIColor.black
            threeTextView.isEditable = true
            threeTextView.textColor = color
        }else{
            anual = ""
            color = UIColor.gray
            threeTextView.isEditable = false
            threeTextView.textColor = color
        }
        
        if isother{
            other = fourTextView.text ?? defaultPayDayText
            color = UIColor.black
            fourTextView.isEditable = true
            fourTextView.textColor = color
        }else{
            other = ""
            color = UIColor.gray
            fourTextView.isEditable = false
            fourTextView.textColor = color
        }
        
        socialinsrn = selInfo.socialinsrn
        btnnatinal.isSelected = socialinsrn.contains("1")
        btnhealth.isSelected = socialinsrn.contains("2")
        btnfour.isSelected = socialinsrn.contains("3")
        btnindustrial.isSelected = socialinsrn.contains("4")
        
        if btnnatinal.isSelected {
            // .Selected
            let mySelectedAttributedTitle = NSAttributedString(string: "국민연금\n가입",
                                                               attributes: setButtonStype(UIColor.white))
            btnnatinal.setAttributedTitle(mySelectedAttributedTitle, for: .selected)
        }else{
            // .Normal
            let myNormalAttributedTitle = NSAttributedString(string: "국민연금\n미가입",
                                                             attributes: setButtonStype(UIColor.init(hexString: "#161D4A")))
            
            btnnatinal.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        }
        
        if btnhealth.isSelected {
            // .Selected
            let mySelectedAttributedTitle = NSAttributedString(string: "건강보험\n가입",
                                                               attributes: setButtonStype(UIColor.white))
            btnhealth.setAttributedTitle(mySelectedAttributedTitle, for: .selected)
        }else{
            // .Normal
            let myNormalAttributedTitle = NSAttributedString(string: "건강보험\n미가입",
                                                             attributes: setButtonStype(UIColor.init(hexString: "#161D4A")))
            
            btnhealth.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        }
        
        
        if btnfour.isSelected {
            // .Selected
            let mySelectedAttributedTitle3 = NSAttributedString(string: "고용보험\n가입",
                                                                attributes: setButtonStype(UIColor.white))
            btnfour.setAttributedTitle(mySelectedAttributedTitle3, for: .selected)
        }else{
            // .Normal
            let myNormalAttributedTitle3 = NSAttributedString(string: "고용보험\n미가입",
                                                              attributes: setButtonStype(UIColor.init(hexString: "#161D4A")))
            
            btnfour.setAttributedTitle(myNormalAttributedTitle3, for: .normal)
        }
        
        if btnindustrial.isSelected {
            // .Selected
            let mySelectedAttributedTitle4 = NSAttributedString(string: "산재보험\n가입",
                                                                attributes: setButtonStype(UIColor.white))
            btnindustrial.setAttributedTitle(mySelectedAttributedTitle4, for: .selected)
        }else{
            
            // .Normal
            let myNormalAttributedTitle4 = NSAttributedString(string: "산재보험\n미가입",
                                                              attributes: setButtonStype(UIColor.init(hexString: "#161D4A")))
            
            btnindustrial.setAttributedTitle(myNormalAttributedTitle4, for: .normal)
        }
        
        
        firstTextView.delegate = self
        twoTextView.delegate = self
        threeTextView.delegate = self
        fourTextView.delegate = self
        
        let test1 = UIColor.init(hexString: "#EDEDF2")         // {["#", "ff", "23", "0d"]}
        let test2 = UIColor.init(hexString: "#CBCBD3")
        
        //border radius
        firstTextView.layer.cornerRadius = 6
        //border width
        firstTextView.layer.borderWidth = 1
        //border color
        firstTextView.layer.borderColor = test1.cgColor
        //UIColor를 뽑아주는 함수이기 때문에 뽑아온 CGColor 컬러를 사용하는 곳에서는 CGColor으로 적용시켜주는 로직필요
        twoTextView.layer.cornerRadius = 6
        twoTextView.layer.borderWidth = 1
        twoTextView.layer.borderColor = test1.cgColor
        threeTextView.layer.cornerRadius = 6
        threeTextView.layer.borderWidth = 1
        threeTextView.layer.borderColor = test1.cgColor
        fourTextView.layer.cornerRadius = 6
        fourTextView.layer.borderWidth = 1
        fourTextView.layer.borderColor = test1.cgColor
        
        //textview padding
        firstTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        twoTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        threeTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        fourTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        
        //임시저장 입력뷰 나오게 하는 버튼 커스텀
        moreBtn.layer.backgroundColor = test2.cgColor
        moreBtn.layer.cornerRadius = 7
        
        //switch 클릭시 textView font color 변환 - 하나의 함수로 돌려쓰고 싶었는데 self 키 기준으로 해당 키의 변수명과 형제 노드를 어떻게 선택해서 해당 노드의 text를 바꿔야하는지 몰라서 그냥 함수 3개 만들고 상황에 따라 호출하도록 만듬
        twoSwitch.addTarget(self, action: #selector(twoClickSwitch(sender:)), for: UIControl.Event.valueChanged)
        threeSwitch.addTarget(self, action: #selector(threeClickSwitch(sender:)), for: UIControl.Event.valueChanged)
        fourSwitch.addTarget(self, action: #selector(fourClickSwitch(sender:)), for: UIControl.Event.valueChanged)
        
        //selected 이미지 변경
        //        directBtn.isSelected = false;
        //        IndirectBtn.isSelected = true;
        //버튼과 이미지view를 분리시키면서 주석처리
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //       //스크롤뷰 클릭 했을때도 키보드 내려갈 수 있도록 해주는 코드
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    override func viewDidLoad() {
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        EnterpriseColor.nonLblBtn(btnNext)
        setUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if selInfo.delivery != "" {
            twoSwitch.isOn = true
            toggleTwo.setOn(on: true, animated: true)
            isdelivery = true
        }else{
            isdelivery = false
            twoSwitch.isOn = false
            toggleTwo.setOn(on: false, animated: true)
        }
        
        if selInfo.anual != "" {
            threeSwitch.isOn  = true
            toggleThree.setOn(on: true, animated: true)
            isanual = true
        }else{
            threeSwitch.isOn  = false
            toggleThree.setOn(on: false, animated: true)
            isanual = false
        }
        
        if selInfo.other != ""  {
            fourSwitch.isOn = true
            toggleFour.setOn(on: true, animated: true)
            isother = true
        }else{
            fourSwitch.isOn = false
            toggleFour.setOn(on: false, animated: true)
            isother = false
        }
        
        if selInfo.form == 0 {
            lblNavigationTitle.text = "정규직 계약정보"
        }else if selInfo.form == 1 {
            lblNavigationTitle.text = "계약직 계약정보"
        }else {
            lblNavigationTitle.text = "수습 계약정보"
        }
        getLCinfo {}
 
    }
    
    fileprivate func getLCinfo(finished : @escaping ()-> Void) {
        NetworkManager.shared().get_LCInfo(LCTSID: selInfo.sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else {
                    return
                }
                self.selInfo = serverData
            }else{
                self.toast("다시 시도해 주세요.")
            }
            
            finished()
        }
    }
    
    override func setNeedsFocusUpdate() {
        super.setNeedsFocusUpdate()
        var social = ""
        if btnnatinal.isSelected == true {  social = "1,"  }
        if btnhealth.isSelected == true {  social += "2," }
        if btnfour.isSelected == true {  social += "3," }
        if btnindustrial.isSelected == true {  social += "4" }
         
        let payday = firstTextView.text ?? defaultPayDayText
         var color: UIColor!
        if isdelivery{
            delivery = twoTextView.text ?? defaultContractText
            color = UIColor.black
            twoTextView.isEditable = true
            twoTextView.textColor = color
        }else{
            delivery = ""
            color = UIColor.gray
            twoTextView.isEditable = false
            twoTextView.textColor = color
        }
        
        if isanual{
            anual = threeTextView.text ?? defaultAnualText
            color = UIColor.black
            threeTextView.isEditable = true
            threeTextView.textColor = color
        }else{
            anual = ""
            color = UIColor.gray
            threeTextView.isEditable = false
            threeTextView.textColor = color
        }
        
        if isother{
            other = fourTextView.text ?? defaultPayDayText
            color = UIColor.black
            fourTextView.isEditable = true
            fourTextView.textColor = color
        }else{
            other = ""
            color = UIColor.gray
            fourTextView.isEditable = false
            fourTextView.textColor = color
        }
        
        selInfo.payday = payday
        selInfo.socialinsrn = social
        selInfo.anual = anual
        selInfo.other = other
        selInfo.delivery = delivery
        
    }
    
    @IBAction func selectMon(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let selectedattributes = setButtonStype(UIColor.white)
        let normalattributes = setButtonStype(UIColor.init(hexString: "#161D4A"))
        
        if sender.isSelected {
            // .Selected
            let mySelectedAttributedTitle = NSAttributedString(string: "국민연금\n가입",
                                                               attributes: selectedattributes)
            btnnatinal.setAttributedTitle(mySelectedAttributedTitle, for: .selected)
        }else{
            // .Normal
            let myNormalAttributedTitle = NSAttributedString(string: "국민연금\n미가입",
                                                             attributes: normalattributes)
            
            btnnatinal.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        }
    }
    @IBAction func selectTue(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let selectedattributes4 = setButtonStype(UIColor.white)
        let normalattributes4 = setButtonStype(UIColor.init(hexString: "#161D4A"))
        
        if sender.isSelected {
            // .Selected
            let mySelectedAttributedTitle4 = NSAttributedString(string: "산재보험\n가입",
                                                                attributes: selectedattributes4)
            btnindustrial.setAttributedTitle(mySelectedAttributedTitle4, for: .selected)
        }else{
            
            // .Normal
            let myNormalAttributedTitle4 = NSAttributedString(string: "산재보험\n미가입",
                                                              attributes: normalattributes4)
            
            btnindustrial.setAttributedTitle(myNormalAttributedTitle4, for: .normal)
        }
    }
    @IBAction func selectWed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let selectedattributes3 = setButtonStype(UIColor.white)
        let normalattributes3 = setButtonStype(UIColor.init(hexString: "#161D4A"))
        
        if sender.isSelected {
            // .Selected
            let mySelectedAttributedTitle3 = NSAttributedString(string: "고용보험\n가입",
                                                                attributes: selectedattributes3)
            btnfour.setAttributedTitle(mySelectedAttributedTitle3, for: .selected)
        }else{
            // .Normal
            let myNormalAttributedTitle3 = NSAttributedString(string: "고용보험\n미가입",
                                                              attributes: normalattributes3)
            
            btnfour.setAttributedTitle(myNormalAttributedTitle3, for: .normal)
        }
    }
    @IBAction func selectThu(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let selectedattributes2 = setButtonStype(UIColor.white)
        let normalattributes2 = setButtonStype(UIColor.init(hexString: "#161D4A"))
        
        if sender.isSelected {
            // .Selected
            let mySelectedAttributedTitle = NSAttributedString(string: "건강보험\n가입",
                                                               attributes: selectedattributes2)
            btnhealth.setAttributedTitle(mySelectedAttributedTitle, for: .selected)
        }else{
            // .Normal
            let myNormalAttributedTitle = NSAttributedString(string: "건강보험\n미가입",
                                                             attributes: normalattributes2)
            
            btnhealth.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        }
    }
    
    fileprivate func setButtonStype(_ color: UIColor) -> [NSAttributedString.Key: Any] {
        
        let font = UIFont.systemFont(ofSize: 15)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
        
        return attributes
    }
 
    
    //스크롤뷰 터치했을때도 키보드 내려가도록 해주는 코드
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step4VC") as! Lc_Step4VC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = self.selInfo
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        var social = ""
        if btnnatinal.isSelected == true {  social = "1,"  }
        if btnhealth.isSelected == true {  social += "2," }
        if btnfour.isSelected == true {  social += "3," }
        if btnindustrial.isSelected == true {  social += "4" }
        
        
        let payday = firstTextView.text ?? ""
        
        if isdelivery == true {
            delivery = twoTextView.text ?? ""
        }else{
            delivery = ""
        }
        
        if isanual == true {
            anual = threeTextView.text ?? ""
        }else{
            anual = ""
        }
        
        if isother == true {
            other = fourTextView.text ?? ""
        }else{
            other = ""
        }
        
        selInfo.payday = payday
        selInfo.socialinsrn = social
        selInfo.anual = anual
        selInfo.other = other
        selInfo.delivery = delivery
        
        NetworkManager.shared().set_step5(LCTSID: selInfo.sid, PAYDAY:selInfo.payday.urlEncoding() , SOCIAL: selInfo.socialinsrn.urlEncoding(), ANUAL: selInfo.anual.urlEncoding(), DELIVERY: selInfo.delivery.urlEncoding(), OTHER: selInfo.other.urlEncoding()) { (isSuccess, resCode) in
            if(isSuccess){
                DispatchQueue.main.async {
                    if resCode == 1 {
                        let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step6VC") as! Lc_Step6VC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.selInfo = self.selInfo
                        self.present(vc, animated: false, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }
                
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
        
        
        
    }
    
    
    
    //MARK: - pop버튼
    @IBAction func moreBtn(_ sender: UIButton) { 
        SelPinplLcEmpInfo = selInfo
        SelPinplLcEmpInfo.viewpage = "step5"
        if SE_flag {
            presentPanModal(RowType.sebasic.presentable.rowVC)
        }else{
            presentPanModal(RowType.basic.presentable.rowVC)
        }
    }
    
    //selected 이미지 변경
    @IBAction func directBtn(_ sender: UIButton) {
        directBtn.isSelected = true
        IndirectBtn.isSelected = false
        directBtnImg.image = checkImg
        IndirectBtnImg.image = uncheckImg
    }
    @IBAction func IndirectBtn(_ sender: UIButton) {
        directBtn.isSelected = false
        IndirectBtn.isSelected = true
        directBtnImg.image = uncheckImg
        IndirectBtnImg.image = checkImg
    }
}
// 문자(Character) 두 개를 하나의 문자열로 합치는 오퍼레이터 함수
func +(left: Character, right: Character) -> String {
    return "\(left)\(right)"
}

private extension Lc_Step5VC {
    enum RowType: Int, CaseIterable {
        case basic
        case sebasic
        
        var presentable: RowPresentable {
            switch self {
            case .basic: return Basic()
            case .sebasic: return SEBsic()
            }
        }
        
        struct Basic: RowPresentable {
            var viewpage: String = "step5"
            let rowVC: PanModalPresentable.LayoutType = ContractInfoPinplPopup()
        }
        struct SEBsic: RowPresentable {
            var viewpage: String = "step1"
            let rowVC: PanModalPresentable.LayoutType = SE_ContractInfoPinplPopup()
            
        }
    }
}

// MARK:  - UITextViewDelegate
extension Lc_Step5VC: UITextViewDelegate{
    //textView 포커스시 해당 textView를 scrollview 상단으로 위치시켜주는 로직
    func textViewDidBeginEditing(_ textView: UITextView){
        //print("textViewDidBeginEditing");
        if textView == firstTextView {
            self.scrollView.contentOffset.y = oneSection.frame.origin.y;
        }else if textView == twoTextView{
            self.scrollView.contentOffset.y = threeSection.frame.origin.y;
        }else if textView == threeTextView{
            self.scrollView.contentOffset.y = fourSection.frame.origin.y;
        }else if textView == fourTextView{
            self.scrollView.contentOffset.y = fiveSection.frame.origin.y;
        }
        
        
    }
}

// MARK: - method
extension Lc_Step5VC {
    
    //사회보험
    @objc func oneClickSwitch(sender: UISwitch) {
        sender.isSelected = !sender.isSelected
        if sender.isOn {
            self.issocial = true
        } else {
            self.issocial = false
        }
    }
    //근로계약서
    @objc func twoClickSwitch(sender: UISwitch) {
        sender.isSelected = !sender.isSelected
        var color: UIColor!
        if sender.isOn {
            self.isdelivery = true
            color = UIColor.black
            twoTextView.isEditable = true
        } else {
            self.isdelivery = false
            color = UIColor.gray
            twoTextView.isEditable = false
        }
        self.twoTextView.textColor = color
    }
    @objc func toggleTwoChanged(toggle: ToggleSwitch) {
        toggle.isSelected = !toggle.isSelected
        var color: UIColor!
        if toggle.isOn {
            self.isdelivery = true
            color = UIColor.black
            twoTextView.isEditable = true
        } else {
            self.isdelivery = false
            color = UIColor.gray
            twoTextView.isEditable = false
        }
        self.twoTextView.textColor = color
    }
    //연차휴가
    @objc func threeClickSwitch(sender: UISwitch) {
        sender.isSelected = !sender.isSelected
        var color: UIColor!
        if sender.isOn {
            self.isanual = true
            color = UIColor.black
            threeTextView.isEditable = true
        } else {
            self.isanual = false
            color = UIColor.gray
            threeTextView.isEditable = false
        }
        self.threeTextView.textColor = color
    }
    @objc func toggleThreeChanged(toggle: ToggleSwitch) {
        toggle.isSelected = !toggle.isSelected
        var color: UIColor!
        if toggle.isOn {
            self.isanual = true
            color = UIColor.black
            threeTextView.isEditable = true
        } else {
            self.isanual = false
            color = UIColor.gray
            threeTextView.isEditable = false
        }
        self.threeTextView.textColor = color
    }
    //기타
    @objc func fourClickSwitch(sender: UISwitch) {
        sender.isSelected = !sender.isSelected
        var color: UIColor!
        if sender.isOn {
            self.isother = true
            color = UIColor.black
            fourTextView.isEditable = true
        } else {
            self.isother = false
            color = UIColor.gray
            fourTextView.isEditable = false
        }
        self.fourTextView.textColor = color
    }
    
    @objc func toggleFourChanged(toggle: ToggleSwitch) {
        toggle.isSelected = !toggle.isSelected
        var color: UIColor!
        if toggle.isOn {
            self.isother = true
            color = UIColor.black
            fourTextView.isEditable = true
        } else {
            self.isother = false
            color = UIColor.gray
            fourTextView.isEditable = false
        }
        self.fourTextView.textColor = color
    }
}
