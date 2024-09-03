//
//  ViewController.swift
//  RequestAuthorizations
//
//  Created by Jonattan Sousa on 27/08/24.
//

import UIKit

class ViewController: UIViewController {
    let center = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        manageNotificationAccess()
    }
    
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
    
    // Calendar
    // Contacts
    // FaceId
}


