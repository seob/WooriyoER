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

class TemGoogleMapVC: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
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
        loclat = SelTemInfo.loclat
        loclong = SelTemInfo.loclong
        
        lat = Double(loclat)!
        long = Double(loclong)!
        
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
        self.dismiss(animated: true, completion: nil)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        
        guard let moreLat = Double(SelTemInfo.loclat) != 0 ?  Double(SelTemInfo.loclat) : (location?.coordinate.latitude)! else { return }
        guard let moreLong = Double(SelTemInfo.loclong) != 0 ?  Double(SelTemInfo.loclong) : (location?.coordinate.longitude)! else { return  }
        
        lat = moreLat
        long = moreLong
        
        ConvertAddress()
        
        let camera = GMSCameraPosition.camera(withLatitude: moreLat, longitude: moreLong, zoom: 17.0)
        
        self.googleMap?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    
    func ConvertAddress() {
        //latitude: 위도, longitude: 경도
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(findLocation, completionHandler: { (placemarksArray, error) in
            let placemark = placemarksArray?[0]
            let address = "\(placemark?.administrativeArea ?? "") \(placemark?.locality ?? "") \(placemark?.subLocality ?? "") \(placemark?.thoroughfare ?? "") \(placemark?.subThoroughfare ?? "")"
            print("-----------------[ConvertAddress lat = \(self.lat), long = \(self.long), address = \(address) ,  cmplat :\(SelTemInfo.loclat) cmplong : \(SelTemInfo.loclong) , cmpaddr : \(SelTemInfo.locaddr)]----------------------")
            
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
        
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) { UIApplication.shared.open(NSURL(string:"comgooglemaps://?saddr=&daddr=\(marker.position.latitude),\(marker.position.longitude)&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
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
            if viewflag == "temsetaddcmtvc" {
                SelCmtareainfo.cmtarea = 2
                SelCmtareainfo.loclat = self.loclat
                SelCmtareainfo.loclong = self.loclong
                SelCmtareainfo.locaddr =  self.locaddr
                SelCmtareainfo.name = self.cmpnm
                NotificationCenter.default.post(name: .reloadList, object: nil)
                self.dismiss(animated: true, completion: nil)
            }else{
                SelTemInfo.cmtarea = 2
                SelTemInfo.loclat = self.loclat
                SelTemInfo.loclong = self.loclong
                SelTemInfo.locaddr =  self.locaddr
                
                NotificationCenter.default.post(name: .reloadList, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
 
        }else {
            self.customAlertView("주소가 입력되지 않았습니다.")
        }
    }
    
}

