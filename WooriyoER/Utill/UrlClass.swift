//
//  UrlClass.swift
//  PinPle
//
//  Created by WRY_010 on 13/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//  개발자 : 오대산
//  url 모음
//

import Foundation

class UrlClass{

    var address = API.baseURL.httpTrim()
    var url: String = ""
    
   //MARK: 이메일 로그인 체크
    func check_mbr(email: String, pass: String, mode: Int, osvs: String, appvs: String, md: String) -> String{
        url = "\(API.baseURL)ios/check_mbr.jsp?EMAIL=\(email)&PASS=\(pass)&MODE=\(mode)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)"
        return url
    }
    //회원가입
    func reg_mbr(mode: Int, email:String, pass:String, name:String, phone:String, osvs:String, appvs:String, md:String) -> String{
        url = "\(API.baseURL)ios/reg_mbr.jsp?MODE=\(mode)&EM=\(email)&PW=\(pass)&NM=\(name)&PN=\(phone)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)"
        return url
    }
    //MARK: 구글 로그인 체크
    func check_mbr4google(gid: String, mode: Int, osvs: String, appvs: String, md: String) -> String{
        url = "\(API.baseURL)ios/check_mbr4google.jsp?GID=\(gid)&MODE=\(mode)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)"
        return url
    }
    //구글 회원가입
    func reg_mbr4google(mode: Int, email:String, gid:String, name:String, gender:Int, birth:String, lunar:Int, phone:String, osvs:String, appvs:String, md:String) -> String{
        url = "\(API.baseURL)ios/reg_mbr4google.jsp?MODE=\(mode)&EM=\(email)&GID=\(gid)&NM=\(name)&GD=\(gender)&BI=\(birth)&LN=\(lunar)&PN=\(phone)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)"
        return url
    }
    //MARK: 네이버 로그인 체크
    func check_mbr4naver(nid: String, mode: Int, osvs: String, appvs: String, md: String) -> String{
        url = "\(API.baseURL)ios/check_mbr4naver.jsp?NID=\(nid)&MODE=\(mode)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)"
        return url
    }
    //네이버 회원가입
    func reg_mbr4naver(mode: Int, email:String, nid:String, name:String, gender:Int, birth:String, lunar:Int, phone:String, osvs:String, appvs:String, md:String) -> String{
        url = "\(API.baseURL)ios/reg_mbr4naver.jsp?MODE=\(mode)&EM=\(email)&NID=\(nid)&NM=\(name)&GD=\(gender)&BI=\(birth)&LN=\(lunar)&PN=\(phone)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)"
        return url
    }
    //MARK: 카카오 로그인 체크
    func check_mbr4kakao(kid: String, mode: Int, osvs: String, appvs: String, md: String) -> String{
        url = "\(API.baseURL)ios/check_mbr4kakao.jsp?KID=\(kid)&MODE=\(mode)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)"
        return url
    }
    //MARK: 카카오 회원가입
    func reg_mbr4kakao(mode: Int, email:String, kid:String, name:String, gender:Int, birth:String, lunar:Int, phone:String, osvs:String, appvs:String, md:String) -> String{
        url = "\(API.baseURL)ios/reg_mbr4kakao.jsp?MODE=\(mode)&EM=\(email)&KID=\(kid)&NM=\(name)&GD=\(gender)&BI=\(birth)&LN=\(lunar)&PN=\(phone)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)"
        return url
    }
    
    //MARK: 애플 로그인 체크
    func check_mbr4apple(aid: String, mode: Int, osvs: String, appvs: String, md: String) -> String{
        url = "\(API.baseURL)ios/check_mbr4apple.jsp?AID=\(aid)&MODE=\(mode)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)"
        return url
    }
    //MARK: 애플 회원가입
    func reg_mbr4apple(mode: Int, email:String, aid:String, name:String,  phone:String, osvs:String, appvs:String, md:String) -> String{
        url = "\(API.baseURL)ios/reg_mbr4apple.jsp?MODE=\(mode)&EM=\(email)&AID=\(aid)&NM=\(name)&PN=\(phone)&OSVS=\(osvs)&APPVS=\(appvs)&MD=\(md)"
        return url
    }
    
