//
//  SystemManager.swift
//  Daily
//
//  Created by 최승용 on 5/1/24.
//

import Foundation
import UIKit

struct System {
    static let appleID = 6480167782
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(System.appleID)"
    
    func getStoreVersion(complete: @escaping (String) -> Void) {
        HTTPManager.requestGET(url: "http://itunes.apple.com/lookup?id=\(System.appleID)&country=kr") { data in
            guard let data: SystemModel = JSONConverter.decodeJson(data: data) else {
                return
            }
            complete(data.results[0].version)
        }
    }
    
    func openAppStore() {
        guard let url = URL(string: System.appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func terminateApp() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }

}
