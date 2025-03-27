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
    
    static func getStoreVersion() async throws -> String {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(System.appleID)&country=kr") else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedData = try JSONDecoder().decode(SystemModel.self, from: data)
        
        return decodedData.results[0].version
    }
    
    func terminateApp() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    func openAppStore() {
        guard let url = URL(string: System.appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func openSettingApp() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
            }
        }
    }
}
