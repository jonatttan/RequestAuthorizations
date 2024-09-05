//
//  ViewController.swift
//  RequestAuthorizations
//
//  Created by Jonattan Sousa on 27/08/24.
//

import UIKit
import EventKit
import Contacts
import LocalAuthentication

class ViewController: UIViewController {
    let center = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        manageNotificationAccess()
        calendarRequestAndVerifyFulllAccess()
        contactsRequestAndVerifyAccess()
        faceIdRequestAccess { biometryPermissionStatus in
            print("Has biometry access: ", biometryPermissionStatus)
        }
    }
    
    // MARK: - FaceID/ Any Biometry
    func faceIdRequestAccess(completion: @escaping(Bool) -> Void ) {
        let kBiometryKey = "app_biometry"
        
        // MARK: - Verify biometry method availability
        let laContext = LAContext()
        var error: NSError?
        
        guard laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print(error?.localizedDescription ?? "Don't have biometric method or deny access")
            return completion(false)
        }
        print("Available biometry type:", laContext.biometryType.typeName)
        
        guard (UserDefaults().value(forKey: kBiometryKey) as? Bool) != true else {
            return completion(true)
        }
        
        // MARK: - Request validation
        let reason = "We want check you."
        laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                 localizedReason: reason) { [weak self] success, authError in
            print("Biometry check status: \(success). Permission error: \(String(describing: authError?.localizedDescription))")
            DispatchQueue.main.async {
                guard success else {
                    return completion(success)
                }
                
                UserDefaults().set(true, forKey: kBiometryKey)
                self?.view.backgroundColor = .green
                completion(true)
            }
        }
    }
    
    // MARK: - Contacts
    func contactsRequestAndVerifyAccess() {
        let store = CNContactStore()
        
        DispatchQueue.main.async() {
            store.requestAccess(for: .contacts) { hasAccess, _ in
               print("Has contact access: ", hasAccess)
           }
        }
    }
    
    // MARK: - Calendar
    func calendarRequestAndVerifyFulllAccess() {
        let event = EKEventStore()
        
        event.requestFullAccessToEvents { hasAccess, error in
            if let error = error {
                return print(error.localizedDescription)
            }
            print("Has calendar access: ", hasAccess)
        }
    }
    
    func calendarVerifyAccess() {
        let eventStatus = EKEventStore.authorizationStatus(for: .event)
        switch eventStatus {
        case .notDetermined:
            print("notDetermined calendar access")
        case .fullAccess, .restricted:
            print("Has calendar access")
        default:
            print("Calendar access deny")
        }
    }
    
    // MARK: - Notifications
    func manageNotificationAccess() {
        Task {
            do {
                try await notificationsRequestUse()
            } catch {
                print(error.localizedDescription)
            }
            
            await haveNotificationsAccess { hasAccess in
                print("Has notification access: ", hasAccess)
            }
        }
    }
    
    func haveNotificationsAccess(completion: @escaping(Bool) -> Void) async {
        let settings = await center.notificationSettings()
        
        guard settings.authorizationStatus == .authorized else {
            return completion(false)
        }
        completion(true)
    }
    
    func notificationsRequestUse() async throws {
        try await center.requestAuthorization(options: [.alert, .sound, .badge])
    }
    
}

extension LABiometryType {
    var typeName: String {
        switch self {
        case .none:
            "Non available"
        case .touchID:
            "Touch ID"
        case .faceID:
            "FaceId"
        case .opticID:
            "OpticID"
        @unknown default:
            "Unkwown biometric type"
        }
    }
}
