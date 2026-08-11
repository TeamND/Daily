//
//  CalendarDayView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

// MARK: - CalendarDayView
struct CalendarDayView: View {
    @EnvironmentObject private var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    var body: some View {
        let weekSelection = calendarViewModel.currentDate.getSelection(type: .week)
        VStack(spacing: .zero) {
            CalendarHeader(type: .day)
            Spacer().frame(height: 12)
            WeekIndicator(mode: .change, selection: weekSelection).padding(.horizontal, 16)
            Spacer().frame(height: 20)
            SymbolFilter(type: .day)
            Spacer().frame(height: 12)
            TabView(selection: calendarViewModel.bindSelection(type: .day)) {
                ForEach(-1 ... GeneralServices.week, id: \.self) { index in
                    let (_, direction, selection) = calendarViewModel.calendarInfo(type: .day, index: index)
                    Group {
                        if direction == .current { CalendarDay(selection: selection) }
                        else { CalendarLoadView(type: .day, direction: direction) }
                    }
                    .tag(selection)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .overlay {
            AddGoalButton()
        }
        .background(Colors.Background.primary)
        .onAppear {
            calendarViewModel.fetchDayData(selection: calendarViewModel.currentDate.getSelection(type: .day))
            if UserDefaultManager.calendarType == .day {
                AnalyticsManager.shared.log(.openDailyCalendar)
            }
        }
        .onChange(of: calendarViewModel.currentDate.getSelection(type: .day) ) { beforeSelection, selection in
            if navigationEnvironment.navigationPath.last?.viewType == .calendarDay {
                calendarViewModel.fetchDayData(selection: selection)
                
                let direction: Direction = beforeSelection > selection ? .left : .right
                AnalyticsManager.shared.log(.navigateCalendar, .direction(direction), .calendar_type(.day))
            }
        }
    }
}

// MARK: - CalendarDay
struct CalendarDay: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    let selection: String
    
    var body: some View {
        let dayData = calendarViewModel.dayData[selection] ?? DayDataModel()
        VStack(spacing: .zero) {
            HolidayView(selection: selection)
            Spacer().frame(height: 12)
            if dayData.recordsInList.isEmpty {
                NoRecord(isEmpty: dayData.isEmpty)
            } else {
                ViewThatFits(in: .vertical) {
                    RecordList(recordsInList: dayData.recordsInList)
                    ScrollView {
                        RecordList(recordsInList: dayData.recordsInList)
                    }
                }
                Spacer().frame(height: 32)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    CalendarDayView()
}
