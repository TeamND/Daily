//
//  RecordList.swift
//  Daily
//
//  Created by seungyooooong on 11/29/24.
//

import SwiftUI

// MARK: - RecordList
struct RecordList: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    let date: Date
    let selection: String
    let recordsInList: [DailyRecordInList]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(recordsInList, id: \.record.id) { recordInList in
                let record = recordInList.record
                if let goal = record.goal {
                    if recordInList.isShowTimeline { DailyTimeLine(setTime: goal.setTime) }
                    DailyRecord(record: record)
                        .contextMenu { DailyMenu(record: record, date: date) }
                }
            }
            Spacer()
        }
    }
}

// MARK: - DailyRecord
struct DailyRecord: View {
    private let record: DailyRecordModel
    private let goal: DailyGoalModel
    private let isButtonDisabled: Bool
    
    init(record: DailyRecordModel, goal: DailyGoalModel? = nil, isButtonDisabled: Bool = false) {
        self.record = record
        self.goal = goal ?? record.goal!
        self.isButtonDisabled = isButtonDisabled
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(goal.symbol.icon(isSuccess: record.isSuccess))
                .resizable()
                .scaledToFit()
                .frame(width: 36)
            VStack(alignment: .leading, spacing: 8) {
                Text(goal.content)
                    .font(Fonts.bodyLgSemiBold)
                    .foregroundStyle(Colors.Text.primary)
                let recordCount = goal.type == .timer ? record.count.timerFormat() : String(record.count)
                let goalCount = goal.type == .timer ? goal.count.timerFormat() : String(goal.count)
                Text("\(recordCount) / \(goalCount)")
                    .font(Fonts.bodyMdRegular)
                    .foregroundStyle(Colors.Text.secondary)
            }
            Spacer()
            RecordButton(record: record, goal: goal, disabled: isButtonDisabled)
                .frame(maxHeight: 40)
                .disabled(isButtonDisabled)
        }
        .frame(height: 72)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 8).fill(Colors.Background.secondary)
        }
        .grayscale(isButtonDisabled ? 1 : 0)
    }
}

// MARK: - NoRecord
struct NoRecord: View {
    @EnvironmentObject private var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    let isEmpty: Bool
    
    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            Image(isEmpty ? .recordYetNormal : .recordYetFilter)
            Spacer().frame(height: 20)
            Text(GeneralServices.noRecordText(isEmpty: isEmpty))
                .font(Fonts.headingSmSemiBold)
                .foregroundStyle(Colors.Text.secondary)
            Spacer().frame(height: 4)
            Text(GeneralServices.noRecordDescriptionText(isEmpty: isEmpty))
                .font(Fonts.bodyLgRegular)
                .foregroundStyle(Colors.Text.tertiary)
            Spacer()
            Spacer()
        }
    }
}
