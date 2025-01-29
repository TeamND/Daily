//
//  RecordList.swift
//  Daily
//
//  Created by seungyooooong on 11/29/24.
//

import SwiftUI
import SwiftData

// MARK: - RecordList
struct RecordList: View {
    let date: Date
    let records: [DailyRecordModel]
    
    init(date: Date, records: [DailyRecordModel]) {
        self.date = date
        self.records = records.sorted {
            if let prevGoal = $0.goal, let nextGoal = $1.goal, prevGoal.isSetTime != nextGoal.isSetTime {
                return !prevGoal.isSetTime && nextGoal.isSetTime
            }
            if let prevGoal = $0.goal, let nextGoal = $1.goal, prevGoal.setTime != nextGoal.setTime {
                return prevGoal.setTime < nextGoal.setTime
            }
            return $0.date < $1.date
        }
    }
    
    var body: some View {
        VStack {
            let processedRecords = records.reduce(into: [(record: DailyRecordModel, showTimeline: Bool)]()) { result, record in
                let prevGoal = result.last?.record.goal
                let showTimeline = record.goal.map { goal in
                    if goal.isSetTime { return prevGoal.map { !$0.isSetTime || $0.setTime != goal.setTime } ?? true }
                    return false
                } ?? false
                result.append((record, showTimeline))
            }
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
    let record: DailyRecordModel
    let isButtonDisabled: Bool
    
    init(record: DailyRecordModel, isButtonDisabled: Bool = false) {
        self.record = record
        self.isButtonDisabled = isButtonDisabled
    }
    
    var body: some View {
        if let goal = record.goal {
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
}

// MARK: - NoRecord
struct NoRecord: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
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
