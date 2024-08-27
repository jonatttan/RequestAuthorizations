//
//  ViewController.swift
//  RequestAuthorizations
//
//  Created by Jonattan Sousa on 27/08/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestCameraAccess()
        requestMicrophoneAccess()
    }
    
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { haveAccess in
            if haveAccess {
                debugPrint("We have access to the camara!")
            } else {
                debugPrint("Don't have access to the camera. 🫤")
            }
        }
    }
    
    private func requestMicrophoneAccess() {
        AVAudioSession.sharedInstance().requestRecordPermission { haveAccess in
            if haveAccess {
                debugPrint("We have access to the microphone!")
            } else {
                debugPrint("Don't have access to the microphone. 🫤")
            }
        }
    }
}

