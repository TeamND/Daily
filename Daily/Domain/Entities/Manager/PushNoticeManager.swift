//
//  PushNoticeManager.swift
//  Daily
//
//  Created by 최승용 on 5/29/24.
//

import UserNotifications

class PushNoticeManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = PushNoticeManager()
    private override init() {
        super.init()
        Task { await setupNotificationDelegate() }
    }
    
    private func setupNotificationDelegate() async {
        await MainActor.run {
            UNUserNotificationCenter.current().delegate = self
        }
    }
    
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
    
    func addDefaultNotice() {
        let id = "default"
        var components = DateComponents()
        components.calendar = Calendar.current
        components.hour = 22
        
        let title: String = "오늘 하루는 어땠나요 🤔"
        let body: String = "하루를 기록해보세요"
        
        UNUserNotificationCenter.current().addNotiRequest(by: components, id: id, title: title, body: body, repeats: true)
    }
    
    func requestNotiAuthorization(showAlert: @escaping () -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                    if granted { self.addDefaultNotice() }
                }
            case .denied:
                showAlert()
            default:
                UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                    if !requests.contains(where: { $0.identifier == "default" }) { self.addDefaultNotice() }
                }
            }
        }
    }
    
    func addNotice(id: String, content: String, date: Date, setTime: String, notice: Int = 5) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = setTime.split(separator: ":").compactMap { Int($0) }
        let hour = timeComponents[0]
        let minute = timeComponents[1]
        
        var components = DateComponents()
        components.calendar = Calendar.current
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = hour
        components.minute = minute
        
        guard let noticeDate = calendar.date(from: components)?.addingTimeInterval(TimeInterval(-notice * 60)) else { return }
        let noticeComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: noticeDate)
        
        UNUserNotificationCenter.current().addNotiRequest(by: noticeComponents, id: id, title: content, body: "\(notice)분 전이에요 😎😎")
    }
    
    func removeNotice(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
    }
    
    func removeAllNoti() {
        self.deleteBadgeNumber()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func deleteBadgeNumber() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}
