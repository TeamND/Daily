//
//  PushNoticeManager.swift
//  Daily
//
//  Created by 최승용 on 5/29/24.
//

import UserNotifications

class PushNoticeManager {
    @Published var isNotiOn: Bool = false
    
    func addNoti() {
        var components = DateComponents()
        components.calendar = Calendar.current
        components.hour = 22
        
        let title: String = "오늘 하루는 어땠나요 🤔"
        let body: String = "하루를 기록해보세요"
        
        UNUserNotificationCenter.current().addNotiRequest(by: components, id: UUID().uuidString, title: title, body: body)
    }
    
    func removeAllNoti() {
        self.deleteBadgeNumber()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func deleteBadgeNumber() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
    
    func requestNotiAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if let error = error { print("reuqest authorization error is \(error)") }

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
                print("other case in get noti setting situation,\n case is \(settings.authorizationStatus)")
            }
        }
    }
}
