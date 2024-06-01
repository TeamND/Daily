//
//  PushNoticeManager.swift
//  Daily
//
//  Created by 최승용 on 5/29/24.
//

import Foundation
import UserNotifications
import UIKit

class PushNoticeManager {
    @Published var isNotiOn: Bool = false
    
    func addNoti() {
        print("addNoti")
//        let calendar = Calendar.current
//        let newDate = calendar.date(byAdding: DateComponents(second: 5), to: .now)
//        let components = calendar.dateComponents([.hour, .minute, .second], from: newDate!)
        var components = DateComponents()
        components.calendar = Calendar.current
        components.hour = 22
//        components.minute = 26
//        components.second = 00
        
        let title: String = "오늘 하루는 어땠나요 🤔"
        let body: String = "하루를 기록해보세요"
        
        UNUserNotificationCenter.current().addNotificationRequest(by: components, id: UUID().uuidString, title: title, body: body)
    }
    
    func removeAllNoti() {
        print("removeAllNoti")
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
//    func deleteBadgeNumber() {
//        UNUserNotificationCenter.current().setBadgeCount(0)
//    }
    
    func requestNotiAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if let error = error { print("Error : \(error)") }

                    if granted { self.addNoti() }
                    completion(false)
                }
            case .denied:
                completion(true)
            case .authorized:
                self.removeAllNoti()
                self.addNoti()
                completion(false)
            default:
                print("other case!! \(settings.authorizationStatus)")
            }
        }
    }
        
    // 설정앱의 Cherish 앱 열기
    func openSettingApp() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
            }
        }
    }
}
