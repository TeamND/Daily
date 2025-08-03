//
//  CalendarDayView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

// MARK: - CalendarDayView
struct CalendarDayView: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    var body: some View {
        let weekSelection = calendarViewModel.currentDate.getSelection(type: .week)
        VStack(spacing: .zero) {
            CalendarHeader(type: .day)
            Spacer().frame(height: 12)
            WeekIndicator(mode: .change, selection: weekSelection)
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
    }
}

// MARK: - CalendarDay
struct CalendarDay: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    let selection: String
    
    var body: some View {
        let dayData = calendarViewModel.dayData[selection] ?? DayDataModel()
        VStack(spacing: .zero) {
            if dayData.recordsInList.isEmpty {
                NoRecord(isEmpty: dayData.isEmpty)
            } else {
                ViewThatFits(in: .vertical) {
                    RecordList(selection: selection, recordsInList: dayData.recordsInList)
                    ScrollView {
                        RecordList(selection: selection, recordsInList: dayData.recordsInList)
                    }
                }
                Spacer().frame(height: 32)
            }
        }
        .padding(.horizontal, 16)
        .onAppear {
            calendarViewModel.fetchDayData(selection: selection)
        }
    }
}

#Preview {
    CalendarDayView()
}
