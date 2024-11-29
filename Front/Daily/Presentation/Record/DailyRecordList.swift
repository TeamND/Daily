//
//  DailyRecordList.swift
//  Daily
//
//  Created by seungyooooong on 11/29/24.
//

import SwiftUI

// MARK: - DailyRecordList
struct DailyRecordList: View {
    @Binding var goalListOnDay: GoalListOnDayModel
    
    var body: some View {
        VStack {
            let goalList = goalListOnDay.goalList
            ForEach (goalList.indices, id: \.self) { index in
                let record = goalList[index]
                if record.is_set_time {
                    let isFirstItem = index == 0
                    let isDifferentFromPrevious = index > 0 &&
                        (!goalList[index - 1].is_set_time || goalList[index - 1].set_time != record.set_time)

                    if isFirstItem || isDifferentFromPrevious { DailyTimeLine(record: record) }
                }
                DailyRecord(record: record)
//                RecordOnList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record)
//                    .contextMenu {
//                        NavigationLink {
//                            ModifyRecordView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record)
//                        } label: {
//                            Label("기록 수정", systemImage: "pencil.and.outline")
//                        }
//                        NavigationLink {
//                            ModifyDateView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record)
//                        } label: {
//                            Label("날짜 변경", systemImage: "calendar")
//                        }
//                        if record.cycle_type.wrappedValue == "repeat" {
//                            if record.parent_uid.wrappedValue == nil {
//                                Menu {
//                                    NavigationLink {
//                                        ModifyGoalView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record, modifyGoalModel: modifyGoalModel(record: record.wrappedValue), isAll: false)
//                                    } label: {
//                                        Text("단일 수정")
//                                    }
//                                    NavigationLink {
//                                        ModifyGoalView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record, modifyGoalModel: modifyGoalModel(record: record.wrappedValue), isAll: true)
//                                    } label: {
//                                        Text("일괄 수정")
//                                    }
//                                } label: {
//                                    Label("목표 수정", systemImage: "pencil.line")
//                                }
//                            } else {
//                                NavigationLink {
//                                    ModifyGoalView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record, modifyGoalModel: modifyGoalModel(record: record.wrappedValue), isAll: true)
//                                } label: {
//                                    Label("목표 수정", systemImage: "pencil.line")
//                                }
//                            }
//                            Menu {
//                                Button {
//                                    // remove Record
//                                    removeRecord(recordUID: String(record.uid.wrappedValue)) { data in
//                                        if data.code == "00" {
//                                            calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel) { code in
//                                                if code == "99" { alertViewModel.showAlert() }
//                                            }
//                                        } else { alertViewModel.showAlert() }
//                                    }
//                                } label: {
//                                    Text("단일 삭제")
//                                }
//                                Menu {
//                                    Button {
//                                        removeRecordAll(goalUID: String(record.goal_uid.wrappedValue)) { data in
//                                            if data.code == "00" {
//                                                calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel) { code in
//                                                    if code == "99" { alertViewModel.showAlert() }
//                                                }
//                                            } else { alertViewModel.showAlert() }
//                                        }
//                                    } label: {
//                                        Text("오늘 이후의 목표만 삭제")
//                                    }
//                                    Button {
//                                        deleteGoal(goalUID: String(record.goal_uid.wrappedValue)) { data in
//                                            if data.code == "00" {
//                                                calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel) { code in
//                                                    if code == "99" { alertViewModel.showAlert() }
//                                                }
//                                            } else { alertViewModel.showAlert() }
//                                        }
//                                    } label: {
//                                        Text("과거의 기록도 함께 삭제")
//                                    }
//                                } label: {
//                                    Text("일괄 삭제")
//                                }
//                            } label: {
//                                Label("목표 삭제", systemImage: "trash")
//                            }
//                        } else {
//                            NavigationLink {
//                                ModifyGoalView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record, modifyGoalModel: modifyGoalModel(record: record.wrappedValue), isAll: true)
//                            } label: {
//                                Label("목표 수정", systemImage: "pencil.line")
//                            }
//                            Button {
//                                // remove Record로 수정(?)
//                                deleteGoal(goalUID: String(record.goal_uid.wrappedValue)) { data in
//                                    if data.code == "00" {
//                                        calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel) { code in
//                                            if code == "99" { alertViewModel.showAlert() }
//                                        }
//                                    } else { alertViewModel.showAlert() }
//                                }
//                            } label: {
//                                Label("목표 삭제", systemImage: "trash")
//                            }
//                        }
//                    }
//                    .foregroundStyle(.primary)
            }
        }
    }
}

// MARK: - DailyRecord
struct DailyRecord: View {
    @StateObject var dailyRecordViewModel: DailyRecordViewModel
    
    init(record: Goal) {
        _dailyRecordViewModel = StateObject(wrappedValue: DailyRecordViewModel(record: record))
    }
//    @State var record: Goal
    
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                let symbolImage: String = "\(dailyRecordViewModel.record.symbol.toSymbol()?.rawValue ?? "d.circle")\(dailyRecordViewModel.record.issuccess ? ".fill" : "")"
                Image(systemName: symbolImage)
                Text(dailyRecordViewModel.record.content)
                Spacer()
                DailyRecordButton(dailyRecordViewModel: dailyRecordViewModel)
                    .frame(maxHeight: 40)
            }
            DailyRecordPerGoal(record: $dailyRecordViewModel.record, paddingTrailing: 40)
        }
        .padding(.horizontal, CGFloat.fontSize * 2)
        .frame(height: 60)
        .background {
            RoundedRectangle(cornerRadius: 15).fill(Colors.background)
        }
        .padding(.horizontal, CGFloat.fontSize / 2)
    }
}

// MARK: - DailyNoRecord
struct DailyNoRecord: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    
    var body: some View {
        VStack {
            Spacer()
            Text(noRecordText)
            Button {
                let navigationObject = NavigationObject(viewType: .goal)
                navigationEnvironment.navigate(navigationObject)
            } label: {
                Text(goRecordViewText)
            }
            .foregroundStyle(Colors.daily)
            Spacer()
        }
    }
}
