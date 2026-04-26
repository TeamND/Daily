//
//  NotificationIndicator.swift
//  Daily
//
//  Created by seungyooooong on 3/14/26.
//

import SwiftUI

struct NotificationIndicator: View {
    let record: DailyRecordModel
    
    var body: some View {
        TimelineView(
            .periodic(
                from: Calendar.current.nextDate(
                    after: Date(),
                    matching: DateComponents(second: 0),
                    matchingPolicy: .nextTime
                ) ?? Date(),
                by: 60
            )
        ) { context in
            let now = context.date
            
            if let noticeDate = CalendarServices.shared.getValidNoticeDate(record: record) {
                ZStack {
                    Circle()
                        .fill(Colors.Background.primary)
                        .frame(width: 16, height: 16)
                    Image(noticeDate > now ? .notificationYet : .notification)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12)
                }
                .padding(.top, -3)
                .padding(.trailing, -2)
                .vTop()
                .hTrailing()
            }
        }
    }
}
