//
//  ViewController.swift
//  RequestAuthorizations
//
//  Created by Jonattan Sousa on 27/08/24.
//

import UIKit
import EventKit
import Contacts

class ViewController: UIViewController {
    let center = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
//        manageNotificationAccess()
//        calendarRequestAndVerifyFulllAccess()
        contactsRequestAndVerifyAccess()
    }
    
    // func faceIdRequestUse() {}
    
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


