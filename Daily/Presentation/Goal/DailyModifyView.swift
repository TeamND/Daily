//
//  DailyModifyView.swift
//  Daily
//
//  Created by seungyooooong on 12/2/24.
//

import SwiftUI

struct DailyModifyView: View {
    @EnvironmentObject var alertEnvironment: AlertEnvironment
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    @StateObject var dailyGoalViewModel: DailyGoalViewModel
    
    init(modifyData: ModifyDataModel) {
        _dailyGoalViewModel = StateObject(wrappedValue: DailyGoalViewModel(modifyData: modifyData))
    }
    
    var body: some View {
        VStack {
            DailyNavigationBar(title: "목표수정")
            if let modifyRecord = dailyGoalViewModel.modifyRecord,
               let modifyGoal = modifyRecord.goal {
                Label("\(CalendarServices.shared.formatDateString(date: dailyCalendarViewModel.currentDate, joiner: .dot, hasSpacing: true, hasLastJoiner: true))\(dailyCalendarViewModel.currentDate.getKoreaDOW())", systemImage: "calendar")
                    .font(.system(size: CGFloat.fontSize * 2.5))
                    .hLeading()
                    .padding(.horizontal)
                if modifyGoal.isSetTime { DailyTimeLine(setTime: modifyGoal.setTime) }
                DailyRecord(record: modifyRecord, isButtonDisabled: true)
                CustomDivider(color: Colors.reverse, height: 1, hPadding: CGFloat.fontSize)
                VStack(spacing: .zero) {
                    DailySection(type: .date, isModify: true) {
                        DateSection(dailyGoalViewModel: dailyGoalViewModel, isModify: true)
                    }
                    DailySection(type: .time) {
                        TimeSection(isSetTime: $dailyGoalViewModel.isSetTime, setTime: $dailyGoalViewModel.setTime)
                    }
                    DailySection(type: .content, essentialConditions: dailyGoalViewModel.content.count >= 2) {
                        ContentSection(content: $dailyGoalViewModel.content, goalType: $dailyGoalViewModel.goalType)
                    }
                    HStack {
                        DailySection(type: .count) {
                            CountSection(recordCount: $dailyGoalViewModel.modifyRecordCount, goalCount: $dailyGoalViewModel.goalCount)
                        }
                        DailySection(type: .symbol) {
                            SymbolSection(symbol: $dailyGoalViewModel.symbol)
                        }
                    }
                    ButtonSection(dailyGoalViewModel: dailyGoalViewModel, buttonType: .modify)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Colors.theme)
        .onTapGesture { hideKeyboard() }
    }
    
    private func countButton(direction: Direction) -> some View {
        Button {
            let afterCount = dailyGoalViewModel.modifyRecordCount + direction.value
            if afterCount < 0 {
                alertEnvironment.showToast(message: "최소 기록 횟수는 0번이에요 😓")
            } else if afterCount > dailyGoalViewModel.goalCount {
                alertEnvironment.showToast(message: "최대 기록 횟수는 \(dailyGoalViewModel.goalCount)번이에요 🙌")
            } else {
                dailyGoalViewModel.modifyRecordCount = afterCount
            }
        } label: {
            Text(direction.rawValue)
                .font(.system(size: CGFloat.fontSize * 5, weight: .bold))
                .frame(width: CGFloat.fontSize * 10)
                .padding()
                .foregroundStyle(Colors.daily)
                .background {
                    Circle()
                        .fill(Colors.background)
                        .opacity(0.8)
                }
        }
    }
}