    //MARK: 이메일 중복 체크
    func check_email(email: String) -> String{
        url = "\(API.baseURL)ios/check_email.jsp?EM=\(email)&MODE=1" // MODE 파라미터 추가
        return url
    }
    //MARK: 회원 푸쉬 토큰 입력
    func set_pushid(mbrsid: Int , mode: Int, pushid: String) -> String{
        url = "\(API.baseURL)ios/set_pushid.jsp?MBRSID=\(mbrsid)&MODE=\(mode)&PUSHID=\(pushid)"
        return url
    }
    //MARK: 이메일 찾기
    func search_email(name: String, phone: String) -> String{
        url = "\(API.baseURL)ios/search_email.jsp?NM=\(name)&PN=\(phone)"
        return url
    }
    //MARK: 비밀번호 찾기
    func search_password(email: String) -> String{
        url = "\(API.baseURL)ios/search_password.jsp?EM=\(email)"
        return url
    }
    //MARK: 회원 추가정보 입력
    func set_mbr_addinfo(mbrsid: Int, gender:Int, birth:String, lunar:Int, enname: String, bcem: String, empnum: String) -> String{
        url = "\(API.baseURL)ios/set_mbr_addinfo.jsp?MBRSID=\(mbrsid)&GD=\(gender)&BI=\(birth)&LN=\(lunar)&ENNM=\(enname)&BCEM=\(bcem)&EMPNUM=\(empnum)"
        return url
    }
    //MARK: 회원정보 조회
    func get_mbr_info(mbrsid: Int) -> String{
        url = "\(API.baseURL)ios/get_mbr_info.jsp?MBRSID=\(mbrsid)"
        return url
    }
    //MARK: 내정보 수정
    func mod_mbr_info(mbrsid: Int, name: String, enname: String, bcem: String, empnum: String, birth: String, lunar: Int, gender: Int,phonenum:String) -> String{
        url = "\(API.baseURL)ios/mod_mbr_info.jsp?MBRSID=\(mbrsid)&NM=\(name)&ENNM=\(enname)&BCEM=\(bcem)&EN=\(empnum)&BI=\(birth)&LN=\(lunar)&GD=\(gender)&PN=\(phonenum)"
        return url
    }
    //MARK: 합류코드 검색
    func get_cmptem_name(code: String) -> String{
        url = "\(API.baseURL)ios/u/get_cmptem_name.jsp?CODE=\(code)"
        return url
    }
    //MARK: 합류
    func join_cmpny(mbrsid: Int, code: String) -> String{
        url = "\(API.baseURL)ios/u/join_cmpny.jsp?MBRSID=\(mbrsid)&CODE=\(code)"
        return url
    }
    //MARK: 회사 등록
    func reg_cmpny(mbrsid: Int, name: String, ename: String) -> String{
        url = "\(API.baseURL)ios/m/reg_cmpny.jsp?MBRSID=\(mbrsid)&NM=\(name)&ENNM=\(ename)"
        return url
    }
    //MARK: 회사 정보 입력
    func set_cmp_addinfo(cmpsid: Int, pn: String, addr: String, site: String) -> String{
        url = "\(API.baseURL)ios/m/set_cmp_addinfo.jsp?CMPSID=\(cmpsid)&PN=\(pn)&ADDR=\(addr)&SITE=\(site)"
        return url
    }
    //MARK: 회사 코드 불러오기
    func get_cmp_joincode(cmpsid: Int) -> String{
        url = "\(API.baseURL)ios/m/get_cmp_joincode.jsp?CMPSID=\(cmpsid)"
        return url
    }
    //MARK: 회사 직원 불러오기
    func join_emplist(cmpsid: Int, curkey: Int, listcnt: Int) -> String{
        url = "\(API.baseURL)ios/m/join_emplist.jsp?CMPSID=\(cmpsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)"
        return url
    }
    //MARK: 직원 권한 설정
    func set_emp_author(empsids: String, auth: Int, temsid: Int, ttmsid: Int) -> String{
        url = "\(API.baseURL)ios/m/set_emp_author.jsp?EMPSIDS=\(empsids)&AUTH=\(auth)&TEMSID=\(temsid)&TTMSID=\(ttmsid)"
        return url
    }
    //MARK: 회사 근무 시간 설정
    func set_cmp_schdl(cmpsid: Int, cmpnm: String, cmtrc: Int, scd: Int, st: String, et: String, bt: Int, wd: String) -> String{
        url = "\(API.baseURL)ios/m/set_cmp_schdl.jsp?CMPSID=\(cmpsid)&CMPNM=\(cmpnm)&CMTRC=\(cmtrc)&SCD=\(scd)&ST=\(st)&ET=\(et)&BT=\(bt)&WD=\(wd)"
        return url
    }
    //MARK: 팀 근무 시간 설정
    func set_tem_schdl(temsid: Int, temnm: String, scd: Int, st: String, et: String, bt: Int, wd: String) -> String{
        url = "\(API.baseURL)ios/m/set_tem_schdl.jsp?TEMSID=\(temsid)&TEMNM=\(temnm)&SCD=\(scd)&ST=\(st)&ET=\(et)&BT=\(bt)&WD=\(wd)"
        return url
    }
    //MARK: 상위팀 근무 시간 설정
    func set_ttm_schdl(ttmsid: Int, ttmnm: String, scd: Int, st: String, et: String, bt: Int, wd: String) -> String{
        url = "\(API.baseURL)ios/m/set_ttm_schdl.jsp?TTMSID=\(ttmsid)&TTMNM=\(ttmnm)&SCD=\(scd)&ST=\(st)&ET=\(et)&BT=\(bt)&WD=\(wd)"
        return url
    }
    //MARK: 팀 생성
    func reg_team(cmpsid: Int, nm: String, mm: String, pn: String) -> String{
        url = "\(API.baseURL)ios/m/reg_team.jsp?CMPSID=\(cmpsid)&NM=\(nm)&MM=\(mm)&PN=\(pn)"
        return url
    }
    //MARK: 상위팀 생성
    func reg_topteam(cmpsid: Int, nm: String, mm: String, pn: String) -> String{
        url = "\(API.baseURL)ios/m/reg_topteam.jsp?CMPSID=\(cmpsid)&NM=\(nm)&MM=\(mm)&PN=\(pn)"
        return url
    }
    //MARK: 상위팀 소속 팀 리스트
    func free_temlist(cmpsid: Int, curkey: Int, listcnt: Int) -> String{
        url = "\(API.baseURL)ios/m/free_temlist.jsp?CMPSID=\(cmpsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)"
        return url
    }
    //MARK: 상위팀 소속 팀 추가
    func add_team(temsids: String, ttmsid: Int) -> String{
        url = "\(API.baseURL)ios/m/add_team.jsp?TEMSIDS=\(temsids)&TTMSID=\(ttmsid)"
        return url
    }
    //MARK: 회사 리스트 불러오기
    func cmp_ttmlist(cmpsid: Int) -> String{
        url = "\(API.baseURL)ios/m/cmp_ttmlist.jsp?CMPSID=\(cmpsid)"
        return url
    }
    //MARK: 출퇴근인원 제외 설정
    func set_emp_notrc(empsid: Int, notrc: Int) -> String{
        url = "\(API.baseURL)ios/m/set_emp_notrc.jsp?EMPSID=\(empsid)&NOTRC=\(notrc)"
        return url
    }
    //MARK: 출퇴근 알림설정
    func set_cmp_cmtnoti(cmpsid: Int, cmtnoti: Int) -> String{
        url = "\(API.baseURL)ios/m/set_cmp_cmtnoti.jsp?CMPSID=\(cmpsid)&CMTNOTI=\(cmtnoti)"
        return url
    }
    //MARK: 회사 연차 설정
    func set_cmp_anualddctn(cmpsid: Int, ad1: Int, ad2: Int, ad3: Int) -> String{
        url = "\(API.baseURL)ios/m/set_cmp_anualddctn.jsp?CMPSID=\(cmpsid)&AD1=\(ad1)&AD2=\(ad2)&AD3=\(ad3)"
        return url
    }
    //MARK: 합류코드 리스트
    func cmp_joincodelist(cmpsid: Int) -> String{
        url = "\(API.baseURL)ios/m/cmp_joincodelist.jsp?CMPSID=\(cmpsid)"
        return url
    }
    //MARK: 합류코드 변경
    func udt_joincode(codesid: Int) -> String{
        url = "\(API.baseURL)ios/m/udt_joincode.jsp?CODESID=\(codesid)"
        return url
    }
    //MARK: 상위팀 코드 불러오기
    func get_ttm_joincode(ttmsid: Int) -> String{
        url = "\(API.baseURL)ios/m/get_ttm_joincode.jsp?TTMSID=\(ttmsid)"
        return url
    }
    //MARK: 팀 코드 불러오기
    func get_tem_joincode(temsid: Int) -> String{
        url = "\(API.baseURL)ios/m/get_tem_joincode.jsp?TEMSID=\(temsid)"
        return url
    }
    //MARK: 무소속 직원리스트
    func free_emplist(cmpsid: Int) -> String{
        url = "\(API.baseURL)ios/m/free_emplist.jsp?CMPSID=\(cmpsid)"
        return url
    }
    //MARK: 팀원 추가
    func tem_addemply(temsid: Int, empsids: String) -> String{
        url = "\(API.baseURL)ios/m/tem_addemply.jsp?TEMSID=\(temsid)&EMPSIDS=\(empsids)"
        return url
    }
    //MARK: 상위팀원 추가
    func ttm_addemply(ttmsid: Int, empsids: String) -> String{
        url = "\(API.baseURL)ios/m/ttm_addemply.jsp?TTMSID=\(ttmsid)&EMPSIDS=\(empsids)"
        return url
    }
    //MARK: 상위팀 관리자 리스트
    func ttm_mgrlist(ttmsid: Int) -> String{
        url = "\(API.baseURL)ios/m/ttm_mgrlist.jsp?TTMSID=\(ttmsid)"
        return url
    }
    //MARK: 팀 관리자 리스트
    func tem_mgrlist(temsid: Int) -> String{
        url = "http://\(address)/ios/m/tem_mgrlist.jsp?TEMSID=\(temsid)"
        return url
    }
    //MARK: 직원 권한설정
    func set_emp_author(temsid: Int) -> String{
        url = "\(API.baseURL)ios/m/set_emp_author.jsp?TEMSID=\(temsid)"
        return url
    }
    //MARK: 상위팀원 리스트 - 관리자제외
    func ttm_emplist(ttmsid: Int) -> String{
        url = "\(API.baseURL)ios/m/ttm_emplist.jsp?TTMSID=\(ttmsid)"
        return url
    }
    //MARK: 팀원 리스트 - 관리자제외
    func tem_emplist(temsid: Int) -> String{
        url = "\(API.baseURL)ios/m/tem_emplist.jsp?TEMSID=\(temsid)"
        return url
    }
    //MARK: 상위팀 연차제한 설정
    func set_ttm_anuallimit(ttmsid: Int, limit: Int) -> String{
        url = "\(API.baseURL)ios/m/set_ttm_anuallimit.jsp?TTMSID=\(ttmsid)&LIMIT=\(limit)"
        return url
    }
    //MARK: 팀 연차제한 설정
    func set_tem_anuallimit(temsid: Int, limit: Int) -> String{
        url = "\(API.baseURL)ios/m/set_tem_anuallimit.jsp?TEMSID=\(temsid)&LIMIT=\(limit)"
        return url
    }
    //MARK: 연차결재라인 조회 - 회사, 상위팀, 팀 같이 이용
    func get_anualaprline(cmpsid: Int, ttmsid: Int, temsid: Int) -> String{
        url = "\(API.baseURL)ios/m/get_anualaprline.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)"
        return url
    }
    //MARK: 근로신청 결재라인 조회 - 회사, 상위팀, 팀 같이 이용
    func get_applyaprline(cmpsid: Int, ttmsid: Int, temsid: Int) -> String{
        url = "\(API.baseURL)ios/m/get_applyaprline.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)"
        return url
    }
    //MARK: 상위팀, 팀 연차결재라인 회사설정으로 적용/미적용 처리
    func set_cmp_anualaprline(ttmsid: Int, temsid: Int, apr: Int) -> String{
        url = "\(API.baseURL)ios/m/set_cmp_anualaprline.jsp?TTMSID=\(ttmsid)&TEMSID=\(temsid)&APR=\(apr)"
        return url
    }
    //MARK: 상위팀, 팀 신청결재라인 회사설정으로 적용/미적용 처리
    func set_cmp_applyaprline(ttmsid: Int, temsid: Int, apr: Int) -> String{
        url = "\(API.baseURL)ios/m/set_cmp_applyaprline.jsp?TTMSID=\(ttmsid)&TEMSID=\(temsid)&APR=\(apr)"
        return url
    }
    //MARK: 회사전채 관리자리스트 - 대표포함
    func cmp_mgrlist(cmpsid: Int) -> String{
        url = "\(API.baseURL)ios/m/cmp_mgrlist.jsp?CMPSID=\(cmpsid)"
        return url
    }
    //MARK: 연차결재라인 설정 - 회사, 상위팀, 팀 모두 같이 이용
    func set_anualaprline(cmpsid: Int, ttmsid: Int, temsid: Int, apr1: Int, apr2:Int, apr3:Int, ref1: Int, ref2: Int) -> String{
        url = "\(API.baseURL)ios/m/set_anualaprline.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)&APR1=\(apr1)&APR2=\(apr2)&APR3=\(apr3)&REF1=\(ref1)&REF2=\(ref2)"
        return url
    }
    //MARK: 신청결재라인 설정 - 회사, 상위팀, 팀 모두 같이 이용
    func set_applyaprline(cmpsid: Int, ttmsid: Int, temsid: Int, apr1: Int, apr2:Int, apr3:Int, ref1: Int, ref2: Int) -> String{
        url = "\(API.baseURL)ios/m/set_applyaprline.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)&APR1=\(apr1)&APR2=\(apr2)&APR3=\(apr3)&REF1=\(ref1)&REF2=\(ref2)"
        return url
    }
    //MARK: 회사 특별휴무일 리스트
    func cmp_holidaylist(cmpsid: Int) -> String{
        url = "\(API.baseURL)ios/m/cmp_holidaylist.jsp?CMPSID=\(cmpsid)"
        return url
    }
    //MARK: 회사 특별휴무일 유무 설정
    func set_cmp_holidayset(cmpsid: Int, holiday: Int) -> String{
        url = "\(API.baseURL)ios/m/set_cmp_holidayset.jsp?CMPSID=\(cmpsid)&HOLIDAY=\(holiday)"
        return url
    }
    //MARK: 회사 특별휴무일 설정
    func set_cmp_holiday(cmpsid: Int, dt: String, nm: String, rpt: Int) -> String{
        url = "\(API.baseURL)ios/m/set_cmp_holiday.jsp?CMPSID=\(cmpsid)&DT=\(dt)&NM=\(nm)&RPT=\(rpt)"
        return url
    }
    //MARK: 회사 특별휴무일 변경
    func udt_cmp_holiday(cmpsid: Int, hldsid:Int, dt: String, nm: String, rpt: Int) -> String{
        url = "\(API.baseURL)ios/m/udt_cmp_holiday.jsp?CMPSID=\(cmpsid)&HLDSID=\(hldsid)&DT=\(dt)&NM=\(nm)&RPT=\(rpt)"
        return url
    }
    //MARK: 회사 특별휴무일 삭제
    func del_cmp_holiday(cmpsid: Int, hldsid: Int) -> String{
        url = "\(API.baseURL)ios/m/del_cmp_holiday.jsp?CMPSID=\(cmpsid)&HLDSID=\(hldsid)"
        return url
    }
    //MARK: 연차촉진 관리직원 리스트 - 회사, 상위팀, 팀 같이 이용
    func anual_adviselist(cmpsid: Int, ttmsid: Int, temsid: Int) -> String{
        url = "\(API.baseURL)ios/m/anual_adviselist.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)"
        return url
    }
    //MARK: 회사 팀리스트-상위팀그룹-소속팀포함
    func cmp_ttnamelist(cmpsid: Int) -> String{
        url = "\(API.baseURL)ios/m/cmp_ttnamelist.jsp?CMPSID=\(cmpsid)"
        return url
    }
    //MARK: 팀, 상위팀-직속 출근직원 리스트x
    func cmton_emplist(cmpsid: Int, ttmsid: Int, temsid: Int) -> String{
        url = "\(API.baseURL)ios/m/cmton_emplist.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)"
        return url
    }
    //MARK: 팀, 상위팀-직속 미출근직원 리스트
    func cmtoff_emplist(cmpsid: Int, ttmsid: Int, temsid: Int) -> String{
        url = "\(API.baseURL)ios/m/cmtoff_emplist.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)"
        return url
    }
    //MARK: 직원 월별 출퇴근기록 + 연차정보(남은연차, 입사일자)
    func emp_cmtlist(empsid: Int, dt: String) -> String{
        url = "\(API.baseURL)ios/m/emp_cmtlist.jsp?EMPSID=\(empsid)&DT=\(dt)"
        return url
    }
    //MARK: 직원 월별 출퇴근기록 + 연차정보(남은연차, 입사일자)
    func udt_empinfo(empsid: Int, spot: String, pn: String, mm: String, jndt: String, use: Int, add: Int) -> String{
        url = "\(API.baseURL)ios/m/udt_empinfo.jsp?EMPSID=\(empsid)&SPOT=\(spot)&PN=\(pn)&MM=\(mm)&JNDT=\(jndt)&USE=\(use)&ADD=\(add)"
        return url
    }
    //MARK: 상위팀 팀원해지-제외
    func ttm_exceptemply(ttmsid: Int, empsid: Int, ttmnm: String) -> String{
        url = "\(API.baseURL)ios/m/ttm_exceptemply.jsp?TTMSID=\(ttmsid)&EMPSID=\(empsid)&TTMNM=\(ttmnm)"
        return url
    }
    //MARK: 팀 팀원해지-제외
    func tem_exceptemply(temsid: Int, empsid: Int, temnm: String) -> String{
        url = "\(API.baseURL)ios/m/tem_exceptemply.jsp?TEMSID=\(temsid)&EMPSID=\(empsid)&TEMNM=\(temnm)"
        return url
    }
    //MARK: 관리자가 직원 근무기록 직접 입력 - 정상근무로 등록됨
    func ins_cmtmgr(empsid: Int, sdt: String, edt: String) -> String{
        url = "\(API.baseURL)ios/m/ins_cmtmgr.jsp?EMPSID=\(empsid)&SDT=\(sdt)&EDT=\(edt)"
        return url
    }
    //MARK: 관리자가 직원 근무기록 직접 수정
    func udt_cmtmgr(cmtsid: Int, empsid: Int, sdt: String, edt: String) -> String{
        url = "\(API.baseURL)ios/m/udt_cmtmgr.jsp?CMTSID=\(cmtsid)&EMPSID=\(empsid)&SDT=\(sdt)&EDT=\(edt)"
        return url
    }
    //MARK: 연차신청 결재,참조 리스트
    func anualapr_list(empsid: Int, curkey: Int, listcnt: Int) -> String{
        url = "\(API.baseURL)ios/m/anualapr_list.jsp?EMPSID=\(empsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)"
        return url
    }
    //MARK: 연차신청 참조 확인 처리
    func read_anualapr(aprsid: Int, empsid: Int) -> String{
        url = "\(API.baseURL)ios/m/read_anualapr.jsp?APRSID=\(aprsid)&EMPSID=\(empsid)"
        return url
    }
    //MARK: 연차 결재현황 조회
    func get_anualaprline_status(aprsid: Int, empsid: Int) -> String{
        url = "\(API.baseURL)ios/m/get_anualaprline_status.jsp?APRSID=\(aprsid)&EMPSID=\(empsid)"
        return url
    }
    //MARK: 연차결재처리 - 보류, 승인, 반려
    func proc_anualapr(aprsid: Int, empsid: Int, step: Int, ddctn: Int, apr: Int, reason: String, next: Int) -> String{
        url = "\(API.baseURL)ios/m/proc_anualapr.jsp?APRSID=\(aprsid)&EMPSID=\(empsid)&STEP=\(step)&DDCTN=\(ddctn)&APR=\(apr)&REASON=\(reason)&NEXT=\(next)"
        return url
    }
    //MARK: 근로신청 결재,참조 리스트
    func applyapr_list(empsid: Int, curkey: Int, listcnt: Int) -> String{
        url = "\(API.baseURL)ios/m/applyapr_list.jsp?EMPSID=\(empsid)&CURKEY=\(curkey)&LISTCNT=\(listcnt)"
        return url
    }
    //MARK: 근로신청 참조 확인 처리
    func read_applyapr(aprsid: Int, empsid: Int) -> String{
        url = "\(API.baseURL)ios/m/read_applyapr.jsp?APRSID=\(aprsid)&EMPSID=\(empsid)"
        return url
    }
    //MARK: 근로신청 결재현황 조회
    func get_applyaprline_status(aprsid: Int, empsid: Int) -> String{
        url = "\(API.baseURL)ios/m/get_applyaprline_status.jsp?APRSID=\(aprsid)&EMPSID=\(empsid)"
        return url
    }
    //MARK: 근로결재처리 - 보류, 승인, 반려
    func proc_applyapr(aprsid: Int, empsid: Int, step: Int, apr: Int, reason: String, next: Int) -> String{
        url = "\(API.baseURL)ios/m/proc_applyapr.jsp?APRSID=\(aprsid)&EMPSID=\(empsid)&STEP=\(step)&APR=\(apr)&REASON=\(reason)&NEXT=\(next)"
        return url
    }
    //MARK: 관리자앱 - 메인정보
    func get_main(empsid: Int, auth: Int, cmpsid: Int, ttmsid: Int, temsid: Int) -> String{
        url = "\(API.baseURL)ios/m/get_main.jsp?EMPSID=\(empsid)&AUTH=\(auth)&CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)"
        return url
    }
    //MARK: 회사정보
    func get_cmp_info(cmpsid: Int) -> String{
        url = "\(API.baseURL)ios/m/get_cmp_info.jsp?CMPSID=\(cmpsid)"
        return url
    }
    //MARK: 회사 주52시간제 설정
    func set_cmp_wk52h(cmpsid: Int, wk52h: Int) -> String{
        url = "\(API.baseURL)ios/m/set_cmp_wk52h.jsp?CMPSID=\(cmpsid)&WK52H=\(wk52h)"
        return url
    }
    //MARK: 권한별 감독이 필요한 근로자 리스트
    func warning_emplist(wk52h: Int, cmpsid: Int, ttmsid: Int, temsid: Int) -> String{
        url = "\(API.baseURL)ios/m/warning_emplist.jsp?WK52H=\(wk52h)&CMPSID=\(cmpsid)&TTMSID=\(ttmsid)&TEMSID=\(temsid)"
        return url
    }
    //MARK: 직원 주간, 월간 근로시간 리스트
    func emp_workminlist(wk52h: Int, empsid: Int) -> String{
        url = "\(API.baseURL)ios/m/emp_workminlist.jsp?WK52H=\(wk52h)&EMPSID=\(empsid)"
        return url
    }
    //MARK: 회사 최고관리자 리스트 - 본인제외
    func cmp_smgrlist(cmpsid: Int, empsid: Int) -> String{
        url = "\(API.baseURL)ios/m/cmp_smgrlist.jsp?CMPSID=\(cmpsid)&EMPSID=\(empsid)"
        return url
    }
    //MARK: 회사 일반직원 리스트 - 관리자 제외
    func cmp_emplist(cmpsid: Int) -> String{
        url = "\(API.baseURL)ios/m/cmp_emplist.jsp?CMPSID=\(cmpsid)"
        return url
    }
    //MARK: 관리자가 직원 근무기록 직접 삭제
    func del_cmtmgr(cmtsid: Int, empsid: Int) -> String{
        url = "\(API.baseURL)ios/m/del_cmtmgr.jsp?CMTSID=\(cmtsid)&EMPSID=\(empsid)"
        return url
    }
    //MARK: 회사 출퇴근영역 설정
    func set_cmp_cmtarea(cmpsid: Int, cmpnm: String, area: Int, wnm: String, wmac: String, wip: String, bcon: String, lat: String, long: String, addr: String) -> String{
        url = "\(API.baseURL)ios/m/set_cmp_cmtarea.jsp?CMPSID=\(cmpsid)&CMPNM=\(cmpnm)&AREA=\(area)&WNM=\(wnm)&WMAC=\(wmac)&WIP=\(wip)&BCON=\(bcon)&LAT=\(lat)&LONG=\(long)&ADDR=\(addr)"
        return url
    }
    //MARK: 팀원 전체 리스트 - 관리자포함
    func tem_emp_alllist(cmpsid: Int, temsid: Int) -> String{
        url = "\(API.baseURL)ios/m/tem_emp_alllist.jsp?CMPSID=\(cmpsid)&TEMSID=\(temsid)"
        return url
    }
    //MARK: 상위팀원 전체 리스트 - 관리자포함
    func ttm_emp_alllist(cmpsid: Int, ttmsid: Int) -> String{
        url = "\(API.baseURL)ios/m/ttm_emp_alllist.jsp?CMPSID=\(cmpsid)&TTMSID=\(ttmsid)"
        return url
    }
    //MARK: 직원 정보
    func get_emp_info(empsid: Int) -> String{
        url = "\(API.baseURL)ios/m/get_emp_info.jsp?EMPSID=\(empsid)"
        return url
    }
    //MARK: 팀 출퇴근영역 설정
    func set_tem_cmtarea(temsid: Int, temnm: String, area: Int, wnm: String, wmac: String, wip: String, bcon: String, lat: String, long: String, addr: String) -> String{
        url = "\(API.baseURL)ios/m/set_tem_cmtarea.jsp?TEMSID=\(temsid)&TEMNM=\(temnm)&AREA=\(area)&WNM=\(wnm)&WMAC=\(wmac)&WIP=\(wip)&BCON=\(bcon)&LAT=\(lat)&LONG=\(long)&ADDR=\(addr)"
        return url
    }
    //MARK: 상위팀 출퇴근영역 설정
    func set_ttm_cmtarea(ttmsid: Int, ttmnm: String, area: Int, wnm: String, wmac: String, wip: String, bcon: String, lat: String, long: String, addr: String) -> String{
        url = "\(API.baseURL)ios/m/set_ttm_cmtarea.jsp?TTMSID=\(ttmsid)&TTMNM=\(ttmnm)&AREA=\(area)&WNM=\(wnm)&WMAC=\(wmac)&WIP=\(wip)&BCON=\(bcon)&LAT=\(lat)&LONG=\(long)&ADDR=\(addr)"
        return url
    }
    //MARK: 상위팀 정보
    func get_ttm_info(ttmsid: Int) -> String{
        url = "\(API.baseURL)ios/m/get_ttm_info.jsp?TTMSID=\(ttmsid)"
        return url
    }
    //MARK: 팀 정보
    func get_tem_info(temsid: Int) -> String{
        url = "\(API.baseURL)ios/m/get_tem_info.jsp?TEMSID=\(temsid)"
        return url
    }
    //MARK: 팀 삭제
    func del_team(temsid: Int) -> String{
        url = "\(API.baseURL)ios/m/del_team.jsp?TEMSID=\(temsid)"
        return url
    }
    //MARK: 상위팀 삭제
    func del_topteam(ttmsid: Int) -> String{
        url = "\(API.baseURL)ios/m/del_topteam.jsp?TTMSID=\(ttmsid)"
        return url
    }
    //MARK: 회사 정보 수정
    func udt_cmpinfo(cmpsid: Int, name: String, enname: String, phone: String, addr: String, site: String) -> String{
        url = "\(API.baseURL)ios/m/udt_cmpinfo.jsp?CMPSID=\(cmpsid)&NM=\(name)&ENNM=\(enname)&PN=\(phone)&ADDR=\(addr)&SITE=\(site)"
        return url
    }
    //MARK: 관리자앱 푸시수신 설정 조회
    func get_mbrpush_mgr(mbrsid: Int) -> String{
        url = "\(API.baseURL)ios/m/get_mbrpush_mgr.jsp?MBRSID=\(mbrsid)"
        return url
    }
    //MARK: 관리자 푸시알림 수신 설정
    func set_mbrpush_mgr(mbrsid: Int, cmtmgr: Int, aprmgr: Int, empmgr: Int) -> String{
        url = "\(API.baseURL)ios/m/set_mbrpush_mgr.jsp?MBRSID=\(mbrsid)&CMT=\(cmtmgr)&APR=\(aprmgr)&EMP=\(empmgr)"
        return url
    }
    //MARK: 퇴직처리를 위한 근로기간, 미사용연차 조회
    func get_leaveinfo(empsid: Int, leavedt: String) -> String{
        url = "\(API.baseURL)ios/m/get_leaveinfo.jsp?EMPSID=\(empsid)&LEAVEDT=\(leavedt)"
        return url
    }
    //MARK: 직원 퇴직처리
    func leave_emply(empsid: Int, leavedt: String, sk: String) -> String{
        url = "\(API.baseURL)ios/m/leave_emply.jsp?EMPSID=\(empsid)&LEAVEDT=\(leavedt)&SK=\(sk)"
        return url
    }
    //MARK: 직원 퇴직처리
    func secede_mbr(mbrsid: Int, sk: String) -> String{
        url = "\(API.baseURL)ios/secede_mbr.jsp?MBRSID=\(mbrsid)&SK=\(sk)"
        return url
    }
    //MARK: 직원 메시지 전송 - 연차촉진메시지, 주52시간경고메시지
    func send_empmsg(type: Int, sndsid: Int, sndnm: String, rcvsid: Int, msg: String) -> String{
        url = "\(API.baseURL)ios/m/send_empmsg.jsp?TYPE=\(type)&SNDSID=\(sndsid)&SNDNM=\(sndnm)&RCVSID=\(rcvsid)&MSG=\(msg)"
        return url
    }
    //MARK: 입사일기준 연차계산 - 분단위 환산
    func get_anualmin(joindt: String) -> String{
        url = "\(API.baseURL)ios/u/get_anualmin.jsp?JOINDT=\(joindt)"
        return url
    }
    //MARK: 직원 추가정보 입력
    func set_emp_addinfo(empsid: Int, spot: String, joindt: String, usemin: Int, addmin: Int) -> String{
        url = "\(API.baseURL)ios/u/set_emp_addinfo.jsp?EMPSID=\(empsid)&SPOT=\(spot)&JNDT=\(joindt)&USE=\(usemin)&ADD=\(addmin)"
        return url
    }
    //MARK: - 회사 최고관리자 리스트
    func cmp_supermgrlist(cmpsid: Int) -> String{
        url = "\(API.baseURL)ios/m/cmp_supermgrlist.jsp?CMPSID=\(cmpsid)"
        return url
    }
}
