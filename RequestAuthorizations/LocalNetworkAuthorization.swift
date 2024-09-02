//
//  LocalNetworkAuthorization.swift
//  RequestAuthorizations
//
//  Created by Jonattan Sousa on 02/09/24.
//

import Foundation
import Network

public class LocalNetworkAuthorization: NSObject {
    private var browser: NWBrowser?
    private var netService: NetService?
    private var completion: ((Bool) -> Void)?
    
    public func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let type = "_pulse._tcp."
        self.completion = completion
        
        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        
        let browser = NWBrowser(for: .bonjour(type: type, domain: nil), using: parameters)
        browser.parameters.expiredDNSBehavior = .allow
        self.browser = browser
        browser.stateUpdateHandler = { newState in
            switch newState {
            case .failed(let error):
                debugPrint(error.localizedDescription)
            case .ready, .cancelled:
                break
            case let .waiting(error):
                self.reset()
                self.completion?(false)
            default:
                break
            }
        }
        
        self.netService = NetService(domain: "local.", type: type, name: "LocalNetworkPrivacy", port: 1100)
        self.netService?.delegate = self
        
        self.browser?.start(queue: .main)
        self.netService?.publish()
    }
    
    private func reset() {
        self.browser?.cancel()
        self.browser = nil
        self.netService?.stop()
        self.netService = nil
    }
}

extension LocalNetworkAuthorization : NetServiceDelegate {
    public func netServiceDidPublish(_ sender: NetService) {
        self.reset()
        completion?(true)
    }
}
