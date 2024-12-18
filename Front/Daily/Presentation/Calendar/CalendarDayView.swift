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
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            DailyCalendarHeader(type: .day)
            DailyWeekIndicator(
                mode: .change,
                opacity: Binding(
                    get: {
                        dailyCalendarViewModel.weekDictionary[dailyCalendarViewModel.weekSelection]?.rating ?? Array(repeating: 0, count: 7)
                    }, set: { _ in }
                )
            )
            CustomDivider(color: Colors.reverse, height: 2, hPadding: CGFloat.fontSize * 2)
            TabView(selection: $dailyCalendarViewModel.daySelection) {
                ForEach(-10 ... 10, id: \.self) { index in
                    ForEach(1 ... 12, id: \.self) { month in
                        let year = Date().year + index
                        let lengthOfMonth = CalendarServices.shared.lengthOfMonth(year: year, month: month)
                        ForEach(1 ... lengthOfMonth, id: \.self) { day in
                            let daySelection = CalendarServices.shared.formatDateString(year: year, month: month, day: day)
                            let goalListOnDayBinding = Binding<GoalListOnDayModel>(
                                get: { dailyCalendarViewModel.dayDictionary[daySelection] ?? GoalListOnDayModel() },
                                set: { dailyCalendarViewModel.dayDictionary[daySelection] = $0 }
                            )
                            CalendarDay(
                                year: year, month: month, day: day,
                                goalListOnDay: goalListOnDayBinding
                            )
                            .tag(daySelection)
                            .onAppear {
                                dailyCalendarViewModel.calendarDayOnAppear(daySelection: daySelection)
                            }
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, CGFloat.fontSize)
            .background(Colors.theme)
            .onChange(of: dailyCalendarViewModel.daySelection) { daySelection in
                if navigationEnvironment.navigationPath.last?.viewType == .calendarDay {
                    let dateComponents = daySelection.split(separator: DateJoiner.hyphen.rawValue).compactMap { Int($0) }
                    guard dateComponents.count == 3 else { return }
                    dailyCalendarViewModel.setDate(dateComponents[0], dateComponents[1], dateComponents[2])
                }
            }
            .onChange(of: dailyCalendarViewModel.weekSelection) { weekSelection in
                dailyCalendarViewModel.weekIndicatorOnChange(weekSelection: weekSelection)
            }
            .onAppear {
                dailyCalendarViewModel.weekIndicatorOnChange()
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
    @Binding var goalListOnDay: GoalListOnDayModel
    
    var body: some View {
        if goalListOnDay.goalList.count > 0 {
            VStack {
                Spacer().frame(height: CGFloat.fontSize)
                ViewThatFits(in: .vertical) {
                    DailyRecordList(
                        year: year, month: month, day: day,
                        goalListOnDay: $goalListOnDay
                    )
                    ScrollView {
                        DailyRecordList(
                            year: year, month: month, day: day,
                            goalListOnDay: $goalListOnDay
                        )
                    }
                }
                Spacer().frame(height: CGFloat.fontSize * 15)
                Spacer()
            }
        } else {
            DailyNoRecord()
        }
    }
}

#Preview {
    CalendarDayView()
}
