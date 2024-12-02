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
               let modifyType = dailyGoalViewModel.modifyType {
                if modifyType == .date {
                    Label(dailyGoalViewModel.beforeDateString ?? "", systemImage: "calendar")
                        .font(.system(size: CGFloat.fontSize * 2.5))
                        .hLeading()
                        .padding(.horizontal)
                }
                if modifyRecord.is_set_time {
                    DailyTimeLine(record: modifyRecord)
                }
                DailyRecord(record: modifyRecord, isButtonDisabled: true)
                CustomDivider(color: Colors.reverse, height: 1, hPadding: CGFloat.fontSize)
                VStack(spacing: .zero) {
                    Spacer()
                    switch modifyType {
                    case .record:
                        ZStack {
                            Circle()
                                .stroke(Colors.reverse, lineWidth: 1)
                                .padding(CGFloat.fontSize * 15)
                            HStack {
                                countButton(direction: .minus)
                                Menu {
                                    ForEach(0 ... modifyRecord.goal_count, id:\.self) { record_count in
                                        Button {
                                            dailyGoalViewModel.modifyRecordCount = record_count
                                        } label: {
                                            Text("\(String(record_count))번")
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
                    ModifyButtonSection(dailyGoalViewModel: dailyGoalViewModel)
                    Spacer()
                }
                .padding()
            }
        }
        .background(Colors.theme)
        .if(dailyGoalViewModel.modifyType == .goal, transform: { view in
            view.onTapGesture {
                hideKeyboard()
            }
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

// MARK: - ButtonSection
struct ModifyButtonSection: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var dailyGoalViewModel: DailyGoalViewModel
    
    var body: some View {
        HStack {
            if dailyGoalViewModel.modifyType == .date {
                Text("\(CalendarServices.shared.formatDateString(year: dailyGoalViewModel.modifyDate.year, month: dailyGoalViewModel.modifyDate.month, day: dailyGoalViewModel.modifyDate.day, joiner: .korean, hasSpacing: true, hasLastJoiner: true))")
            }
            Spacer()
            DailyButton(action: {
                dismiss()
            }, text: "취소")
            DailyButton(action: {
                dailyGoalViewModel.modify()
            }, text: "수정")
        }
        .padding(.top, CGFloat.fontSize)
    }
}
