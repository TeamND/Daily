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

    func log(_ event: AnalyticsEvent, _ parameter: AnalyticsParameters...) {
        let parameters = Dictionary(uniqueKeysWithValues: parameter.map { ($0.key, $0.value) })
        
        Analytics.logEvent(event.name, parameters: parameters.isEmpty ? nil : parameters)

        #if DEBUG
        print("📊 Analytics:", event.name, parameters)
        #endif
    }
}
