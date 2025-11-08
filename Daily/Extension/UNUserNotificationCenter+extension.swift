//
//  UNUserNotificationCenter+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    func addNotiRequest(by date: DateComponents, id: String, title: String, body: String = "", repeats: Bool = false) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        self.add(request) { error in
            if let error = error { print("add notification request error is \(error)") }
        }
    }
}
