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
        VStack {
            ForEach(recordsInList, id: \.record.id) { recordInList in
                let record = recordInList.record
                if let goal = record.goal {
                    if recordInList.isShowTimeline { DailyTimeLine(setTime: goal.setTime) }
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
