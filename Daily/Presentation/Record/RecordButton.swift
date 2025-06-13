//
//  RecordButton.swift
//  Daily
//
//  Created by seungyooooong on 11/28/24.
//

import SwiftUI

struct RecordButton: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    let record: DailyRecordModel
    let goal: DailyGoalModel
    let disabled: Bool
    
    var body: some View {
        Button {
            if record.isSuccess || disabled { return }
            calendarViewModel.actionOfRecordButton(record: record)
        } label: {
            ZStack {
                if record.isSuccess {
                    Image(.success)
                        .resizable()
                        .scaledToFit()
                } else if goal.type == .timer {
                    Image(record.startTime == nil ? .start : .pause)
                        .resizable()
                        .scaledToFit()
                }
                RatingIndicator(rating: Double(record.count) / Double(goal.count))
            }
            .frame(width: 40, height: 40)
        }
    }
}
