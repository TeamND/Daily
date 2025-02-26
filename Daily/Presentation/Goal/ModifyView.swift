//
//  ModifyView.swift
//  Daily
//
//  Created by seungyooooong on 12/2/24.
//

import SwiftUI

struct ModifyView: View {
    @EnvironmentObject var alertEnvironment: AlertEnvironment
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @StateObject var goalViewModel: GoalViewModel
    
    init(modifyData: ModifyDataModel) {
        _goalViewModel = StateObject(wrappedValue: GoalViewModel(modifyData: modifyData))
    }
    
    var body: some View {
        VStack {
            DailyNavigationBar(title: "목표수정")
            originalRecord
            VStack(spacing: .zero) {
                Spacer()
                DailySection(type: .date, isModify: true) {
                    DateSection(goalViewModel: goalViewModel)
                }
                DailySection(type: .time) {
                    TimeSection(isSetTime: $goalViewModel.goal.isSetTime, setTime: goalViewModel.setTime)
                }
                DailySection(type: .content, essentialConditions: goalViewModel.goal.content.count >= 2) {
                    ContentSection(content: $goalViewModel.goal.content, goalType: $goalViewModel.goal.type)
                }
                HStack {
                    if let modifyType = goalViewModel.modifyType, modifyType == .all {
                        DailySection(type: .goalCount) {
                            GoalCountSection(
                                goalType: $goalViewModel.goal.type,
                                goalCount: $goalViewModel.goal.count
                            )
                        }
                    } else {
                        DailySection(type: .count) {
                            CountSection(recordCount: $goalViewModel.record.count, goalCount: $goalViewModel.goal.count)
                        }
                    }
                    DailySection(type: .symbol) {
                        SymbolSection(symbol: $goalViewModel.goal.symbol)
                    }
                }
                ButtonSection(goalViewModel: goalViewModel, buttonType: .modify)
                Spacer()
                Spacer()
            }
            .padding()
        }
        .background(Colors.theme)
        .onTapGesture { hideKeyboard() }
    }
    
    private var originalRecord: some View {
        VStack {
            Label("\(CalendarServices.shared.formatDateString(date: calendarViewModel.currentDate, joiner: .dot, hasSpacing: true, hasLastJoiner: true))\(calendarViewModel.currentDate.getKoreaDOW())", systemImage: "calendar")
                .font(.system(size: CGFloat.fontSize * 2.5))
                .hLeading()
                .padding(.horizontal)
            if goalViewModel.originalGoal.isSetTime { DailyTimeLine(setTime: goalViewModel.originalGoal.setTime) }
            DailyRecord(record: goalViewModel.originalRecord, goal: goalViewModel.originalGoal, isButtonDisabled: true)
            CustomDivider(color: Colors.reverse, height: 1, hPadding: CGFloat.fontSize)
        }
    }
}
