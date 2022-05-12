//
//  GoogleMapVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/11/27.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class GoogleMapVC: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet var startLocation: UITextField!
    @IBOutlet var btnLocation: UIButton!
    @IBOutlet var googleMap: GMSMapView!
    
    @IBOutlet weak var btnSave: UIButton!
    var locationManager = CLLocationManager()
    var locationStart = CLLocation()
    var placesClient: GMSPlacesClient!
    
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
        btnSave.layer.cornerRadius = 6
        placesClient = GMSPlacesClient.shared()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        let camera = GMSCameraPosition.camera(withLatitude: lat , longitude: long , zoom:17)
        googleMap.camera = camera
        googleMap.delegate = self
        googleMap.isMyLocationEnabled = true
        googleMap.settings.compassButton = true
        googleMap.settings.zoomGestures = true
        googleMap.settings.myLocationButton = true
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
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
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        
        self.googleMap?.animate(to: camera)
        
        let position = CLLocationCoordinate2DMake(lat,long)
        let marker = GMSMarker(position: position) 
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = self.googleMap
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
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMap.isMyLocationEnabled = true
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        googleMap.isMyLocationEnabled = true
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        googleMap.isMyLocationEnabled = true
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D)
    {
        self.googleMap.clear()
        lat = coordinate.latitude
        long = coordinate.longitude
        ConvertAddress()
        
        let marker = GMSMarker(position: coordinate)
        marker.title = "선택 장소"
        marker.map = googleMap
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        googleMap.clear()
    }
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.open(NSURL(string:"comgooglemaps://?saddr=&daddr=\(marker.position.latitude),\(marker.position.longitude)&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
            
        }
        else {
            
            let alert = UIAlertController(title: "Google Maps not found", message: "Please install Google Maps in your device.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func btnLocation(_ sender: UIButton) {
        let token = GMSAutocompleteSessionToken.init()
        
        // Create a type filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        placesClient?.findAutocompletePredictions(fromQuery: "cheesebu",
                                                  bounds: nil,
                                                  boundsMode: GMSAutocompleteBoundsMode.bias,
                                                  filter: filter,
                                                  sessionToken: token,
                                                  callback: { (results, error) in
                                                    if let error = error {
                                                        print("Autocomplete error: \(error)")
                                                        return
                                                    }
                                                    if let results = results {
                                                        for result in results {
                                                            print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                                                            let placeID = result.placeID
                                                            
                                                            // Specify the place data types to return.
                                                            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                                                                        UInt(GMSPlaceField.placeID.rawValue))!
                                                            
                                                            self.placesClient?.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: {
                                                                (place: GMSPlace?, error: Error?) in
                                                                if let error = error {
                                                                    print("An error occurred: \(error.localizedDescription)")
                                                                    return
                                                                }
                                                                if let place = place {
                                                                    print("The selected place is: \(String(describing: place.name))")
                                                                }
                                                            })
                                                        }
                                                    }
                                                  })
        
        
        
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
