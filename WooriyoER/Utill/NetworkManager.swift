//
//  NetworkManager.swift
//  PinPle
//
//  Created by seob on 2020/01/10.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

class NetworkManager {
    
    // MARK: - Properties
    var AlamofireAppManager: SessionManager?
    var baseURL: String = ""
    var isInfoSending: Bool = false
    var isActionSending: Bool = false
    
    private static var sharedNetworkManager: NetworkManager = {
        let networkManager = NetworkManager(baseURL: API.baseURL)
        return networkManager
    }()
    
    private init(baseURL:String) {
        self.baseURL = baseURL
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        AlamofireAppManager = Alamofire.SessionManager(configuration: configuration)
        
    }
    
    func getAPIURL(api:String) -> String {
        let url:String = API.baseURL + api
        
        return url;
    }
    
    
    func getwebAPIURL(api:String) -> String {
        let url:String = API.WEBbaseURL + api
        
        return url;
    }
    
    // MARK: - Accessors
    
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
    
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    
    // MARK: - 회원관련
    //MARK:  마스터 로그인
    /**
     iPhone Android SmartPhone APP으로부터 요청받은 데이터 처리(마스터 계정 회원로그인)
     Parameter
     EMAIL    Email(ID) BASE64 인코딩
     PASS    비밀번호 BASE64 인코딩
     */
    func checkMst(email: String , pass: String ,completion: @escaping (_ success:Bool, MbrInfo?) ->()) {
        let checkMstURL = getAPIURL(api: "ios/check_mst.jsp?EMAIL=\(email)&PASS=\(pass)")
        print("\n---------- [ checkMstURL : \(checkMstURL) ] ----------\n")
        AlamofireAppManager?.request(checkMstURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<MbrInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    
    
    //MARK:  아이폰 APNS Token 갱신
    /**
     아이폰 APNS Token 갱신
     Parameter
     - parameter mbrsid:        회원번호
     - parameter pushid:        APNS Token
     
     - returns : 성공 1 실패 0
     test
     http://ios.pinpl.biz/ios/set_pushid.jsp?MBRSID=317&MODE=1&PUSHID=dWti06wb9MY:APA91bHdJP3vc45j-0Stk1jxlSQE0xTC6zEfURE6ZYzbxsLTp5Jr3fRu-pj_4BrkTYdtdEQj1TCB6dolBKniyB-oR4fn1coCerNQP-scuT61pQSwahPCfnDEYIrx6roORXj67Sx_l4fE
     */
    func setPushId(mbrsid: Int, pushid: String, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let setPushIdURL = getAPIURL(api: "ios/set_pushid.jsp?MBRSID=\(mbrsid)&MODE=1&PUSHID=\(pushid)")
        print("\n---------- [ setPushIdURL : \(setPushIdURL) ] ----------\n")
        AlamofireAppManager?.request(setPushIdURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    
    
    //MARK:  회원 확인
    /**
     회원 확인
     - parameter email:    Email(ID) BASE64 인코딩
     - parameter pass:    비밀번호 SHA1Password 암호화 형식으로 전달 받음...
     - parameter mode:    0.근로자 1.관리자
     - parameter osvs:    OS버전(예:4.3.3)
     - parameter appvs:    어플버전
     - parameter md:        단말기모델명 BASE64 인코딩
     - parameter type: 1:네이버 , 2:구글 , 3:카카오 , 4:애플 , 5:email
     - parameter id: sns에서 주는 고유 아이디값
     
     - returns :  회원 확인
     */
    func checkMbr(type: Int ,id:String = "", fid:String = "", email: String = "", pass: String = "", mode: Int, osvs: String, appvs: String, md: String, completion: @escaping (_ success:Bool, MbrInfo?) ->()) {
        
        var checkURL = ""
        switch type {
        case 1:
            //naver
            checkURL = getAPIURL(api: "ios/check_mbr4naver.jsp?NID=\(id)&MODE=\(mode)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)")
        case 2:
            // google
            checkURL = getAPIURL(api: "ios/check_mbr4googleNew.jsp?GID=\(id)&MODE=\(mode)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)")
        case 3:
            // kakao
            checkURL = getAPIURL(api: "ios/check_mbr4kakao.jsp?KID=\(id)&MODE=\(mode)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)")
        case 4:
            // apple
            checkURL = getAPIURL(api: "ios/check_mbr4appleNew.jsp?AID=\(fid)&FID=\(id)&MODE=\(mode)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)")
        default:
            // email 경우
            checkURL = getAPIURL(api: "ios/check_mbr.jsp?EMAIL=\(email)&PASS=\(pass)&MODE=\(mode)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)")
        }
        
        
        print("\n---------- [ type : \(type) ] ----------\n")
        print("\n---------- [ checkURL : \(checkURL) ] ----------\n")
        AlamofireAppManager?.request(checkURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<MbrInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error :\(error.localizedDescription) ] ----------\n")
                completion(false, nil)
            }
        })
    }
    
    func checkMbrRx(type: Int ,id:String = "", email: String = "", pass: String = "", mode: Int, osvs: String, appvs: String, md: String) -> Observable<(Bool, MbrInfo?)> {
        
        return Observable.create { emitter in
            self.checkMbr(type: type, id: id, email: email, pass: pass, mode: mode, osvs: osvs, appvs: appvs, md: md) { (isSuccess, resData) in
                if(isSuccess){
                    emitter.onNext((true , resData))
                    emitter.onCompleted()
                }else{
                    emitter.onNext((false, nil))
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    
    //MARK:  회원가입 체크
    /*
     Return  - 정상회원가입시:회원번호, 가입실패:0, 이미가입:-1
     Parameter
     EMAIL    Email(ID) BASE64 인코딩

     PASS    비밀번호 SHA1Password 암호화 형식으로 전달 받음...
     MODE    0.근로자 1.관리자
     OSVS    OS버전(예:4.3.3)
     APPVS   어플버전
     MD      단말기모델명 BASE64 인코딩
     */
    func checkRegMbr(type: Int ,id:String = "",email: String = "", name:String = "", pass: String = "", gender:Int, birth:String = "", lunar:Int = 0, phone:String = "", mode: Int, osvs: String, appvs: String, md: String, completion: @escaping (_ success:Bool, _ resCode:Int) ->()) {
        
        var checRegkURL = ""
        switch type {
        case 1:
            //naver
            checRegkURL = getAPIURL(api: "ios/reg_mbr4naver.jsp?MODE=\(mode)&EM=\(email)&NID=\(id)&NM=\(name)&GD=\(gender)&BI=\(birth)&LN=\(lunar)&PN=\(phone)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)")
        case 2:
            // google
            checRegkURL = getAPIURL(api: "ios/reg_mbr4google.jsp?MODE=\(mode)&EM=\(email)&GID=\(id)&NM=\(name)&GD=\(gender)&BI=\(birth)&LN=\(lunar)&PN=\(phone)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)")
            
        case 3:
            // kakao
            checRegkURL = getAPIURL(api: "ios/reg_mbr4kakao.jsp?MODE=\(mode)&EM=\(email)&KID=\(id)&NM=\(name)&GD=\(gender)&BI=\(birth)&LN=\(lunar)&PN=\(phone)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)")
        case 4:
            // apple
            checRegkURL = getAPIURL(api: "ios/reg_mbr4apple.jsp?MODE=\(mode)&EM=\(email)&AID=\(id)&NM=\(name)&PN=\(phone)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)")
        default:
            // email 경우
            checRegkURL = getAPIURL(api: "ios/reg_mbr.jsp?MODE=\(mode)&EM=\(email)&PW=\(pass)&NM=\(name)&PN=\(phone)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)")
        }
        
        
        print("\n---------- [ checRegkURL : \(checRegkURL) ] ----------\n")
        AlamofireAppManager?.request(checRegkURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int {
                            completion(true,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error :\(error.localizedDescription) ] ----------\n")
                completion(false, 0)
            }
        })
    }
    //MARK: -  이메일 찾기
    /**
     이메일 찾기 
     - parameter name:        이름 - URL인코딩 후 Base64 인코딩(한글깨짐 방지)
     - parameter phone:        폰번호 - Base64 인코딩
     
     - returns : 이메일
     */
    func SearchEmail(name: String, phone: String, completion: @escaping (_ success: Bool, _ error: Int, _ result: String) ->()) {
        let searchEmailURL = getAPIURL(api: "ios/search_email.jsp?NM=\(name)&PN=\(phone)")
        
        print("\n---------- [ searchEmailURL : \(searchEmailURL) ] ----------\n")
        AlamofireAppManager?.request(searchEmailURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success(let data):
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ search_email jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? String {
                            completion(true, 1, resultCode)
                        }
                    }else {
                        completion(false , 0, "" )
                    }
                }
            case.failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false, 99, "" )
            }
        })
    }
    //MARK: -  비밀번호 찾기
    /**
     비밀번호 찾기
     
     - parameter  email:        이메일 - Base64 인코딩
     - returns : 1.성공 0.실패
     */
    func SearchPassword(email: String, completion: @escaping (_ success: Bool, _ error: Int, _ result: Int) ->()) {
        
        let searchPasswordURL = getAPIURL(api: "ios/search_password.jsp?EM=\(email)")
        
        print("\n---------- [ searchPasswordURL : \(searchPasswordURL) ] ----------\n")
        AlamofireAppManager?.request(searchPasswordURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success(let data):
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ search_password jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int {
                            completion(true, 1, resultCode)
                        }
                    }else {
                        completion(false, 0, 0 )
                    }
                }
            case.failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false, 0, 0 )
            }
        })
    }
    //MARK: - 회사 정보
    // MARK: 회사 등록
    /**
     회사 등록
     
     - parameter mbrsid:        회원번호
     - parameter name:            회사이름 - URL 인코딩
     - parameter ename:        영문회사이름 - URL 인코딩
     
     - returns : 성공:직원번호, 실패:0, 이미등록:-1
     */
    func regCmpny(mbrsid: Int, name: String, ename: String, completion: @escaping (_ success:Bool , _ result:Int , _ empsid:Int) ->()) {
        
        let regCmpnyURL = getAPIURL(api: "ios/m/reg_cmpny.jsp?MBRSID=\(mbrsid)&NM=\(name)&ENNM=\(ename)")
        print("\n---------- [ regCmpnyURL : \(regCmpnyURL) ] ----------\n")
        AlamofireAppManager?.request(regCmpnyURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int,
                            let resultempsid = jsonData["empsid"] as? Int {
                            completion(true,  resultCode , resultempsid)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0,0 )
            }
        })
    }
    // MARK: - 회사 코드불러오기
    /**
     회사 코드불러오기
     
     - parameter cmpsid:        회사번호
     - returns : 조회결과 있는경우 : 합류코드(Base64), 조회결과 없는경우 : ""
     */
    func getCmpJoincode(cmpsid: Int, completion: @escaping (_ success:Bool , _ result:String) ->()) {
        
        let getCmpJoincodeURL = getAPIURL(api: "ios/m/get_cmp_joincode.jsp?CMPSID=\(cmpsid)")
        
        print("\n---------- [ getCmpJoincodeURL : \(getCmpJoincodeURL) ] ----------\n")
        AlamofireAppManager?.request(getCmpJoincodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? String  {
                            completion(true,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , "" )
            }
        })
    }
    // MARK: - 회사 정보 불러오기
    /**
     회사 정보 불러오기
     
     - parameter cmpsid:        회사번호
     - returns : 회사정보
     */
    func getCmpInfo(cmpsid: Int, completion: @escaping (_ success:Bool ,_ error: Int , CmpInfo?) ->()) {
        
        let getcmpinfoURL = getAPIURL(api: "ios/m/get_cmp_info.jsp?CMPSID=\(cmpsid)")
        
        print("\n---------- [ getcmpinfoURL : \(getcmpinfoURL) ] ----------\n")
        AlamofireAppManager?.request(getcmpinfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        //                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let errData = jsonData["error"] as? String {
                            print("\n---------- [ errData : \(errData) ] ----------\n")
                            completion(true , 99 , nil)
                        }else{
                            if let resData = Mapper<CmpInfo>().map(JSON: jsonData){
                                completion(true , 1 , resData)
                            }
                        }
                        
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0, nil )
            }
        })
    }
    
    func getCmpInfoRx(cmpsid: Int) -> Observable<(Bool , Int , CmpInfo?)> {
        return Observable.create { emitter in
            self.getCmpInfo(cmpsid: cmpsid) { (isSuccess, error, resData) in
                if(isSuccess){
                    emitter.onNext((true , 1 , resData))
                    emitter.onCompleted()
                }else{
                    emitter.onNext((false , 0, nil))
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    //MARK: - 회사 정보 수정
    /**
     회사 정보 수정
     
     - parameter cmpsid:        회사번호
     - parameter name:            회사이름 - URL 인코딩 .. 필수
     - parameter enname:        영문회사이름 - URL 인코딩
     - parameter phone:            대표전화번호 - URL 인코딩(-, 띄어쓰기 처리할것인지..)
     - parameter addr:        주소 - URL 인코딩
     - parameter site:        사이트주소 - URL 인코딩 (http://, https:// 제거 url 패턴 검사 후 전달)
     - parameter ceo:        대표자명- URL 인코딩
     - returns : 성공:1, 실패:0
     */
    func UdtCmpinfo(cmpsid: Int, name: String, enname: String, phone: String, addr: String, site: String, ceo: String,  completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
        let udtCmpinfoURL = getAPIURL(api: "ios/m/udt_cmpinfo.jsp?CMPSID=\(cmpsid)&NM=\(name)&ENNM=\(enname)&PN=\(phone)&ADDR=\(addr)&SITE=\(site)&CEO=\(ceo)")
        
        print("\n---------- [ udtCmpinfoURL : \(udtCmpinfoURL) ] ----------\n")
        AlamofireAppManager?.request(udtCmpinfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    // MARK: - 합류한 직원리스트.. 대표제외
    /**
     합류한 직원리스트.. 대표제외
     
     - parameter cmpsid:        회사번호
     - parameter curkey:        페이징 키(첫 페이지는 0 또는 안넘김)
     - parameter listcnt:        리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     
     - returns : 합류한 직원정보
     */
    func JoinEmplist(cmpsid: Int, curkey: Int, listcnt: Int, completion: @escaping (_ success:Bool, _ error: Int , [EmplyInfo]?, _ nextkey: Int) ->()) {
        
        let joinEmplistURL = getAPIURL(api: "ios/m/join_emplist.jsp?CMPSID=\(cmpsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)")
        
        print("\n---------- [ joinEmplistURL : \(joinEmplistURL) ] ----------\n")
        AlamofireAppManager?.request(joinEmplistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ join_emplist jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]] {
                            if let resNextkey = jsonData["nextkey"] as? Int {
                                let response = Mapper<EmplyInfo>().mapArray(JSONArray: resData)
                                completion(true, 1, response, resNextkey)
                            }else {
                                let response = Mapper<EmplyInfo>().mapArray(JSONArray: resData)
                                completion(true, 1, response, 0)
                            }
                        }else {
                            completion(false, 0, nil, 0)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false, 99, nil, 0)
            }
        })
    }
    //MARK: - 입사일기준 연차계산 - 분단위 환산
    /**
     입사일기준 연차계산 - 분단위 환산
     
     - parameter joindt:        입사일자(형식 : 2018-05-05).. URL 인코딩
     - returns : 연차(분단위환산 - 하루 8시간)
     */
    func GetAnualmin(joindt: String, completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
        let getAnualminURL = getAPIURL(api: "ios/u/get_anualmin.jsp?JOINDT=\(joindt)")
        
        print("\n---------- [ getAnualminURL : \(getAnualminURL) ] ----------\n")
        AlamofireAppManager?.request(getAnualminURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    func GetAnualminNew(empsid:Int ,joindt: String, completion: @escaping (_ success:Bool , _ result: Int, _ resfical: Int, _ resremain: Int, _ resusemin: Int, _ resaddmin: Int) ->()) {
        
        let getAnualminURL = getAPIURL(api: "ios/m/get_anualminNew.jsp?EMPSID=\(empsid)&JOINDT=\(joindt)")
        
        print("\n---------- [ getAnualminURL : \(getAnualminURL) ] ----------\n")
        AlamofireAppManager?.request(getAnualminURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int ,
                           let resultFical = jsonData["calFicalmin"] as? Int ,
                           let resultRemain = jsonData["remainmin"] as? Int ,
                           let resultUsemin = jsonData["usemin"] as? Int ,
                           let resultAddmin = jsonData["addmin"] as? Int {
                            
                            completion(true ,  resultCode ,resultFical,resultRemain,resultUsemin,resultAddmin)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0, 0, 0, 0, 0 )
            }
        })
    }
    
    // MARK: - 복수출퇴근 설정
    // MARK: 출퇴근영역 복수설정 & 재택출퇴근영역 월 이용 설정
    /**
     출퇴근영역 복수설정 & 재택출퇴근영역 월 이용 설정
     - parameter CMPSID : 회사번호
     - parameter MBRSID : 회원번호
     
     - returns: 성공:1, 실패:0, 핀포인트 부족:-1
     */
    
    func set_multicmtarea(cmpsid: Int, mbrsid: Int  , completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let set_multicmtareaURL =   getAPIURL(api:"ios/m/set_multicmtarea.jsp?CMPSID=\(cmpsid)&MBRSID=\(mbrsid)")
        
        print("\n---------- [ set_multicmtareaURL : \(set_multicmtareaURL) ] ----------\n")
        AlamofireAppManager?.request(set_multicmtareaURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
 
    // MARK: 복수 출퇴근영역 리스트 .. 회사, 상위팀, 팀
    /**
     복수 출퇴근영역 리스트 .. 회사, 상위팀, 팀
     - parameter CMPSID : 회사번호(화사 설정의 경우.. 상위팀번호,팀번호는 0)
     - parameter TTMSID : 상위팀번호(상위팀 설정의 경우.. 회사번호,팀번호는 0)
     - parameter TEMSID : 팀번호(팀 설정의 경우.. 회사번호,상위팀번호는 0)
     
     - returns: 성공:1, 실패:0, 핀포인트 부족:-1
     */
    
    func addcmtareaList(cmpsid: Int, ttmsid: Int , temsid: Int  , completion: @escaping (_ success:Bool , [Addcmtarea]?) ->()) {
        
        let addcmtareaList =   getAPIURL(api:"ios/m/addcmtarea_list.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)")
        
        print("\n---------- [ addcmtareaList : \(addcmtareaList) ] ----------\n")
        AlamofireAppManager?.request(addcmtareaList, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["addcmtarea"] as? [[String : Any]] {
                            let response = Mapper<Addcmtarea>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let _):
                completion(false , nil)
            }
        })
    }
     
    // MARK: 복수 출퇴근영역 정보 삭제
    /**
     복수 출퇴근영역 정보 삭제
     - parameter ACASID : 추가출퇴근영역 번호
     
     - returns: 성공:1, 실패:0(이미삭제)
     */
    
    func del_Cmtarea(acasid: Int,   completion: @escaping (_ success:Bool ,_ resCode:Int) ->()) {
        
        let delcmtareaURL =   getAPIURL(api:"ios/m/del_cmtarea.jsp?ACASID=\(acasid)")
        
        print("\n---------- [ delcmtareaURL : \(delcmtareaURL) ] ----------\n")
        AlamofireAppManager?.request(delcmtareaURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["result"] as? Int {
                            completion(true ,  resData)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
 
    // MARK: 복수 출퇴근영역 회사,상위팀,팀 출퇴근영역 추가등록)
    /**
     복수 출퇴근영역 회사,상위팀,팀 출퇴근영역 추가등록)
     - parameter CMPSID : 회사번호(회사 출퇴근영역 추가등록의 경우 TtmSid 0, TemSid 0)
     - parameter TTMSID :  상위팀번호(상위팀 출퇴근영역 추가등록의 경우 CmpSid 0, TemSid 0)
     - parameter TEMSID : 팀번호(팀 출퇴근영역 추가등록의 경우 CmpSid 0, TtmSid 0)
     - parameter NM : 출퇴근영역이름 - URL 인코딩
     - parameter ST : 상태(0.사용안함 1.사용)
     - parameter AREA : 출퇴근영역설정 1.WiFi 2.Gps 3.Beacon
     - parameter WNM : WiFi 이름 .. URL 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter WMAC : WiFi MAC .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter WIP :  WiFi IP .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter BCON : 비콘 UUID .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter LAT : 위치정보 위도 .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter LONG : 위치정보 경도 .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter ADDR : 위치정보 주소 ..URL 인코딩 후 Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter scope : 위치범위(반경)..(50m, 100m, 300m, 500m) ..2021-04-29 추가
     
     - returns: 성공:1, 실패:0
     */
    
    func add_Cmtarea(cmpsid: Int,ttmsid: Int,temsid: Int, nm:String , st:Int , area:Int , wnm:String , wmac:String , wip:String , bcon: String , lat:String , long:String , addr: String , scope: Int, completion: @escaping (_ success:Bool ,_ resCode:Int) ->()) {
        
        let addcmtareaURL =   getAPIURL(api:"ios/m/add_cmtarea.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)&NM=\(nm)&ST=\(st)&AREA=\(area)&WNM=\(wnm)&WMAC=\(wmac)&WIP=\(wip)&BCON=\(bcon)&LAT=\(lat)&LONG=\(long)&ADDR=\(addr)&SCOPE=\(scope)")
        
        print("\n---------- [ addcmtareaURL : \(addcmtareaURL) ] ----------\n")
        AlamofireAppManager?.request(addcmtareaURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["result"] as? Int {
                            completion(true ,  resData)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    
    // MARK: 복수 출퇴근영역 정보수정
    /**
     복수 출퇴근영역 정보수정
     - parameter ACASID : 추가출퇴근영역 번호
     - parameter NM : 출퇴근영역이름 - URL 인코딩
     - parameter ST : 상태(0.사용안함 1.사용)
     - parameter AREA : 출퇴근영역설정 1.WiFi 2.Gps 3.Beacon
     - parameter WNM : WiFi 이름 .. URL 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter WMAC : WiFi MAC .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter WIP :  WiFi IP .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter BCON : 비콘 UUID .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter LAT : 위치정보 위도 .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter LONG : 위치정보 경도 .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter ADDR : 위치정보 주소 ..URL 인코딩 후 Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter scope : 위치범위(반경)..(50m, 100m, 300m, 500m) ..2021-04-29 추가
      
     - returns: 성공:1, 실패:0
     */
    
    func udt_Cmtarea(acasid: Int, nm:String , st:Int , area:Int , wnm:String , wmac:String , wip:String , bcon: String , lat:String , long:String , addr: String , scope: Int, completion: @escaping (_ success:Bool ,_ resCode:Int) ->()) {
        
        let udtcmtareaURL =   getAPIURL(api:"ios/m/udt_cmtarea.jsp?ACASID=\(acasid)&NM=\(nm)&ST=\(st)&AREA=\(area)&WNM=\(wnm)&WMAC=\(wmac)&WIP=\(wip)&BCON=\(bcon)&LAT=\(lat)&LONG=\(long)&ADDR=\(addr)&SCOPE=\(scope)")
        
        print("\n---------- [ udtcmtareaURL : \(udtcmtareaURL) ] ----------\n")
        AlamofireAppManager?.request(udtcmtareaURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["result"] as? Int {
                            completion(true ,  resData)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    
    // MARK: - 출퇴근
    
     
    
    // MARK: 직원현황 리스트
    /**
     직원현황 리스트 - 회사, 상위팀, 팀 같이 이용 .. 페이징 없음
     
     - parameter author:        권한(1.마스터관리자, 2.최고관리자, 3.상위팀관리자 4.팀관리자)
     - parameter cmpsid:        회사번호
     - parameter ttmsid:        상위팀번호
     - parameter temsid:        팀번호
     - parameter curkey:        페이징 키(첫 페이지는 0 또는 안넘김)
     - parameter listcnt:        리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     
     - returns : 직원현황리스트
     */
    func totalEmpList(author: Int, cmpsid: Int, ttmsid: Int, temsid: Int,curkey: Int, listcnt: Int, completion: @escaping (_ success:Bool , _ nextkey:Int, [TotalAnualInfo]?) ->()) {
        
        let totalEmpListURL = getAPIURL(api: "ios/m/total_emplist.jsp?AUTH=\(author)&CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)")
        print("\n---------- [ totalEmpListURL : \(totalEmpListURL) ] ----------\n")
        AlamofireAppManager?.request(totalEmpListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["anual"] as? [[String : Any]] ,
                            let resNextkey = jsonData["nextkey"] as? Int {
                            let response = Mapper<TotalAnualInfo>().mapArray(JSONArray: resData)
                            completion(true , resNextkey, response)
                        }
                        
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false ,0, nil)
            }
        })
    }
    
    // MARK: 직원 연차신청 내역 리스트
    /**
     직원 연차신청 내역 리스트
     
     - parameter empsid:        직원번호
     - parameter aprsid:        보조 페이징 키(첫 페이지는 0)
     - parameter curkey:        페이징 키(첫 페이지는 안넘김)
     - parameter listcnt:        리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     
     - returns : 연차신청내역, 근로시간 합계는 1page일때만 정상적으로 넘겨 줌
     */
    func myAnualList(empsid: Int, curkey: String, listcnt: Int, aprsid: Int , completion: @escaping (_ success:Bool , _ nextkey:String,  [MyAnualListInfo]? , _ aprsid:Int) ->()) {
        var myAnualListURL = ""
        if curkey != "" {
            myAnualListURL = getAPIURL(api: "ios/m/get_anualaprlist.jsp?EMPSID=\(empsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)&APRKEY=\(aprsid)")
        }else{
            myAnualListURL = getAPIURL(api: "ios/m/get_anualaprlist.jsp?EMPSID=\(empsid)&LISTCNT=\(listcnt)&APRKEY=\(aprsid)")
        }
        
        print("\n---------- [ myAnualListURL : \(myAnualListURL) ] ----------\n")
        AlamofireAppManager?.request(myAnualListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] { 
                        if let anualaprlist = jsonData["anualaprlist"] as? [[String : Any]] {
                            if let nextkey = jsonData["nextkey"] as? String ,
                                let aprsid = jsonData["aprkey"] as? Int {
                                let resData = Mapper<MyAnualListInfo>().mapArray(JSONArray: anualaprlist)
                                completion(true,  nextkey, resData , aprsid)
                            }else {
                                let resData = Mapper<MyAnualListInfo>().mapArray(JSONArray: anualaprlist)
                                completion(true,  "", resData , 0)
                            }
                        }
                    }else{
                        // 파라미터 없다고 서버에서 내려줄때
                        completion(false,"", nil , 0)
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false ,"", nil,0)
            }
        })
    }
    /**
     직원 연차신청 내역 리스트
     
     - parameter empsid:        직원번호
     - parameter aprsid:        보조 페이징 키(첫 페이지는 0)
     - parameter curkey:        페이징 키(첫 페이지는 안넘김)
     - parameter listcnt:        리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     
     - returns : 연차신청내역, 근로시간 합계는 1page일때만 정상적으로 넘겨 줌
     */
    func myAnualListRx(empsid: Int, curkey: String, listcnt: Int, aprsid: Int) -> Observable<(Bool , String,  [MyAnualListInfo]? , Int)> {
        return Observable.create { emitter in
            self.myAnualList(empsid: empsid, curkey: curkey, listcnt: listcnt, aprsid: aprsid) { (isSuccess, nextKey, resData, aprsid) in
                if(isSuccess){
                    emitter.onNext((true,  nextKey, resData , aprsid))
                    emitter.onCompleted()
                }else{
                    emitter.onNext((false,"", nil , 0))
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    // MARK: 직원 출장/연장근로신청 내역 리스트
    /**
     직원 출장/연장근로신청 내역 리스트.. 페이징
     - parameter cmpsid: 회사번호
     - parameter empsid:        직원번호
     - parameter curkey:        페이징 키(첫 페이지는 안넘김)
     - parameter listcnt:        리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     - parameter aprsid:        보조 페이징 키(첫 페이지는 0)
     
     - returns : 출장/연장근로 신청내역, 남은연차는 .. total_emplist.jsp 에서 전달 받은 값 이용
     */
    func myApplyList(cmpsid: Int, empsid: Int, curkey: String, listcnt: Int, aprsid: Int , completion: @escaping (_ success:Bool , _ nextkey:String, _ wkh:Int , _ workmin:Int, [MyApplyListInfo]?, _ aprsid:Int) ->()) {
        var myApplyListURL = ""
        if curkey != "" {
            myApplyListURL = getAPIURL(api: "ios/m/get_applyaprlist.jsp?CMPSID=\(cmpsid)&EMPSID=\(empsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)&APRKEY=\(aprsid)")
        }else{
            myApplyListURL = getAPIURL(api: "ios/m/get_applyaprlist.jsp?CMPSID=\(cmpsid)&EMPSID=\(empsid)&LISTCNT=\(listcnt)&APRKEY=\(aprsid)")
        }
        
        print("\n---------- [ myApplyListURL : \(myApplyListURL) ] ----------\n")
        AlamofireAppManager?.request(myApplyListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    //{"workmin":242,"applyaprlist":[],"aprkey":0,"wk52h":0}
                    
                    if let jsonData = data as? [String : Any] ,
                        let aprkey = jsonData["aprkey"] as? Int ,
                        let reswk = jsonData["wk52h"] as? Int ,
                        let resworkmin = jsonData["workmin"] as? Int {
                        
                        if let resData = jsonData["applyaprlist"] as? [[String : Any]] ,
                            let nextkey = jsonData["nextkey"] as? String {
                            let response = Mapper<MyApplyListInfo>().mapArray(JSONArray: resData)
                            completion(true,nextkey, reswk, resworkmin ,response, aprkey)
                        }else{
                            completion(true, "" , reswk, resworkmin ,nil, aprkey)
                        }
                    }else{
                        completion(false ,"", 0,0, nil,0)
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false ,"", 0,0, nil,0)
            }
        })
    }
    /**
     직원 출장/연장근로신청 내역 리스트.. 페이징
     - parameter cmpsid: 회사번호
     - parameter empsid:        직원번호
     - parameter curkey:        페이징 키(첫 페이지는 안넘김)
     - parameter listcnt:        리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     - parameter aprsid:        보조 페이징 키(첫 페이지는 0)
     
     - returns : 출장/연장근로 신청내역, 남은연차는 .. total_emplist.jsp 에서 전달 받은 값 이용
     */
    
    func myApplyListRx(cmpsid: Int, empsid: Int, curkey: String, listcnt: Int, aprsid: Int) -> Observable<(Bool,String,Int,Int, [MyApplyListInfo]?,Int)>{
        return Observable.create { emitter in
            self.myApplyList(cmpsid: cmpsid, empsid: empsid, curkey: curkey, listcnt: listcnt, aprsid: aprsid) { (isSuccess, nextkey, wkh, workmin, resData, aprsid) in
                if(isSuccess){
                    emitter.onNext((true,nextkey, wkh, workmin ,resData, aprsid))
                    emitter.onCompleted()
                }else{
                    emitter.onNext((false ,"", 0,0, nil,0))
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    // MARK: 팀, 상위팀-직속 출근직원 리스트
    /**
     팀, 상위팀-직속 출근직원 리스트
     - parameter cmpsid:        회사번호(필수) .. 회사 전체 조회시 (상위팀번호 -1, 팀번호 -1)
     - parameter ttmsid:        상위팀번호(상위팀 직속 조회시 팀번호는 0) .. 상위팀, 팀 번호 둘다 0인경우는 팀 미지정(팀소속 없는 직원들.. 팀이 없는경우)
     - parameter temsid:        팀번호(팀 조회시 상위팀번호는 -1)
     
     - returns: 출근직원 리스트
     */
    
    func cmtOnEmpListRx(cmpsid: Int, ttmsid: Int, temsid: Int) -> Observable<(Bool , Int ,Int,Int ,String, [CmtEmplyInfo]?)> {
        return Observable.create { emitter in
            let onEmpListURL = self.getAPIURL(api: "ios/m/cmton_emplist.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)")
            print("\n---------- [ onEmpListURL : \(onEmpListURL) ] ----------\n")
            self.AlamofireAppManager?.request(onEmpListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let data) :
                    let statusCode = response.response?.statusCode
                    if statusCode == 200 {
                        //정상
                        if let jsonData = data as? [String : Any] {
                            if let resData = jsonData["commute"] as? [[String : Any]] ,
                                let empCnt = jsonData["empcnt"] as? Int ,
                                let anualCnt = jsonData["anualcnt"] as? Int ,
                                let applyCnt = jsonData["applycnt"] as? Int ,
                                let joinCode = jsonData["joincode"] as? String
                            {
                                let response = Mapper<CmtEmplyInfo>().mapArray(JSONArray: resData)
                                emitter.onNext((true , empCnt,anualCnt, applyCnt,joinCode,  response))
                            }
                        }
                        emitter.onCompleted()
                    }
                case .failure(let error):
                    print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                    emitter.onError(error)
                }
            })
            return Disposables.create()
        }
    }
    
    // MARK: 팀, 상위팀-직속 미퇴근직원 리스트
    /**
     팀, 상위팀-직속 미퇴근직원 리스트
     - parameter cmpsid:        회사번호(필수) .. 회사 전체 조회시 (상위팀번호 -1, 팀번호 -1)
     - parameter ttmsid:        상위팀번호(상위팀 직속 조회시 팀번호는 0) .. 상위팀, 팀 번호 둘다 0인경우는 팀 미지정(팀소속 없는 직원들.. 팀이 없는경우)
     - parameter temsid:        팀번호(팀 조회시 상위팀번호는 -1)
     
     - returns: 미퇴근직원 리스트
     */
    
    func cmtNotLeaveEmpListRx(cmpsid: Int, ttmsid: Int, temsid: Int) -> Observable<(Bool , Int ,Int,Int ,String, [CmtEmplyInfo]?)> {
        return Observable.create { emitter in
            let notLeaveEmpListURL = self.getAPIURL(api: "ios/m/cmtnotleave_emplist.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)")
            print("\n---------- [ notLeaveEmpListURL : \(notLeaveEmpListURL) ] ----------\n")
            self.AlamofireAppManager?.request(notLeaveEmpListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let data) :
                    let statusCode = response.response?.statusCode
                    if statusCode == 200 {
                        //정상
                        if let jsonData = data as? [String : Any] {
                            if let resData = jsonData["commute"] as? [[String : Any]] ,
                                let empCnt = jsonData["empcnt"] as? Int ,
                                let anualCnt = jsonData["anualcnt"] as? Int ,
                                let applyCnt = jsonData["applycnt"] as? Int ,
                                let joinCode = jsonData["joincode"] as? String
                            {
                                let response = Mapper<CmtEmplyInfo>().mapArray(JSONArray: resData)
                                emitter.onNext((true , empCnt,anualCnt, applyCnt,joinCode,  response))
                            }
                        }
                        emitter.onCompleted()
                    }
                case .failure(let error):
                    print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                    emitter.onError(error)
                }
            })
            return Disposables.create()
        }
    }
    
    // MARK: 미출근직원 리스트
    /**
     팀, 상위팀-직속 미출근직원 리스트
     - parameter cmpsid:        회사번호(필수)
     - parameter ttmsid:        상위팀번호(상위팀 직속 조회시 팀번호는 0 또는 안넘김) .. 상위팀, 팀 번호 둘다 0인경우는 팀 미지정(팀소속 없는 직원들.. 팀이 없는경우)
     - parameter temsid:        팀번호(팀 조회시 상위팀번호는 0 또는 안넘김)
     
     - returns : 미출근직원 리스트
     */
    func cmtOffEmpList(cmpsid: Int, ttmsid: Int, temsid: Int, completion: @escaping (_ success:Bool , [CmtEmplyInfo]?) ->()) {
        let offEmpListURL = getAPIURL(api: "ios/m/cmtoff_emplist.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)")
        print("\n---------- [ offEmpListURL : \(offEmpListURL) ] ----------\n")
        AlamofireAppManager?.request(offEmpListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["commute"] as? [[String : Any]]{
                            let response = Mapper<CmtEmplyInfo>().mapArray(JSONArray: resData)
                            print("\n---------- [ response : \(response) ] ----------\n")
                            completion(true ,  response)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    
    func cmtOffEmpListRx(cmpsid: Int, ttmsid: Int, temsid: Int) -> Observable<(Bool , [CmtEmplyInfo]?)> {
        return Observable.create { emitter in
            self.cmtOffEmpList(cmpsid: cmpsid, ttmsid: ttmsid, temsid: temsid) { (isSuccess, resData) in
                if(isSuccess){
                    emitter.onNext((true, resData))
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    // MARK: 직원 월별 출퇴근기록 + 연차정보
    /**
     직원 월별 출퇴근기록 + 연차정보
     - parameter empsid:        직원번호
     - parameter dt:            월초일(형식: 2019-10-01).. 해당년월의 1일
     
     - returns: 직원 출퇴근기록 + 연차정보
     */
    func EmpDetailList(empsid: Int, dt: String, completion: @escaping (_ success:Bool ,_ addmin:Int, _ joindt:String , _ remainmin:Int , _ resUseMin:Int,_ resfical:Int, [EmplyInfoDetailList]?) ->()) {
        let EmpDetailURL = getAPIURL(api: "ios/m/emp_cmtlist.jsp?EMPSID=\(empsid)&DT=\(dt)")
        print("\n---------- [ EmpDetailURL : \(EmpDetailURL) ] ----------\n")
        AlamofireAppManager?.request(EmpDetailURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            print("\n---------- [ EmpDetailURL response : \(response) ] ----------\n")
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                print("\n---------- [ EmpDetailURL statusCode : \(statusCode) ] ----------\n")
                
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ EmpDetailURL jsonData : \(jsonData) ] ----------\n")
                        if let resAdmin = jsonData["addmin"] as? Int ,
                            let resJoinDt = jsonData["joindt"] as? String ,
                            let resRemain = jsonData["remainmin"] as? Int ,
                            let resfical = jsonData["calFicalmin"] as? Int,
                            let resusemin = jsonData["usemin"] as? Int ,
                            let resData = jsonData["commute"] as? [[String : Any]]{
                            
                            let response = Mapper<EmplyInfoDetailList>().mapArray(JSONArray: resData)
                            
                            completion(true , resAdmin , resJoinDt , resRemain,resusemin, resfical ,response )
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false ,0,"",0 ,0, 0, nil)
            }
        })
    }
    // MARK: 관리자가 직원 근무기록 직접 입력 - 정상근무로 등록됨
    /**
     관리자가 직원 근무기록 직접 입력 - 정상근무로 등록됨
     - parameter empsid:        직원번호
     - parameter sdt:            근무 시작일자(형식 : 2019-10-10 09:10) .. URL 인코딩
     - parameter edt:            근무 종료일자.. 종료일자는 시작일자보다 큰 시간이어야 함(형식 : 2019-10-10 18:20) .. URL 인코딩
     
     - returns: 성공:1, 실패:0, 시간중복 : -1
     */
    func Ins_cmtmgr(empsid: Int, sdt: String, edt: String, memo:String, completion: @escaping (_ success:Bool ,_ resCode:Int) ->()) {
        let url = URL(string: "\(API.baseURL)ios/m/ins_cmtmgr.jsp")
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]

        let defaultSession = URLSession(configuration: config)

        var request = URLRequest(url: url!)
        request.encodeParameters(parameters: [
            "EMPSID"    :  "\(empsid)",
            "SDT"      : "\(sdt)",
            "EDT"       : "\(edt)",
            "MEMO"   : memo
            ]
        )
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                completion(false , 0)
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false , 0)
                return
            }

            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                completion(true , res.result)
            } catch {
                completion(false , 0)
            }
        }
        dataTask.resume()
    }
    
    // MARK: 관리자가 직원 근무기록 직접 수정
    /**
     관리자가 직원 근무기록 직접 수정
     - parameter cmtsid:        근무기록 번호
     - parameter empsid:        직원번호
     - parameter sdt:            시작일자(형식 : 2019-10-10 09:10) .. URL 인코딩
     - parameter edt:            종료일자.. 종료일자는 시작일자보다 큰 시간이어야 함(형식 : 2019-10-10 18:20) .. URL 인코딩
     
     - returns: 성공:1, 실패:0
     */
    func Udt_cmtmgr(cmtsid: Int, empsid: Int, sdt: String, edt: String,memo:String , completion: @escaping (_ success:Bool ,_ resCode:Int) ->()) {
        let url = URL(string: "\(API.baseURL)ios/m/udt_cmtmgr.jsp")
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]

        let defaultSession = URLSession(configuration: config)

        var request = URLRequest(url: url!)
        request.encodeParameters(parameters: [
            "CMTSID"    :  "\(cmtsid)",
            "EMPSID"    :  "\(empsid)",
            "SDT"      : "\(sdt)",
            "EDT"       : "\(edt)",
            "MEMO"   : memo
            ]
        )
        print("\n---------- [ request : \(request) ,  ] ----------\n")
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                completion(false , 0)
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false , 0)
                return
            }

            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                completion(true , res.result)
            } catch {
                completion(false , 0)
            }
        }
        dataTask.resume()
    }
    
    
    // MARK: 관리자가 직원 근무기록 직접 삭제
    
    //MARK: - 관리자앱 - 메인정보
    func GetMain(empsid: Int, auth: Int, cmpsid: Int, ttmsid: Int, temsid: Int, completion: @escaping (_ success:Bool , MainInfo?) ->()) {
        
        let getMainURL = getAPIURL(api: "ios/m/get_main.jsp?EMPSID=\(empsid)&AUTH=\(auth)&CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)")
        
        print("\n---------- [ getMainURL : \(getMainURL) ] ----------\n")
        AlamofireAppManager?.request(getMainURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = Mapper<MainInfo>().map(JSON: jsonData){
                            print("\n---------- [ resData : \(resData) ] ----------\n")
                            completion(true , resData)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    
    /**
     관리자앱 - 메인정보
     
     - parameter empsid:        직원번호
     - parameter  auth:        권한( 1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.팀관리자).. 관리자앱 권한 없는 5.사원은 앱에서 막고.. 근로자앱으로 유도해야됨
     - parameter  cmpsid:        회사번호
     - parameter  ttmsid:        상위팀번호
     - parameter  temsid:        팀번호
     
     - returns: 출퇴근현황, 결재신청현황
     http://pinpl.wooriyo.com/ios/m/get_main.jsp?EMPSID=394&AUTH=1&CMPSID=200&TTMSID=0&TEMSID=0
     */
    func GetMainRx(empsid: Int, auth: Int, cmpsid: Int, ttmsid: Int, temsid: Int) -> Observable<(Bool , MainInfo?)> {
        return Observable.create { emitter in
            self.GetMain(empsid: empsid, auth: auth, cmpsid: cmpsid, ttmsid: ttmsid, temsid: temsid) { (isSuccess, resData) in
                if(isSuccess){
                    emitter.onNext((true, resData))
                    emitter.onCompleted()
                }else{
                    emitter.onNext((false, nil))
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    //MARK:  관리자가 직원 근무기록 직접 삭제
    /**
     관리자가 직원 근무기록 직접 삭제.. Type 9.결근은 삭제불가..앱에서 막아야됨
     
     - parameter cmtsid:        근무기록 번호
     - parameter empsid:        직원번호
     
     - returns : 성공:1, 실패:0
     */
    func Del_cmtmgr(cmtsid: Int, empsid: Int, completion: @escaping (_ success:Bool ,_ resCode:Int) ->()) {
        let DelURL = getAPIURL(api: "ios/m/del_cmtmgr.jsp?CMTSID=\(cmtsid)&EMPSID=\(empsid)")
        print("\n---------- [ DelURL : \(DelURL) ] ----------\n")
        AlamofireAppManager?.request(DelURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resCode = jsonData["result"] as? Int {
                            
                            completion(true , resCode)
                            
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false ,0)
            }
        })
    } 
    
    // MARK: - 연차
    
    //MARK: 상위팀 연차제한 설정 & 팀 연차제한 설정
    /**
     상위팀 연차제한 설정 & 팀 연차제한 설정
     - parameter ttmsid:        상위팀번호
     - parameter limit:        제한직원 수
     - parameter type : 1 - 상위팀 연차제한 설정 2: 팀 연차제한 설정
     
     - returns: 성공:1, 실패:0
     */
    func SetTtmAnualLimit(type:Int, ttmsid: Int, limit: Int, completion: @escaping (_ success: Bool, _ result: Int) ->()) {
        var AnualLimitURL = ""
        if type == 1 {
            AnualLimitURL = getAPIURL(api: "ios/m/set_ttm_anuallimit.jsp?TTMSID=\(ttmsid)&LIMIT=\(limit)")
            
        }else{
            AnualLimitURL = getAPIURL(api: "ios/m/set_tem_anuallimit.jsp?TEMSID=\(ttmsid)&LIMIT=\(limit)")
        }
        
        
        print("\n---------- [ AnualLimitURL : \(AnualLimitURL) ] ----------\n")
        AlamofireAppManager?.request(AnualLimitURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success(let data):
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int {
                            completion(true, resultCode)
                        }
                    }
                }
            case.failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    //MARK:  연차신청 결재,참조 리스트
    /**
     연차신청 결재,참조 리스트
     - parameter empsid:        직원번호(본인)
     - parameter curkey:        페이징 키(첫 페이지는 0 또는 안넘김)
     - parameter listcnt:        리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     
     - returns: 연차신청 결재,참조리스트
     */
    func anualaprList(empsid: Int, curkey: Int, listcnt: Int, completion: @escaping (_ success:Bool , _ total:Int , _ nextkey:Int , [AnualListArr]?) ->()) {
        
        let anualaprListURL = getAPIURL(api: "ios/m/anualapr_list.jsp?EMPSID=\(empsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)")
        
        print("\n---------- [ anualaprListURL : \(anualaprListURL) ] ----------\n")
        AlamofireAppManager?.request(anualaprListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let restotal = jsonData["total"] as? Int ,
                            let resnextkey = jsonData["nextkey"] as? Int ,
                            let resData = jsonData["anualapr"] as? [[String : Any]] {
                            let resultArr = Mapper<AnualListArr>().mapArray(JSONArray: resData)
                            completion(true , restotal,resnextkey ,resultArr)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0,0,nil )
            }
        })
    }
    // MARK: 2021.01.25 연차신청 결재,참조리스트 - total , nextkey 삭제
    func anualaprList_New(empsid: Int, curkey: Int, listcnt: Int, completion: @escaping (_ success:Bool , [AnualListArr]?) ->()) {
        
        let anualaprListURL = getAPIURL(api: "ios/m/anualapr_list2.jsp?EMPSID=\(empsid)")
        
        print("\n---------- [ anualaprListURL : \(anualaprListURL) ] ----------\n")
        AlamofireAppManager?.request(anualaprListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if  let resData = jsonData["anualapr"] as? [[String : Any]] {
                            let resultArr = Mapper<AnualListArr>().mapArray(JSONArray: resData)
                            completion(true , resultArr)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    
    //MARK:  근로신청 결재,참조 리스트
    /**
     근로신청 결재,참조 리스트
     
     - parameter empsid:        직원번호(본인)
     - parameter curkey:        페이징 키(첫 페이지는 0 또는 안넘김)
     - parameter listcnt:        리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     
     - returns: 근로신청 결재,참조리스트
     */
    func applyList(empsid: Int, curkey: Int, listcnt: Int, completion: @escaping (_ success:Bool , _ total:Int , _ nextkey:Int , [ApplyListArr]?) ->()) {
        
        let applyListURL = getAPIURL(api: "ios/m/applyapr_list.jsp?EMPSID=\(empsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)")
        
        print("\n---------- [ applyListURL : \(applyListURL) ] ----------\n")
        AlamofireAppManager?.request(applyListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let restotal = jsonData["total"] as? Int ,
                            let resnextkey = jsonData["nextkey"] as? Int ,
                            let resData = jsonData["anualapr"] as? [[String : Any]] {
                            let resultArr = Mapper<ApplyListArr>().mapArray(JSONArray: resData)
                            completion(true , restotal,resnextkey ,resultArr)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0,0,nil )
            }
        })
    }
    
    // MARK: 2021.01.25 출장신청 결재,참조리스트 - total , nextkey 삭제
    func applyList_New(empsid: Int, curkey: Int, listcnt: Int, completion: @escaping (_ success:Bool ,   [ApplyListArr]?) ->()) {
        
        let applyListURL = getAPIURL(api: "ios/m/applyapr_list2.jsp?EMPSID=\(empsid)")
        
        print("\n---------- [ applyListURL : \(applyListURL) ] ----------\n")
        AlamofireAppManager?.request(applyListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if  let resData = jsonData["applyapr"] as? [[String : Any]] {
                            let resultArr = Mapper<ApplyListArr>().mapArray(JSONArray: resData)
                            completion(true , resultArr)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    
    //MARK:  연차결재처리 - 보류, 승인, 반려
    /**
     연차결재처리 - 보류, 승인, 반려
     - parameter aprsid:    연차신청 번호
     - parameter empsid:    결재자 직원번호(본인)
     - parameter step:    결재 단계 (1.1차, 2.2차, 3.3차)
     - parameter ddctn:    연차차감 여부(0.미차감 1.차감)
     - parameter apr:        처리(1.보류, 2.승인, 3.반려)
     - parameter reason:    보류/반려사유 .. URL 인코딩
     - parameter next:    다음 결재자 직원번호(보류, 반려의 경우와 최종 결재자의경우 0 넘김) .. 승인 + 다음 결재자 있는경우에만 다음결재자 직원번호 전송 그외 0
     
     - returns: 성공:1, 실패:0, 결재권한 없는경우:-1
     test
     http://ios.pinpl.biz/ios/m/proc_applyapr.jsp?APRSID=14&EMPSID=39&STEP=1&APR=1&REASON=%E3%85%8E%E3%85%8E%E3%85%8E&NEXT=0
     */
    func procAnualapr(aprsid: Int, empsid: Int, step: Int, ddctn: Int, apr: Int, reason: String, next: Int, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let anualaprURL = getAPIURL(api: "ios/m/proc_anualapr.jsp?APRSID=\(aprsid)&EMPSID=\(empsid)&STEP=\(step)&DDCTN=\(ddctn)&APR=\(apr)&REASON=\(reason)&NEXT=\(next)")
        
        print("\n---------- [ anualaprURL : \(anualaprURL) ] ----------\n")
        let url = URL(string: "\(API.baseURL)/ios/m/proc_anualapr.jsp")
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let defaultSession = URLSession(configuration: config)
        
        var request = URLRequest(url: url!)
        request.encodeParameters(parameters: [
            "APRSID"    : "\(aprsid)",
            "EMPSID"    :   "\(empsid)",
            "STEP"      :   "\(step)",
            "DDCTN"     : "\(ddctn)",
            "APR"       :  "\(apr)",
            "NEXT"      : "\(next)",
            "REASON"   : reason
            ]
        )
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                completion(false , 0)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false , 0)
                return
            }
            
            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                completion(true , res.result)
            } catch {
                completion(false , 0)
            }
        }
        dataTask.resume()
    }
    
    
    //MARK:  근로결재처리 - 보류, 승인, 반려
    /**
     근로결재처리 - 보류, 승인, 반려
     - parameter aprsid:    연차신청 번호
     - parameter empsid:    결재자 직원번호(본인)
     - parameter step:    결재 단계 (1.1차, 2.2차, 3.3차)
     - parameter apr:        처리(1.보류, 2.승인, 3.반려)
     - parameter reason:    보류/반려사유 .. URL 인코딩
     - parameter next:    다음 결재자 직원번호(보류, 반려의 경우와 최종 결재자의경우 0 넘김) .. 승인 + 다음 결재자 있는경우에만 다음결재자 직원번호 전송 그외 0
     
     - returns: 성공:1, 실패:0, 결재권한 없는경우:-1
     test
     http://ios.pinpl.biz/ios/m/proc_applyapr.jsp?APRSID=14&EMPSID=39&STEP=1&APR=1&REASON=%E3%85%8E%E3%85%8E%E3%85%8E&NEXT=0
     */
    func procApplyapr(aprsid: Int, empsid: Int, step: Int, apr: Int, reason: String, next: Int, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        let url = URL(string: "\(API.baseURL)/ios/m/proc_applyapr.jsp")
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let defaultSession = URLSession(configuration: config)
        
        var request = URLRequest(url: url!)
        request.encodeParameters(parameters: [
            "APRSID"    : "\(aprsid)",
            "EMPSID"    :  "\(empsid)",
            "STEP"      : "\(step)",
            "APR"       : "\(apr)",
            "NEXT"      : "\(next)",
            "REASON"   : reason
            ]
        )
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                completion(false , 0)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false , 0)
                return
            }
            
            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                completion(true , res.result)
            } catch {
                completion(false , 0)
            }
        }
        dataTask.resume()
    }
    //MARK:  연차신청 참조 확인 처리
    /**
     연차신청 참조 확인 처리
     - parameter aprsid:    연차신청 번호
     - parameter empsid:    결재자 직원번호(본인)
     
     - returns: 성공:1, 실패:0, 결재권한 없는경우:-1
     test
     http://ios.pinpl.biz/ios/m/proc_applyapr.jsp?APRSID=14&EMPSID=39&STEP=1&APR=1&REASON=%E3%85%8E%E3%85%8E%E3%85%8E&NEXT=0
     */
    func readAnualapr(aprsid: Int, empsid: Int, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let readAnualaprURL = getAPIURL(api: "ios/m/read_anualapr.jsp?APRSID=\(aprsid)&EMPSID=\(empsid)")
        
        print("\n---------- [ readAnualaprURL : \(readAnualaprURL) ] ----------\n")
        AlamofireAppManager?.request(readAnualaprURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    //MARK:  출장 참조 확인 처리
    /**
     근로신청 참조 확인 처리
     - parameter aprsid:    근로신청번호
     - parameter empsid:    참조자 직원번호(본인)
     
     - returns: 성공:1, 실패:0, 참조가 권한없음:-1
     */
    func readApplyapr(aprsid: Int, empsid: Int, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let readApplyaprURL = getAPIURL(api: "ios/m/read_applyapr.jsp?APRSID=\(aprsid)&EMPSID=\(empsid)")
        
        print("\n---------- [ readApplyaprURL : \(readApplyaprURL) ] ----------\n")
        AlamofireAppManager?.request(readApplyaprURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    //MARK:  일괄 연차신청 상세 날짜별 연차차감 여부 갱신
    /**
     일괄 연차신청 상세 날짜별 연차차감 여부 갱신
     - parameter subsid:    일괄 연차신청 상세번호
     - parameter ddctn:    차감여부(0.미차감 1.차감)
     
     - returns: 성공:1, 실패:0
     
     */
    func udt_anualaprsub_ddctn(subsid: Int, ddctn: Int, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let udtddctnURL = getAPIURL(api: "ios/m/udt_anualaprsub_ddctn.jsp?SUBSID=\(subsid)&DDCTN=\(ddctn)")
        
        print("\n---------- [ udtddctnURL : \(udtddctnURL) ] ----------\n")
        AlamofireAppManager?.request(udtddctnURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    // MARK: - 더보기
    //MARK: 회사 연차 설정
    
    /**
     회사 연차 설정
     - parameter cmpsid:        회사번호
     - parameter anualddctn1:            지각 연차차감 여부 0.미차감, 1.차감
     - parameter anualddctn2:            조퇴 연차차감 여부 0.미차감, 1.차감
     - parameter anualddctn3:            외출 연차차감 여부 0.미차감, 1.차감
     
     - returns: 성공:1, 실패:0
     */
    func SetCmpAnualddctn(cmpsid: Int, anualddctn1: Int, anualddctn2: Int, anualddctn3: Int, nStAnual: Int, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let cmpAnualddctnURL = getAPIURL(api: "ios/m/set_cmp_anualddctn.jsp?CMPSID=\(cmpsid)&AD1=\(anualddctn1)&AD2=\(anualddctn2)&AD3=\(anualddctn3)&STANUAL=\(nStAnual)")
        
        print("\n---------- [ cmpAnualddctnURL : \(cmpAnualddctnURL) ] ----------\n")
        AlamofireAppManager?.request(cmpAnualddctnURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    
    // MARK: - 더보기
    //MARK: 회사회계년도 기준 설정
    
    /**
     회사 연차 설정
     - parameter cmpsid:        회사번호
     - parameter anualYear:     회계년도 기준
     
     - returns: 성공:1, 실패:0
     */
    func SetCmpAnualFical(cmpsid: Int, anualYear: String, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let SetCmpAnualFicalURL = getAPIURL(api: "ios/m/set_cmp_ficalanual.jsp?CMPSID=\(cmpsid)&STANUALYEAR=\(anualYear)")
        
        print("\n---------- [ SetCmpAnualFicalURL : \(SetCmpAnualFicalURL) ] ----------\n")
        AlamofireAppManager?.request(SetCmpAnualFicalURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    
    //MARK:  회사 근무시간 설정
    
    /**
     회사 근무시간 설정
     - parameter cmpsid:        회사번호
     - parameter cmpnm:     회사명
     - parameter cmtrc:        출퇴근기록 설정(0.회사 근무시간기준기록 1.자율기록 default '0')
     - parameter schdl:            근무일정 사용여부 0.사용안함 1.사용함
     - parameter starttm:            근무 시작시간.. ex)09:00
     - parameter endtm:            근무 종료시간.. ex)18:00
     - parameter brktime:            휴게시간 설정(0.설정안함 1.설정 default '1')
     - parameter workday:            근무요일.. 1(일),2(월),3(화),4(수),5(목),6(금),7(토) 구분자 ','  .. ex) 2,3,4,5,6
     
     - returns: 성공:1, 실패:0
     */
    func SetCmpSchdl(cmpsid: Int, cmpnm: String, cmtrc: Int, schdl: Int, starttm: String, endtm: String, brktime: Int, workday: String, cmtlt:Int, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let setScheduleURL = getAPIURL(api: "ios/m/set_cmp_schdl.jsp?CMPSID=\(cmpsid)&CMPNM=\(cmpnm)&CMTRC=\(cmtrc)&SCD=\(schdl)&ST=\(starttm)&ET=\(endtm)&BT=\(brktime)&WD=\(workday)&CMTLT=\(cmtlt)")
        
        print("\n---------- [ setScheduleURL : \(setScheduleURL) ] ----------\n")
        AlamofireAppManager?.request(setScheduleURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] { 
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    //MARK: 회사 주52시간제 설정
    
    /**
     회사 주52시간제 설정
     - parameter cmpsid:        회사번호
     - parameter wk52h:        주52시간제 설정(0.주단위 1.월단위)
     - returns: 성공:1, 실패:0, -1:회사 근무일정 있는경우 월단위 선택시 월단위 선택 불가
     */
    func SetCmpWk52h(cmpsid: Int, wk52h: Int, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let setCmpWk52hURL = getAPIURL(api: "ios/m/set_cmp_wk52h.jsp?CMPSID=\(cmpsid)&WK52H=\(wk52h)")
        
        print("\n---------- [ setCmpWk52hURL : \(setCmpWk52hURL) ] ----------\n")
        AlamofireAppManager?.request(setCmpWk52hURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    //MARK: 직원 주간, 월간 근로시간 리스트
    
    /**
     직원 주간, 월간 근로시간 리스트
     - parameter wk52h:        주52시간제 설정정보(0.주간 1.월간)
     - parameter empsid:        직원번호
     
     - returns: 주간, 월간 근로시간 리스트
     */
    func EmpWorkminlist(wk52h: Int, empsid: Int, completion: @escaping (_ success:Bool , [EmplyInfoDetail]?) ->()) {
        
        let empWorkminlistURL = getAPIURL(api: "ios/m/emp_workminlist.jsp?WK52H=\(wk52h)&EMPSID=\(empsid)")
        
        print("\n---------- [ empWorkminlistURL : \(empWorkminlistURL) ] ----------\n")
        AlamofireAppManager?.request(empWorkminlistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["empwork"] as? [[String : Any]]{
                            let response = Mapper<EmplyInfoDetail>().mapArray(JSONArray: resData)
                            print("\n---------- [ response : \(response) ] ----------\n")
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , [] )
            }
        })
    }
    
    // MARK:  회사 출퇴근영역 설정
    /**
     회사 출퇴근영역 설정
     - parameter cmpsid:         회사번호
     - parameter   cmpnm:     회사이름 - URL 인코딩(푸시알림을위해 추가..2019-11-20)
     - parameter  area :        출퇴근영역설정 0.설정안함 1.WiFi 2.Gps 3.Beacon
     - parameter  wnm:            WiFi 이름 .. URL 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter  wmac:        WiFi MAC .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter wip:            WiFi IP .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter  bcon :        비콘 UUID .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter lat:            위치정보 위도 .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter long:        위치정보 경도 .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter addr:        위치정보 주소 ..URL 인코딩 후 Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter scope:        위치범위(반경)..(50m, 100m, 300m, 500m) ..2021-04-29 추가
      
     - returns : 성공:1, 실패:0
     */
    func SetCmpCmtarea(cmpsid: Int, cmpnm: String, area: Int, wnm: String, wmac: String, wip: String, bcon: String, lat: String, long: String, addr: String, scope: Int, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let cmtareaURL = getAPIURL(api: "ios/m/set_cmp_cmtarea.jsp?CMPSID=\(cmpsid)&CMPNM=\(cmpnm)&AREA=\(area)&WNM=\(wnm)&WMAC=\(wmac)&WIP=\(wip)&BCON=\(bcon)&LAT=\(lat)&LONG=\(long)&ADDR=\(addr)&SCOPE=\(scope)")
        
        print("\n---------- [ cmtareaURL : \(cmtareaURL) ] ----------\n")
        AlamofireAppManager?.request(cmtareaURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    // MARK: 관리자앱 배너제거 월 이용 설정
    /**
     관리자앱 배너제거 월 이용 설정
     - parameter cmpsid:        회사번호
     - parameter mbrsid:        회원번호

     - returns: 성공:1, 실패:0, 핀포인트 부족:-1
     */
    func Sethiddenm(cmpsid: Int, mbrsid: Int,  completion: @escaping (_ success:Bool , _ result:Int , _ hiddendate:String) ->()) {

        let SethiddenmURL = getAPIURL(api: "ios/m/set_hidebnm.jsp?CMPSID=\(cmpsid)&MBRSID=\(mbrsid)")

        print("\n---------- [ SethiddenmURL : \(SethiddenmURL) ] ----------\n")
        AlamofireAppManager?.request(SethiddenmURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int ,
                           let resultDate = jsonData["hidebnm"] as? String {
                            completion(true ,  resultCode , resultDate)
                        }
                    }

                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 , "")
            }
        })
    }
 
    // MARK: 근로자앱 배너제거 월 이용 설정
    /**
     근로자앱 배너제거 월 이용 설정
     - parameter cmpsid:        회사번호
     - parameter mbrsid:        회원번호

     - returns: 성공:1, 실패:0, 핀포인트 부족:-1
     */
    func Sethidden(cmpsid: Int, mbrsid: Int,  completion: @escaping (_ success:Bool , _ result:Int , _ hiddendate:String) ->()) {

        let SethiddenURL = getAPIURL(api: "ios/m/set_hidebn.jsp?CMPSID=\(cmpsid)&MBRSID=\(mbrsid)")

        print("\n---------- [ SethiddenURL : \(SethiddenURL) ] ----------\n")
        AlamofireAppManager?.request(SethiddenURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int ,
                           let resultDate = jsonData["hidebn"] as? String {
                            completion(true ,  resultCode , resultDate)
                        }
                    }

                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 , "")
            }
        })
    }
 
    // MARK: 증빙용 근로기록조회 월 이용 설정
    /**
     증빙용 근로기록조회 월 이용 설정
     - parameter cmpsid:        회사번호
     - parameter mbrsid:        회원번호

     - returns: 성공:1, 실패:0, 핀포인트 부족:-1
     */
    func SetCmtList(cmpsid: Int, mbrsid: Int,  completion: @escaping (_ success:Bool , _ result:Int , _ hiddendate:String) ->()) {

        let SetCmtListURL = getAPIURL(api: "ios/m/set_empcmt.jsp?CMPSID=\(cmpsid)&MBRSID=\(mbrsid)")

        print("\n---------- [ SetCmtListURL : \(SetCmtListURL) ] ----------\n")
        AlamofireAppManager?.request(SetCmtListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int ,
                           let resultDate = jsonData["empcmt"] as? String {
                            completion(true ,  resultCode , resultDate)
                        }
                    }

                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 , "")
            }
        })
    }
    
    // MARK: 회계년도 월 이용 설정
    /**
     회계년도 월 이용 설정
     - parameter cmpsid:        회사번호
     - parameter mbrsid:        회원번호

     - returns: 성공:1, 실패:0, 핀포인트 부족:-1
     */
    func Setfical(cmpsid: Int, mbrsid: Int,  completion: @escaping (_ success:Bool , _ result:Int , _ hiddendate:String) ->()) {

        let SethiddenURL = getAPIURL(api: "ios/m/set_hiddenfical.jsp?CMPSID=\(cmpsid)&MBRSID=\(mbrsid)")

        print("\n---------- [ SethiddenURL : \(SethiddenURL) ] ----------\n")
        AlamofireAppManager?.request(SethiddenURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int ,
                           let resultDate = jsonData["ficalAnual"] as? String {
                            completion(true ,  resultCode , resultDate)
                        }
                    }

                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 , "")
            }
        })
    }
    
    // MARK: 데이터보관 월 이용 설정
    /**
     데이터보관 월 이용 설정
     - parameter cmpsid:        회사번호
     - parameter mbrsid:        회원번호

     - returns: 성공:1, 실패:0, 핀포인트 부족:-1
     */
    func setDataLimits(cmpsid: Int, mbrsid: Int,  completion: @escaping (_ success:Bool , _ result:Int , _ hiddendate:String) ->()) {

        let setDataURL = getAPIURL(api: "ios/m/set_dataLimits.jsp?CMPSID=\(cmpsid)&MBRSID=\(mbrsid)")

        print("\n---------- [ setDataURL : \(setDataURL) ] ----------\n")
        AlamofireAppManager?.request(setDataURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int ,
                           let resultDate = jsonData["datalimits"] as? String {
                            completion(true ,  resultCode , resultDate)
                        }
                    }

                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 , "")
            }
        })
    }
    
    //MARK: 출퇴근 알림설정
    /**
     - parameter cmpsid  :      회사번호
     - parameter cmtnoti  :      출퇴근알림 설정(0.사용하지않음 1.사용함)
     
     - returns: 성공:1, 실패:0, 회사근무일정 사용안함으로 설정된경우 : -1
     */
    func SetCmpNoti(cmpsid: Int, cmtnoti: Int, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let cmtnotiURL = getAPIURL(api: "ios/m/set_cmp_cmtnoti.jsp?CMPSID=\(cmpsid)&CMTNOTI=\(cmtnoti)")
        
        print("\n---------- [ cmtnotiURL : \(cmtnotiURL) ] ----------\n")
        AlamofireAppManager?.request(cmtnotiURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    //MARK: 직원 권한설정
    /**
     직원 권한설정
     - parameter empsids  :      직원번호들(구분자',')
     - parameter auth  :      권한(0.혼자쓰기 1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.팀관리자  5.직원) .. 해지시 5 넘김
     - parameter temsid  :      팀번호(팀관리자의 경우에만 필요.. 그외 0)
     - parameter ttmsid    :    상위팀번호(상위팀관리자의 경우에만 필요.. 그외 0)
     
     - returns: 성공:설정완료 카운트, 실패:0
     
     */
    func SetEmpAuthor(empsids: String, auth: Int, temsid: Int, ttmsid: Int, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let AuthorURL = getAPIURL(api: "ios/m/set_emp_author.jsp?EMPSIDS=\(empsids)&AUTH=\(auth)&TEMSID=\(temsid)&TTMSID=\(ttmsid)")
        
        print("\n---------- [ AuthorURL : \(AuthorURL) ] ----------\n")
        AlamofireAppManager?.request(AuthorURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    // MARK: 직원 관리자 권한 해제
    /**
     직원 관리자 권한 해제
     - parameter empsids:        직원번호들(구분자',')
     - parameter temsid   :     팀번호(팀관리자의 경우에만 필요.. 그외 0)
     - parameter ttmsid  :      상위팀번호(상위팀관리자의 경우에만 필요.. 그외 0)
     
     - returns: 성공 : 1, 실패 : 0, 결재라인 관리자로 해제처리 불가 : -1
     */
    func CancelAuthor(empsids: String,   temsid: Int, ttmsid: Int, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let AuthorURL = getAPIURL(api: "ios/m/except_mgr.jsp?EMPSID=\(empsids)&TEMSID=\(temsid)&TTMSID=\(ttmsid)")
        
        print("\n---------- [ AuthorURL : \(AuthorURL) ] ----------\n")
        AlamofireAppManager?.request(AuthorURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    //MARK:  마스터관리자 권한 위임
    /**
     마스터관리자 권한 위임
     - parameter sndsid:        현재 마스터관리자 직원번호(본인 직원번호).. 현재 마스터 관리자만 권한 위임 할 수 있기 때문에 본인 직원 번호 임
     - parameter rcvsid:        마스터관리자 위임 받을 직원 직원번호
     
     - returns : 1.성공 0.실패 -1.마스터권한 없음
     */
    func DelegateMaster(sndsid: Int, rcvsid: Int, completion: @escaping (_ success:Bool , _ result:Int) ->()) {
        
        let DelegateMasterURL = getAPIURL(api: "ios/m/delegate_master.jsp?SNDSID=\(sndsid)&RCVSID=\(rcvsid)")
        
        print("\n---------- [ DelegateMasterURL : \(DelegateMasterURL) ] ----------\n")
        AlamofireAppManager?.request(DelegateMasterURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    
    
    //MARK:  회사 최고관리자 리스트 - 본인제외
    /**
     회사 일반직원 리스트
     - parameter cmpsid     :   회사번호
     - parameter empsid     :   직원번호
     */
    func CmpSmgrList(cmpsid: Int, empsid: Int, completion: @escaping (_ success:Bool , [EmplyInfo]?) ->()) {
        
        let CmpSmgrListURL = getAPIURL(api: "ios/m/cmp_smgrlist.jsp?CMPSID=\(cmpsid)&EMPSID=\(empsid)")
        
        print("\n---------- [ CmpSmgrListURL : \(CmpSmgrListURL) ] ----------\n")
        AlamofireAppManager?.request(CmpSmgrListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]]{
                            let response = Mapper<EmplyInfo>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    
    
    //MARK:  회사 최고관리자 리스트 - 마스터관리자 위임을 위한 최고관리자 목록
    
    /**
     회사 최고관리자 리스트 - 마스터관리자 위임을 위한 최고관리자 목록
     - parameter cmpsid :        회사번호
     - returns : 회사 최고관리자 리스트
     */
    func CmpSupermgrlist(cmpsid: Int, completion: @escaping (_ success:Bool , [SuperMgrInfo]?) ->()) {
        
        let cmpSupermgrlistURL = getAPIURL(api: "ios/m/cmp_supermgrlist.jsp?CMPSID=\(cmpsid)")
        
        print("\n---------- [ cmpSupermgrlistURL : \(cmpSupermgrlistURL) ] ----------\n")
        AlamofireAppManager?.request(cmpSupermgrlistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]]{
                            let response = Mapper<SuperMgrInfo>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    
    
    //MARK:  권한별 감독이 필요한 근로자 리스트 - 최고관리자-화사전체, 상위팀관리자-하위팀+직속, 팀관리자-팀원
    /**
     권한별 감독이 필요한 근로자 리스트 - 최고관리자-화사전체, 상위팀관리자-하위팀+직속, 팀관리자-팀원
     Parameter
     - parameter wk52h:        주52시간제 설정 상태(0.주단위 1.월단위)
     - parameter cmpsid:        회사번호(필수)
     - parameter ttmsid:        상위팀번호(상위팀관리자 필수.. 팀번호는 0넘김)
     - parameter temsid:        팀번호(팀관리자 필수... 상위팀 번호는 0넘김)
     
     - returns : 감독이 필요한 근로자 리스트
     */
    func WarningEmplist(wk52h: Int, cmpsid: Int, ttmsid: Int, temsid: Int, completion: @escaping (_ success:Bool , [WarningEmpInfo]?) ->()) {
        
        let warningEmplistURL = getAPIURL(api: "ios/m/warning_emplist.jsp?WK52H=\(wk52h)&CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)")
        
        print("\n---------- [ warningEmplistURL : \(warningEmplistURL) ] ----------\n")
        AlamofireAppManager?.request(warningEmplistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["warning"] as? [[String : Any]]{
                            let response = Mapper<WarningEmpInfo>().mapArray(JSONArray: resData)
                            
                            completion(true ,  response)
                        }else{
                            completion(true , nil)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    //MARK: 연차촉진 관리직원 리스트 - 회사, 상위팀, 팀 같이 이용
    /**
     연차촉진 관리직원 리스트 - 회사, 상위팀, 팀 같이 이용
     
     - parameter author : 권한
     - parameter cmpsid:        회사번호 .. 상위팀번호, 팀번호는 0 또는 안보냄
     - parameter ttmsid:        상위팀번호.. 회사번호, 팀번호는 0 또는 안보냄
     - parameter temsid:        팀번호.. 회사번호, 상위팀번호는 0 또는 안보냄
     
     - returns : 회사 연차촉진 관리직원 리스트
     */
    func AnualAdviselist(author: Int, cmpsid: Int, ttmsid: Int, temsid: Int, completion: @escaping (_ success:Bool , [AnualInfo]?) ->()) {
        
        var anualAdviselistURL = ""
        
        switch author {
        case 1, 2:
            anualAdviselistURL = getAPIURL(api: "ios/m/anual_adviselist.jsp?CMPSID=\(cmpsid)&TTMSID=\(0)&TEMSID=\(0)")
        case 3:
            anualAdviselistURL = getAPIURL(api: "ios/m/anual_adviselist.jsp?CMPSID=\(0)&TTMSID=\(ttmsid)&TEMSID=\(0)")
        case 4:
            anualAdviselistURL = getAPIURL(api: "ios/m/anual_adviselist.jsp?CMPSID=\(0)&TTMSID=\(0)&TEMSID=\(temsid)")
        default:
            anualAdviselistURL = getAPIURL(api: "ios/m/anual_adviselist.jsp?CMPSID=\(cmpsid)&TTMSID=\(0)&TEMSID=\(0)")
            break
        }
        
        
        print("\n---------- [ anualAdviselistURL : \(anualAdviselistURL) ] ----------\n")
        AlamofireAppManager?.request(anualAdviselistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["anual"] as? [[String : Any]]{
                            let response = Mapper<AnualInfo>().mapArray(JSONArray: resData)
                            
                            completion(true ,  response)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    //MARK: 회원 정보
    /**
     회원 정보
     - parameter mbrsid:        회원번호
     - returns : 회원 정보
     http://pinpl.wooriyo.com/ios/get_mbr_info.jsp?MBRSID=2
     */
    func GetMbrInfo(mbrsid: Int, completion: @escaping (_ success:Bool , getMbrInfo?) ->()) {
        
        let getMbrInfoURL = getAPIURL(api: "ios/get_mbr_info.jsp?MBRSID=\(mbrsid)")
        
        print("\n---------- [ getMbrInfoURL : \(getMbrInfoURL) ] ----------\n")
        AlamofireAppManager?.request(getMbrInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ getMbrInfoURL jsonData : \(jsonData) ] ----------\n")
                        if let resData = Mapper<getMbrInfo>().map(JSON: jsonData){
                            completion(true , resData)
                        }
                    }else{
                        completion(false , nil)
                    }
                    
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    //MARK: 직원 정보
    /**
     직원 정보
     
     - parameter empsid:        직원번호
     - returns : 직원 정보
     */
    func GetEmpInfo(empsid: Int, completion: @escaping (_ success:Bool , EmpInfoList?) ->()) {
        
        let getEmpInfoURL = getAPIURL(api: "ios/m/get_emp_info.jsp?EMPSID=\(empsid)")
        
        print("\n---------- [ getEmpInfoURL : \(getEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(getEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<EmpInfoList>().map(JSON: jsonData)
                        
                        completion(true ,  resData)
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    //MARK: 직원 퇴직처리
    /**
     직원 퇴직처리
     
     - parameter empsid:        직원번호
     - parameter leavedt:        퇴직일자(형식 2019-11-30)
     - parameter sk:            인증코드(직원번호 SHA1 암호화 해서 넘김)
     
     - returns : 퇴직처리 결과 1.성공 0.실패
     */
    func LeaveEmply(empsid: Int, leavedt: String, sk: String, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let LeaveEmplyURL = getAPIURL(api: "ios/m/leave_emply.jsp?EMPSID=\(empsid)&LEAVEDT=\(leavedt)&SK=\(sk)")
        
        print("\n---------- [ LeaveEmplyURL : \(LeaveEmplyURL) ] ----------\n")
        AlamofireAppManager?.request(LeaveEmplyURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    //MARK: 합류코드 변경
    /**
     합류코드 변경
     
     - parameter codesid:        합류코드번호
     - returns : 성공:변경된 합류코드, 실패:""
     */
    func UpdateJoinCode(codesid: Int, completion: @escaping (_ success:Bool , _ resultCode:String) ->()) {
        
        let joinCodeURL = getAPIURL(api: "ios/m/udt_joincode.jsp?CODESID=\(codesid)")
        
        print("\n---------- [ joinCodeURL : \(joinCodeURL) ] ----------\n")
        AlamofireAppManager?.request(joinCodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["code"] as? String{
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , "" )
            }
        })
    }
    //MARK: 회사 특별휴무일 설정
    /**
     회사 특별휴무일 설정
     url = "\(API.baseURL)ios/m/set_cmp_holiday.jsp?CMPSID=\(cmpsid)&DT=\(dt)&NM=\(nm)&RPT=\(rpt)"
     - parameter cmpsid: 회사번호
     - parameter dt: 날짜(형식 : 2019-05-05) .. URL 인코딩
     - parameter nm:  휴뮤일제목.. URL 인코딩
     - parameter rpt: 반복설정 0.반복안함 1.매년 2.매월
     
     - returns: 성공:1, 실패:0, 이미등록:-1
     */
    func setCmpHoldiay(cmpsid: Int, dt: String, nm: String, rpt: Int ,completion: @escaping (_ success:Bool ,_ result:Int) ->()) {
        let setCmpholidayURL = getAPIURL(api: "ios/m/set_cmp_holiday.jsp?CMPSID=\(cmpsid)&DT=\(dt)&NM=\(nm)&RPT=\(rpt)")
        
        print("\n---------- [ setCmpholidayURL : \(setCmpholidayURL) ] ----------\n")
        AlamofireAppManager?.request(setCmpholidayURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    /**
     회사 특별휴무일 설정
     url = "\(API.baseURL)ios/m/set_cmp_holiday.jsp?CMPSID=\(cmpsid)&DT=\(dt)&NM=\(nm)&RPT=\(rpt)"
     - parameter cmpsid: 회사번호
     - parameter dt: 날짜(형식 : 2019-05-05) .. URL 인코딩
     - parameter nm:  휴뮤일제목.. URL 인코딩
     - parameter rpt: 반복설정 0.반복안함 1.매년 2.매월
     
     - returns: 성공:1, 실패:0, 이미등록:-1
     */
    
    func setCmpHolidayRx(cmpsid: Int, dt: String, nm: String, rpt: Int ) -> Observable<(Bool ,Int)>{
        return Observable.create { emitter in
            self.setCmpHoldiay(cmpsid: cmpsid, dt: dt, nm: nm, rpt: rpt) { (isSuccess, resCode) in
                if(isSuccess){
                    emitter.onNext((true , resCode ))
                    emitter.onCompleted()
                }else{
                    emitter.onNext((false , 0 ))
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    //MARK: 회사 특별휴무일 리스트
    /**
     회사 특별휴무일 리스트
     - parameter cmpsid : 회사번호
     - returns:  특별휴무일 리스트 .. 페이징 없음 .. Sorting 최근등록순
     */
    func getCmpHolidayList(cmpsid: Int , completion: @escaping (_ success:Bool , [HolidayInfo]?) ->()) {
        let CmpholidayURL = getAPIURL(api: "ios/m/cmp_holidaylist.jsp?CMPSID=\(cmpsid)")
        
        print("\n---------- [ CmpholidayURL : \(CmpholidayURL) ] ----------\n")
        AlamofireAppManager?.request(CmpholidayURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["cmpholiday"] as? [[String : Any]]{
                            let response = Mapper<HolidayInfo>().mapArray(JSONArray: resData)
                            print("\n---------- [ holiday : \(response) ] ----------\n")
                            completion(true ,  response)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    
    
    //MARK: 회사 특별휴무일 변경
    /**
     회사 특별휴무일 변경
     
     - parameter cmpsid:        회사번호
     - parameter hldsid:        휴무일번호
     - parameter dt:            날짜(형식 : 2019-05-05) .. URL 인코딩
     - parameter nm:            휴뮤일제목.. URL 인코딩
     - parameter rpt:            반복설정 0.반복안함 1.매년
     
     - returns : 성공:1, 실패:0, 기존등록:-1
     */
    func UdtCmpholiday(cmpsid: Int, hldsid:Int, dt: String, nm: String, rpt: Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let UdtCmpholidayURL = getAPIURL(api: "ios/m/udt_cmp_holiday.jsp?CMPSID=\(cmpsid)&HLDSID=\(hldsid)&DT=\(dt)&NM=\(nm)&RPT=\(rpt)")
        
        print("\n---------- [ UdtCmpholidayURL : \(UdtCmpholidayURL) ] ----------\n")
        AlamofireAppManager?.request(UdtCmpholidayURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    } 
    //MARK: 회사 특별휴무일 삭제
    /**
     회사 특별휴무일 삭제
     
     - parameter hldsid:        휴일번호
     - parameter cmpsid :        회사번호
     - returns :  성공:1, 실패:0
     */
    func DelCmpholiday(cmpsid: Int, hldsid: Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let DelCmpholidayURL = getAPIURL(api: "ios/m/del_cmp_holiday.jsp?CMPSID=\(cmpsid)&HLDSID=\(hldsid)")
        
        print("\n---------- [ DelCmpholidayURL : \(DelCmpholidayURL) ] ----------\n")
        AlamofireAppManager?.request(DelCmpholidayURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    //MARK:  출퇴근인원 제외 설정
    /**
     출퇴근인원 제외 설정
     
     - parameter empsid:        직원번호
     - parameter notrc:        0.출퇴근 기록함 1.출퇴근 기록하지않음
     - returns : 성공:1, 실패:0
     */
    func SetEmpNotrc(empsid: Int, notrc: Int, completion: @escaping (_ success:Bool, _ error: Int, _ resultCode:Int) ->()) {
        
        let SetEmpNotrcURL = getAPIURL(api: "ios/m/set_emp_notrc.jsp?EMPSID=\(empsid)&NOTRC=\(notrc)")
        
        print("\n---------- [ SetEmpNotrcURL : \(SetEmpNotrcURL) ] ----------\n")
        AlamofireAppManager?.request(SetEmpNotrcURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ set_emp_notrc jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true, 1,  resultCode)
                        }else{
                            completion(false, 0, 0)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false, 0, 0)
            }
        })
    }
    //MARK:  직원 추가정보 입력
    /**
     직원 추가정보 입력
     
     - parameter empsid:        직원번호
     - parameter spot:        직급(직책).. URL 인코딩
     - parameter joindt:        입사일(형식 : 2018-05-05).. URL 인코딩
     - parameter usemin:            사용한 연차(분환산 - 1일 8시간) 2일 4시간 = (2*8*60) + (4*60) = 1200
     - parameter addmin:            추가된 연차(분환산 - 1일 8시간) 2일 4시간 = (2*8*60) + (4*60) = 1200
     
     - returns : 성공:1, 실패:0
     */
    func SetEmpAddinfo(empsid: Int, spot: String, joindt: String, usemin: Int, addmin: Int, completion: @escaping (_ success:Bool, _ error: Int, _ resultCode:Int) ->()) {
        
        let setEmpAddinfoURL = getAPIURL(api: "ios/u/set_emp_addinfo.jsp?EMPSID=\(empsid)&SPOT=\(spot)&JNDT=\(joindt)&USE=\(usemin)&ADD=\(addmin)")
        
        print("\n---------- [ setEmpAddinfoURL : \(setEmpAddinfoURL) ] ----------\n")
        AlamofireAppManager?.request(setEmpAddinfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ set_emp_addinfo jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int {
                            completion(true, 1,  resultCode)
                        }else{
                            completion(false, 0, 0)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false, 0, 0)
            }
        })
    }
    //MARK: 직원 메시지 전송 - 연차촉진메시지, 주52시간경고메시지
    /**
     직원 메시지 전송 - 연차촉진메시지, 주52시간경고메시지
     
     - parameter type:        타입(0.연차촉진메시지 1.주52시간경고메시지)
     - parameter sndsid:        발신자 직원번호
     - parameter sndnm:        발신자 이름 - URL 인코딩
     - parameter rcvsid:        수신자 직원번호
     - parameter msg:            메시지 - URL 인코딩
     
     - returns : 성공:1, 실패:0
     */
    func SendPushMsg(type: Int, sndsid: Int, sndnm: String, rcvsid: Int, msg: String, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let sendMsgURL = getAPIURL(api: "ios/m/send_empmsg.jsp?TYPE=\(type)&SNDSID=\(sndsid)&SNDNM=\(sndnm)&RCVSID=\(rcvsid)&MSG=\(msg)")
        
        print("\n---------- [ sendMsgURL : \(sendMsgURL.strinTrim()) ] ----------\n")
        AlamofireAppManager?.request(sendMsgURL.strinTrim(), method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    //MARK: 상위팀 연차제한 설정 & 팀 연차제한 설정
    /**
     상위팀 연차제한 설정 & 팀 연차제한 설정
     
     - parameter temsid:        상위팀번호
     - parameter ttmsid:        하위팀번호
     - parameter limit:        제한직원 수
     - parameter temflag: 상위팀 false , 하위팀 true
     
     - returns : 성공:1, 실패:0
     */
    func SetTemAnualLimit(temflag:Bool, ttmsid: Int, temsid: Int, limit: Int, completion: @escaping (_ success: Bool, _ result: Int) ->()) {
        var setTemAnualLimitURL = ""
        if temflag {
            setTemAnualLimitURL = getAPIURL(api: "ios/m/set_ttm_anuallimit.jsp?TTMSID=\(ttmsid)&LIMIT=\(limit)")
            
        }else{
            setTemAnualLimitURL = getAPIURL(api: "ios/m/set_tem_anuallimit.jsp?TEMSID=\(temsid)&LIMIT=\(limit)")
        }
        
        print("\n---------- [ setTemAnualLimitURL : \(setTemAnualLimitURL) ] ----------\n")
        AlamofireAppManager?.request(setTemAnualLimitURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success(let data):
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int {
                            completion(true, resultCode)
                        }
                    }
                }
            case.failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    //MARK: 직원 정보 수정
    /**
     직원 정보 수정
     
     - parameter empsid:        직원번호
     - parameter spot:        직급(직책).. URL 인코딩 ..변경 안한경우 기존정보 그대로 전달
     - parameter  pn:            전화번호... URL 인코딩 ..변경 안한경우 기존정보 그대로 전달
     - parameter mm:            메모.. URL 인코딩 ..변경 안한경우 기존정보 그대로 전달
     - returns : 성공:1, 실패:0
     */
    func UpdateMyInfo(empsid: Int, spot: String, pn: String, mm: String, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let updateMyInfoURL = getAPIURL(api: "ios/m/udt_emply.jsp?EMPSID=\(empsid)&SPOT=\(spot)&PN=\(pn)&MM=\(mm)")
        
        print("\n---------- [ updateMyInfoURL : \(updateMyInfoURL) ] ----------\n")
        AlamofireAppManager?.request(updateMyInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    //MARK: 입사일 변경
    /**
     입사일 변경
     
     - parameter empsid:        직원번호
     - parameter jndt:        기존 입사일(형식 : 2018-05-05) .. 인코딩 안함
     - parameter  njndt:        변경 입사일(형식  : 2019-05-05).. 인코딩 안함
     - returns : 성공:1, 실패:0
     */
    func udtJoindt(empsid: Int, jndt: String, njndt: String, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let udtJoindtURL = getAPIURL(api: "ios/m/udt_joindt.jsp?EMPSID=\(empsid)&JNDT=\(jndt)&NJNDT=\(njndt)")
        
        print("\n---------- [ udtJoindtURL : \(udtJoindtURL) ] ----------\n")
        AlamofireAppManager?.request(udtJoindtURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    //MARK: 연차정보 관리 입력
    /**
     연차정보 관리 입력
     
     - parameter empsid:        직원번호
     - parameter type:        타입(0.사용연차, 1.추가연차)
     - parameter  setmin:        변경연차(분)
     - parameter memo; 메모.. URL 인코딩
     - returns : 성공:1, 실패:0
     */
    func ins_Anual(empsid: Int, type: Int, setmin: Int, memo: String ,completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let insAnualURL = getAPIURL(api: "ios/m/ins_anualmgr.jsp?EMPSID=\(empsid)&TYPE=\(type)&SETMIN=\(setmin)&MEMO=\(memo)")
        
        print("\n---------- [ insAnualURL : \(insAnualURL) ] ----------\n")
        AlamofireAppManager?.request(insAnualURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }else{
                            completion(false , 99)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    //MARK: 연차정보 관리 수정
    /**
     연차정보 관리 수정
     
     - parameter anmsid:        연차정보관리 번호
     - parameter empsid:        직원번호
     - parameter type:        타입(0.사용연차, 1.추가연차)
     - parameter  setmin:       변경연차(분)
     - parameter  difmin:       변경전과의 차이(분)  =  변경후(분) - 변경전(분)
     - parameter memo: 메모.. URL 인코딩
     - returns : 성공:1, 실패:0
     */
    func udt_Anual(empsid: Int, anmsid: Int, type: Int, setmin:Int, difmin:Int, memo:String, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let udtAnual = getAPIURL(api: "ios/m/udt_anualmgr.jsp?ANMSID=\(anmsid)&EMPSID=\(empsid)&TYPE=\(type)&SETMIN=\(setmin)&DIFMIN=\(difmin)&MEMO=\(memo)")
        
        print("\n---------- [ udtAnual : \(udtAnual) ] ----------\n")
        AlamofireAppManager?.request(udtAnual, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }else{
                            completion(false , 99 )
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    //MARK: 연차정보 관리 삭제
    /**
     연차정보 관리 삭제
     
     - parameter anmsid:        연차정보관리 번호
     - parameter empsid:        직원번호
     - parameter type:        타입(0.사용연차, 1.추가연차)
     - parameter  setmin:       변경연차(분)
     - returns : 성공:1, 실패:0
     */
    func del_Anual(empsid: Int, anmsid: Int, type: Int, setmin:Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let delAnual = getAPIURL(api: "ios/m/del_anualmgr.jsp?ANMSID=\(anmsid)&EMPSID=\(empsid)&TYPE=\(type)&SETMIN=\(setmin)")
        
        print("\n---------- [ delAnual : \(delAnual) ] ----------\n")
        AlamofireAppManager?.request(delAnual, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            
                            completion(true ,  resultCode)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    
    //MARK: 연차정보 관리 리스트
    /**
     연차정보 관리 리스트
     
     - parameter empsid:        직원번호
     - parameter curkey:        페이징 키(첫 페이지는 "").. 날짜형식..URL 인코딩
     - parameter listcnt:        리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     - returns : 연차정보 관리 리스트
     */
    func AnualmgrList(empsid: Int, curkey: String, listcnt: Int,  completion: @escaping (_ success:Bool , _ nextkey:String ,[anualmgrInfo]?) ->()) {
        var AnualListURL = ""
        if curkey != "" {
            AnualListURL = getAPIURL(api: "ios/m/anualmgr_list.jsp?EMPSID=\(empsid)&CURKEY=\(curkey.urlEncoding())&LISTCNT=\(listcnt)")
        }else{
            AnualListURL = getAPIURL(api: "ios/m/anualmgr_list.jsp?EMPSID=\(empsid)&CURKEY=&LISTCNT=\(listcnt)")
        }
        print("\n---------- [ AnualListURL : \(AnualListURL) ] ----------\n")
        AlamofireAppManager?.request(AnualListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["anualmgr"] as? [[String : Any]] {
                            if let resnextkey = jsonData["nextkey"] as? String {
                                let response = Mapper<anualmgrInfo>().mapArray(JSONArray: resData)
                                completion(true ,  resnextkey , response)
                            }else{
                                let response = Mapper<anualmgrInfo>().mapArray(JSONArray: resData)
                                completion(true ,  "" , response)
                            }
                            
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , "", nil )
            }
        })
    }
    
    //MARK:  비밀번호 변경
    /**
     비밀번호 변경
     
     - parameter mbrsid:        회원번호
     - parameter oldpw:        기존 비밀번호..SHA1Password 암호화 형식으로 전달 받음...
     - parameter newpw:        번경 비밀번호..SHA1Password 암호화 형식으로 전달 받음...
     - returns : 1.성공 0.실패  -1.기존비밀번호 틀림
     */
    func PassChange(mbrsid: Int, oldpw: String, newpw: String, completion: @escaping (_ success: Bool, _ result: Int) ->()) {
        let passChangeURL = getAPIURL(api: "ios/mod_password.jsp?MBRSID=\(mbrsid)&OLDPW=\(oldpw)&NEWPW=\(newpw)")
        print("\n---------- [ passChangeURL : \(passChangeURL) ] ----------\n")
        AlamofireAppManager?.request(passChangeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success(let data):
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int {
                            completion(true, resultCode)
                        }
                    }
                }
            case.failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    //MARK:  회원탈퇴
    /**
     회원탈퇴
     
     - parameter mbrsid:        직원번호
     - parameter sk:            인증코드(직원번호 SHA1 암호화 해서 넘김)
     
     - returns : 성공 : 1, 실패 : 0  회원정보없음(이미탈퇴) : -1, 회사대표 직원있는경우(모두 퇴직처리 후 가능) : -2, 결재라인(결재라인 변경 후 가능) : -3
     */
    func SecedeMbr(mbrsid: Int, sk: String, completion: @escaping (_ success: Bool, _ result: Int) ->()) {
        let SecedeMbrURL = getAPIURL(api: "ios/secede_mbr.jsp?MBRSID=\(mbrsid)&SK=\(sk)")
        print("\n---------- [ SecedeMbrURL : \(SecedeMbrURL) ] ----------\n")
        AlamofireAppManager?.request(SecedeMbrURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success(let data):
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int {
                            completion(true, resultCode)
                        }
                    }
                }
            case.failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 )
            }
        })
    }
    //MARK: - 더보기 - 팀관리
    //MARK:  상위팀 리스트 - 소속팀 포함
    /**
     상위팀 리스트 - 소속팀 포함
     
     - parameter cmpsid:        회사번호
     - returns : 상위팀 리스트(소속팀 포함)
     */
    func CmpTtmlist(cmpsid: Int, completion: @escaping (_ success:Bool, _ error: Int, [Ttmlist]?) ->()) {
        
        let cmpTtmlistURL = getAPIURL(api: "ios/m/cmp_ttmlist.jsp?CMPSID=\(cmpsid)")
        
        print("\n---------- [ cmpTtmlistURL : \(cmpTtmlistURL) ] ----------\n")
        AlamofireAppManager?.request(cmpTtmlistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["topteam"] as? [[String : Any]] {
                            let response = Mapper<Ttmlist>().mapArray(JSONArray: resData)
                            completion(true, 1, response)
                        }
                    }else {
                        completion(true, 0, nil)
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false, 99, nil )
            }
        })
    } 
    //MARK:  상위팀 정보
    /**
     상위팀 정보
     
     - parameter temflag:   상위팀 false 하위팀 true
     - parameter ttmsid :   하위팀번호
     - parameter temsid :   상위팀번호
     - returns : 상위팀 리스트(소속팀 포함)
     */
    func GetTemInfo(temflag: Bool, ttmsid: Int, temsid: Int, completion: @escaping (_ success:Bool , TemInfo?) ->()) {
        
        var getTemInfoURL = ""
        
        if temflag {
            getTemInfoURL = getAPIURL(api: "ios/m/get_ttm_info.jsp?TTMSID=\(ttmsid)")
        }else {
            getTemInfoURL = getAPIURL(api: "ios/m/get_tem_info.jsp?TEMSID=\(temsid)")
        }
        print("\n---------- [ getTemInfoURL : \(getTemInfoURL) ] ----------\n")
        AlamofireAppManager?.request(getTemInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        
                        let resData = Mapper<TemInfo>().map(JSON: jsonData) 
                        completion(true ,  resData)
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    
    //MARK: - 팀원 추가(AddMemberVC.swift)
    //MARK:  상위팀번호로 합류코드 조회
    
    /**
     상위팀번호로 합류코드 조회
     
     - parameter temflag:   상위팀 false 하위팀 true
     - parameter ttmsid :   하위팀번호
     - parameter temsid :   상위팀번호
     - returns : 조회결과 있는경우 : 합류코드(Base64), 조회결과 없는경우 : ""
     */
    func GetTmJoincode(temflag: Bool, ttmsid: Int, temsid: Int, completion: @escaping (_ success:Bool , _ result: String) ->()) {
        
        var getTmJoincodeURL = ""
        
        if temflag {
            getTmJoincodeURL = getAPIURL(api: "ios/m/get_ttm_joincode.jsp?TTMSID=\(ttmsid)")
        }else {
            getTmJoincodeURL = getAPIURL(api: "ios/m/get_tem_joincode.jsp?TEMSID=\(temsid)")
        }
        
        print("\n---------- [ getTmJoincodeURL : \(getTmJoincodeURL) ] ----------\n")
        AlamofireAppManager?.request(getTmJoincodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? String {
                            completion(true ,  result)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , "" )
            }
        })
    }
    
    //MARK:  무소속 직원리스트
    /**
     무소속 직원리스트
     
     - parameter cmpsid:        회사번호
     - returns : 무소속 직원리스트(대표 제외) .. 페이징 없음(검색처리를 위해 모든데이터 한번에 줌) .. Sorting 이름 가나다 순
     */
    func FreeEmplist(cmpsid: Int, completion: @escaping (_ success:Bool , [EmplyInfo]?) ->()) {
        
        let freeEmplistURL = getAPIURL(api: "ios/m/free_emplist.jsp?CMPSID=\(cmpsid)")
        
        print("\n---------- [ freeEmplistURL : \(freeEmplistURL) ] ----------\n")
        AlamofireAppManager?.request(freeEmplistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]]{
                            let response = Mapper<EmplyInfo>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    
    //MARK:  상위팀 팀원(직속)추가
    
    /**
     상위팀 팀원(직속)추가
     
     - parameter temflag:   상위팀 false 하위팀 true
     - parameter ttmsid :   하위팀번호
     - parameter temsid :   상위팀번호
     - parameter empsids:        직원번호들(구분자',')
     
     - returns : 성공:추가된 팀원수, 실패:0
     */
    func TmAddemply(temflag: Bool, ttmsid: Int, temsid: Int, empsids: String, completion: @escaping (_ success:Bool , _ result: Int?) ->()) {
        
        var tmAddemplyURL = ""
        
        if temflag {
            tmAddemplyURL = getAPIURL(api: "ios/m/ttm_addemply.jsp?TTMSID=\(ttmsid)&EMPSIDS=\(empsids)")
        }else {
            tmAddemplyURL = getAPIURL(api: "ios/m/tem_addemply.jsp?TEMSID=\(temsid)&EMPSIDS=\(empsids)")
        }
        
        print("\n---------- [ tmAddemplyURL : \(tmAddemplyURL) ] ----------\n")
        AlamofireAppManager?.request(tmAddemplyURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true ,  result)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    // MARK: - 재택 출퇴근
    
    // MARK: 팀별 재택출퇴근 설정 직원 리스트 카운트
    /**
     팀별 재택출퇴근 설정 직원 카운트 조회).. 페이징 없음
     
     - parameter cmpsid:        회사번호
     - returns : 팀별 재택 출퇴근 설정 직원 카운트
     */
    func Home_cmtTtmlist(cmpsid: Int, completion: @escaping (_ success:Bool, _ error: Int, [Ttmlist]?) ->()) {
        
        let Home_cmpTtmlistURL = getAPIURL(api: "ios/m/homecmtarea_cntlist.jsp?CMPSID=\(cmpsid)")
        
        print("\n---------- [ Home_cmpTtmlistURL : \(Home_cmpTtmlistURL) ] ----------\n")
        AlamofireAppManager?.request(Home_cmpTtmlistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["topteam"] as? [[String : Any]] {
                            let response = Mapper<Ttmlist>().mapArray(JSONArray: resData)
                            completion(true, 1, response)
                        }
                    }else {
                        completion(true, 0, nil)
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false, 99, nil )
            }
        })
    }
     
    // MARK: 팀별 재택출퇴근 설정 직원
    /**
     팀별 재택출퇴근 설정 직원 카운트 조회).. 페이징 없음
     
     - parameter cmpsid:        회사번호(무소속 조회시 TTMSID : 0, TEMSID : 0)
     - parameter ttmsid:        상위팀번호(상위팀 직속 조회시 TEMSID : 0)
     - parameter temsid:        팀번호
     
     - returns : 팀별 재택 출퇴근영역 설정 직원 목록
     */
    func Home_TemEmpList(cmpsid: Int, ttmsid: Int, temsid: Int, completion: @escaping (_ success:Bool,  [HomeCmtAreaInfo]?) ->()) {
        
        let Home_TemEmpListURL = getAPIURL(api: "ios/m/homecmtarea_emplist.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)")
        
        print("\n---------- [ Home_TemEmpListURL : \(Home_TemEmpListURL) ] ----------\n")
        AlamofireAppManager?.request(Home_TemEmpListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["homecmtarea"] as? [[String : Any]] {
                            let response = Mapper<HomeCmtAreaInfo>().mapArray(JSONArray: resData)
                            completion(true, response)
                        }
                    }else {
                        completion(true, nil)
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false,  nil )
            }
        })
    }
    
    // MARK: 재택 출퇴근영역 정보 삭제
    /**
     재택 출퇴근영역 정보 삭제
     
     - parameter HCASID:        재택출퇴근영역 번호
     - parameter EMPSID:        직원번호(재택출퇴근 직원)
     
     - returns : 성공:1, 실패:0
     */
    func del_Homecmtarea(hcasid: Int, empsid: Int,  completion: @escaping (_ success:Bool, _ resCode:Int) ->()) {
        
        let delHomecmtareaURL = getAPIURL(api: "ios/m/del_homecmtarea.jsp?HCASID=\(hcasid)&EMPSID=\(empsid)")
        
        print("\n---------- [ delHomecmtareaURL : \(delHomecmtareaURL) ] ----------\n")
        AlamofireAppManager?.request(delHomecmtareaURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["result"] as? Int {
                            completion(true, resData)
                        }
                    }else {
                        completion(true, 0)
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false,  0 )
            }
        })
    }
    //MARK: - 팀원 관리
    //MARK: 팀원 전체 리스트 - 관리자포함(CmtEmpList.swift)
    /**
     팀원 전체 리스트 - 관리자포함
     
     - parameter temflag:   상위팀 false 하위팀 true
     - parameter ttmsid :   하위팀번호
     - parameter temsid :   상위팀번호
     - parameter cmpsid:    회사번호
     
     - returns : 팀원 전체 리스트(관리자 포함) .. 페이징 없음 .. Sorting 관리자 권한 순, 이름 가나다 순
     */
    func TemEmpAlllist(temflag: Bool, cmpsid: Int, ttmsid: Int, temsid: Int, completion: @escaping (_ success:Bool , [EmplyInfo]?, _ anualcnt: Int, _ applycnt: Int, _ empcnt: Int, _ joincode: String) ->()) {
        
        var temEmpAlllistURL = ""
        
        if temflag {
            temEmpAlllistURL = getAPIURL(api: "ios/m/ttm_emp_alllist.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)")
        }else {
            temEmpAlllistURL = getAPIURL(api: "ios/m/tem_emp_alllist.jsp?CMPSID=\(cmpsid)&TEMSID=\(temsid)")
        }
        
        print("\n---------- [ temEmpAlllistURL : \(temEmpAlllistURL) ] ----------\n")
        AlamofireAppManager?.request(temEmpAlllistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]],
                            let anualcnt = jsonData["anualcnt"] as? Int,
                            let applycnt = jsonData["applycnt"] as? Int,
                            let empcnt = jsonData["empcnt"] as? Int,
                            let joincode = jsonData["joincode"] as? String {
                            let response = Mapper<EmplyInfo>().mapArray(JSONArray: resData)
                            completion(true ,  response, anualcnt, applycnt, empcnt, joincode)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil , 0, 0, 0, "")
            }
        })
    }
    
    //MARK:  남은연차, 입사일자(TemEmpCmtList.swift)
    /**
     남은연차, 입사일자
     
     - parameter empsid:        직원번호
     - parameter dt:            월초일(형식: 2019-10-01).. 해당년월의 1일
     
     - returns : 직원 출퇴근기록 + 연차정보(남은연차, 입사일자)
     */
    func EmpCmtlist(empsid: Int, dt: String, completion: @escaping (_ success:Bool , [EmplyInfoDetail]?, _ joindt: String, _ remainmin: Int, _ usemin: Int, _ addmin: Int) ->()) {
        
        let empCmtlistURL = getAPIURL(api: "ios/m/emp_cmtlist.jsp?EMPSID=\(empsid)&DT=\(dt)")
        
        print("\n---------- [ empCmtlistURL : \(empCmtlistURL) ] ----------\n")
        AlamofireAppManager?.request(empCmtlistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["commute"] as? [[String : Any]],
                            let joindt = jsonData["joindt"] as? String,
                            let remainmin = jsonData["remainmin"] as? Int,
                            let usemin = jsonData["usemin"] as? Int,
                            let addmin = jsonData["addmin"] as? Int {
                            let response = Mapper<EmplyInfoDetail>().mapArray(JSONArray: resData)
                            completion(true ,  response, joindt, remainmin, usemin, addmin)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil , "", 0, 0, 0)
            }
        })
    }
    
    //MARK:  직원정보 수정(TemEmpInfoVC.swift)
    /**
     직원정보 수정
     
     - parameter empsid:        직원번호
     - parameter spot:        직급(직책).. URL 인코딩 ..변경 안한경우 기존정보 그대로 전달
     - parameter phone:            전화번호... URL 인코딩 ..변경 안한경우 기존정보 그대로 전달
     - parameter memo:            메모.. URL 인코딩 ..변경 안한경우 기존정보 그대로 전달
     - parameter joindt:        입사일(형식 : 2018-05-05).. URL 인코딩 ..변경 안한경우 기존정보 그대로 전달
     - parameter usemin:            사용한 연차(분환산 - 1일 8시간) 2일 4시간 = (2*8*60) + (4*60) = 1200 ..변경 안한경우 기존정보 그대로 전달
     - parameter addmin:            추가된 연차(분환산 - 1일 8시간) 2일 4시간 = (2*8*60) + (4*60) = 1200 ..변경 안한경우 기존정보 그대로 전달
     
     - returns : 성공:1, 실패:0
     */
    func UdtEmpinfo(empsid: Int, spot: String, phone: String, memo: String, joindt: String, usemin: Int, addmin: Int, completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
        let udtEmpinfoURL = getAPIURL(api: "ios/m/udt_empinfo.jsp?EMPSID=\(empsid)&SPOT=\(spot)&PN=\(phone)&MM=\(memo)&JNDT=\(joindt)&USE=\(usemin)&ADD=\(addmin)")
        
        print("\n---------- [ udtEmpinfoURL : \(udtEmpinfoURL) ] ----------\n")
        AlamofireAppManager?.request(udtEmpinfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true , result)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    
    //MARK:  팀 팀원해지-제외(TemEmpInfoTrmPopUp.swift)
    /**
     팀 팀원해지-제외
     
     - parameter temflag:   상위팀 false 하위팀 true
     - parameter ttmsid :   하위팀번호
     - parameter temsid :   상위팀번호
     - parameter empsid:        직원번호
     - parameter temnm:        팀이름 - URL 인코딩(푸시알림을위해 추가..2019-11-20)
     
     - returns : 성공:1, 실패:0
     */
    func TemExceptemply(temflag: Bool, ttmsid: Int, temsid: Int, empsid: Int, temnm: String, completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
        var temExceptemplyURL = ""
        if temflag {
            temExceptemplyURL = getAPIURL(api: "ios/m/ttm_exceptemply.jsp?TTMSID=\(ttmsid)&EMPSID=\(empsid)&TTMNM=\(temnm)")
        }else {
            temExceptemplyURL = getAPIURL(api: "ios/m/tem_exceptemply.jsp?TEMSID=\(temsid)&EMPSID=\(empsid)&TEMNM=\(temnm)")
        }
        
        print("\n---------- [ temExceptemplyURL : \(temExceptemplyURL) ] ----------\n")
        AlamofireAppManager?.request(temExceptemplyURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true , result)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    
    //MARK:  관리자가 직원 근무기록 직접 입력 - 정상근무로 등록됨, 관리자가 직원 근무기록 직접 수정 (TemCmtTimeSetVC.swift)
    /**
     관리자가 직원 근무기록 직접 입력 - 정상근무로 등록됨, 관리자가 직원 근무기록 직접 수정
     
     - parameter cmtsid:        근무기록 번호
     - parameter empsid:        직원번호
     - parameter sdt:            근무 시작일자(형식 : 2019-10-10 09:10) .. URL 인코딩
     - parameter edt:            근무 종료일자.. 종료일자는 시작일자보다 큰 시간이어야 함(형식 : 2019-10-10 18:20) .. URL 인코딩
     
     - returns : 성공:1, 실패:0, 시간중복 : -1
     */
    func InsUdtCmtmgr(cmtsid: Int , empsid: Int, sdt: String, edt: String, completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
        var insUdtCmtmgrURL = ""
        if cmtsid > 0 {
            insUdtCmtmgrURL = getAPIURL(api: "ios/m/udt_cmtmgr.jsp?CMTSID=\(cmtsid)&EMPSID=\(empsid)&SDT=\(sdt)&EDT=\(edt)")
        }else {
            insUdtCmtmgrURL = getAPIURL(api: "ios/m/ins_cmtmgr.jsp?EMPSID=\(empsid)&SDT=\(sdt)&EDT=\(edt)")
        }
        
        print("\n---------- [ insUdtCmtmgrURL : \(insUdtCmtmgrURL) ] ----------\n")
        AlamofireAppManager?.request(insUdtCmtmgrURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true , result)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    //MARK:  관리자가 직원 근무기록 직접 삭제.. Type 9.결근은 삭제불가..앱에서 막아야됨 (TemCmtTimeSetVC.swift)
    /**
     관리자가 직원 근무기록 직접 삭제.. Type 9.결근은 삭제불가..앱에서 막아야됨
     
     - parameter cmtsid:        근무기록 번호
     - parameter empsid:        직원번호
     
     - returns : 성공:1, 실패:0, 시간중복 : -1
     */
    func DelCmtmgr(cmtsid: Int , empsid: Int, completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
        let delCmtmgrURL = getAPIURL(api: "ios/m/del_cmtmgr.jsp?CMTSID=\(cmtsid)&EMPSID=\(empsid)")
        
        print("\n---------- [ delCmtmgrURL : \(delCmtmgrURL) ] ----------\n")
        AlamofireAppManager?.request(delCmtmgrURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true , result)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    //MARK:  퇴직처리를 위한 근로기간, 미사용연차 조회 (TemRtrPrcVC.swift)
    /**
     퇴직처리를 위한 근로기간, 미사용연차 조회
     
     - parameter empsid:        직원번호
     - parameter leavedt:        퇴직일자(형식 2019-11-30)
     
     - returns : 근로기간 + 미사용연차
     */
    func GetLeaveinfo(empsid: Int, leavedt: String, completion: @escaping (_ success:Bool , _ unused: Int, _ workday: Int, _ workmonth: Int, _ workyear: Int) ->()) {
        
        let getLeaveinfoURL = getAPIURL(api: "ios/m/get_leaveinfo.jsp?EMPSID=\(empsid)&LEAVEDT=\(leavedt)")
        
        print("\n---------- [ getLeaveinfoURL : \(getLeaveinfoURL) ] ----------\n")
        AlamofireAppManager?.request(getLeaveinfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let unused = jsonData["unused"] as? Int,
                            let workday = jsonData["workday"] as? Int,
                            let workmonth = jsonData["workmonth"] as? Int,
                            let workyear = jsonData["workyear"] as? Int {
                            completion(true , unused, workday, workmonth, workyear)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0, 0, 0, 0)
            }
        })
    }
    //MARK: - 더보기 - 팀관리 - 관리자관리
    //MARK:  상위팀원 리스트 - 관리자제외(AddMgrVC.swift)
    /**
     상위팀원 리스트 - 관리자제외
     
     - parameter temflag:   상위팀 false 하위팀 true
     - parameter ttmsid :   하위팀번호
     - parameter temsid :   상위팀번호
     
     - returns : 상위팀원 리스트(관리자 제외) .. 페이징 없음(검색처리를 위해 모든데이터 한번에 줌) .. Sorting 이름 가나다 순
     */
    func TemEmplist(temflag: Bool, ttmsid: Int, temsid: Int, completion: @escaping (_ success:Bool , [EmplyInfo]?) ->()) {
        var temEmplistURL = ""
        if temflag {
            temEmplistURL = getAPIURL(api: "ios/m/ttm_emplist.jsp?TTMSID=\(ttmsid)")
        }else {
            temEmplistURL = getAPIURL(api: "ios/m/tem_emplist.jsp?TEMSID=\(temsid)")
        }
        
        print("\n---------- [ temEmplistURL : \(temEmplistURL) ] ----------\n")
        AlamofireAppManager?.request(temEmplistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]] {
                            let response = Mapper<EmplyInfo>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    
    // MARK: 회사 일반직원 리스트 - 관리자 제외
    /**
     회사 일반직원 리스트 - 관리자 제외
     - parameter cmpsid : 회사번호
     - returns: 회사 일반직원 리스트
     */
    func getCmp_emplist(cmpsid: Int, completion: @escaping (_ success:Bool , [EmplyInfo]?) ->()) {
        
        let CmpEmplistURL = getAPIURL(api: "ios/m/cmp_emplist.jsp?CMPSID=\(cmpsid)")
        
        
        print("\n---------- [ CmpEmplistURL : \(CmpEmplistURL) ] ----------\n")
        AlamofireAppManager?.request(CmpEmplistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]] {
                            let response = Mapper<EmplyInfo>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    
    //MARK:  상위팀관리자 리스트(MgmtMgrVC..swift)
    /**
     상위팀관리자 리스트
     
     - parameter temflag:   상위팀 false 하위팀 true
     - parameter ttmsid :   하위팀번호
     - parameter temsid :   상위팀번호
     
     - returns : 팀관리자 리스트 .. 페이징 없음(검색처리를 위해 모든데이터 한번에 줌) .. Sorting 이름 가나다 순
     */
    func TemMgrlist(temflag: Bool, ttmsid: Int, temsid: Int, completion: @escaping (_ success:Bool , [EmplyInfo]?) ->()) {
        var temMgrlistURL = ""
        if temflag {
            temMgrlistURL = getAPIURL(api: "ios/m/ttm_mgrlist.jsp?TTMSID=\(ttmsid)")
        }else {
            temMgrlistURL = getAPIURL(api: "ios/m/tem_mgrlist.jsp?TEMSID=\(temsid)")
        }
        
        print("\n---------- [ temMgrlistURL : \(temMgrlistURL) ] ----------\n")
        AlamofireAppManager?.request(temMgrlistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]] {
                            let response = Mapper<EmplyInfo>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    //MARK: - 더보기 - 팀관리 - 출퇴근설정
    //MARK:  상위팀 출퇴근영역 설정(MgmtMgrVC..swift)
    /**
     상위팀 출퇴근영역 설정
     
     - parameter temflag:   상위팀 false 하위팀 true
     - parameter ttmsid :   하위팀번호
     - parameter temsid :   상위팀번호
     - parameter temnm:     상위팀이름 - URL 인코딩(푸시알림을위해 추가..2019-11-20)
     - parameter area:        출퇴근영역설정 0.설정안함 1.WiFi 2.Gps 3.Beacon 4.회사출퇴근영역이용
     - parameter wnm:            WiFi 이름 .. URL 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter wmac:        WiFi MAC .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter wip:            WiFi IP .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter bcon:        비콘 UUID .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter lat:            위치정보 위도 .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter long:        위치정보 경도 .. Base64 인코딩 ..출퇴근영역 설정값에따라 필요없는경우에는 "" 넘김
     - parameter addr:        위치정보 주소
     - parameter scope:        위치범위(반경)..(50m, 100m, 300m, 500m) ..2021-04-29 추가
      
     - returns : 성공:1, 실패:0
     */
    func SetTemCmtarea(temflag: Bool, ttmsid: Int, temsid: Int, temnm: String, area: Int, wnm: String, wmac: String, wip: String, bcon: String, lat: String, long: String, addr: String, scope: Int, completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        var setTemCmtareaURL = ""
        if temflag {
            setTemCmtareaURL = getAPIURL(api: "ios/m/set_ttm_cmtarea.jsp?TTMSID=\(ttmsid)&TTMNM=\(temnm)&AREA=\(area)&WNM=\(wnm)&WMAC=\(wmac)&WIP=\(wip)&BCON=\(bcon)&LAT=\(lat)&LONG=\(long)&ADDR=\(addr)&SCOPE=\(scope)")
        }else {
            setTemCmtareaURL = getAPIURL(api: "ios/m/set_tem_cmtarea.jsp?TEMSID=\(temsid)&TEMNM=\(temnm)&AREA=\(area)&WNM=\(wnm)&WMAC=\(wmac)&WIP=\(wip)&BCON=\(bcon)&LAT=\(lat)&LONG=\(long)&ADDR=\(addr)&SCOPE=\(scope)")
        }
        
        print("\n---------- [ setTemCmtareaURL : \(setTemCmtareaURL) ] ----------\n")
        AlamofireAppManager?.request(setTemCmtareaURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true , result)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    
    //MARK:  상위팀 근무시간 설정(TemCmtTimeVC...swift)
    /**
     상위팀 근무시간 설정
     
     - parameter temflag:   상위팀 false 하위팀 true
     - parameter ttmsid :   하위팀번호
     - parameter temsid :   상위팀번호
     - parameter temnm:     상위팀이름 - URL 인코딩(푸시알림을위해 추가..2019-11-20)
     - parameter scd:            근무일정 사용여부 0.사용안함 1.회사근무일정 사용 2.팀근무일정 사용
     - parameter st:            근무 시작시간.. ex)9:00
     - parameter et:            근무 종료시간.. ex)18:00
     - parameter bt:            휴게시간 설정(0.설정안함 1.설정 default '1')
     - parameter wd:            근무요일.. 1(일),2(월),3(화),4(수),5(목),6(금),7(토) 구분자 ','  .. ex) 2,3,4,5,6
     
     - returns : 성공:1, 실패:0
     */
    func SetTemSchdl(temflag: Bool, ttmsid: Int, temsid: Int, temnm: String, scd: Int, st: String, et: String, bt: Int, wd: String, cmtlt:Int, completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        var setTemSchdlURL = ""
        if temflag {
            setTemSchdlURL = getAPIURL(api: "ios/m/set_ttm_schdl.jsp?TTMSID=\(ttmsid)&TTMNM=\(temnm)&SCD=\(scd)&ST=\(st)&ET=\(et)&BT=\(bt)&WD=\(wd)&CMTLT=\(cmtlt)")
        }else {
            setTemSchdlURL = getAPIURL(api: "ios/m/set_tem_schdl.jsp?TEMSID=\(temsid)&TEMNM=\(temnm)&SCD=\(scd)&ST=\(st)&ET=\(et)&BT=\(bt)&WD=\(wd)&CMTLT=\(cmtlt)")
        }
        
        print("\n---------- [ setTemSchdlURL : \(setTemSchdlURL) ] ----------\n")
        AlamofireAppManager?.request(setTemSchdlURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        //                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true , result)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    //MARK: - 더보기 - 팀관리 - 결재라인
    //MARK:  연차결재라인 조회 - 회사, 상위팀, 팀 같이 이용(AprSelVC.swift)
    /**
     연차결재라인 조회 - 회사, 상위팀, 팀 같이 이용
     
     - parameter aprflag:   연차 true 신청 false
     - parameter ttmsid :   상위팀번호.. 회사번호, 팀번호는 0 또는 안보냄
     - parameter temsid :   팀번호.. 회사번호, 상위팀번호는 0 또는 안보냄
     - parameter cmpsid:    회사번호 .. 상위팀번호, 팀번호는 0 또는 안보냄
     
     - returns : 연차결재라인 정보
     */
    func GetAprline(aprflag: Bool, cmpsid: Int, ttmsid: Int, temsid: Int, completion: @escaping (_ success:Bool , AprInfo?) ->()) {
        
        var getAprlineURL = ""
        
        if aprflag {
            getAprlineURL = getAPIURL(api: "ios/m/get_anualaprline.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)")
        }else {
            getAprlineURL = getAPIURL(api: "ios/m/get_applyaprline.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)")
        }
        
        print("\n---------- [ getAprlineURL : \(getAprlineURL) ] ----------\n")
        AlamofireAppManager?.request(getAprlineURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] { 
                        let resData = Mapper<AprInfo>().map(JSON: jsonData)
                        completion(true ,  resData)
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    
    //MARK:  상위팀, 팀 연차결재라인 회사설정으로 적용/미적용 처리(AnlAprVC....swift)
    /**
     상위팀, 팀 연차결재라인 회사설정으로 적용/미적용 처리
     
     - parameter ttmsid:    상위팀번호(팀 설정의 경우 상위팀번호는 0 또는 안넘김)
     - parameter temsid:    팀번호(상위팀 설정의 경우 팀번호는 0 또는 안넘김)
     - parameter apr:        회사설정 적용여부 0.회사설정 적용 1.회사설정 미적용(자체설정)
     - parameter aprflag:    true.연차 false.근무
     
     - returns : 성공:1, 실패:0
     */
    func SetCmpAprline(aprflag: Bool, ttmsid: Int, temsid: Int, apr: Int,completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
        var setCmpAprlineURL = ""
        
        if aprflag {
            setCmpAprlineURL = getAPIURL(api: "ios/m/set_cmp_anualaprline.jsp?TTMSID=\(ttmsid)&TEMSID=\(temsid)&APR=\(apr)")
        }else {
            setCmpAprlineURL = getAPIURL(api: "ios/m/set_cmp_applyaprline.jsp?TTMSID=\(ttmsid)&TEMSID=\(temsid)&APR=\(apr)")
        }
        
        print("\n---------- [ setCmpAprlineURL : \(setCmpAprlineURL) ] ----------\n")
        AlamofireAppManager?.request(setCmpAprlineURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true , result)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    //MARK:  연차결재라인 설정 - 회사, 상위팀, 팀 모두 같이 이용(AnlAprVC....swift)
    /**
     연차결재라인 설정 - 회사, 상위팀, 팀 모두 같이 이용
     
     - parameter ttmsid:    상위팀번호(팀 설정의 경우 상위팀번호는 0 또는 안넘김)
     - parameter temsid:    팀번호(상위팀 설정의 경우 팀번호는 0 또는 안넘김)
     - parameter apr1:      결재자 1
     - parameter apr2:      결재자 2
     - parameter apr3:      결재자 3
     - parameter ref1:      참조자 1
     - parameter ref2:      참조자 2
     - parameter aprflag:    true.연차 false.근무
     - parameter cmpsid : 회사번호
     
     - return  : 성공:1, 실패:0
     */
    func SetAprline(aprflag: Bool, cmpsid: Int, ttmsid: Int, temsid: Int, apr1: Int, apr2:Int, apr3:Int, ref1: Int, ref2: Int,completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
        var setAprlineURL = ""
        
        if aprflag {
            setAprlineURL = getAPIURL(api: "ios/m/set_anualaprline.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)&APR1=\(apr1)&APR2=\(apr2)&APR3=\(apr3)&REF1=\(ref1)&REF2=\(ref2)")
        }else {
            setAprlineURL = getAPIURL(api: "ios/m/set_applyaprline.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)&APR1=\(apr1)&APR2=\(apr2)&APR3=\(apr3)&REF1=\(ref1)&REF2=\(ref2)")
        }
        print("\n---------- [ setAprlineURL : \(setAprlineURL) ] ----------\n")
        AlamofireAppManager?.request(setAprlineURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true , result)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    //MARK:  회사전채 관리자리스트 - 대표포함(AprMgrListVC.swift)
    /**
     회사전채 관리자리스트 - 대표포함
     
     - parameter cmpsid:        회사번호
     - returns : 무소속 직원리스트(대표 제외) .. 페이징 없음(검색처리를 위해 모든데이터 한번에 줌) .. Sorting 권한 순
     */
    func CmpMgrlist(cmpsid: Int, completion: @escaping (_ success:Bool , [EmplyInfo]?) ->()) {
        
        let cmpMgrlistURL = getAPIURL(api: "ios/m/cmp_mgrlist.jsp?CMPSID=\(cmpsid)")
        
        print("\n---------- [ cmpMgrlistURL : \(cmpMgrlistURL) ] ----------\n")
        AlamofireAppManager?.request(cmpMgrlistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]]{
                            let response = Mapper<EmplyInfo>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    //MARK: - 더보기 - 팀관리 - 하위팀 설정
    //MARK:  상위팀 팀 해제 추가를 위한 - 하위팀 + 무소속팀 목록(SubTemSetVC.swift)
    /**
     상위팀 팀 해제 추가를 위한 - 하위팀 + 무소속팀 목록
     
     - parameter cmpsid:        회사번호
     - parameter ttmsid:        상위팀번호
     
     - returns : 팀정보
     */
    func TtmTemsetlist(cmpsid: Int, ttmsid: Int, completion: @escaping (_ success:Bool , [SubTemlist]?) ->()) {
        
        let ttmTemsetlistURL = getAPIURL(api: "ios/m/ttm_temsetlist.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)")
        
        print("\n---------- [ ttmTemsetlistURL : \(ttmTemsetlistURL) ] ----------\n")
        AlamofireAppManager?.request(ttmTemsetlistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["team"] as? [[String : Any]]{
                            let response = Mapper<SubTemlist>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    //MARK: 상위팀 소속팀 해제(SubTemSetVC.swift)
    /**
     상위팀 소속팀 해제
     
     - parameter ttmsid:        상위팀번호
     - parameter temsid:        팀번호
     
     - returns : 성공:1, 실패:0
     */
    func ExceptTeam(ttmsid: Int, temsid: Int, completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
        let exceptTeamURL = getAPIURL(api: "ios/m/except_team.jsp?TTMSID=\(ttmsid)&TEMSID=\(temsid)")
        
        print("\n---------- [ exceptTeamURL : \(exceptTeamURL) ] ----------\n")
        AlamofireAppManager?.request(exceptTeamURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true ,  result)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    
    //MARK: - 더보기 - 팀관리 - 팀삭제
    //MARK:  상위팀정보 수정(TemSettingVC.swift)
    /**
     상위팀정보 수정
     
     - parameter temflag :  상위팀 true 하위팀 false
     - parameter temsid :   하위팀번호
     - parameter ttmsid:        상위팀번호
     - parameter name:            상위팀이름 - URL 인코딩
     - parameter memo:            상위팀메모 - URL 인코딩
     - parameter phone:            전화번호
     
     - returns : 성공:1, 실패:0, 동일상위팀명 존재:-1
     */
    func UdtTeminfo(temflag: Bool, ttmsid: Int, temsid: Int, name: String, memo: String, phone: String, completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
        var udtTeminfoURL = ""
        if temflag {
            udtTeminfoURL = getAPIURL(api: "ios/m/udt_ttminfo.jsp?TTMSID=\(ttmsid)&NM=\(name)&MM=\(memo)&PN=\(phone)")
        }else {
            udtTeminfoURL = getAPIURL(api: "ios/m/udt_teminfo.jsp?TEMSID=\(temsid)&NM=\(name)&MM=\(memo)&PN=\(phone)")
        }
        
        print("\n---------- [ udtTeminfoURL : \(udtTeminfoURL) ] ----------\n")
        AlamofireAppManager?.request(udtTeminfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true ,  result)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    //MARK:  팀 삭제(TemSettingVC.swift)
    /**
     팀 삭제
     
     - parameter temflag :  상위팀 true 하위팀 false
     - parameter temsid :   하위팀번호
     - parameter ttmsid:        상위팀번호
     
     - return  : 성공:1, 실패:0, 팀정보 존재하지않음 : -1
     */
    func DelTeam(temflag: Bool, ttmsid: Int, temsid: Int, completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
        var delTeamURL = ""
        if temflag {
            delTeamURL = getAPIURL(api: "ios/m/del_topteam.jsp?TTMSID=\(ttmsid)")
        }else {
            delTeamURL = getAPIURL(api: "ios/m/del_team.jsp?TEMSID=\(temsid)")
        }
        
        print("\n---------- [ delTeamURL : \(delTeamURL) ] ----------\n")
        AlamofireAppManager?.request(delTeamURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true ,  result)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    //MARK:  팀생성(AddTemVC.swift)
    /**
     팀생성
     
     - parameter temflag :  상위팀 true 하위팀 false
     - parameter cmpsid :   회사번호
     - parameter name:            팀이름 - URL 인코딩
     - parameter memo:            팀메모 - URL 인코딩
     - parameter phone:            전화번호
     
     - returns : 성공:팀번호, 실패:0, 동일팀명 존재:-1
     */
    func RegTeam(temflag: Bool, cmpsid: Int, name: String, memo: String, phone: String, completion: @escaping (_ success: Bool, _ error: Int, _ result: Int) ->()) {
        
        var regTeamURL = ""
        if temflag {
            regTeamURL = getAPIURL(api: "ios/m/reg_topteam.jsp?CMPSID=\(cmpsid)&NM=\(name)&MM=\(memo)&PN=\(phone)")
        }else {
            regTeamURL = getAPIURL(api: "ios/m/reg_team.jsp?CMPSID=\(cmpsid)&NM=\(name)&MM=\(memo)&PN=\(phone)")
        }
        
        print("\n---------- [ regTeamURL : \(regTeamURL) ] ----------\n")
        AlamofireAppManager?.request(regTeamURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true, 1, result)
                        }
                    }else {
                        completion(true, 0, 0)
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false, 99, 0)
            }
        })
    }
    //MARK:  상위팀에 소속되지않은 팀리스트.. 상위팀에서 팀추가 할 때 목록(AflTemVC.swift)
    /**
     상위팀에 소속되지않은 팀리스트.. 상위팀에서 팀추가 할 때 목록
     
     - parameter cmpsid:        회사번호
     - parameter curkey:        페이징 키(첫 페이지는 0 또는 안넘김)
     - parameter listcnt:        리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     
     - returns : 팀정보
     */
    func FreeTemlist(cmpsid: Int, curkey: Int, listcnt: Int, completion: @escaping (_ success:Bool , _ error: Int, [TemInfo]?, _ nextkey: Int) ->()) {
        
        let freeTemlistURL = getAPIURL(api: "ios/m/free_temlist.jsp?CMPSID=\(cmpsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)")
        
        print("\n---------- [ freeTemlistURL : \(freeTemlistURL) ] ----------\n")
        AlamofireAppManager?.request(freeTemlistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["team"] as? [[String : Any]] {
                            if let nextkey = jsonData["nextkey"] as? Int {
                                let response = Mapper<TemInfo>().mapArray(JSONArray: resData)
                                completion(true, 1, response, nextkey)
                            }else {
                                let response = Mapper<TemInfo>().mapArray(JSONArray: resData)
                                completion(true, 1, response, 0)
                            }
                        }else {
                            completion(true, 0, nil, 0)
                        }
                    }else {
                        completion(true, 0, nil, 0)
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false, 99, nil, 0)
            }
        })
    }
    //MARK:  상위팀 소속팀 추가(AflTemVC.swift)
    /**
     상위팀 소속팀 추가
     
     - parameter temsids:        팀번호들(구분자',')
     - parameter ttmsid:        상위팀번호
     
     - returns : 성공:설정완료 카운트, 실패:0
     */
    func AddTeam(temsids: String, ttmsid: Int, completion: @escaping (_ success:Bool, _ error: Int, _ result: Int) ->()) {
        
        let addTeamURL = getAPIURL(api: "ios/m/add_team.jsp?TEMSIDS=\(temsids)&TTMSID=\(ttmsid)")
        
        print("\n---------- [ addTeamURL : \(addTeamURL) ] ----------\n")
        AlamofireAppManager?.request(addTeamURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true, 1, result)
                        }
                    }else {
                        completion(true, 0, 0)
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false, 0, 0)
            }
        })
    }
    //MARK:  회사 마스터+최고관리자 리스트 - 출퇴근 제외 설정을 위한 목록(MgrCmtSetting.swift)
    /**
     회사 마스터+최고관리자 리스트 - 출퇴근 제외 설정을 위한 목록
     
     - parameter cmpsid:        회사번호
     - returns : 회사 최고관리자 리스트
     */
    func CmpMsmgrlist(cmpsid: Int, completion: @escaping (_ success:Bool , [Msmgrlist]?) ->()) {
        let cmpMsmgrlistURL = getAPIURL(api: "ios/m/cmp_msmgrlist.jsp?CMPSID=\(cmpsid)")
        
        print("\n---------- [ cmpMsmgrlistURL : \(cmpMsmgrlistURL) ] ----------\n")
        AlamofireAppManager?.request(cmpMsmgrlistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]] {
                            let response = Mapper<Msmgrlist>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false, nil)
            }
        })
    }
    //MARK: -  배너리스트
    /**
     배너광고 리스트
     
     - parameter app:        앱종류 0.근로자용 1.관리자용
     - parameter page:    배너위치 0.메인 1.더보기
     
     - returns : 배너광고 리스트
     */
    func BannerList(_ app: Int,_ page:Int ,completion: @escaping (_ success: Bool, [BannerList]?) ->()) {
        let BannerURL = getAPIURL(api: "ios/banner_list.jsp?APP=\(app)&PAGE=\(page)")
        print("\n---------- [ BannerURL : \(BannerURL) ] ----------\n")
        AlamofireAppManager?.request(BannerURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success(let data):
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["banner"] as? [[String : Any]] {
                            let bannerList = Mapper<BannerList>().mapArray(JSONArray: resData)
                            completion(true, bannerList)
                        }
                    }
                }
            case.failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    
    func BannerListRx(_ app: Int,_ page:Int) -> Observable<(Bool, [BannerList]?)>{
        return Observable.create { (emitter) -> Disposable in
            self.BannerList(app, page) { (isSuccess, resData) in
                if(isSuccess){
                    emitter.onNext((true, resData))
                    emitter.onCompleted()
                }else{
                    emitter.onNext((false, nil))
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    
    //MARK: - 앱 버전 체크
    
    /**
     버전체크
     
     - parameter mode:    모드(0.근로자 1.관리자)
     - parameter appvs:    어플버전
     - returns : 업데이트메세지 , 강제업데이트 여부 (1:강제 , 0:권유) , 현재버전
     */
    func AppVersionCheck(mode: Int, appvs: String, completion: @escaping (_ success:Bool , _ update:Int , _ updatemsg:String , _ curver:String, _ isreview:Int) ->()) {
        
        let appVersionURL = getAPIURL(api: "ios/check_version.jsp?MODE=\(mode)&APPVS=\(appvs)")
        
        print("\n---------- [ appVersionURL : \(appVersionURL) ] ----------\n")
        AlamofireAppManager?.request(appVersionURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultUpdate = jsonData["update"] as? Int,
                            let resultMsg = jsonData["updatemsg"] as? String,
                            let resultcurver = jsonData["curver"] as? String,
                            let resultreview = jsonData["review"] as? Int{
                            completion(true ,  resultUpdate , resultMsg , resultcurver , resultreview)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 ,"","" , 0)
            }
        })
    }
    
    
    
    //MARK: 인사관리자 리스트
    /**
     회사 인사관리자 리스트
     
     - parameter cmpsid:        회사번호
     - returns : 회사 인사관리자 리스트
     */
    func PersonMgrList(cmpsid: Int, completion: @escaping (_ success:Bool , [PersonInfo]?) ->()) {
        
        let personMgrlistURL = getAPIURL(api: "ios/m/cmp_hrmgrlist.jsp?CMPSID=\(cmpsid)")
        
        print("\n---------- [ personMgrlistURL : \(personMgrlistURL) ] ----------\n")
        AlamofireAppManager?.request(personMgrlistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]]{
                            let response = Mapper<PersonInfo>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    
    /**
     회사 최고관리자 리스트 - 인사관리자 추가를 위한 최고관리자 목록
     - parameter cmpsid : 회사번호
     - returns: 회사 최고관리자 리스트
     */
    func getPerson_emplist(cmpsid: Int, completion: @escaping (_ success:Bool , [PersonInfo]?) ->()) {
        
        let PersonEmplistURL = getAPIURL(api: "ios/m/cmp_onlysmgrlist.jsp?CMPSID=\(cmpsid)")
        
        
        print("\n---------- [ PersonEmplistURL : \(PersonEmplistURL) ] ----------\n")
        AlamofireAppManager?.request(PersonEmplistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]] {
                            let response = Mapper<PersonInfo>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    
    // MARK: - 보안서약서
    
    /**
     보안서약서 핀플직원 리스트 - 최고관리자 제외.. 페이징 없음
     - parameter cmpsid : 회사번호
     - returns: 회사 직원 리스트
     */
    func getSc_empList(cmpsid: Int, completion: @escaping (_ success:Bool , [ScEmpList]?) ->()) {
        
        let LcEmplistURL = getAPIURL(api: "ios/m/sc_emplist.jsp?CMPSID=\(cmpsid)")
        
        
        print("\n---------- [ LcEmplistURL : \(LcEmplistURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmplistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]] {
                            let response = Mapper<ScEmpList>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    
    /**
     보안서약서 리스트
     - parameter cmpsid : 회사번호
     - parameter curkey : 페이징 키(첫 페이지는 0 또는 안넘김)
     - parameter listcnt : 리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     - returns: 보안서약서 리스트
     */
    func getSc_List(cmpsid: Int,curkey: String, listcnt: Int, completion: @escaping (_ success:Bool ,  _ nextkey:String , [ScEmpInfo]?) ->()) {
        var LcListURL = ""
        if curkey != "" {
            LcListURL = getAPIURL(api: "ios/m/sc_listdt.jsp?CMPSID=\(cmpsid)&CURKEY=\(curkey.urlEncoding())&LISTCNT=\(listcnt)")
        }else{
            LcListURL = getAPIURL(api: "ios/m/sc_listdt.jsp?CMPSID=\(cmpsid)&CURKEY=&LISTCNT=\(listcnt)")
        }
        
        
        print("\n---------- [ LcListURL : \(LcListURL) ] ----------\n")
        AlamofireAppManager?.request(LcListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["securt"] as? [[String : Any]] {
                            if let resnextkey = jsonData["nextkey"] as? String {
                                let response = Mapper<ScEmpInfo>().mapArray(JSONArray: resData)
                                completion(true ,  resnextkey , response)
                            }else{
                                let response = Mapper<ScEmpInfo>().mapArray(JSONArray: resData)
                                completion(true ,  "" , response)
                            }
                            
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , "" , nil)
            }
        })
    }
    
    
    /**
     검색된 보안서약서 리스트
     - parameter cmpsid : 회사번호
     - parameter name : 검색어(이름) .. URL 인코딩
     - parameter curkey : 페이징 키(첫 페이지는 0 또는 안넘김)
     - parameter listcnt : 리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     - returns: 검색된 보안서약서 리스트
     */
    func searchSc_List(cmpsid: Int,curkey: String,listcnt: Int, name: String,  completion: @escaping (_ success:Bool ,  _ nextkey:String , [ScEmpInfo]?) ->()) {
        
        //        let searchLcListURL = getAPIURL(api: "ios/m/lc_searchlist.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=\(curkey)&LISTCNT=\(listcnt)")
        
        var searchLcListURL = ""
        if curkey != "" {
            searchLcListURL = getAPIURL(api: "ios/m/sc_searchlistdt.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=\(curkey.urlEncoding())&LISTCNT=\(listcnt)")
        }else{
            searchLcListURL = getAPIURL(api: "ios/m/sc_searchlistdt.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=&LISTCNT=\(listcnt)")
        }
        
        print("\n---------- [ searchLcListURL : \(searchLcListURL) ] ----------\n")
        AlamofireAppManager?.request(searchLcListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["securt"] as? [[String : Any]] {
                            if let resnextkey = jsonData["nextkey"] as? String {
                                let response = Mapper<ScEmpInfo>().mapArray(JSONArray: resData)
                                completion(true ,  resnextkey , response)
                            }else{
                                let response = Mapper<ScEmpInfo>().mapArray(JSONArray: resData)
                                completion(true ,  "" , response)
                            }
                            
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , "" , nil)
            }
        })
    }
    
    /**
     보안서약서 정보 조회
     - parameter LCTSID : 계약서번호
     - returns: 보안서약서 정보
     */
    func get_SCInfo(LCTSID: Int, completion: @escaping (_ success:Bool , ScEmpInfo?) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/get_scinfo.jsp?LCTSID=\(LCTSID)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<ScEmpInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                }
            case .failure(let _):
                completion(false , nil)
            }
        })
    }
    
    /**
     보안서약서 PDF web 에서 받아오기
     - parameter LCTSID : 계약서번호
     - returns: 성공 : 1, 실패 : 0
     */
    func getSc_PDF(LCTSID: String, completion: @escaping (_ success:Bool , _ resCode:Int , _ pdfPath: String) ->()) {
        
        let LcpdfURL = getAPIURL(api: "ios/m/save_sc_pdf.jsp?LCTSID=\(LCTSID)")
        //        let LcpdfURL = getAPIURL(api: "ios/m/save_pdf_test.jsp?LCTSID=\(LCTSID)")
        
        print("\n---------- [ LcpdfURL : \(LcpdfURL) ] ----------\n")
        AlamofireAppManager?.request(LcpdfURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int ,
                            let respdf = jsonData["pdffile"] as? String {
                            completion(true ,  resultCode, respdf)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0 , "")
            }
        })
    }
    
    /**
     보안서약서 작성 정보 수정
     - parameter ceysid : 보안서약서 번호
     - parameter spot: 직위.. URL 인코딩
     - parameter bi : 생년월일.. Base64 인코딩
     - parameter pn : 핸드폰번호.. Base64 인코딩
     - parameter addr: 주소.. URL 인코딩 후 Base64 인코딩
      
     - returns :  성공 : 1, 실패 : 0
     */
    func udSecurtEmply(CEYSID: Int, SPOT: String, BI: String,PN: String,ADDR:String , completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let udtCertEmplyURL =   getAPIURL(api:"ios/m/udt_securtemply.jsp?LCSID=\(CEYSID)&SPOT=\(SPOT)&BI=\(BI)&PN=\(PN)&ADDR=\(ADDR)")
        
        print("\n---------- [ udtCertEmplyURL : \(udtCertEmplyURL) ] ----------\n")
        AlamofireAppManager?.request(udtCertEmplyURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure( _):
                completion(false , 0)
            }
        })
    }
    
    /**
     보안서약서 작성 -
     - parameter LCTSID        계약서번호
     - returns: 성공 : 1, 실패 : 0
     */
    
    func sc_step2(lctsid: Int, cmpnm: String, lcdt:String ,json: String, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
         
        let url = URL(string: "\(API.baseURL)ios/m/sc_step2.jsp")
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]

        let defaultSession = URLSession(configuration: config)

        var request = URLRequest(url: url!)
        request.encodeParameters(parameters: [
            "LCTSID": "\(lctsid)",
            "CMPNM": "\(cmpnm)",
            "LCDT" : "\(lcdt)",
            "JSON"  : json
            ]
        )

        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                completion(false , 0)
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false , 0)
                return
            }

            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                    completion(true , res.result)
            } catch {
                    completion(false , 0)
            }
        }
        dataTask.resume()
        
    }
     
   /**
    보안서약서  조항삭제
    - parameter LCTSID : 계약서번호
    - parameter OPTSID : 옵션 번호
    - returns: 회사 직원 리스트
    */
   func delScOtp(lctsid: Int, optsid: Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
       
       let delScOtpURL = getAPIURL(api: "ios/m/del_SecurtOpt.jsp?LCTSID=\(lctsid)&OPTSID=\(optsid)")
       
       
       print("\n---------- [ delScOtpURL : \(delScOtpURL) ] ----------\n")
       AlamofireAppManager?.request(delScOtpURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
           switch response.result {
           case .success(let data) :
               let statusCode = response.response?.statusCode
               if statusCode == 200 {
                   //정상
                   if let jsonData = data as? [String : Any] {
                       if let resultCode = jsonData["result"] as? Int{
                           completion(true ,  resultCode)
                       }
                   }
               }
           case .failure(let error):
               completion(false , 0)
           }
       })
   }
   
    /**
     미합류직원 보안서약서 입력 및 조회
     - parameter cmpsid : 회사번호
     - parameter nm : 이름 - Base64 인코딩
     - parameter pn : 핸드폰번호 - Base64 인코딩
     - parameter em : 아이디(Email) - Base64 인코딩
     - parameter format : 계약서포맷(0.입사자 보안서약서 1.퇴사바보안서약서 )
     - returns: 보안서약서 정보
     */
    func setNotJoinSc(cmpsid: Int, nm: String,pn: String,em: String,format:Int, completion: @escaping (_ success:Bool , ScEmpInfo?) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/get_notjoinsc.jsp?CMPSID=\(cmpsid)&NM=\(nm)&PN=\(pn)&EM=\(em)&FORMAT=\(format)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        let resData = Mapper<ScEmpInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                }
            case .failure(let _):
                completion(false , nil)
            }
        })
    }
    
    /**
     합류직원 보안서약서 입력 및 조회
     - parameter cmpsid : 회사번호
     - parameter empsid : 직원번호
     - parameter format : 계약서포맷(0.입사자 보안서약서 1.퇴사바보안서약서 )
     - returns: 보안서약서 정보
     */
    func getSc_empInfo(cmpsid: Int, empsid: Int,format : Int, completion: @escaping (_ success:Bool , ScEmpInfo?) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/get_joinsc.jsp?CMPSID=\(cmpsid)&EMPSID=\(empsid)&FORMAT=\(format)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<ScEmpInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                }
            case .failure(let _):
                completion(false , nil)
            }
        })
    }
    
    /**
     보안서약서 작성 - 고용형태 저장
     - parameter lctsid : 계약서번호
     - parameter form : 고용형태(0.정규직 1.계약직 2.수습)
     - returns: 성공 : 1, 실패 : 0
     */
    func set_Scstep1(lctsid: Int, form: Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/sc_step1.jsp?LCTSID=\(lctsid)&FORMAT=\(form)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    
    /**
     보안서약서 작성 - 계약정보 저장
     - parameter LCTSID        계약서번호
     - parameter EMPSID        본인 직원번호(계약서 작성자).. 알림 메시지 저장용
     - parameter MBRSID        본인 회원번호(계약서 작성자)..포인트 사용내역 저장용
     - returns: 성공 1, 실패 0, 회사직인미설정 -1, 보안서약서 없음 -2, 잔여포인트 부족 -3
     */
    
    func Sc_send(LCTSID: Int, EMPSID: Int,MBRSID: Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let lcsendURL = getAPIURL(api: "ios/m/sc_send.jsp?LCTSID=\(LCTSID)&EMPSID=\(EMPSID)&MBRSID=\(MBRSID)")
        
        
        print("\n---------- [ lcsendURL : \(lcsendURL) ] ----------\n")
        AlamofireAppManager?.request(lcsendURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    
    
    // MARK: - 근로계약서
    /**
     근로계약서 핀플직원 리스트 - 최고관리자 제외.. 페이징 없음
     - parameter cmpsid : 회사번호
     - returns: 회사 직원 리스트
     */
    func getLc_empList(cmpsid: Int, completion: @escaping (_ success:Bool , [LcEmpList]?) ->()) {
        
        let LcEmplistURL = getAPIURL(api: "ios/m/lc_emplist.jsp?CMPSID=\(cmpsid)")
        
        
        print("\n---------- [ LcEmplistURL : \(LcEmplistURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmplistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]] {
                            let response = Mapper<LcEmpList>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    
    /**
     근로계약서 리스트
     - parameter cmpsid : 회사번호
     - parameter curkey : 페이징 키(첫 페이지는 0 또는 안넘김)
     - parameter listcnt : 리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     - returns: 근로계약서 리스트
     */
    func getLc_List(cmpsid: Int,curkey: String, listcnt: Int, completion: @escaping (_ success:Bool ,  _ nextkey:String , [LcEmpInfo]?) ->()) {
        
        //        let LcListURL = getAPIURL(api: "ios/m/lc_list.jsp?CMPSID=\(cmpsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)")
        
        var LcListURL = ""
        if curkey != "" {
            LcListURL = getAPIURL(api: "ios/m/lc_listdt.jsp?CMPSID=\(cmpsid)&CURKEY=\(curkey.urlEncoding())&LISTCNT=\(listcnt)")
        }else{
            LcListURL = getAPIURL(api: "ios/m/lc_listdt.jsp?CMPSID=\(cmpsid)&CURKEY=&LISTCNT=\(listcnt)")
        }
        
        
        print("\n---------- [ LcListURL : \(LcListURL) ] ----------\n")
        AlamofireAppManager?.request(LcListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["labor"] as? [[String : Any]] {
                            if let resnextkey = jsonData["nextkey"] as? String {
                                let response = Mapper<LcEmpInfo>().mapArray(JSONArray: resData)
                                completion(true ,  resnextkey , response)
                            }else{
                                let response = Mapper<LcEmpInfo>().mapArray(JSONArray: resData)
                                completion(true ,  "" , response)
                            }
                            
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , "" , nil)
            }
        })
    }
    
    /**
     검색된 근로계약서 리스트
     - parameter cmpsid : 회사번호
     - parameter name : 검색어(이름) .. URL 인코딩
     - parameter curkey : 페이징 키(첫 페이지는 0 또는 안넘김)
     - parameter listcnt : 리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     - returns: 검색된 근로계약서 리스트
     */
    func searchLc_List(cmpsid: Int,curkey: String,listcnt: Int, name: String,  completion: @escaping (_ success:Bool ,  _ nextkey:String , [LcEmpInfo]?) ->()) {
        
        //        let searchLcListURL = getAPIURL(api: "ios/m/lc_searchlist.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=\(curkey)&LISTCNT=\(listcnt)")
        
        var searchLcListURL = ""
        if curkey != "" {
            searchLcListURL = getAPIURL(api: "ios/m/lc_searchlistdt.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=\(curkey.urlEncoding())&LISTCNT=\(listcnt)")
        }else{
            searchLcListURL = getAPIURL(api: "ios/m/lc_searchlistdt.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=&LISTCNT=\(listcnt)")
        }
        
        print("\n---------- [ searchLcListURL : \(searchLcListURL) ] ----------\n")
        AlamofireAppManager?.request(searchLcListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["labor"] as? [[String : Any]] {
                            if let resnextkey = jsonData["nextkey"] as? String {
                                let response = Mapper<LcEmpInfo>().mapArray(JSONArray: resData)
                                completion(true ,  resnextkey , response)
                            }else{
                                let response = Mapper<LcEmpInfo>().mapArray(JSONArray: resData)
                                completion(true ,  "" , response)
                            }
                            
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , "" , nil)
            }
        })
    }
    
    /**
     근로계약서 정보 조회
     - parameter LCTSID : 계약서번호
     - returns: 근로계약서 정보
     */
    func get_LCInfo(LCTSID: Int, completion: @escaping (_ success:Bool , LcEmpInfo?) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/get_lcinfo.jsp?LCTSID=\(LCTSID)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<LcEmpInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                }
            case .failure(let _):
                completion(false , nil)
            }
        })
    }
    
    /**
     근로계약서 PDF web 에서 받아오기
     - parameter LCTSID : 계약서번호
     - returns: 성공 : 1, 실패 : 0
     */
    func getLc_PDF(LCTSID: String, completion: @escaping (_ success:Bool , _ resCode:Int , _ pdfPath: String) ->()) {
        
        let LcpdfURL = getAPIURL(api: "ios/m/save_pdf.jsp?LCTSID=\(LCTSID)") 
        //        let LcpdfURL = getAPIURL(api: "ios/m/save_pdf_test.jsp?LCTSID=\(LCTSID)")
        
        print("\n---------- [ LcpdfURL : \(LcpdfURL) ] ----------\n")
        AlamofireAppManager?.request(LcpdfURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int ,
                            let respdf = jsonData["pdffile"] as? String {
                            completion(true ,  resultCode, respdf)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0 , "")
            }
        })
    }
    
    /**
     합류직원 근로계약서 입력 및 조회
     - parameter cmpsid : 회사번호
     - parameter empsid : 직원번호
     - parameter format : 계약서포맷(0.핀플근로계약서 1.표준근로계약서)
     - returns: 근로계약서 정보
     */
    func getLc_empInfo(cmpsid: Int, empsid: Int,format : Int, completion: @escaping (_ success:Bool , LcEmpInfo?) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/get_joinlc.jsp?CMPSID=\(cmpsid)&EMPSID=\(empsid)&FORMAT=\(format)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<LcEmpInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                }
            case .failure(let _):
                completion(false , nil)
            }
        })
    }
    
    /**
     근로계약서 작성 - 고용형태 저장
     - parameter lctsid : 계약서번호
     - parameter form : 고용형태(0.정규직 1.계약직 2.수습)
     - returns: 성공 : 1, 실패 : 0
     */
    func set_step1(lctsid: Int, form: Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/lc_step1.jsp?LCTSID=\(lctsid)&FORM=\(form)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    
    /**
     근로계약서 작성 - 필수정보 저장
     - parameter type : 고용형태 0.정규직 1.계약직 2.수습
     - parameter LCTSID : 계약서번호
     - parameter SDT : 시작날짜
     - parameter EDT : 종료날짜(정규직은 안보냄)
     - parameter PSDT : 급여 시작날짜
     - parameter PEDT : 급여 종료날짜
     - parameter PLACE : 근무지(URL 인코딩)
     - parameter TASK : 담당업무(URL 인코딩)
     - parameter STM : 근무 시작시간
     - parameter ETM : 근무 종료시간
     - parameter BSTM : 휴게 시작시간
     - parameter BETM : 휴게 종료시간
     - parameter WDAY : 출근요일(2,3,4,5,6 형식)
     - parameter TRAIN: 수습기간 특약(URL 인코딩)... 수습계약서 특약 입력하는경우에만 넘김(2020-09-02 추가)
     - parameter DWT: 핀플 근로계약서 일별근로 사용 0.미사용 , 1.사용 (2022-04-15 추가)
     - returns: 성공 : 1, 실패 : 0
     */
    
    func set_step2(type:Int ,LCTSID: Int, SDT: String,EDT: String, PSDT: String,PEDT: String,PLACE: String,TASK: String,STM: String,ETM: String,BSTM: String,BETM: String,WDAY: String, TRAIN: String?, DWT:Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        var step2URL = ""
        
        print("\n---------- [ step2URL : \(step2URL) ] ----------\n")

        let url =   URL(string: "\(API.baseURL)/ios/m/lc_step2.jsp")
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let defaultSession = URLSession(configuration: config)
        
        var request = URLRequest(url: url!)
        var Tmptrain = ""
         if let train = TRAIN  , train != "" {
            Tmptrain = train
         }else{
            Tmptrain = ""
        }
        request.encodeParameters(parameters: [
            "LCTSID"    : "\(LCTSID)",
            "SDT"    :   "\(SDT)",
            "EDT"      :   "\(EDT)",
            "PSDT"     : "\(PSDT)",
            "PEDT"       :  "\(PEDT)",
            "PLACE"      : "\(PLACE)",
            "TASK"   :  "\(TASK)",
            "STM"   :  "\(STM)",
            "ETM"   :  "\(ETM)",
            "BSTM"   :  "\(BSTM)",
            "BETM"   :  "\(BETM)",
            "WDAY"   :  "\(WDAY)",
            "TRAIN"   :  "\(Tmptrain)",
            "DWT"   :  "\(DWT)"
            ]
        )
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                completion(false , 0)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false , 0)
                return
            }
            
            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                completion(true , res.result)
            } catch {
                completion(false , 0)
            }
        }
        dataTask.resume()
    }
    
    /**
     근로계약서 근로일별 근로시간 저장
     - parameter lctsid : 계약서번호
     - parameter json : 근로시간정보(번호, 요일, 근로시작시간, 근로종료시간, 휴게시작시간, 휴게종료시간, 근로시간(분)) JSON 데이터
     - returns: 성공 : 1, 실패 : 0
     */
    
    func lc_step2_1(lctsid: Int, json: String, completion: @escaping (_ success:Bool , _ result:Int)->() ){
        // Get value for userWeek: weekday, saturday or holiday
        let url = URL(string: "\(API.baseURL)/ios/m/lc_step2_1.jsp")
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let defaultSession = URLSession(configuration: config)
        
        var request = URLRequest(url: url!)
        request.encodeParameters(parameters: [
            "LCTSID": "\(lctsid)" ,
            "JSON"  : json
            ]
        )
        
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                completion(false , 0)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false , 0)
                return
            }
            
            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                completion(true , res.result)
            } catch {
                completion(false , 0)
            }
        }
        dataTask.resume()
    }
    
    /**
     근로계약서 작성 - 급여선택 저장
     - parameter LCTSID : 계약서번호
     - parameter SLYTYPE : 급여선택(0.월급 1.연봉 2.시급)
     - returns: 성공 : 1, 실패 : 0
     */
    
    func set_step3(LCTSID: Int, SLYTYPE: Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let step3URL = getAPIURL(api: "ios/m/lc_step3.jsp?LCTSID=\(LCTSID)&SLYTYPE=\(SLYTYPE)")
        
        
        print("\n---------- [ step3URL : \(step3URL) ] ----------\n")
        AlamofireAppManager?.request(step3URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    
    /**
     근로계약서 작성 - 급여 상세정보 저장
     - parameter LCTSID        계약서번호
     - parameter BASEPAY        기본급
     - parameter PSTNPAY        직책수당
     - parameter OVRTMPAY    연장수당
     - parameter HLDYPAY        휴일수당
     - parameter BONUS        상여금
     - parameter BENEFITS    복지후생
     - parameter OTHERPAY    기타
     - parameter MEALS        식대
     - parameter RSRCHSBDY    연구보조비
     - parameter CHLDEXPNS    자녀보육수당
     - parameter VHCLMNCST    차량유지비
     - parameter JOBEXPNS    일직숙직비
     - parameter HLDYALWNC    명절수당
     - parameter HOURPAY        시급
     - parameter MONTHPAY    계산된 월급
     - parameter YEARPAY        계산된 연봉
     - parameter MONTHOVRTM    계산된 연장근로시간
     - parameter CNTNSPAY     장기근속수당
     - parameter NIGHTPAY    야간수당(2020-07-15 추가)
     - parameter ADJUSTPAY    조정수당(2020-07-15 추가)
     - parameter ANUALPAY    연차수당(2020-07-15 추가)
     - returns: 성공 : 1, 실패 : 0
     */
    
    func set_step4(LCTSID: Int, BASEPAY: Int,PSTNPAY: Int,OVRTMPAY: Int,HLDYPAY: Int,BONUS: Int,BENEFITS: Int,OTHERPAY: Int,MEALS: Int,RSRCHSBDY: Int,CHLDEXPNS: Int,VHCLMNCST: Int,JOBEXPNS: Int,HLDYALWNC: Int,HOURPAY: Int,MONTHPAY: Int,YEARPAY: Int,MONTHOVRTM: Int, CNTNSPAY:Int,NIGHTPAY:Int , ADJUSTPAY:Int,ANUALPAY:Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let step4URL = getAPIURL(api: "ios/m/lc_step4.jsp?LCTSID=\(LCTSID)&BASEPAY=\(BASEPAY)&PSTNPAY=\(PSTNPAY)&OVRTMPAY=\(OVRTMPAY)&HLDYPAY=\(HLDYPAY)&BONUS=\(BONUS)&BENEFITS=\(BENEFITS)&OTHERPAY=\(OTHERPAY)&MEALS=\(MEALS)&RSRCHSBDY=\(RSRCHSBDY)&CHLDEXPNS=\(CHLDEXPNS)&VHCLMNCST=\(VHCLMNCST)&JOBEXPNS=\(JOBEXPNS)&HLDYALWNC=\(HLDYALWNC)&HOURPAY=\(HOURPAY)&MONTHPAY=\(MONTHPAY)&YEARPAY=\(YEARPAY)&MONTHOVRTM=\(MONTHOVRTM)&CNTNSPAY=\(CNTNSPAY)&NIGHTPAY=\(NIGHTPAY)&ADJUSTPAY=\(ADJUSTPAY)&ANUALPAY=\(ANUALPAY)")
        
        
        print("\n---------- [ step4URL : \(step4URL) ] ----------\n")
        AlamofireAppManager?.request(step4URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(_ ):
                completion(false , 0)
            }
        })
    }
    
    /**
     근로계약서 작성 - 급여 상세정보 산출근거 저장
     - parameter LCTSID        계약서번호
     - parameter BASEBS        기본급 산출근거.. URL 인코딩
     - parameter CNTNSBS        장기근속수당 산출근거.. URL 인코딩
     - parameter PSTNBS        직책수당 산출근거.. URL 인코딩
     - parameter HLDYBS        휴일수당 산출근거
     - parameter BONUSBS        상여금 산출근거
     - parameter BENEFITSBS    복지후생 산출근거
     - parameter OTHERBS    기타 산출근거
     - parameter RSRCHBS    연구보조비 산출근거
     - parameter CHLDBS    자녀보육수당 산출근거
     - parameter VHCLBS    차량유지비 산출근거
     - parameter JOBBS    일직숙직비 산출근거
     - parameter NIGHTBS        야간수당 산출근거.. URL 인코딩(2020-07-15 추가)
     - parameter ADJUSTBS    조정수당 산출근거.. URL 인코딩(2020-07-15 추가)
     - parameter ANUALBS        연차수당 산출근거.. URL 인코딩(2020-07-15 추가)
     - returns: 성공 : 1, 실패 : 0
     */
    
    func set_step4_1(LCTSID: Int, BASEBS: String,CNTNSBS: String,PSTNBS: String,HLDYBS: String,BONUSBS: String,BENEFITSBS: String,OTHERBS: String,RSRCHBS: String,CHLDBS: String,VHCLBS: String,JOBBS: String, NIGHTBS:String, ADJUSTBS:String, ANUALBS:String, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let url = URL(string: "\(API.baseURL)/ios/m/lc_step4_1.jsp")
        let config = URLSessionConfiguration.default
        
        let defaultSession = URLSession(configuration: config)
        
        var request = URLRequest(url: url!)
        request.encodeParameters(parameters: [
            "LCTSID": "\(LCTSID)" ,
            "BASEBS"  : BASEBS ,
            "CNTNSBS"  : CNTNSBS ,
            "PSTNBS"  : PSTNBS ,
            "HLDYBS"  : HLDYBS ,
            "BONUSBS"  : BONUSBS,
            "BENEFITSBS"  : BENEFITSBS,
            "OTHERBS"  : OTHERBS,
            "RSRCHBS"  : RSRCHBS,
            "CHLDBS"  : CHLDBS,
            "VHCLBS"  : VHCLBS,
            "JOBBS"  : JOBBS,
            "NIGHTBS"  : NIGHTBS,
            "ADJUSTBS"  : ADJUSTBS,
            "ANUALBS"  : ANUALBS
            ]
        )
        
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                completion(false , 0)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false , 0)
                return
            }
            
            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                completion(true , res.result)
            } catch {
                completion(false , 0)
            }
        }
        dataTask.resume()
    }
    
    /**
     근로계약서 작성 - 계약정보 저장
     - parameter LCTSID        계약서번호
     - parameter PAYDAY        임금지급일(URL 인코딩)
     - parameter SOCIAL        사회보험(URL 인코딩)
     - parameter ANUAL        연차휴가(URL 인코딩)
     - parameter DELIVERY    근로계약서 교부(URL 인코딩)
     - parameter OTHER        기타사항(URL 인코딩)
     - returns: 성공 : 1, 실패 : 0
     */
    
    func set_step5(LCTSID: Int, PAYDAY: String ,SOCIAL: String , ANUAL: String , DELIVERY: String , OTHER: String ,   completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        // Get value for userWeek: weekday, saturday or holiday
        let url = URL(string: "\(API.baseURL)/ios/m/lc_step5.jsp")
        let config = URLSessionConfiguration.default
        
        let defaultSession = URLSession(configuration: config)
        
        var request = URLRequest(url: url!)
        request.encodeParameters(parameters: [
            "LCTSID": "\(LCTSID)" ,
            "PAYDAY"  : PAYDAY ,
            "SOCIAL"  : SOCIAL ,
            "ANUAL"  : ANUAL ,
            "DELIVERY"  : DELIVERY ,
            "OTHER"  : OTHER
            ]
        )
        
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                completion(false , 0)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false , 0)
                return
            }
            
            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                completion(true , res.result)
            } catch {
                completion(false , 0)
            }
        }
        dataTask.resume()
    }
    
    /**
     근로계약서 작성 - 계약정보 저장
     - parameter LCTSID        계약서번호
     - parameter LCDT        계약일(2020-05-19)
     - parameter ADDR        주소(Base64 인코딩)
     - parameter BIRTH    생년월일(Base64 인코딩)
     - parameter PHONE        핸드폰번호(Base64 인코딩)
     - parameter HOLDER        예금주명(Base64 인코딩)
     - parameter BANK        은형명(Base64 인코딩)
     - parameter NUM        계좌번호(Base64 인코딩)
     - returns: 성공 : 1, 실패 : 0
     */
    
    func set_step6(LCTSID: Int, LCDT: String,ADDR: String,BIRTH: String,PHONE: String,HOLDER: String,BANK: String,NUM: String, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let step6URL = getAPIURL(api: "ios/m/lc_step6.jsp?LCTSID=\(LCTSID)&LCDT=\(LCDT)&ADDR=\(ADDR)&BIRTH=\(BIRTH)&PHONE=\(PHONE)&HOLDER=\(HOLDER)&BANK=\(BANK)&NUM=\(NUM)")
        
        
        print("\n---------- [ step6URL : \(step6URL) ] ----------\n")
        AlamofireAppManager?.request(step6URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }else{
                            completion(false , 0)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    
    /**
     근로계약서 필수 회사정보 체크
     - parameter cmpsid        회사번호
     - returns: 성공 : 1, 실패 : 0
     */
    
    func chkCmpinfo(cmpsid: Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let chkcmpinfoURL = getAPIURL(api: "ios/m/check_cmplcinfo.jsp?CMPSID=\(cmpsid)")
        
        
        print("\n---------- [ chkcmpinfoURL : \(chkcmpinfoURL) ] ----------\n")
        AlamofireAppManager?.request(chkcmpinfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    /**
     근로계약서 작성 - 계약정보 저장
     - parameter LCTSID        계약서번호
     - parameter EMPSID        본인 직원번호(계약서 작성자).. 알림 메시지 저장용
     - parameter MBRSID        본인 회원번호(계약서 작성자)..포인트 사용내역 저장용
     - returns: 성공 1, 실패 0, 회사직인미설정 -1, 근로계약서 없음 -2, 잔여포인트 부족 -3
     */
    
    func lc_send(LCTSID: Int, EMPSID: Int,MBRSID: Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let lcsendURL = getAPIURL(api: "ios/m/lc_send.jsp?LCTSID=\(LCTSID)&EMPSID=\(EMPSID)&MBRSID=\(MBRSID)")
        
        
        print("\n---------- [ lcsendURL : \(lcsendURL) ] ----------\n")
        AlamofireAppManager?.request(lcsendURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    /**
     미합류직원 근로계약서 입력 및 조회
     - parameter cmpsid : 회사번호
     - parameter nm : 이름 - Base64 인코딩
     - parameter pn : 핸드폰번호 - Base64 인코딩
     - parameter em : 아이디(Email) - Base64 인코딩
     - parameter format : 계약서포맷(0.핀플근로계약서 1.표준근로계약서)
     - returns: 근로계약서 정보
     */
    func setNotJoinLc(cmpsid: Int, nm: String,pn: String,em: String,format:Int, completion: @escaping (_ success:Bool , LcEmpInfo?) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/get_notjoinlc.jsp?CMPSID=\(cmpsid)&NM=\(nm)&PN=\(pn)&EM=\(em)&FORMAT=\(format)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        let resData = Mapper<LcEmpInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                }
            case .failure(let _):
                completion(false , nil)
            }
        })
    }
    
    /**
     회사직인 리스트
     - parameter cmpsid : 회사번호
     - returns: 회사직인 리스트 .. 페이징 없음
     */
    func getcmp_sealList(cmpsid: Int, completion: @escaping (_ success:Bool , [cmpSignInfo]?) ->()) {
        
        let cmpSealURL = getAPIURL(api: "ios/m/cmpseal_list.jsp?CMPSID=\(cmpsid)")
        
        
        print("\n---------- [ cmpSealURL : \(cmpSealURL) ] ----------\n")
        AlamofireAppManager?.request(cmpSealURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["cmpseal"] as? [[String : Any]] {
                            let response = Mapper<cmpSignInfo>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    
    /**
     회사직인 사용설정
     - parameter cslsid : 직인번호
     - parameter cmpsid : 회사번호
     - returns: 성공 : 1, 실패 : 0
     */
    func useCmpseal(cmpsid: Int,cslsid: Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let cmpSealURL = getAPIURL(api: "ios/m/udt_cmpsealuseflag.jsp?CMPSID=\(cmpsid)&CSLSID=\(cslsid)")
        
        
        print("\n---------- [ cmpSealURL : \(cmpSealURL) ] ----------\n")
        AlamofireAppManager?.request(cmpSealURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    
    /**
     회사직인 이름 변경
     - parameter cslsid : 직인번호
     - parameter name : 이름(URL 인코딩)
     - parameter shape: 직인모양 0.원형 1.사각형
     - returns: 성공 : 1, 실패 : 0
     */
    func udtCmpsealName(cslsid: Int,name: String, shape:Int , completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let cmpSealURL = getAPIURL(api: "ios/m/udt_cmpsealname.jsp?NAME=\(name)&CSLSID=\(cslsid)&SHAPE=\(shape)")
        
        
        print("\n---------- [ cmpSealURL : \(cmpSealURL) ] ----------\n")
        AlamofireAppManager?.request(cmpSealURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    
    /**
     회사직인 삭제
     - parameter cslsid : 직인번호
     - parameter sealimg : 직인 파일URL
     - returns: 성공 : 1, 실패 : 0
     */
    func delCmpseal(cslsid: Int,sealimg: String, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let cmpSealURL = getAPIURL(api: "ios/m/del_cmpseal.jsp?SEALIMG=\(sealimg)&CSLSID=\(cslsid)")
        
        
        print("\n---------- [ cmpSealURL : \(cmpSealURL) ] ----------\n")
        AlamofireAppManager?.request(cmpSealURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    /**
     
     회사직인 수정 - 파일 변경이 포함된 경우.. 이름만 변경하는 경우는 별도 처리 udt_cmpsealname.jsp로 연동
     - parameter cslsid : 직인번호
     - parameter cmpsid : 회사번호
     - parameter name : 이름(URL 인코딩)
     - parameter shape    직인모양 0.원형 1.사각형
     - parameter old : 기존 파일명
     - parameter file : 직인 이미지
     - returns: 성공 : 1 , 실패 0
     */
    
    func udtCmpseal(cmpsid: Int, cslsid: Int, image: UIImage, name:String ,  oldfilename:String , shape:Int , completion: @escaping (_ success:Bool , _ resultCode :Int) ->()) {
        
        var urlStr = ""
        var param: [String:Any] = [:]
        //     let imageData = image.jpegData(compressionQuality: 0.50)
        let imageData = image.pngData()
        param = [
            "CSLSID" : cslsid,
            "CMPSID" : cmpsid,
            "OLD" : oldfilename,
            "NAME" : name,
            "SHAPE" : shape
        ]
        urlStr = baseURL + "ios/m/udt_cmpseal.jsp"
        
        guard let url = URL(string: urlStr) else { return }
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "FILE", fileName: "swift_file.png", mimeType: "image/png")
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print("uploading \(progress)")
                    
                })
                
                upload.responseJSON { response in
                    if let err = response.error{
                        print("err? \(err.localizedDescription)")
                        completion(false , 0 )
                        return
                    }
                    switch response.result {
                    case .success(let data):
                        if let jsonData = data as? [String : Any] {
                            if let resultCode = jsonData["result"] as? Int{
                                completion(true ,  resultCode)
                            }
                        }
                    case .failure(let err):
                        print("error \(err)")
                        completion(false , 0 )
                    }
                }
            case .failure( _):
                //print encodingError.description
                completion(false , 0 )
                break
            }
        }
    }
    
    /**
     회사직인 등록
     - parameter cmpsid : 회사번호
     - parameter type : 종류 0.직인 1.서명
     - parameter shape    직인모양 0.원형 1.사각형
     - parameter name : 이름(URL 인코딩)
     - parameter file : 직인 이미지
     - parameter cert : 이용 구분(0.근로계약서 1.증명서) .. 2020-08-12 추가
     - returns: 성공 : 1 , 실패 0
     */
    
    func uploadCmpseal(cmpsid: Int, type: Int, image: UIImage, name:String ,shape:Int,cert :Int, completion: @escaping (_ success:Bool , _ resultCode :Int , _ resultimg: String) ->()) {
        
        var urlStr = ""
        var param: [String:Any] = [:]
        //        let imageData = image.jpegData(compressionQuality: 0.50)
        let imageData = image.pngData()
        param = [
            "CMPSID" : cmpsid,
            "TYPE" : type,
            "NAME" : name,
            "SHAPE" : shape,
            "CERT" : cert
        ]
        
        let url = getAPIURL(api: "ios/m/upload_cmpseal.jsp")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "FILE", fileName: "swift_file.png", mimeType: "image/png")
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print("uploading \(progress)")
                    
                })
                
                upload.responseJSON { response in
                    if let err = response.error{
                        print("err? \(err.localizedDescription)")
                        completion(false , 0 ,"")
                        return
                    }
                    switch response.result {
                    case .success(let data):
                        if let jsonData = data as? [String : Any] {
                            if let resultCode = jsonData["result"] as? Int{
                                let resultImg = jsonData["sealimg"] as? String ?? ""
                                completion(true ,  resultCode,resultImg)
                            }
                        }
                    case .failure(let err):
                        print("error \(err)")
                        completion(false , 0 ,"")
                    }
                }
            case .failure( _):
                //print encodingError.description
                completion(false , 0 ,"")
                break
            }
        }
    }
    
    // MARK: 표준근로계약서
    /**
     표준근로계약서 작성 - 고용형태 저장
     - parameter lctsid : 계약서번호
     - parameter form : 고용형태 0.월급(정규직) 1.월급(계약직) 2.시급(소정시간) 3.시급(근로일별) 4.일급(소정시간) 5.일급(근로일별)
     - returns: 성공 : 1, 실패 : 0
     */
    func lc_std_step1(lctsid: Int, form: Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let lc_std_step1 = getAPIURL(api: "ios/m/lc_std_step1.jsp?LCTSID=\(lctsid)&FORM=\(form)")
        
        
        print("\n---------- [ lc_std_step1 : \(lc_std_step1) ] ----------\n")
        AlamofireAppManager?.request(lc_std_step1, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    
    /**
     표준근로계약서 작성 - 필수정보 저장
     - parameter LCTSID : 계약서번호
     - parameter SDT : 시작날짜
     - parameter EDT : 종료날짜(고용형태에따라 안보낼 수 있음)
     - parameter PLACE : 근무지(URL 인코딩)
     - parameter TASK : 담당업무(URL 인코딩)
     - parameter STM :  근무 시작시간 ..입력 안받는경우 기본값 보냄 09:00
     - parameter ETM :  근무 종료시간 ..입력 안받는경우 기본값 보냄 18:00
     - parameter BSTM : 휴게 시작시간 ..입력 안받는경우 기본값 보냄 12:00
     - parameter BETM : 휴게 종료시간 ..입력 안받는경우 기본값 보냄 13:00
     - parameter WDAY : 출근요일(2,3,4,5,6 형식)
     - returns: 성공 : 1, 실패 : 0
     */
    
    func lc_std_step2(LCTSID: Int, SDT: String,EDT: String, PLACE: String,TASK: String,STM: String,ETM: String,BSTM: String,BETM: String,WDAY: String, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let lc_std_step2URL =   getAPIURL(api:"ios/m/lc_std_step2.jsp?LCTSID=\(LCTSID)&SDT=\(SDT)&EDT=\(EDT)&PLACE=\(PLACE)&TASK=\(TASK)&STM=\(STM)&ETM=\(ETM)&BSTM=\(BSTM)&BETM=\(BETM)&WDAY=\(WDAY)")
        
        print("\n---------- [ lc_std_step2URL : \(lc_std_step2URL) ] ----------\n")
        AlamofireAppManager?.request(lc_std_step2URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    
    
    /**
     표준근로계약서 작성 - 급여 정보 저장
     - parameter LCTSID : 계약서번호
     - parameter BASEPAY : 월급, 일급, 시급
     - parameter BONUS : 상여금
     - parameter OTHERPAY : 기타급여
     - parameter ADDRATE : 초과근로 가산임금률
     - returns: 성공 : 1, 실패 : 0
     */
    
    func lc_std_step3(LCTSID: Int, BASEPAY: Int,BONUS: Int, OTHERPAY: Int,ADDRATE: Int, HOURPAY:Int , DAYPAY:Int , completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let lc_std_step3URL =   getAPIURL(api:"ios/m/lc_std_step3.jsp?LCTSID=\(LCTSID)&BASEPAY=\(BASEPAY)&BONUS=\(BONUS)&OTHERPAY=\(OTHERPAY)&HOURPAY=\(HOURPAY)&DAYPAY=\(DAYPAY)&ADDRATE=\(ADDRATE)")
        
        print("\n---------- [ lc_std_step3URL : \(lc_std_step3URL) ] ----------\n")
        AlamofireAppManager?.request(lc_std_step3URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    
    /**
     표준근로계약서 작성 - 계약정보 저장
     - parameter LCTSID : 계약서번호
     - parameter PAYDAY : 임금지급일(URL 인코딩)
     - parameter PAYROLL : 지급방법(0.직접지급 1.통장입금)
     - parameter SOCIAL : 사회보험(URL 인코딩)
     - parameter ANUAL :  연차휴가(URL 인코딩)
     - parameter DELIVERY :  근로계약서 교부(URL 인코딩)
     - parameter OTHER :  기타사항(URL 인코딩)
     - returns: 성공 : 1, 실패 : 0
     */
    
    func lc_std_step4(LCTSID: Int, PAYDAY: String,PAYROLL: Int, SOCIAL: String,ANUAL: String,DELIVERY:String , OTHER:String , completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        // Get value for userWeek: weekday, saturday or holiday
        let url = URL(string: "\(API.baseURL)/ios/m/lc_std_step4.jsp")
        let config = URLSessionConfiguration.default
        
        let defaultSession = URLSession(configuration: config)
        
        var request = URLRequest(url: url!)
        request.encodeParameters(parameters: [
            "LCTSID": "\(LCTSID)" ,
            "PAYDAY"  : PAYDAY ,
            "PAYROLL"  : "\(PAYROLL)" ,
            "SOCIAL"  : SOCIAL ,
            "ANUAL"  : ANUAL ,
            "DELIVERY"  : DELIVERY ,
            "OTHER"  : OTHER
            ]
        )
        
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                completion(false , 0)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false , 0)
                return
            }
            
            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                completion(true , res.result)
            } catch {
                completion(false , 0)
            }
        }
        dataTask.resume()
    }
    
    /**
     표준근로계약서 작성 - 계약정보 저장
     - parameter LCTSID : 계약서번호
     - parameter LCDT : 계약일(2020-05-19)
     - parameter ADDR : 주소(Base64 인코딩)
     - parameter BIRTH : 생년월일(Base64 인코딩)
     - parameter PHONE :  핸드폰번호(Base64 인코딩)
     - parameter HOLDER :  예금주명(Base64 인코딩)
     - parameter BANK :  은형명(Base64 인코딩)
     - parameter NUM :  계좌번호(Base64 인코딩)
     - returns: 성공 : 1, 실패 : 0
     */
    
    func lc_std_step5(LCTSID: Int, LCDT: String,ADDR: String, BIRTH: String,PHONE: String,HOLDER:String , BANK:String , NUM:String , completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let lc_std_step5URL =   getAPIURL(api:"ios/m/lc_std_step5.jsp?LCTSID=\(LCTSID)&LCDT=\(LCDT)&ADDR=\(ADDR)&BIRTH=\(BIRTH)&PHONE=\(PHONE)&HOLDER=\(HOLDER)&BANK=\(BANK)&NUM=\(NUM)")
        
        print("\n---------- [ lc_std_step5URL : \(lc_std_step5URL) ] ----------\n")
        AlamofireAppManager?.request(lc_std_step5URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    
    /**
     표준근로계약서 근로일별 근로시간 저장
     - parameter lctsid : 계약서번호
     - parameter json : 근로시간정보(번호, 요일, 근로시작시간, 근로종료시간, 휴게시작시간, 휴게종료시간, 근로시간(분)) JSON 데이터
     - returns: 성공 : 1, 실패 : 0
     */
    
    func lc_std_step2_1(lctsid: Int, json: String, completion: @escaping (_ success:Bool , _ result:Int)->() ){
        // Get value for userWeek: weekday, saturday or holiday
        let url = URL(string: "\(API.baseURL)/ios/m/lc_std_step2_1.jsp")
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let defaultSession = URLSession(configuration: config)
        
        var request = URLRequest(url: url!)
        request.encodeParameters(parameters: [
            "LCTSID": "\(lctsid)" ,
            "JSON"  : json
            ]
        )
        
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                completion(false , 0)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false , 0)
                return
            }
            
            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                completion(true , res.result)
            } catch {
                completion(false , 0)
            }
        }
        dataTask.resume()
    }
    
    // MARK: - 인앱결제
    /**
     인앱 상품 정보
     
     - parameter pin:   타입번호
     - parameter name :   상품명
     - parameter price :  가격
     
     - returns : 인앱 상품 정보
     */
    func InappInfo(completion: @escaping (_ success:Bool , [InappInfo]? , _ img:String) ->()) {
        
        let inappInfoURL =  getAPIURL(api: "ios/inapp_list.jsp")
        
        
        print("\n---------- [ inappInfoURL : \(inappInfoURL) ] ----------\n")
        AlamofireAppManager?.request(inappInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["inapp"] as? [[String : Any]] ,
                            let eventimg = jsonData["image"] as? String {
                            let response = Mapper<InappInfo>().mapArray(JSONArray: resData)
                            completion(true , response , eventimg)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil , "")
            }
        })
    }
    
    
    /**
     애플 IAP 결제 결과 저장).. 보안키 삽입
     - parameter mbrsid : 회원번호
     - parameter cmpsid: 회사번호
     - parameter type: 결제타입 : 0. 5pin(5,500원), 1. 11pin(11,000원), 2. 23pin(22,000원), 3. 36pin(33,000원)
     - parameter pid: IAP 결제 고유 ID
     - parameter status : 결제 상태(0.사용자결제취소, 1.결제성공, 2.결제요청후 결제취소, 3.비정상적인 결제 4.앱스토어 접속 오류 5. 6. 7.)
     - parameter tid : 거래번호
     - parameter tdate: 거래일시
     - parameter sk: 인증키.. 정상구매 확인을 위한... (MBRSID + ORDER).. SHA1 암호화
     - returns :  남은포인트, 실패시 0 , 인증실패시 -1
     */
    func payment_iap(MBRSID: Int, CMPSID: Int,TYPE: Int, PID: String,STATUS: Int,TID:String , TDATE:String , SK:String , completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let paymentURL =   getAPIURL(api:"ios/m/payment_iap.jsp?MBRSID=\(MBRSID)&CMPSID=\(CMPSID)&TYPE=\(TYPE)&PID=\(PID)&STATUS=\(STATUS)&TID=\(TID)&TDATE=\(TDATE)&SK=\(SK)")
        
        print("\n---------- [ paymentURL : \(paymentURL) ] ----------\n")
        AlamofireAppManager?.request(paymentURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    
    
    
    /**
     근로계약서 업로드
     - parameter lctsid : 근로계약서 번호
     - parameter sfile : 근로계약서 회사직인 포함 이미지
     - parameter file : 근로계약서 회사직인 제외 이미지
     - returns: 성공 : 1 , 실패 0 , 1:성공일때 pdffile 파일경로
     */
    func upload_labor(lctsid: Int, simage: Data, image: Data,  completion: @escaping (_ success:Bool , _ resultCode :Int) ->()) {
        
        var urlStr = ""
        var param: [String:Any] = [:]
        
        param = [
            "LCTSID" : lctsid
        ]
        urlStr = baseURL + "ios/m/upload_labor.jsp"
        
        guard let url = URL(string: urlStr) else { return }
        
        
        Alamofire.upload(
            multipartFormData: {
                multipartFormData in
                
                multipartFormData.append(simage, withName: "SFILE", fileName: "Cmpseal.pdf", mimeType: "application/pdf")
                multipartFormData.append(image, withName: "FILE", fileName: "Cmpseal_no.pdf", mimeType: "application/pdf")
                for (key, value) in param {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                
        },
            to: url,
            method: .post,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                    
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        if let err = response.error{
                            print("err? \(err.localizedDescription)")
                            completion(false , 0 )
                            return
                        }
                        switch response.result {
                        case .success(let data):
                            if let jsonData = data as? [String : Any] {
                                if let resultCode = jsonData["result"] as? Int{
                                    completion(true ,  resultCode)
                                }
                            }
                        case .failure(let err):
                            print("error \(err)")
                            completion(false , 0 )
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    completion(false , 0 )
                }
        })
    }
    // MARK: - 재직증명서
    
    //MARK: - 재직증명서, 경력증명서 신청 직원 카운트 조회
    /**
     재직증명서, 경력증명서 신청 직원 카운트 조회
     
     - parameter cmpsid:        회사번호
     - returns : 재직증명서 신청직원 카운트 , 경력증명서 신청직원 카운트
     */
    func GetCertmain(cmpsid: Int, completion: @escaping (_ success:Bool , _ empcnt: Int , _ careercnt: Int) ->()) {
        
        let getCertminURL = getAPIURL(api: "ios/m/get_certmain.jsp?CMPSID=\(cmpsid)")
        
        print("\n---------- [ getCertminURL : \(getCertminURL) ] ----------\n")
        AlamofireAppManager?.request(getCertminURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let empCnt = jsonData["emplycnt"] as? Int ,
                            let careerCnt = jsonData["careercnt"] as? Int {
                            
                            completion(true ,  empCnt , careerCnt)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 , 0)
            }
        })
    }
    
    /**
     재직증명서 정보 조회
     - parameter CEYSID : 재직증명서 번호
     - returns: 재직증명서 정보
     */
    func get_CeInfo(CEYSID: Int, completion: @escaping (_ success:Bool , Ce_empInfo?) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/get_ceinfo.jsp?CEYSID=\(CEYSID)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<Ce_empInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                }
            case .failure(let _):
                completion(false , nil)
            }
        })
    }
    
     
    /**
     회사 마스터관리자 + 인사관리자 리스트)..증명서 발급 담당자 설정 .. 페이징 없음
     - parameter cmpsid : 회사번호
     - returns: 회사 마스터관리자 + 인사관리자 리스트
     */
    func getCmp_mghrList(cmpsid: Int, completion: @escaping (_ success:Bool , [CeMgrList]?) ->()) {
        
        let mghrListURL = getAPIURL(api: "ios/m/cmp_mshrlist.jsp?CMPSID=\(cmpsid)")
        
        
        print("\n---------- [ mghrListURL : \(mghrListURL) ] ----------\n")
        AlamofireAppManager?.request(mghrListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]] {
                            let response = Mapper<CeMgrList>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    
    
    /**
     재직증명서 핀플직원 리스트.. 페이징 없음
     - parameter cmpsid : 회사번호
     - returns: 회사 직원 리스트
     */
    func getCe_empList(cmpsid: Int, completion: @escaping (_ success:Bool , [Ce_empListInfo]?) ->()) {
        
        let LcEmplistURL = getAPIURL(api: "ios/m/ce_emplist.jsp?CMPSID=\(cmpsid)")
        
        
        print("\n---------- [ LcEmplistURL : \(LcEmplistURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmplistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]] {
                            let response = Mapper<Ce_empListInfo>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    
    
    /**
     합류직원 재직증명서 입력 및 조회
     - parameter cmpsid : 회사번호
     - parameter isuempsid : 발급자 직원번호
     - parameter empsid : 직원번호
     - returns: 재직증명서 정보
     */
    func getJoinCe(cmpsid: Int, empsid: Int,isuempsid : Int, completion: @escaping (_ success:Bool , Ce_empInfo?) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/get_joince.jsp?CMPSID=\(cmpsid)&EMPSID=\(empsid)&ISUEMPSID=\(isuempsid)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<Ce_empInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                }
            case .failure( _):
                completion(false , nil)
            }
        })
    }
    
    
    /**
     미합류직원 재직증명서 입력 및 조회
     - parameter cmpsid : 회사번호
     - parameter isuempsid : 발급자 직원번호
     - parameter nm : 이름 - Base64 인코딩
     - parameter pn : 핸드폰번호(11) - Base64 인코딩
     - parameter em : 아이디(Email) - Base64 인코딩(E-mail)
     - returns: 재직증명서 정보
     */
    func getNotJoinCe(cmpsid: Int,  isuempsid : Int, nm : String ,pn : String ,em : String , completion: @escaping (_ success:Bool , Ce_empInfo?) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/get_notjoince.jsp?CMPSID=\(cmpsid)&ISUEMPSID=\(isuempsid)&NM=\(nm)&PN=\(pn)&EM=\(em)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<Ce_empInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                }
            case .failure( _):
                completion(false , nil)
            }
        })
    }
    
    /**
     합류직원 경력증명서 입력 및 조회
     - parameter cmpsid : 회사번호
     - parameter isuempsid : 발급자 직원번호
     - parameter empsid : 직원번호
     - returns: 경력증명서 정보
     */
    func getJoinCc(cmpsid: Int, empsid: Int,isuempsid : Int, completion: @escaping (_ success:Bool , Ce_empInfo?) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/get_joincc.jsp?CMPSID=\(cmpsid)&EMPSID=\(empsid)&ISUEMPSID=\(isuempsid)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<Ce_empInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                }
            case .failure( _):
                completion(false , nil)
            }
        })
    }
    
    /**
     미합류직원 경력증명서 입력 및 조회
     - parameter cmpsid : 회사번호
     - parameter isuempsid : 발급자 직원번호
     - parameter nm : 이름 - Base64 인코딩
     - parameter pn : 핸드폰번호(11) - Base64 인코딩
     - parameter em : 아이디(Email) - Base64 인코딩(E-mail)
     - returns: 경력증명서 정보
     */
    func getNotJoinCc(cmpsid: Int,  isuempsid : Int, nm : String ,pn : String ,em : String , completion: @escaping (_ success:Bool , Ce_empInfo?) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/get_notjoincc.jsp?CMPSID=\(cmpsid)&ISUEMPSID=\(isuempsid)&NM=\(nm)&PN=\(pn)&EM=\(em)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<Ce_empInfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                }
            case .failure( _):
                completion(false , nil)
            }
        })
    }
    
    /**
     재직증명서 작성 정보 수정
     - parameter ceysid : 재직증명서 번호
     - parameter spot: 직위.. URL 인코딩
     - parameter dept: 소속.. URL 인코딩
     - parameter bi : 생년월일.. Base64 인코딩
     - parameter pn : 핸드폰번호.. Base64 인코딩
     - parameter addr: 주소.. URL 인코딩 후 Base64 인코딩
     - parameter jdt: 근로시작일(입사일).. URL 인코딩
     - parameter min: 형식(811008-1).. Base64인코딩
     - parameter pur: 용도..URL 인코딩 .. 2021-01-28 추가
      
     - returns :  성공 : 1, 실패 : 0
     */
    func udtCertEmply(CEYSID: Int, SPOT: String,DEPT: String, BI: String,PN: String,ADDR:String , JDT:String ,PUR:String,  completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let udtCertEmplyURL =   getAPIURL(api:"ios/m/udt_certemply.jsp?CEYSID=\(CEYSID)&SPOT=\(SPOT)&DEPT=\(DEPT)&BI=\(BI)&PN=\(PN)&ADDR=\(ADDR)&JDT=\(JDT)&PUR=\(PUR)")
        
        print("\n---------- [ udtCertEmplyURL : \(udtCertEmplyURL) ] ----------\n")
        AlamofireAppManager?.request(udtCertEmplyURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure( _):
                completion(false , 0)
            }
        })
    }
    
    /**
     재직증명서 발급
     - parameter ceysid : 재직증명서 번호
     - parameter isuempsid:  발급자 직원번호
     - parameter isumbrsid: 발급자 회원번호..포인트 사용내역 저장용
     - returns :  미합류직원 SMS 전송 필요 2, 성공 1, 실패 0, 회사직인미설정 -1, 재직증명서 없음 -2, 잔여포인트 부족 -3
     */
    func Ce_Send(CEYSID: Int, ISUEMPSID: Int,ISUMBRSID: Int ,  completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let paymentURL =   getAPIURL(api:"ios/m/ce_send.jsp?CEYSID=\(CEYSID)&ISUEMPSID=\(ISUEMPSID)&ISUMBRSID=\(ISUMBRSID)")
        
        print("\n---------- [ paymentURL : \(paymentURL) ] ----------\n")
        AlamofireAppManager?.request(paymentURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure( _):
                completion(false , 0)
            }
        })
    }
    
    
    /**
     경력증명서 발급
     - parameter ccrsid : 경력증명서 번호
     - parameter isuempsid:  발급자 직원번호
     - parameter isumbrsid: 발급자 회원번호..포인트 사용내역 저장용
     - returns :  미합류직원 SMS 전송 필요 2, 성공 1, 실패 0, 회사직인미설정 -1, 재직증명서 없음 -2, 잔여포인트 부족 -3
     */
    func Cc_Send(CCRSID: Int, ISUEMPSID: Int,ISUMBRSID: Int ,  completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let CcSendtURL =   getAPIURL(api:"ios/m/cc_send.jsp?CCRSID=\(CCRSID)&ISUEMPSID=\(ISUEMPSID)&ISUMBRSID=\(ISUMBRSID)")
        
        print("\n---------- [ CcSendtURL : \(CcSendtURL) ] ----------\n")
        AlamofireAppManager?.request(CcSendtURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure( _):
                completion(false , 0)
            }
        })
    }
    
    
    /**
     증명서 설정 정보 조회 - 증명서발급 담당자, 증명서 삽입로고 조회
     - parameter cmpsid : 회사번호
     - returns: 증명서발급 담당자, 증명서 삽입로고 조회
     */
    func getCerSetinfo(cmpsid: Int, completion: @escaping (_ success:Bool , Ce_certiSetinfo?) ->()) {
        
        let LcEmpInfoURL = getAPIURL(api: "ios/m/get_certsetinfo.jsp?CMPSID=\(cmpsid)")
        
        
        print("\n---------- [ LcEmpInfoURL : \(LcEmpInfoURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmpInfoURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        let resData = Mapper<Ce_certiSetinfo>().map(JSON: jsonData)
                        
                        completion(true , resData)
                    }
                }
            case .failure( _):
                completion(false , nil)
            }
        })
    }
    
    /**
     회사 마스터관리자 + 인사관리자 리스트)..증명서 발급 담당자 설정 .. 페이징 없음
     - parameter cmpsid : 회사번호
     - returns: 회사 마스터관리자 + 인사관리자 리스트
     */
    func get_mghrList(cmpsid: Int, completion: @escaping (_ success:Bool , [CeMgrList]?) ->()) {
        
        let mghrListURL = getAPIURL(api: "ios/m/cmp_mshrlist.jsp?CMPSID=\(cmpsid)")
        
        
        print("\n---------- [ mghrListURL : \(mghrListURL) ] ----------\n")
        AlamofireAppManager?.request(mghrListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]] {
                            let response = Mapper<CeMgrList>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
    
    /**
     증명서 발급 담당자 설정
     - parameter cmpsid : 회사번호
     - parameter empsid:  직원번호
     - parameter isumbrsid: 발급자 회원번호..포인트 사용내역 저장용
     - returns : 성공:1, 실패:0
     */
    func Set_certiUser(CMPSID: Int, EMPSID: Int,   completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let paymentURL =   getAPIURL(api:"ios/m/set_certissuer.jsp?CMPSID=\(CMPSID)&EMPSID=\(EMPSID)")
        
        print("\n---------- [ paymentURL : \(paymentURL) ] ----------\n")
        AlamofireAppManager?.request(paymentURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure( _):
                completion(false , 0)
            }
        })
    }
    
    /**
     증명서 삽입로고 등록
     - parameter cmpsid : 회사번호
     - parameter file : 로고 이미지
     - returns: 성공 : 1 , 실패 0
     */
    
    func uploadLogo(cmpsid: Int,  image: UIImage,  completion: @escaping (_ success:Bool , _ resultCode :Int) ->()) {
        
        var param: [String:Any] = [:]
        let imageData = image.pngData()
        param = [
            "CMPSID" : cmpsid
        ]
        
        let url = getAPIURL(api: "ios/m/upload_certlogo.jsp")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "FILE", fileName: "cmplogo.png", mimeType: "image/png")
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print("uploading \(progress)")
                    
                })
                
                upload.responseJSON { response in
                    if let err = response.error{
                        print("err? \(err.localizedDescription)")
                        completion(false , 0)
                        return
                    }
                    switch response.result {
                    case .success(let data):
                        if let jsonData = data as? [String : Any] {
                            if let resultCode = jsonData["result"] as? Int{
                                completion(true ,  resultCode)
                            }
                        }
                    case .failure(let err):
                        print("error \(err)")
                        completion(false , 0 )
                    }
                }
            case .failure( _):
                //print encodingError.description
                completion(false , 0)
                break
            }
        }
    }
    
    
    /**
     재직증명서 리스트
     - parameter cmpsid : 회사번호
     - parameter curkey : 페이징 키(첫 페이지는 0 또는 안넘김)
     - parameter listcnt : 리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     - returns: 재직증명서 리스트
     */
    func get_CeList(cmpsid: Int,curkey: String,listcnt: Int, completion: @escaping (_ success:Bool , _ nextKey: String , [CeList]?) ->()) {
        
//        let mghrListURL = getAPIURL(api: "ios/m/ce_list.jsp?CMPSID=\(cmpsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)")
        var CeListURL = ""
        if curkey != "" {
            CeListURL = getAPIURL(api: "ios/m/ce_list.jsp?CMPSID=\(cmpsid)&CURKEY=\(curkey.urlEncoding())&LISTCNT=\(listcnt)")
        }else{
            CeListURL = getAPIURL(api: "ios/m/ce_list.jsp?CMPSID=\(cmpsid)&CURKEY=&LISTCNT=\(listcnt)")
        }
        
        
        print("\n---------- [ CeListURL : \(CeListURL) ] ----------\n")
        AlamofireAppManager?.request(CeListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["cert"] as? [[String : Any]] {
                            
                            if let resnextkey = jsonData["nextkey"] as? String {
                                let response = Mapper<CeList>().mapArray(JSONArray: resData)
                                completion(true ,  resnextkey , response)
                            }else{
                                let response = Mapper<CeList>().mapArray(JSONArray: resData)
                                completion(true ,  "" , response)
                            }
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , "", nil)
            }
        })
    }
    
    /**
     검색된 근로계약서 리스트
     - parameter cmpsid : 회사번호
     - parameter name : 검색어(이름) .. URL 인코딩
     - parameter curkey : 페이징 키(첫 페이지는 0 또는 안넘김)
     - parameter listcnt : 리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     - returns: 검색된 근로계약서 리스트
     */
    func searchCe_List(cmpsid: Int,curkey: String,listcnt: Int, name: String,  completion: @escaping (_ success:Bool ,  _ nextkey:String , [CeList]?) ->()) {
       
//        var searchLcListURL = ""
//        if curkey > 0 {
//            searchLcListURL = getAPIURL(api: "ios/m/ce_searchlist.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=\(curkey)&LISTCNT=\(listcnt)")
//        }else{
//            searchLcListURL = getAPIURL(api: "ios/m/ce_searchlist.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=&LISTCNT=\(listcnt)")
//        }
        var searchLcListURL = ""
        if curkey != "" {
            searchLcListURL = getAPIURL(api: "ios/m/ce_searchlist.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=\(curkey.urlEncoding())&LISTCNT=\(listcnt)")
        }else{
            searchLcListURL = getAPIURL(api: "ios/m/ce_searchlist.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=&LISTCNT=\(listcnt)")
        }
        
        print("\n---------- [ searchLcListURL : \(searchLcListURL) ] ----------\n")
        AlamofireAppManager?.request(searchLcListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["cert"] as? [[String : Any]] {
                            if let resnextkey = jsonData["nextkey"] as? String {
                                let response = Mapper<CeList>().mapArray(JSONArray: resData)
                                completion(true ,  resnextkey , response)
                            }else{
                                let response = Mapper<CeList>().mapArray(JSONArray: resData)
                                completion(true ,  "" , response)
                            }
                            
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , "" , nil)
            }
        })
    }
    
    /**
    회사직인 증명서 직인사용 설정
     - parameter cslsid : 직인번호
     - parameter cmpsid : 회사번호
     - returns: 성공 : 1, 실패 : 0
     */
    func Ce_useCmpseal(cmpsid: Int,cslsid: Int, completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let cmpSealURL = getAPIURL(api: "ios/m/udt_cmpsealcertflag.jsp?CMPSID=\(cmpsid)&CSLSID=\(cslsid)")
        
        
        print("\n---------- [ cmpSealURL : \(cmpSealURL) ] ----------\n")
        AlamofireAppManager?.request(cmpSealURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    
    //MARK:  핀플 공지사항 리스트
    /**
     - parameter empsid:        직원번호(본인)
     
     - returns: 핀플 공지사항 리스트
     */
    func getMasterNotice(empsid: Int, completion: @escaping (_ success:Bool , [NoticeListInfo]?) ->()) {
        
        let anualaprListURL = getAPIURL(api: "ios/m/getMasterNotice.jsp?EMPSID=\(empsid)&TYPE=2")
        
        print("\n---------- [ anualaprListURL : \(anualaprListURL) ] ----------\n")
        AlamofireAppManager?.request(anualaprListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                            if let resData = jsonData["noticeList"] as? [[String : Any]] {
                            let resultArr = Mapper<NoticeListInfo>().mapArray(JSONArray: resData)
                            completion(true , resultArr)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    
    //MARK:  사내 공지사항 리스트
    /**
     - parameter empsid:        직원번호(본인)
     
     - returns: 사내 공지사항 리스트
     */
    func getNotice(empsid: Int, completion: @escaping (_ success:Bool , [NoticeListInfo]?) ->()) {
        
        let anualaprListURL = getAPIURL(api: "ios/m/getNotice.jsp?EMPSID=\(empsid)&TYPE=2")
        
        print("\n---------- [ anualaprListURL : \(anualaprListURL) ] ----------\n")
        AlamofireAppManager?.request(anualaprListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                            if let resData = jsonData["noticeList"] as? [[String : Any]] {
                            let resultArr = Mapper<NoticeListInfo>().mapArray(JSONArray: resData)
                            completion(true , resultArr)
                        }
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    
    
    //MARK:  사내 공지사항 상세
    /**
     - parameter sid:       번호
     
     - returns: 사내 공지사항 리스트
     */
    func getNoticeDetailApp(sid: Int, completion: @escaping (_ success:Bool , NoticeListInfo?) ->()) {
        
        let noticeURL = getAPIURL(api: "ios/m/get_notice_info.jsp?SID=\(sid)")
        
        print("\n---------- [ noticeURL : \(noticeURL) ] ----------\n")
        AlamofireAppManager?.request(noticeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        let resData = Mapper<NoticeListInfo>().map(JSON: jsonData)
                        completion(true , resData) 
                    }
                    
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil )
            }
        })
    }
    
    //MARK:  공지사항 수정
    /**
     공지사항 수정
     
     - parameter sid :  게시물 번호
     - parameter title:    제목 - URL 인코딩
     - parameter memo:            내용 - URL 인코딩
     
     - returns : 성공:1, 실패:0
     */
    func UdtNotice(nsid: Int, title: String, memo: String,  completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
//        let udtNoticeURL = getAPIURL(api: "ios/m/edit_notice.jsp?SID=\(nsid)&TT=\(title)&MM=\(memo)")
//
//
//        print("\n---------- [ udtNoticeURL : \(udtNoticeURL) ] ----------\n")
//        AlamofireAppManager?.request(udtNoticeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
//            switch response.result {
//            case .success(let data) :
//                let statusCode = response.response?.statusCode
//                if statusCode == 200 {
//                    //정상
//                    if let jsonData = data as? [String : Any] {
//                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
//                        if let result = jsonData["result"] as? Int {
//                            completion(true ,  result)
//                        }
//                    }
//                }
//            case .failure(let error):
//                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
//                completion(false , 0)
//            }
//        })
        
        
        let url = URL(string: "\(API.baseURL)/ios/m/edit_notice.jsp")
        let config = URLSessionConfiguration.default
        
        let defaultSession = URLSession(configuration: config)
        
        var request = URLRequest(url: url!)
        request.encodeParameters(parameters: [
            "SID" : "\(nsid)",
            "TT" : title,
            "MM" : memo
            ]
        )
        
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                completion(false , 0)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false , 0)
                return
            }
            
            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                completion(true , res.result)
            } catch {
                completion(false , 0)
            }
        }
        dataTask.resume()
    }
    //MARK:  공지사항 삭제
    /**
     공지사항 삭제
     
     - parameter sid :  게시물 번호
     
     - return  : 성공:1, 실패:0,
     */
    func DelNotice(nsid: Int,  completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
        let delNoticeURL = getAPIURL(api: "ios/m/del_notice.jsp?SID=\(nsid)")
        
        print("\n---------- [ delNoticeURL : \(delNoticeURL) ] ----------\n")
        AlamofireAppManager?.request(delNoticeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let result = jsonData["result"] as? Int {
                            completion(true ,  result)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    
    //MARK:  사내공지 new 표시 (메인)
    /**
     사내공지 최신글이 있는지 new 표시
     
     - parameter cmpsid :  회사번호
     
     - return  : 성공:1, 실패:0,
     */
    func checkNewNotice(cmpsid: Int,  completion: @escaping (_ success:Bool , _ result: Int) ->()) {
        
        var checkNewURL = getAPIURL(api: "ios/m/checkPushNew.jsp?CMPSID=\(cmpsid)")
        
        print("\n---------- [ checkNewURL : \(checkNewURL) ] ----------\n")
        AlamofireAppManager?.request(checkNewURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let result = jsonData["result"] as? Int {
                            completion(true ,  result)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0)
            }
        })
    }
    
    // MARK: 공지사항 월 이용 설정
    /**
     공지사항 월 이용 설정
     - parameter cmpsid:        회사번호
     - parameter mbrsid:        회원번호

     - returns: 성공:1, 실패:0, 핀포인트 부족:-1
     */
    func setNoticeMonth(cmpsid: Int, mbrsid: Int,  completion: @escaping (_ success:Bool , _ result:Int , _ hiddendate:String) ->()) {

        let setNoticeURL = getAPIURL(api: "ios/m/set_notice.jsp?CMPSID=\(cmpsid)&MBRSID=\(mbrsid)")

        print("\n---------- [ setNoticeURL : \(setNoticeURL) ] ----------\n")
        AlamofireAppManager?.request(setNoticeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resultCode = jsonData["result"] as? Int ,
                           let resultDate = jsonData["notice"] as? String {
                            completion(true ,  resultCode , resultDate)
                        }
                    }

                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , 0 , "")
            }
        })
    }
    
    //MARK:  공지사항 등록
    /**
     공지사항 등록
      
     - parameter cmpsid :   회사번호
     - parameter empsid:    직원번호
     - parameter type:    1 근로자 , 2 관리자 3 전체
     - parameter memo:            팀메모 - URL 인코딩
     - parameter title:          제목 - URL 인코딩
     
     - returns : 성공:팀번호, 실패:0, 동일팀명 존재:-1
     */
    func RegNotice(cmpsid: Int,empsid: Int, type: Int, memo: String, title: String,name: String, completion: @escaping (_ success: Bool, _ result: Int) ->()) {
         
        let url = URL(string: "\(API.baseURL)/ios/m/reg_notice.jsp")
        let config = URLSessionConfiguration.default
        
        let defaultSession = URLSession(configuration: config)
        
        var request = URLRequest(url: url!)
        request.encodeParameters(parameters: [
            "CMPSID" : "\(cmpsid)",
            "EMPSID" : "\(empsid)",
            "TYPE" : "\(type)",
            "TT" : title,
            "MM" : memo,
            "NM" : name
            ]
        )
        
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                completion(false , 0)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false , 0)
                return
            }
            
            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                completion(true , res.result)
            } catch {
                completion(false , 0)
            }
        }
        dataTask.resume()
    }
    
    // MARK: - 경력증명서
    /**
     경력증명서 핀플직원 리스트.. 페이징 없음
     - parameter cmpsid : 회사번호
     - returns: 회사 직원 리스트
     */
    func getCc_empList(cmpsid: Int, completion: @escaping (_ success:Bool , [Ce_empListInfo]?) ->()) {
        
        let LcEmplistURL = getAPIURL(api: "ios/m/cc_emplist.jsp?CMPSID=\(cmpsid)")
        
        
        print("\n---------- [ LcEmplistURL : \(LcEmplistURL) ] ----------\n")
        AlamofireAppManager?.request(LcEmplistURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["emply"] as? [[String : Any]] {
                            let response = Mapper<Ce_empListInfo>().mapArray(JSONArray: resData)
                            completion(true ,  response)
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , nil)
            }
        })
    }
     
    
    /**
     경력증명서 작성 정보 수정
     - parameter ccrsid : 재직증명서 번호
     - parameter spot: 직위.. URL 인코딩
     - parameter dept: 소속.. URL 인코딩
     - parameter bi : 생년월일.. Base64 인코딩
     - parameter pn : 핸드폰번호.. Base64 인코딩
     - parameter jdt: 근로시작일(입사일).. URL 인코딩
     - parameter min: 형식(811008-1).. Base64인코딩
     - parameter ldt: 퇴직일.. URL 인코딩
     - parameter task: 담당업무..URL 인코딩
     - parameter pur: 용도..URL 인코딩
     - returns :  성공 : 1, 실패 : 0
     */
    func career_udtCertEmply(CCRSID: Int, SPOT: String,DEPT: String, BI: String,PN: String,  JDT:String , LDT:String,TASK:String,PUR:String,  completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let paymentURL =   getAPIURL(api:"ios/m/udt_certcareer.jsp?CCRSID=\(CCRSID)&SPOT=\(SPOT)&DEPT=\(DEPT)&BI=\(BI)&PN=\(PN)&JDT=\(JDT)&LDT=\(LDT)&TASK=\(TASK)&PUR=\(PUR)")
        
        print("\n---------- [ paymentURL : \(paymentURL) ] ----------\n")
        AlamofireAppManager?.request(paymentURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure( _):
                completion(false , 0)
            }
        })
    }
    
    /**
     경력증명서 리스트
     - parameter cmpsid : 회사번호
     - parameter curkey : 페이징 키(첫 페이지는 0 또는 안넘김)
     - parameter listcnt : 리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     - returns: 경력증명서 리스트
     */
    func get_CcList(cmpsid: Int,curkey: String,listcnt: Int, completion: @escaping (_ success:Bool , _ nextKey: String , [CeList]?) ->()) {
        
//        let mghrListURL = getAPIURL(api: "ios/m/cc_list.jsp?CMPSID=\(cmpsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)")
        var CcListURL = ""
        if curkey != "" {
            CcListURL = getAPIURL(api: "ios/m/cc_list.jsp?CMPSID=\(cmpsid)&CURKEY=\(curkey.urlEncoding())&LISTCNT=\(listcnt)")
        }else{
            CcListURL = getAPIURL(api: "ios/m/cc_list.jsp?CMPSID=\(cmpsid)&CURKEY=&LISTCNT=\(listcnt)")
        }
        
        print("\n---------- [ CcListURL : \(CcListURL) ] ----------\n")
        AlamofireAppManager?.request(CcListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        print("\n---------- [ jsonData : \(jsonData) ] ----------\n")
                        if let resData = jsonData["cert"] as? [[String : Any]] {
                            
                            if let resnextkey = jsonData["nextkey"] as? String {
                                let response = Mapper<CeList>().mapArray(JSONArray: resData)
                                completion(true ,  resnextkey , response)
                            }else{
                                let response = Mapper<CeList>().mapArray(JSONArray: resData)
                                completion(true ,  "" , response)
                            }
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , "", nil)
            }
        })
    }
    
    /**
     검색된 경력증명서 리스트
     - parameter cmpsid : 회사번호
     - parameter name : 검색어(이름) .. URL 인코딩
     - parameter curkey : 페이징 키(첫 페이지는 0 또는 안넘김)
     - parameter listcnt : 리스트 카운트(요청시 한번에 몇개씩 가져올 것인지)
     - returns: 검색된 경력증명서 리스트
     */
    func searchCc_List(cmpsid: Int,curkey: String,listcnt: Int, name: String,  completion: @escaping (_ success:Bool ,  _ nextkey:String , [CeList]?) ->()) {
        
        
//        var searchLcListURL = ""
//        if curkey > 0 {
//            searchLcListURL = getAPIURL(api: "ios/m/cc_searchlist.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=\(curkey)&LISTCNT=\(listcnt)")
//        }else{
//            searchLcListURL = getAPIURL(api: "ios/m/cc_searchlist.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=&LISTCNT=\(listcnt)")
//        }
        var searchLcListURL = ""
        if curkey != "" {
            searchLcListURL = getAPIURL(api: "ios/m/cc_searchlist.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=\(curkey.urlEncoding())&LISTCNT=\(listcnt)")
        }else{
            searchLcListURL = getAPIURL(api: "ios/m/cc_searchlist.jsp?CMPSID=\(cmpsid)&NAME=\(name)&CURKEY=&LISTCNT=\(listcnt)")
        }
        
        print("\n---------- [ searchLcListURL : \(searchLcListURL) ] ----------\n")
        AlamofireAppManager?.request(searchLcListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resData = jsonData["cert"] as? [[String : Any]] {
                            if let resnextkey = jsonData["nextkey"] as? String {
                                let response = Mapper<CeList>().mapArray(JSONArray: resData)
                                completion(true ,  resnextkey , response)
                            }else{
                                let response = Mapper<CeList>().mapArray(JSONArray: resData)
                                completion(true ,  "" , response)
                            }
                            
                        }
                    }
                }
            case .failure(let error):
                print("\n---------- [ error : \(error.localizedDescription) ] ----------\n")
                completion(false , "" , nil)
            }
        })
    }
    
    
    /**
     재직증명서 pdf 생성 -이미지서버로 전송
     - parameter CEYSID        계약서번호
     - returns: 성공 1, 실패 0
     */
    
    func ce_pdfsend(CEYSID: String,   completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
        
        let pdfURL = getwebAPIURL(api: "m_ce/send_cePdf.jsp?CEYSID=\(CEYSID)")
        
        
        print("\n---------- [ lcsendURL : \(pdfURL) ] ----------\n")
        AlamofireAppManager?.request(pdfURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    //정상
                    if let jsonData = data as? [String : Any] {
                        if let resultCode = jsonData["result"] as? Int{
                            completion(true ,  resultCode)
                        }
                    }
                }
            case .failure(let _):
                completion(false , 0)
            }
        })
    }
    
    /**
      경력증명서 pdf 생성 -이미지서버로 전송
      - parameter CCRSID        계약서번호
      - returns: 성공 1, 실패 0
      */
     
     func cc_pdfsend(CCRSID: String,   completion: @escaping (_ success:Bool , _ resultCode:Int) ->()) {
         
         let pdfURL = getwebAPIURL(api: "m_ce/send_ccPdf.jsp?CCRSID=\(CCRSID)")
         
         
         print("\n---------- [ lcsendURL : \(pdfURL) ] ----------\n")
         AlamofireAppManager?.request(pdfURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
             switch response.result {
             case .success(let data) :
                 let statusCode = response.response?.statusCode
                 if statusCode == 200 {
                     //정상
                     if let jsonData = data as? [String : Any] {
                         if let resultCode = jsonData["result"] as? Int{
                             completion(true ,  resultCode)
                         }
                     }
                 }
             case .failure(let _):
                 completion(false , 0)
             }
         })
     }
    
    
    //    func upload_labor(lctsid: Int, simage: UIImage, image:UIImage ,  completion: @escaping (_ success:Bool , _ resultCode :Int) ->()) {
    //
    //        var urlStr = ""
    //        var param: [String:Any] = [:]
    //        print("\n---------- [ simageData : \(simage) , imageData:\(image)  ] ----------\n")
    //        let simageData = simage.pngData()
    //        let imageData = image.pngData()
    //
    //        param = [
    //            "LCTSID" : lctsid
    //        ]
    //        urlStr = baseURL + "ios/m/upload_labor.jsp"
    //
    //        guard let url = URL(string: urlStr) else { return }
    //
    //
    //        Alamofire.upload(multipartFormData: { (multipartFormData) in
    //            multipartFormData.append(simageData!, withName: "SFILE", fileName: "seal_file.png", mimeType: "image/png")
    //            multipartFormData.append(imageData!, withName: "FILE", fileName: "noseal_file.png", mimeType: "image/png")
    //            for (key, value) in param {
    //                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
    //            }
    //        }, to: url)
    //        { (result) in
    //            switch result {
    //            case .success(let upload, _, _):
    //
    //                upload.uploadProgress(closure: { (progress) in
    //                    //Print progress
    //                    print("uploading \(progress.fileCompletedCount?.byteSwapped)")
    //
    //                })
    //
    //                upload.responseJSON { response in
    //                    if let err = response.error{
    //                        print("err? \(err.localizedDescription)")
    //                        completion(false , 0 )
    //                        return
    //                    }
    //                    switch response.result {
    //                    case .success(let data):
    //                        if let jsonData = data as? [String : Any] {
    //                            if let resultCode = jsonData["result"] as? Int{
    //                                completion(true ,  resultCode)
    //                            }
    //                        }
    //                    case .failure(let err):
    //                        print("error \(err)")
    //                        completion(false , 0 )
    //                    }
    //                }
    //            case .failure( _):
    //                //print encodingError.description
    //                completion(false , 0 )
    //                break
    //            }
    //        }
    //    }
    
    
    //MARK:  - 이미지 업로드
    /**
     이미지 업로드
     - parameter type = 1: 회원프로필 이미지 , 2:회사로고
     - parameter sid: 회사번호 혹은 회원번호
     - parameter image: 이미지
     
     - returns : 이미지경로
     */
    func Uploadimage(sid: Int, image: UIImage, type:Int , completion: @escaping (_ success:Bool , _ resultCode :Int , _ resultImg: String?) ->()) {
        
        var urlStr = ""
        var param: [String:Any] = [:]
        let imageData = image.jpegData(compressionQuality: 0.50)
        if type == 1 {
            param = ["MBRSID" : sid ]
            urlStr = baseURL + "ios/upload_mbrphoto.jsp"
        }else{
            param = ["CMPSID" : sid ]
            urlStr = baseURL + "ios/m/upload_logo.jsp"
        }
        
        guard let url = URL(string: urlStr) else { return }
        print("\n---------- [ url : \(url) ] ----------\n")
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "FILE", fileName: "swift_file.png", mimeType: "image/png")
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print("uploading \(progress)")
                    
                })
                
                upload.responseJSON { response in
                    if let err = response.error{
                        print("err? \(err.localizedDescription)")
                        completion(false , 0 ,nil)
                        return
                    }
                    switch response.result {
                    case .success(let data):
                        if let jsonData = data as? [String: Any], let resultData = jsonData["result"] as? Int {
                            if resultData == 0 {
                                print("\n---------- [ fail : \(resultData) ] ----------\n")
                                completion(false , resultData,nil)
                                return
                            } else {
                                if type == 1 {
                                    if let resImg = jsonData["photourl"] as? String {
                                        print("\n---------- [ success : \(resultData) , img : \(resImg) ] ----------\n")
                                        completion(true , resultData , resImg)
                                        
                                    }
                                }else{
                                    if let resImg = jsonData["logourl"] as? String {
                                        print("\n---------- [ success : \(resultData) , img : \(resImg) ] ----------\n")
                                        completion(true , resultData , resImg)
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                    case .failure(let err):
                        print("error \(err)")
                        completion(false , 0 ,nil)
                    }
                }
            case .failure( _):
                //print encodingError.description
                completion(false , 0 ,nil)
                break
            }
        }
    }
    
}


extension URLRequest {
    
    private func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    mutating func encodeParameters(parameters: [String : String]) {
        httpMethod = "POST"
        
        let parameterArray = parameters.map { (arg) -> String in
            let (key, value) = arg
            return "\(key)=\(self.percentEscapeString(value))"
        }
        
        httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
}

