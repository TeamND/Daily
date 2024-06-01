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
    func addCalendarNoti(type: String = "noRecord") {
        print("addCalendarNoti")
//        let calendar = Calendar.current
//        let newDate = calendar.date(byAdding: DateComponents(second: 5), to: .now)
//        let components = calendar.dateComponents([.hour, .minute, .second], from: newDate!)
        var components = DateComponents()
        components.calendar = Calendar.current
        components.hour = 18
        components.minute = 26
        components.second = 00
        
        let title: String = type == "noRecord" ? "오늘 하루는 어땠나요 🤔" : "아직 기록하지 않은 목표가 있어요 😥"
        let body: String = "하루를 기록해보세요"
        
        UNUserNotificationCenter.current().addNotificationRequest(by: components, id: UUID().uuidString, title: title, body: body)
    }

    // PushNotificationHelper.swfit > PushNotificationHelper
//    func pushNotification(title: String, body: String, seconds: Double, identifier: String) {
//        // 1️⃣ 알림 내용, 설정
//        let notificationContent = UNMutableNotificationContent()
//        notificationContent.title = title
//        notificationContent.body = body
//
//        // 2️⃣ 조건(시간, 반복)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
//
//        // 3️⃣ 요청
//        let request = UNNotificationRequest(identifier: identifier,
//                                            content: notificationContent,
//                                            trigger: trigger)
//
//        // 4️⃣ 알림 등록
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Notification Error: ", error)
//            }
//        }
//    }
    func cancelNotification() {
        // 곧 다가올 알림 지우기
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // 현재 사용자 폰에 떠 있는 알림 지우기
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    func deleteBadgeNumber() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
    // 제일 처음 앱 열릴 때
    func viewAppear() {
        UNUserNotificationCenter.current().getNotificationSettings { permission in
            switch permission.authorizationStatus  {
            case .notDetermined: // 제일 처음 알림 설정
                self.addCalendarNoti()
//                self.requestAuthorization(date: Date(h: 18, mi: 0), text: "K_오늘 나의 하루는 어땠나요?")
            default:
                break
            }
        }
    }
        
    // 알림 설정 시 확인할 때
    func checkNotificationSetting(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)
            default:
                completion(false)
            }
        }
    }

    // -> View에서는 아래와 같이 사용
    //NotificationManager.instance.checkNotificationSetting { isAuthorized in
    //    if isAuthorized {
    //        // 동의시
    //    } else {
    //        // 비동의시
    //           NotificationManager.instance.openSettingApp()
    //    }
    //}
        
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
