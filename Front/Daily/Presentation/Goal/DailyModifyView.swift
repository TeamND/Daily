//
//  DailyModifyView.swift
//  Daily
//
//  Created by seungyooooong on 12/2/24.
//

import SwiftUI

struct DailyModifyView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @StateObject var dailyGoalViewModel: DailyGoalViewModel
    
    init(modifyData: ModifyDataModel) {
        _dailyGoalViewModel = StateObject(wrappedValue: DailyGoalViewModel(modifyData: modifyData))
    }
    
    var body: some View {
        VStack {
            DailyNavigationBar(title: dailyGoalViewModel.getNavigationBarTitle())
            if let modifyRecord = dailyGoalViewModel.modifyRecord,
               let modifyGoal = modifyRecord.goal,
               let modifyType = dailyGoalViewModel.modifyType {
                if modifyType == .date {
                    Label(dailyGoalViewModel.beforeDateString ?? "", systemImage: "calendar")
                        .font(.system(size: CGFloat.fontSize * 2.5))
                        .hLeading()
                        .padding(.horizontal)
                }
                if modifyGoal.isSetTime { DailyTimeLine(setTime: modifyGoal.setTime) }
                DailyRecord(record: modifyRecord, isButtonDisabled: true)
                CustomDivider(color: Colors.reverse, height: 1, hPadding: CGFloat.fontSize)
                VStack(spacing: .zero) {
                    switch modifyType {
                    case .record:
                        ZStack {
                            Circle()
                                .stroke(Colors.reverse, lineWidth: 1)
                                .padding(CGFloat.fontSize * 15)
                            HStack {
                                countButton(direction: .minus)
                                Menu {
                                    ForEach(0 ... modifyGoal.count, id:\.self) { count in
                                        Button {
                                            dailyGoalViewModel.modifyRecordCount = count
                                        } label: {
                                            Text("\(String(count))번")
                                        }
                                    }
                                } label: {
                                    Text("\(dailyGoalViewModel.modifyRecordCount)")
                                        .font(.system(size: CGFloat.fontSize * 10, weight: .bold))
                                        .frame(width: CGFloat.fontSize * 10)
                                        .padding()
                                        .foregroundColor(Colors.reverse)
                                }
                                countButton(direction: .plus)
                            }
                        }
                    case .date:
                        DatePicker("", selection: $dailyGoalViewModel.modifyDate, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .accentColor(Colors.daily)
                    case .goal:
                        DailySection(type: .time) {
                            TimeSection(isSetTime: $dailyGoalViewModel.isSetTime, setTime: $dailyGoalViewModel.setTime)
                        }
                        DailySection(type: .content, essentialConditions: dailyGoalViewModel.content.count >= 2) {
                            ContentSection(content: $dailyGoalViewModel.content, goalType: $dailyGoalViewModel.goalType)
                        }
                        HStack {
                            DailySection(type: .count) {
                                CountSection(
                                    goalType: $dailyGoalViewModel.goalType,
                                    goalCount: $dailyGoalViewModel.goalCount,
                                    goalTime: .constant(300)    // TODO: 추후 수정
                                )
                            }
                            DailySection(type: .symbol) {
                                SymbolSection(symbol: $dailyGoalViewModel.symbol)
                            }
                        }
                    }
                    ButtonSection(dailyGoalViewModel: dailyGoalViewModel, buttonType: .modify)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Colors.theme)
        .if(dailyGoalViewModel.modifyType == .goal, transform: { view in
            view.onTapGesture { hideKeyboard() }
        })
    }
    
    private func countButton(direction: Direction) -> some View {
        Button {
            let afterCount = dailyGoalViewModel.modifyRecordCount + direction.value
            if afterCount < 0 {
                alertViewModel.showToast(message: "최소 기록 횟수는 0번이에요 😓")
            } else if afterCount > dailyGoalViewModel.goalCount {
                alertViewModel.showToast(message: "최대 기록 횟수는 \(dailyGoalViewModel.goalCount)번이에요 🙌")
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
