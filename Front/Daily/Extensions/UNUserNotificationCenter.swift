//
//  UNUserNotificationCenter.swift
//  Daily
//
//  Created by 최승용 on 5/29/24.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    func addNotificationRequest(by date: DateComponents, id: String, title: String, body: String) {
        
        // content 만들기
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        // trigger 만들기
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        // request 만들기
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        self.add(request) { error in
            if let error = error { print("notification error is \(error)") }
        }
    }
}
