//
//  PushNoticeManager.swift
//  Daily
//
//  Created by 최승용 on 5/29/24.
//

import UserNotifications

class PushNoticeManager: NSObject, UNUserNotificationCenterDelegate {
    private(set) var noticeTouchAction: ((Date?) -> Void)?
    
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
        let userInfo = response.notification.request.content.userInfo
        let date = (userInfo["date"] as? TimeInterval).map { Date(timeIntervalSince1970: $0) }
        
        noticeTouchAction?(date)
        completionHandler()
    }
    
    // MARK: - Default
    func addDefaultNotice() {
        let id = "default"
        var components = DateComponents()
        components.calendar = Calendar.current
        components.hour = 22
        
        let title: String = "how_was_your_day".localized
        let body: String = "write_down_your_day".localized
        
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
    func addNotice(id: String, content: String, date: Date, setTime: String, notification: Notifications) {
        // FIXME: 유효성 검사 추가 필요, 유효하지 않다면 토스트 출력이 필요, 추가로 record.notice 자체를 저장할지에 대해서도 고민
        guard let noticeTime = notification.noticeTime,
              let noticeDate = CalendarServices.shared.noticeDate(date: date, setTime: setTime, notice: noticeTime)
        else { return }
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: noticeDate)
        
        let userInfo: [AnyHashable : Any] = [
            "type": "normal",
            "date": date.timeIntervalSince1970
        ]
        
        UNUserNotificationCenter.current().addNotiRequest(
            by: components,
            id: id,
            title: content,
            body: "before_ready_to_begin".localized(notification.text),
            userInfo: userInfo
        )
    }
    
    func removeNotice(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
    }
    
    func setNoticeTouchAction(noticeTouchAction: @escaping (Date?) -> Void) {
        self.noticeTouchAction = noticeTouchAction
    }
    
    // MARK: - Timer
    func addTimerNotice(id: String, content: String, date: Date, remainTime: Int) {
        let noticeDate = Date().addingTimeInterval(TimeInterval(remainTime))
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: noticeDate)
        
        let userInfo: [AnyHashable : Any] = [
            "type": "normal",
            "date": date.timeIntervalSince1970
        ]
        
        UNUserNotificationCenter.current().addNotiRequest(
            by: components,
            id: id,
            title: content,
            body: "you_did_it_goal_complete".localized,
            userInfo: userInfo
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
