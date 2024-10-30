//
//  CalendarYearView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

// MARK: - CalendarYearView
struct CalendarYearView: View {
    @ObservedObject var dailyCalendarViewModel: DailyCalendarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            DailyCalendarHeader(type: .year, backButton: .constant(0), title: $dailyCalendarViewModel.year)
            CustomDivider(color: .primary, height: 2, hPadding: CGFloat.fontSize).padding(12)
            TabView(selection: $dailyCalendarViewModel.yearSelection) {
                ForEach(-10 ... 10, id: \.self) { index in
                    let year = Date().year + index
                    let yearSelection = year.formatDateString(type: .year)
                    CalendarYear(year: year, action: dailyCalendarViewModel.selectMonth)
                        .tag(yearSelection)
                        .onAppear {
                            dailyCalendarViewModel.calendarYearOnAppear()
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, CGFloat.fontSize)
            .background(Colors.theme)
            .onChange(of: dailyCalendarViewModel.yearSelection) { yearSelection in
                guard let year = Int(yearSelection) else { return }
                dailyCalendarViewModel.setYear(year)
            }
        }
        .overlay {
            DailyAddGoalButton()
        }
    }
}

// MARK: - CalendarYear
struct CalendarYear: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    let year: Int
    let action: (Int) -> Void
    
    var body: some View {
        VStack {
            VStack(spacing: CGFloat.fontSize * 4) {
                ForEach (0 ..< 4) { rowIndex in
                    HStack {
                        ForEach (0 ..< 3) { colIndex in
                            let month = (rowIndex * 3) + colIndex + 1
                            Button {
                                action(month)
                            } label: {
                                DailyMonthOnYear(year: year, month: month)
                            }
                        }
                    }
                }
            }
            .padding(CGFloat.fontSize)
            .background(Colors.background)
            .cornerRadius(20)
            Spacer()
        }
    }
}

// MARK: - DailyMonthOnYear
struct DailyMonthOnYear: View {
    let year: Int
    let month: Int
    let startDayIndex: Int
    let lengthOfMonth: Int
    
    init(year: Int, month: Int) {
        self.year = year
        self.month = month
        self.startDayIndex = CalendarServices.shared.startDayIndex(year: year, month: month)
        self.lengthOfMonth = CalendarServices.shared.lengthOfMonth(year: year, month: month)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(month)월")
                .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                .padding(4)
            ForEach (0 ..< 6) { rowIndex in
                HStack(spacing: 1) {
                    ForEach (0 ..< 7) { colIndex in
                        ZStack {
                            let day: Int = rowIndex * 7 + colIndex - startDayIndex + 1
                            if 1 <= day && day <= lengthOfMonth {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: CGFloat.fontSize * 2))
                                    .foregroundStyle(Colors.daily.opacity(0.2))
//                                    .foregroundColor(Colors.daily.opacity(calendarViewModel.getDayOfRatingOnYear(monthIndex: month-1, dayIndex: day-1)*0.8))
                                Text("\(day)")
                                    .font(.system(size: CGFloat.fontSize, weight: .bold))
                            } else {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: CGFloat.fontSize * 2))
                                    .foregroundColor(Colors.daily.opacity(0))
                                    .opacity(0)
                                Text("1")
                                    .font(.system(size: CGFloat.fontSize, weight: .bold))
                                    .opacity(0)
                            }
                        }
                    }
                }
            }
        }
        .foregroundStyle(Colors.reverse)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CalendarYearView(dailyCalendarViewModel: DailyCalendarViewModel())
}
