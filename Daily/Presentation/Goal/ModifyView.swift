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
            if let modifyRecord = goalViewModel.modifyRecord,
               let modifyGoal = modifyRecord.goal {
                Label("\(CalendarServices.shared.formatDateString(date: calendarViewModel.currentDate, joiner: .dot, hasSpacing: true, hasLastJoiner: true))\(calendarViewModel.currentDate.getKoreaDOW())", systemImage: "calendar")
                    .font(.system(size: CGFloat.fontSize * 2.5))
                    .hLeading()
                    .padding(.horizontal)
                if modifyGoal.isSetTime { DailyTimeLine(setTime: modifyGoal.setTime) }
                DailyRecord(record: modifyRecord, isButtonDisabled: true)
                CustomDivider(color: Colors.reverse, height: 1, hPadding: CGFloat.fontSize)
                VStack(spacing: .zero) {
                    DailySection(type: .date, isModify: true) {
                        DateSection(goalViewModel: goalViewModel, isModify: true)
                    }
                    DailySection(type: .time) {
                        TimeSection(isSetTime: $goalViewModel.isSetTime, setTime: $goalViewModel.setTime)
                    }
                    DailySection(type: .content, essentialConditions: goalViewModel.content.count >= 2) {
                        ContentSection(content: $goalViewModel.content, goalType: $goalViewModel.goalType)
                    }
                    HStack {
                        if let modifyType = goalViewModel.modifyType, modifyType == .all {
                            DailySection(type: .goalCount) {
                                GoalCountSection(
                                    goalType: $goalViewModel.goalType,
                                    goalCount: $goalViewModel.goalCount
                                )
                            }
                        } else {
                            DailySection(type: .count) {
                                CountSection(recordCount: $goalViewModel.recordCount, goalCount: $goalViewModel.goalCount)
                            }
                        }
                        DailySection(type: .symbol) {
                            SymbolSection(symbol: $goalViewModel.symbol)
                        }
                    }
                    ButtonSection(goalViewModel: goalViewModel, buttonType: .modify)
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
            let afterCount = goalViewModel.recordCount + direction.value
            if afterCount < 0 {
                alertEnvironment.showToast(message: "최소 기록 횟수는 0번이에요 😓")
            } else if afterCount > goalViewModel.goalCount {
                alertEnvironment.showToast(message: "최대 기록 횟수는 \(goalViewModel.goalCount)번이에요 🙌")
            } else {
                goalViewModel.recordCount = afterCount
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
