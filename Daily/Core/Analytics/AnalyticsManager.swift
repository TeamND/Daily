//
//  AnalyticsManager.swift
//  Daily
//
//  Created by seungyooooong on 7/15/26.
//

import FirebaseAnalytics

final class AnalyticsManager {
    static let shared = AnalyticsManager()

    private init() {}

    func log(_ event: AnalyticsEvent) {
        Analytics.logEvent(
            event.name,
            parameters: event.parameters
        )

        #if DEBUG
        print("📊 Analytics:", event.name, event.parameters ?? [:])
        #endif
    }
}
