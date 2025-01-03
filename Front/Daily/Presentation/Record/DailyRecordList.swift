//
//  DailyRecordList.swift
//  Daily
//
//  Created by seungyooooong on 11/29/24.
//

import SwiftUI
import SwiftData

// MARK: - DailyRecordList
struct DailyRecordList: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    let date: Date
    let records: [DailyRecordModel]
    
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
                        .contextMenu {
                            // MARK: ModifyRecord
                            Button {
                                let data = ModifyDataModel(modifyRecord: record, modifyType: .record)
                                let navigationObject = NavigationObject(viewType: .modify, data: data)
                                navigationEnvironment.navigate(navigationObject)
                            } label: {
                                Label("기록 수정", systemImage: "pencil.and.outline")
                            }
                            // MARK: ModifyDate
                            Button {
                                let data = ModifyDataModel(modifyRecord: record, modifyType: .date, date: date)
                                let navigationObject = NavigationObject(viewType: .modify, data: data)
                                navigationEnvironment.navigate(navigationObject)
                            } label: {
                                Label("날짜 변경", systemImage: "calendar")
                            }
                            // MARK: ModifyGoal
                            if goal.cycleType == .date || goal.parentGoal != nil {
                                Button {
                                    let data = ModifyDataModel(modifyRecord: record, modifyType: .goal, isAll: true)
                                    let navigationObject = NavigationObject(viewType: .modify, data: data)
                                    navigationEnvironment.navigate(navigationObject)
                                } label: {
                                    Label("목표 수정", systemImage: "pencil.line")
                                }
                            } else {
                                Menu {
                                    Button {
                                        let data = ModifyDataModel(modifyRecord: record, modifyType: .goal, isAll: false)
                                        let navigationObject = NavigationObject(viewType: .modify, data: data)
                                        navigationEnvironment.navigate(navigationObject)
                                    } label: {
                                        Text("단일 수정")
                                    }
                                    Button {
                                        let data = ModifyDataModel(modifyRecord: record, modifyType: .goal, isAll: true)
                                        let navigationObject = NavigationObject(viewType: .modify, data: data)
                                        navigationEnvironment.navigate(navigationObject)
                                    } label: {
                                        Text("일괄 수정")
                                    }
                                } label: {
                                    Label("목표 수정", systemImage: "pencil.line")
                                }
                            }
                            // MARK: DeleteGoal
                            if goal.cycleType == .date {
                                Button {
                                    modelContext.delete(goal)
                                    try? modelContext.save()
                                } label: {
                                    Label("목표 삭제", systemImage: "trash")
                                }
                            } else {
                                Menu {
                                    Button {
                                        modelContext.delete(record)
                                        try? modelContext.save()
                                    } label: {
                                        Text("단일 삭제")
                                    }
                                    Menu {
                                        Button {
                                            guard let totalRecords = try? modelContext.fetch(FetchDescriptor<DailyRecordModel>()) else { return }
                                            let deleteRecords = totalRecords.filter { currentRecord in
                                                guard let currentGoal = currentRecord.goal else { return false }
                                                return currentGoal.parentGoal?.id ?? currentGoal.id == goal.id && currentRecord.date >= Calendar.current.startOfDay(for: Date())
                                            }
                                            deleteRecords.forEach { modelContext.delete($0) }
                                            try? modelContext.save()
                                        } label: {
                                            Text("오늘 이후의 목표만 삭제")
                                        }
                                        Button {
                                            goal.childGoals.forEach { modelContext.delete($0) }
                                            modelContext.delete(goal)
                                            try? modelContext.save()
                                        } label: {
                                            Text("과거의 기록도 함께 삭제")
                                        }
                                    } label: {
                                        Text("일괄 삭제")
                                    }
                                } label: {
                                    Label("목표 삭제", systemImage: "trash")
                                }
                            }
                        }
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
                DailyRecordButton(record: record, color: isButtonDisabled ? Colors.reverse : Colors.daily)
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
            .background {
                RoundedRectangle(cornerRadius: 15).fill(Colors.background)
            }
            .padding(.horizontal, CGFloat.fontSize / 2)
        }
    }
}

// MARK: - DailyNoRecord
struct DailyNoRecord: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    
    var body: some View {
        VStack {
            Text(noRecordText)
            Button {
                navigationEnvironment.navigate(NavigationObject(viewType: .goal))
            } label: {
                Text(goRecordViewText)
                    .foregroundStyle(Colors.daily)
            }
        }
        .padding()
        .padding(.bottom, CGFloat.screenHeight * 0.25)
        .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
    }
}
