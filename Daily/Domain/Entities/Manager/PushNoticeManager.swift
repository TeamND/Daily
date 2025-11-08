//
//  PushNoticeManager.swift
//  Daily
//
//  Created by 최승용 on 5/29/24.
//

import UserNotifications

class PushNoticeManager: NSObject, UNUserNotificationCenterDelegate {
    private(set) var noticeTouchAction: (() -> Void)?
    
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
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        noticeTouchAction?()
        completionHandler()
    }
    
    // MARK: - Default
    func addDefaultNotice() {
        let id = "default"
        var components = DateComponents()
        components.calendar = Calendar.current
        components.hour = 22
        
        let title: String = "오늘 하루는 어땠나요 🤔"
        let body: String = "하루를 기록해보세요"
        
        UNUserNotificationCenter.current().addNotiRequest(by: components, id: id, title: title, body: body, repeats: true)
    }
    
    func requestNotiAuthorization(showAlert: @escaping (NoticeAlert) -> Void, alertType: NoticeAlert) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                    if granted { self.addDefaultNotice() }
                }
            case .denied:
                showAlert(alertType)
            default:
                self.removeBadges()
                self.removePastNotice()
                UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                    if !requests.contains(where: { $0.identifier == "default" }) { self.addDefaultNotice() }
                }
            }
        }
    }
    
    // MARK: - Notice
    func addNotice(id: String, content: String, date: Date, setTime: String, noticeTime: NoticeTimes = .five) {
        guard let noticeDate = CalendarServices.shared.noticeDate(date: date, setTime: setTime, notice: noticeTime.rawValue) else { return }
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: noticeDate)
        
        UNUserNotificationCenter.current().addNotiRequest(
            by: components,
            id: id,
            title: content,
            body: "\(noticeTime.text) 전이에요. 준비되셨나요?"
        )
    }
    
    func removeNotice(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
    }
    
    func setNoticeTouchAction(noticeTouchAction: @escaping () -> Void) {
        self.noticeTouchAction = noticeTouchAction
    }
    
    // MARK: - Timer
    func addTimerNotice(id: String, remainTime: Int) {
        let noticeDate = Date().addingTimeInterval(TimeInterval(remainTime))
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: noticeDate)
        
        UNUserNotificationCenter.current().addNotiRequest(
            by: components,
            id: id,
            title: "목표한 시간이 끝났어요. 수고하셨어요!"
        )
    }
    
    func removeTimerNotice(id: String) {
        removeNotice(id: id)
    }
    
    // MARK: - remove
    func removePastNotice() {
        let notificationCenter = UNUserNotificationCenter.current()
        let currentDate = Date(format: .daily)
        
        notificationCenter.getPendingNotificationRequests { requests in
            let pastIDs = requests.compactMap { request -> String? in
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let triggerDate = trigger.nextTriggerDate(),
                   triggerDate < currentDate,
                   !trigger.repeats {
                    return request.identifier
                }
                return nil
            }
            
            if !pastIDs.isEmpty {
                notificationCenter.removePendingNotificationRequests(withIdentifiers: pastIDs)
                notificationCenter.removeDeliveredNotifications(withIdentifiers: pastIDs)
            }
        }
    }
    
    func removeBadges() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}
