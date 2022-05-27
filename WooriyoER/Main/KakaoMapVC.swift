//
//  KakaoMapVC.swift
//  WooriyoER
//
//  Created by seob on 2022/05/27.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit
import CoreLocation

public let DEFAULT_POSITION = MTMapPointGeo(latitude: 37.576568, longitude: 127.029148)


class KakaoMapVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet var startLocation: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet var subView: UIView!
    
    var locationManager = CLLocationManager()
    var locationStart = CLLocation()
     
    var mapViewMain: MTMapView?
    var mapPoint1: MTMapPoint?
    var poiItem1: MTMapPOIItem?
    
    var lat: Double =  0.0
    var long: Double =  0.0
    
    var loclat: String = ""
    var loclong: String = ""
    var locaddr: String = ""
    
    var gpsStatus:Int = 0 // 주소가 변경되면 1 , 아니면 0
    var viewflag = "" // 복수 출퇴근영역 설정때문에 추가 21.02.17 seob
    var cmtareainfo = Addcmtarea()
    
    
    var cmtarea: Int = 0         //출퇴근영역(0.설정안함 1.WiFi 2.Gps 3.Beacon)
    var cmtnoti: Int = 0         //출퇴근 전 알림설정(0.사용하지않음 1.사용함)
    var cmpnm: String = ""
    var acasid : Int = 0
    var wifinm: String = ""         //무선랜 이름
    var wifimac: String = ""        //무선랜 맥주소
    var wifiip: String = ""         //무선랜 IP
    var beacon: String = ""         //비콘 UDID
    var nowmac: String = ""         //접속 무선랜 이름
    var nownm: String = ""          //접속 무선랜 맥주소
    var nowip: String = ""          //접속 무선랜 IP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        btnSave.layer.cornerRadius = 6
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        // 지도 불러오기
        mapViewMain = MTMapView(frame: subView.frame)
        
        if let mapView = mapViewMain {
            mapView.delegate = self
            mapView.baseMapType = .standard
            
            // 지도 중심점, 레벨
            //mapView.setMapCenter(MTMapPoint(geoCoord: DEFAULT_POSITION), zoomLevel: 4, animated: true)
            
            // 현재 위치 트래킹
            mapView.showCurrentLocationMarker = true
            mapView.currentLocationTrackingMode = .onWithoutHeading
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  lat, longitude: long)), zoomLevel: 3, animated: true)
   
            let poiItem: MTMapPOIItem = MTMapPOIItem()
            self.mapPoint1 = MTMapPoint(geoCoord: MTMapPointGeo(latitude:  lat, longitude: long))
            poiItem.markerType = .bluePin
            poiItem.mapPoint = mapPoint1
            poiItem.draggable = true
            mapView.add(poiItem)
