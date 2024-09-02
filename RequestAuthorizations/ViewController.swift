//
//  ViewController.swift
//  RequestAuthorizations
//
//  Created by Jonattan Sousa on 27/08/24.
//

import UIKit
import AVKit
import Photos

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
//        verifyAvailability()
        requestCameraAccess()
        requestPhotoLibraryAccess()
    }
    
    // MARK: - Just note, this verify availability of resources
    func verifyAvailability() {
        let cameraAccess = UIImagePickerController.isSourceTypeAvailable(.camera)
        let photoLibraryAccess = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        print("has camera: ", cameraAccess)
        print("has Photo Library: ", photoLibraryAccess)
    }
    
    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { hasAccess in
            print("Has camera access?: ", hasAccess)
        }
    }
    
    func requestPhotoLibraryAccess() {
        var authStatus = ""
        let photoLibrary = PHPhotoLibrary.authorizationStatus()
        if photoLibrary == .notDetermined {
            PHPhotoLibrary.requestAuthorization { authorization in
                switch authorization {
                case .authorized:
                    authStatus = "Authorized"
                case .restricted:
                    authStatus = "Restricted"
                case .limited:
                    authStatus = "Limited"
                default:
                    authStatus = "Denied"
                }
                print("Photo library access is: ", authStatus)
            }
        }
    }
}

//class ImageChoice: NSObject
