//
//  CalendarDayView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

// MARK: - CalendarDayView
struct CalendarDayView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var dailyCalendarViewModel: DailyCalendarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            DailyCalendarHeader(type: .day, backButton: $dailyCalendarViewModel.month, title: $dailyCalendarViewModel.day)
            DailyWeekIndicator(mode: .change)
            CustomDivider(color: .primary, height: 2, hPadding: CGFloat.fontSize * 2)
            TabView(selection: $dailyCalendarViewModel.daySelection) {
                ForEach(-10 ... 10, id: \.self) { index in
                    ForEach(1 ... 12, id: \.self) { month in
                        let year = Date().year + index
                        let lengthOfMonth = CalendarServices.shared.lengthOfMonth(year: year, month: month)
                        ForEach(1 ... lengthOfMonth, id: \.self) { day in
                            let daySelection = year.formatDateString(type: .year) + "-" + month.formatDateString(type: .month) + "-" +  day.formatDateString(type: .day)
                            CalendarDay(year: year, month: month, day: day)
                                .tag(daySelection)
                                .onAppear {
                                    dailyCalendarViewModel.calendarDayOnAppear()
                                }
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, CGFloat.fontSize)
            .background(Colors.theme)
            .onChange(of: dailyCalendarViewModel.daySelection) { daySelection in
                guard let year = Int(daySelection.split(separator: "-")[0]) else { return }
                guard let month = Int(daySelection.split(separator: "-")[1]) else { return }
                guard let day = Int(daySelection.split(separator: "-")[2]) else { return }
                dailyCalendarViewModel.setYear(year)
                dailyCalendarViewModel.setMonth(month)
                dailyCalendarViewModel.setDay(day)
            }
        }
        .overlay {
            DailyAddGoalButton()
        }
    }
}
// MARK: - CalendarDay
struct CalendarDay: View {
    let year: Int
    let month: Int
    let day: Int
    
    var body: some View {
        if false {
            VStack {
                Spacer().frame(height: CGFloat.fontSize)
                ViewThatFits(in: .vertical) {
                    DailyRecordList(records: .constant([]))
                    ScrollView {
                        DailyRecordList(records: .constant([]))
                    }
                }
                Spacer().frame(height: CGFloat.fontSize * 15)
                Spacer()
            }
        } else {
            DailyNoRecord()
//            NoRecord(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel())
        }
    }
}

// MARK: - DailyRecordList
struct DailyRecordList: View {
    @Binding var records: [Int]
    
    var body: some View {
        VStack {
            ForEach(records, id: \.self) { record in
//                let record = $calendarViewModel.recordsOnWeek[index]
//                if record.is_set_time.wrappedValue {
//                    if index == 0 ||    // 첫번째 항목일 경우 표기
//                        (index > 0 &&   // n번째 항목일 경우
//                         (calendarViewModel.recordsOnWeek[index - 1].is_set_time == false ||    // 이전 항목의 is_set_time이 false라면 set_time에 상관 없이 표기
//                          calendarViewModel.recordsOnWeek[index - 1].set_time != record.set_time.wrappedValue)  // 이전 항목과 set_time이 다르면 표기
//                        )
//                    {
//                        TimeLine(record: record)
//                    }
//                }
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
    let record: Int
    
    var body: some View {
        Text("record is \(String(record))")
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


#Preview {
    CalendarDayView(dailyCalendarViewModel: DailyCalendarViewModel())
}