//            mapView.addPOIItems([poiItem1]
//            mapView.fitAreaToShowAllPOIItems()
            
            self.view.addSubview(mapView)
        }
    }
    
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "setaddcmtvc" {
            var vc = MoreSB.instantiateViewController(withIdentifier: "SetAddCmtVC") as! SetAddCmtVC
            if SE_flag {
                vc = MoreSB.instantiateViewController(withIdentifier: "SE_SetAddCmtVC") as! SetAddCmtVC
            }else{
                vc = MoreSB.instantiateViewController(withIdentifier: "SetAddCmtVC") as! SetAddCmtVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.cmtareainfo.loclat = self.loclat
            self.cmtareainfo.loclong = self.loclong
            self.cmtareainfo.locaddr = self.locaddr
            self.cmtareainfo.status = 1
            self.cmtareainfo.cmtarea = 2
            vc.cmtareainfo = self.cmtareainfo
            vc.wifiip = self.wifiip
            vc.wifinm = self.wifinm
            vc.wifimac = self.wifimac
            vc.acasid = self.acasid
            vc.cmtnoti = self.cmtnoti
            vc.cmtarea = self.cmtarea
            vc.beacon = self.beacon
            vc.cmpnm = self.cmpnm
            
            
            self.present(vc, animated: false, completion: nil)
        }else if viewflag == "temsetaddcmtvc" {
            var vc = MoreSB.instantiateViewController(withIdentifier: "SetAddTemCmtVC") as! SetAddTemCmtVC
            if SE_flag {
                vc = MoreSB.instantiateViewController(withIdentifier: "SetAddTemCmtVC") as! SetAddTemCmtVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.cmtareainfo.loclat = self.loclat
            self.cmtareainfo.loclong = self.loclong
            self.cmtareainfo.locaddr = self.locaddr
            self.cmtareainfo.status = 1
            self.cmtareainfo.cmtarea = 2
            vc.cmtareainfo = self.cmtareainfo
            vc.wifiip = self.wifiip
            vc.wifinm = self.wifinm
            vc.wifimac = self.wifimac
            vc.acasid = self.acasid
            vc.cmtnoti = self.cmtnoti
            vc.cmtarea = self.cmtarea
            vc.beacon = self.beacon
            vc.cmpnm = self.cmpnm
            
            self.dismiss(animated: true) {
                self.present(vc, animated: true, completion: nil)
            }
        }else{
            var vc = MoreSB.instantiateViewController(withIdentifier: "SetCmtVC") as! SetCmtVC
            if SE_flag {
                vc = MoreSB.instantiateViewController(withIdentifier: "SE_SetCmtVC") as! SetCmtVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            
            vc.gpsStatus = self.gpsStatus
            
            vc.tmpcmtarea = moreCmpInfo.tmpcmtarea
            vc.tmpcmtnoti = moreCmpInfo.cmtnoti
            vc.tmpbeacon = moreCmpInfo.beacon
            vc.tmpwifinm = moreCmpInfo.wifinm
            vc.tmpwifiip = moreCmpInfo.wifiip
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        if(startLocation.text != "") {
            locationManager.stopUpdatingLocation()
//            print("loclat = ", loclat, "loclong = ", loclong)
            print("\n---------- [ viewflag : \(viewflag) ] ----------\n")
            
            if viewflag == "setaddcmtvc" {
                
                var vc = MoreSB.instantiateViewController(withIdentifier: "SetAddCmtVC") as! SetAddCmtVC
                if SE_flag {
                    vc = MoreSB.instantiateViewController(withIdentifier: "SE_SetAddCmtVC") as! SetAddCmtVC
                }else{
                    vc = MoreSB.instantiateViewController(withIdentifier: "SetAddCmtVC") as! SetAddCmtVC
                }
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                
                self.cmtareainfo.loclat = self.loclat
                self.cmtareainfo.loclong = self.loclong
                self.cmtareainfo.locaddr = self.locaddr
                self.cmtareainfo.status = 1
                self.cmtareainfo.cmtarea = 2
                self.cmtareainfo.name = cmpnm
                vc.wifiip = self.wifiip
                vc.wifinm = self.wifinm
                vc.wifimac = self.wifimac
                vc.acasid = self.acasid
                vc.cmtnoti = self.cmtnoti
                vc.cmtarea = self.cmtarea
                vc.beacon = self.beacon
                vc.cmtareainfo = self.cmtareainfo
                cmtareainfo.status = 1
                self.present(vc, animated: false, completion: nil)
            }else if viewflag == "temsetaddcmtvc" {
                
                let vc = MoreSB.instantiateViewController(withIdentifier: "SetAddTemCmtVC") as! SetAddTemCmtVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen

                self.cmtareainfo.loclat = self.loclat
                self.cmtareainfo.loclong = self.loclong
                self.cmtareainfo.locaddr = self.locaddr
                self.cmtareainfo.status = 1
                self.cmtareainfo.cmtarea = 2
                self.cmtareainfo.name = self.cmpnm
                vc.wifiip = self.wifiip
                vc.wifinm = self.wifinm
                vc.wifimac = self.wifimac
                vc.acasid = self.acasid
                vc.cmtnoti = self.cmtnoti
                vc.cmtarea = self.cmtarea
                vc.beacon = self.beacon
                vc.cmtareainfo = self.cmtareainfo
                self.cmtareainfo.status = 1
                self.present(vc, animated: true, completion: nil)
                 
                
            }else{
                moreCmpInfo.loclat = self.loclat
                moreCmpInfo.loclong = self.loclong
                moreCmpInfo.locaddr =  self.locaddr
                moreCmpInfo.cmtarea = 2
                
                let vc = MoreSB.instantiateViewController(withIdentifier: "SetCmtVC") as! SetCmtVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                
                self.gpsStatus = 1
                vc.gpsStatus = self.gpsStatus
                vc.tmpcmtarea = moreCmpInfo.tmpcmtarea
                vc.tmpcmtnoti = moreCmpInfo.cmtnoti
                vc.tmpbeacon = moreCmpInfo.beacon
                vc.tmpwifinm = moreCmpInfo.wifinm
                vc.tmpwifiip = moreCmpInfo.wifiip
                self.present(vc, animated: false, completion: nil)
            }
            
        } else {
            customAlertView("주소가 입력되지 않았습니다.")
        }
    }
}

// MARK:  - MTMapViewDelegate
extension KakaoMapVC : MTMapViewDelegate {
    // Custom: 현 위치 트래킹 함수
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let currentLocation = location?.mapPointGeo()
        if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude{
            
            lat = latitude
            long = longitude
            
            ConvertAddress()
            // 마커 추가
            self.mapPoint1 = MTMapPoint(geoCoord: MTMapPointGeo(latitude:  lat, longitude: long))
            poiItem1 = MTMapPOIItem()
            poiItem1?.markerType = .bluePin
            poiItem1?.mapPoint = mapPoint1
            poiItem1?.draggable = true
            mapViewMain?.add(poiItem1)
            self.locationManager.stopUpdatingLocation()
        }
    }
    func mapView(_ mapView: MTMapView!, longPressOn mapPoint: MTMapPoint!) {
        
        
    }
    
    func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
        print("MTMapView updateDeviceHeading (\(headingAngle)) degrees")
    }
     
}

// MARK: - locationManager
extension KakaoMapVC {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last

        guard let moreLat = Double(moreCmpInfo.loclat) != 0 ?  Double(moreCmpInfo.loclat) : (location?.coordinate.latitude)! else { return }
        guard let moreLong = Double(moreCmpInfo.loclong) != 0 ?  Double(moreCmpInfo.loclong) : (location?.coordinate.longitude)! else { return  }

        lat = moreLat
        long = moreLong

        //          let location = locations.last
        //          lat = (location?.coordinate.latitude)!
        //          long = (location?.coordinate.longitude)!
        print("-----------------[didUpdateLocations lat = \(lat), long = \(long)]----------------------")
        ConvertAddress() 
        self.locationManager.stopUpdatingLocation()
    }

    func ConvertAddress()
    {
        //latitude: 위도, longitude: 경도
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()


        geocoder.reverseGeocodeLocation(findLocation, completionHandler: { (placemarksArray, error) in
            let placemark = placemarksArray?[0]
            let address = "\(placemark?.administrativeArea ?? "") \(placemark?.locality ?? "") \(placemark?.subLocality ?? "") \(placemark?.thoroughfare ?? "") \(placemark?.subThoroughfare ?? "")"
            print("-----------------[ConvertAddress lat = \(self.lat), long = \(self.long), address = \(address)]----------------------")

            self.startLocation.text = address
            self.loclat = String(self.lat)
            self.loclong = String(self.long)
            self.locaddr = address
        })

    }
}
