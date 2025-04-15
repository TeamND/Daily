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
    let records: [DailyRecordModel]
    
    // FIXME: 캘린더별 데이터 구조를 통일하면서 showTimeline을 해당 객체 안으로 이동
    private var processedRecords: [(record: DailyRecordModel, showTimeline: Bool)] {
        return records.reduce(into: [(record: DailyRecordModel, showTimeline: Bool)]()) { result, record in
            let prevGoal = result.last?.record.goal
            let showTimeline = record.goal.map { goal in
                if goal.isSetTime { return prevGoal.map { !$0.isSetTime || $0.setTime != goal.setTime } ?? true }
                return false
            } ?? false
            result.append((record, showTimeline))
        }
    }
    
    var body: some View {
        VStack {
            ForEach(processedRecords, id: \.record.id) { processed in
                let record = processed.record
                if let goal = record.goal {
                    if processed.showTimeline { DailyTimeLine(setTime: goal.setTime) }
                    DailyRecord(record: record)
                        .contextMenu { DailyMenu(record: record, date: date) }
                }
            }
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
            Image(systemName: "\(goal.symbol.imageName)\(record.isSuccess ? ".fill" : "")")
            Text(goal.content)
            Spacer()
            RecordButton(record: record, color: isButtonDisabled ? Colors.reverse : Colors.daily)
                .frame(maxHeight: 40)
                .disabled(isButtonDisabled)
        }
        .frame(height: 60)
        .overlay {
            let recordCount = goal.type == .timer ? record.count.timerFormat() : String(record.count)
            let goalCount = goal.type == .timer ? goal.count.timerFormat() : String(goal.count)
            Text("\(recordCount) / \(goalCount)")
                .font(.system(size : CGFloat.fontSize * 2))
                .padding(.top, CGFloat.fontSize)
                .padding(.trailing, 40)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .padding(.horizontal, CGFloat.fontSize * 2)
        .foregroundStyle(Colors.reverse)
        .background {
            RoundedRectangle(cornerRadius: 15).fill(Colors.background)
        }
        .padding(.horizontal, CGFloat.fontSize / 2)
    }
}

// MARK: - NoRecord
struct NoRecord: View {
    @EnvironmentObject private var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            Text(GeneralServices.noRecordText)
            Button {
                let data = GoalDataModel(date: calendarViewModel.currentDate)
                let navigationObject = NavigationObject(viewType: .goal, data: data)
                navigationEnvironment.navigate(navigationObject)
            } label: {
                Text(GeneralServices.goRecordViewText)
                    .foregroundStyle(Colors.daily)
            }
        }
        .padding()
        .padding(.bottom, CGFloat.screenHeight * 0.25)
        .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
    }
}
