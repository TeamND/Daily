//
//  DailyRecordList.swift
//  Daily
//
//  Created by seungyooooong on 11/29/24.
//

import SwiftUI

// MARK: - DailyRecordList
struct DailyRecordList: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    let date: Date
    let records: [DailyRecordModel]
    
    var body: some View {
        LazyVStack {
            let processedRecords = records.reduce(into: [(record: DailyRecordModel, showTimeline: Bool)]()) { result, record in
                let prevGoal = result.last?.record.goal
                let showTimeline = record.goal.map { goal in
                    if goal.isSetTime { return prevGoal.map { !$0.isSetTime || $0.setTime != goal.setTime } ?? true }
                    return false
                } ?? false
                result.append((record, showTimeline))
            }
            ForEach(processedRecords, id: \.record.id) { processed in
                if processed.showTimeline, let setTime = processed.record.goal?.setTime { DailyTimeLine(setTime: setTime) }
                DailyRecord(record: processed.record)
//                    .contextMenu {
//                        Button {
//                            let data = ModifyDataModel(modifyRecord: record, modifyType: .record)
//                            let navigationObject = NavigationObject(viewType: .modify, data: data)
//                            navigationEnvironment.navigate(navigationObject)
//                        } label: {
//                            Label("기록 수정", systemImage: "pencil.and.outline")
//                        }
//                        Button {
//                            let data = ModifyDataModel(modifyRecord: record, modifyType: .date, year: year, month: month, day: day)
//                            let navigationObject = NavigationObject(viewType: .modify, data: data)
//                            navigationEnvironment.navigate(navigationObject)
//                        } label: {
//                            Label("날짜 변경", systemImage: "calendar")
//                        }
//                        if record.cycle_type == CycleTypes.rept.rawValue {
//                            if record.parent_uid == nil {
//                                Menu {
//                                    Button {
//                                        let data = ModifyDataModel(modifyRecord: record, modifyType: .goal, isAll: false)
//                                        let navigationObject = NavigationObject(viewType: .modify, data: data)
//                                        navigationEnvironment.navigate(navigationObject)
//                                    } label: {
//                                        Text("단일 수정")
//                                    }
//                                    Button {
//                                        let data = ModifyDataModel(modifyRecord: record, modifyType: .goal, isAll: true)
//                                        let navigationObject = NavigationObject(viewType: .modify, data: data)
//                                        navigationEnvironment.navigate(navigationObject)
//                                    } label: {
//                                        Text("일괄 수정")
//                                    }
//                                } label: {
//                                    Label("목표 수정", systemImage: "pencil.line")
//                                }
//                            } else {
//                                Button {
//                                    let data = ModifyDataModel(modifyRecord: record, modifyType: .goal, isAll: true)
//                                    let navigationObject = NavigationObject(viewType: .modify, data: data)
//                                    navigationEnvironment.navigate(navigationObject)
//                                } label: {
//                                    Label("목표 수정", systemImage: "pencil.line")
//                                }
//                            }
//                            Menu {
//                                Button {
//                                    DailyRecordViewModel(record: record).removeRecord(isAll: false)
//                                } label: {
//                                    Text("단일 삭제")
//                                }
//                                Menu {
//                                    Button {
//                                        DailyRecordViewModel(record: record).removeRecord(isAll: true)
//                                    } label: {
//                                        Text("오늘 이후의 목표만 삭제")
//                                    }
//                                    Button {
//                                        DailyRecordViewModel(record: record).removeGoal()
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
//                            Button {
//                                let data = ModifyDataModel(modifyRecord: record, modifyType: .goal, isAll: true)
//                                let navigationObject = NavigationObject(viewType: .modify, data: data)
//                                navigationEnvironment.navigate(navigationObject)
//                            } label: {
//                                Label("목표 수정", systemImage: "pencil.line")
//                            }
//                            Button {
//                                DailyRecordViewModel(record: record).removeGoal()
//                            } label: {
//                                Label("목표 삭제", systemImage: "trash")
//                            }
//                        }
//                    }
            }
        }
    }
}

// MARK: - DailyRecord
struct DailyRecord: View {
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    @StateObject var dailyRecordViewModel: DailyRecordViewModel
    let isButtonDisabled: Bool
    
    init(record: DailyRecordModel, isButtonDisabled: Bool = false) {
        _dailyRecordViewModel = StateObject(wrappedValue: DailyRecordViewModel(record: record))
        self.isButtonDisabled = isButtonDisabled
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                Image(systemName: "\(dailyRecordViewModel.record.goal!.symbol.imageName)\(dailyRecordViewModel.record.isSuccess ? ".fill" : "")")
                Text(dailyRecordViewModel.record.goal!.content)
                Spacer()
                DailyRecordButton(dailyRecordViewModel: dailyRecordViewModel, color: isButtonDisabled ? Colors.reverse : Colors.daily)
                    .frame(maxHeight: 40)
                    .disabled(isButtonDisabled)
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
                navigationEnvironment.navigate(NavigationObject(viewType: .goal))
            } label: {
                Text(goRecordViewText)
                    .foregroundStyle(Colors.daily)
            }
            Spacer()
        }
    }
}
