//
//  ViewController.swift
//  RequestAuthorizations
//
//  Created by Jonattan Sousa on 27/08/24.
//

import UIKit
import CoreLocation
import Network
import CoreBluetooth

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    var bluetoothManager: CBCentralManager?
    var bluetoothDiscoveredDevices = [CBPeripheral]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        requestLocation()
        requestNetwork()
        requestBluetooth()
    }
    
    func requestBluetooth() {
        bluetoothManager = CBCentralManager(delegate: self,
                                            queue: .main)
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

extension ViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is available")
            self.bluetoothManager?.scanForPeripherals(withServices: nil,
                                                      options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        case .poweredOff:
            print("Turn on your bluetooth")
        default:
            print("Some error accurred")
        }
    }
    
    // MARK: - Showing bluetooth connected devices
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !bluetoothDiscoveredDevices.contains(peripheral) {
            bluetoothDiscoveredDevices.append(peripheral)
        }
        bluetoothDiscoveredDevices.forEach {
            if let name = $0.name {
             print(name)
            }
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
