//
//  ViewController.swift
//  RequestAuthorizations
//
//  Created by Jonattan Sousa on 27/08/24.
//

import UIKit
import CoreLocation
import Network

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        requestLocation()
        requestNetwork()
//        requestBluetooth()
    }
    
    
    func requestLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func requestNetwork() {
        LocalNetworkAuthorization().requestAuthorization { success in
            print(success)
        }
    }
}

extension ViewController: NetServiceDelegate {
    public func netServiceDidPublish(_ sender: NetService) {
        print("Allow local network share")
    }
}

extension ViewController {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        var locationStatus = ""
        
        switch status {
        case .authorizedAlways:
            locationStatus = "authorizedAlways"
        case .authorizedWhenInUse:
            locationStatus = "authorizedWhenInUse"
        case .notDetermined:
            locationStatus = "notDetermined"
        case .restricted:
            locationStatus = "restricted"
        case .denied:
            locationStatus = "denied"
        default:
            locationStatus = "Non mapped status"
            break
        }
        print("Location status is: ", locationStatus)
    }
}
