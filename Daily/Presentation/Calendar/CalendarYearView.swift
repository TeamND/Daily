//
//  CalendarYearView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

// MARK: - CalendarYearView
struct CalendarYearView: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            DailyCalendarHeader(type: .year)
            DailySymbolFilter()
            CustomDivider(color: Colors.reverse, height: 2, hPadding: CGFloat.fontSize * 2)
            Spacer().frame(height: CGFloat.fontSize)
            TabView(selection: calendarViewModel.bindSelection(type: .year)) {
                ForEach(-1 ... 10, id: \.self) { index in
                    let (date, direction, selection) = calendarViewModel.calendarInfo(type: .year, index: index)
                    Group {
                        if direction == .current { CalendarYear(date: date, selection: selection) }
                        else { CalendarLoadView(type: .year, direction: direction) }
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

// MARK: - CalendarYear
struct CalendarYear: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    @EnvironmentObject private var navigationEnvironment: NavigationEnvironment
    
    let date: Date
    let selection: String
    
    var body: some View {
        let yearData = calendarViewModel.yearData[selection] ?? YearDataModel()
        LazyVStack(spacing: .zero) {
            VStack(spacing: CGFloat.fontSize * 2) {
                ForEach(0 ..< 4) { row in
                    HStack(spacing: .zero) {
                        ForEach(0 ..< 3) { col in
                            let month = row * 3 + col + 1
                            Button {
                                calendarViewModel.setDate(year: date.year, month: month)
                                navigationEnvironment.navigate(NavigationObject(viewType: .calendarMonth))
                            } label: {
                                DailyMonthOnYear(year: date.year, month: month, ratingsOfMonth: yearData.ratings[month - 1])
                            }
                        }
                    }
                }
            }
            .padding(CGFloat.fontSize)
            .foregroundStyle(Colors.reverse)
            .background(Colors.background)
            .cornerRadius(20)
        }
        .vTop()
        .onAppear {
            calendarViewModel.fetchYearData(selection: selection)
        }
    }
}

// MARK: - DailyMonthOnYear
struct DailyMonthOnYear: View {
    @AppStorage(UserDefaultKey.startDay.rawValue) var startDay: Int = 0
    
    let year: Int
    let month: Int
    let ratingsOfMonth: [Double]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(month)월")
                .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                .padding(CGFloat.fontSize)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: GeneralServices.week), spacing: .zero) {
                let date: Date = CalendarServices.shared.getDate(year: year, month: month, day: 1) ?? Date(format: .daily)
                ForEach(CalendarServices.shared.getDaysInMonth(date: date, startDay: startDay), id: \.id) { item in
                    if item.date.month == month {
                        let day = item.date.day
                        DailyDayOnYear(day: day, rating: ratingsOfMonth[day - 1])
                    } else { Spacer() }
                }
            }
        }
        .padding(.horizontal, CGFloat.fontSize)
    }
}

// MARK: - DailyDayOnYear
struct DailyDayOnYear: View {
    let day: Int
    let rating: Double
    
    var body: some View {
        Text("\(day)")
            .font(.system(size: CGFloat.fontSize, weight: .bold))
            .background {
                Image(systemName: "circle.fill")
                    .font(.system(size: CGFloat.fontSize * 2))
                    .foregroundStyle(Colors.daily.opacity(rating * 0.8))
            }
            .padding(.vertical, CGFloat.fontSize / 2)
    }
}

#Preview {
    CalendarYearView()
}
