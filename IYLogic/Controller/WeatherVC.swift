//
//  WeatherVC.swift
//  IYLogic
//
//  Created by RMS on 2019/10/8.
//  Copyright © 2019 IYLogic. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherVC: BaseViewController {

    @IBOutlet weak var ui_lblTemp: UILabel!
    @IBOutlet weak var ui_lblAddr: UILabel!
    @IBOutlet weak var ui_lblDate: UILabel!
    @IBOutlet weak var ui_tableView: UITableView!
    @IBOutlet weak var ui_txtNotification: UITextView!
    
    var dataWeater = [WeatherModel]()
    var locationManager: CLLocationManager!
    var addressString : String = ""
    
    let geocoder = CLGeocoder()
    
    var locality = ""
    var administrativeArea = ""
    var country = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        
        //let locValue : CLLocationCoordinate2D = locationManager.location!.coordinate
        //getAddressFromLatLon(lat: locValue.latitude, lon: locValue.longitude)
        
        self.weatherData()
        self.ui_tableView.rowHeight = 30.0
        
    }
    
    func weatherData() {
        var today = Date()
        
        ui_lblDate.text = getStringFormDate(date: today, format: "EEEE, MMM dd, yyyy")
        for _ in 0 ..< 7 {
            
            today = Date(timeInterval: 24 * 60 * 60, since: today)
            
            let date = getStringFormDate(date: today, format: "MMM dd, yyyy")
            let strVal = "8 ~ 13" + "°C Fine"
            
            let one = WeatherModel(strDate: date, strVal: strVal)
            dataWeater.append(one)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    
    
    @IBAction func onTapedMenu(_ sender: Any) {
        panel?.openLeft(animated: true)
    }
    
    @IBAction func onTapedMain(_ sender: Any) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
        let centerNavVC = UINavigationController(rootViewController: centerVC)
        
        _ = panel!.center(centerNavVC)
        
        self.navigationController?.popViewController(animated: false)
    }

}

extension WeatherVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: AnyClass) {
        let locValue : CLLocationCoordinate2D = locationManager.location!.coordinate
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        locationManager.stopUpdatingLocation()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("Error in reverseGeocode")
            }
            
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                
                self.locality = placemark.locality!
                self.administrativeArea = placemark.administrativeArea!
                self.country = placemark.country!
                
                self.ui_lblAddr.text = self.locality + ", " + self.country
            }
        })
    }
    
    func userLocationString() -> String {
        let userLocationString = "\(locality), \(administrativeArea), \(country)"
        return userLocationString
    }
    
    func getAddressFromLatLon(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    self.addressString = ""
                    self.addressString = pm.subLocality! +  ", " + pm.country!
                    
                    //self.ui_lblAddr.text = self.addressString
                    /*
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
//
 */
                    
                }
        })
        
    }
    
}

extension WeatherVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath as IndexPath) as! weatherCell
        
        cell.ui_lblDate.text = dataWeater[indexPath.row].strDate
        cell.ui_lblVal.text = dataWeater[indexPath.row].strVal
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return dataWeater.count
        return 7
    }
    
    func numberOfSectionsInTableView(tableView:UITableView!) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

class weatherCell: UITableViewCell {
    
    @IBOutlet var ui_lblDate : UILabel!
    @IBOutlet var ui_lblVal : UILabel!
    
}

class WeatherModel {
    
    var strDate = ""
    var strVal = ""
    
    init(strDate: String, strVal: String) {
        
        self.strDate = strDate
        self.strVal = strVal
    }
}
