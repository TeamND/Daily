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
    
    func requestNotiAuthorization(last_time: String?, completion: @escaping (Bool) -> Void) {
        if self.validateRequestCondition(last_time: last_time) {
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
    
    func validateRequestCondition(last_time: String?) -> Bool {
        if last_time == nil { // 신규 사용자
            return true
        } else {
            let last_time = String(last_time!.split(separator: " ")[0])
            let gap = Calendar.current.dateComponents([.year,.month,.day], from: last_time.toDate()!, to: Date())
            return gap.year! > 0 || gap.month! > 0 || gap.day! > 6   // 일주일 이내 사용 이력이 없는 사용자
        }
    }
}
