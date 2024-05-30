//
//  PushNoticeManager.swift
//  Daily
//
//  Created by 최승용 on 5/29/24.
//

import Foundation
import UserNotifications

class PushNoticeManager {
    func addCalendarNoti(type: String = "noRecord") {
//        let calendar = Calendar.current
//        let newDate = calendar.date(byAdding: DateComponents(second: 5), to: .now)
//        let components = calendar.dateComponents([.hour, .minute, .second], from: newDate!)
        var components = DateComponents()
        components.calendar = Calendar.current
        components.hour = 22
        components.minute = 33
        
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
}
