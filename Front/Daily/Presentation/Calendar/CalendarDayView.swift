//
//  CalendarDayView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI
import SwiftData

// MARK: - CalendarDayView
struct CalendarDayView: View {
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            DailyCalendarHeader(type: .day)
            DailyWeekIndicator(mode: .change)
            CustomDivider(color: Colors.reverse, height: 2, hPadding: CGFloat.fontSize * 2)
            Spacer().frame(height: CGFloat.fontSize)
            TabView(selection: dailyCalendarViewModel.bindSelection(type: .day)) {
                ForEach(-1 ... 7, id: \.self) { index in
                    let (date, direction, selection) = dailyCalendarViewModel.getCalendarInfo(type: .day, index: index)
                    Group {
                        if direction == .current {
                            CalendarDay(year: date.year, month: date.month, day: date.day, goalListOnDay: .constant(GoalListOnDayModel()))
                        } else { CalendarLoadView(type: .day, direction: direction) }
                    }
                    .tag(selection)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, CGFloat.fontSize)
            .background(Colors.theme)
        }
        .overlay {
            DailyAddGoalButton()
        }
    }
}
// MARK: - CalendarDay
struct CalendarDay: View {
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    @Environment(\.modelContext) private var modelContext
    let year: Int
    let month: Int
    let day: Int
    @Binding var goalListOnDay: GoalListOnDayModel
    
    var body: some View {
        if let goalList = goalListOnDay.goalList {
            if goalList.count > 0 {
                VStack {
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
        } else {
            ProgressView()
        }
    }
}

#Preview {
    CalendarDayView()
}
