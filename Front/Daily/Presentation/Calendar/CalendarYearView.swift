//
//  CalendarYearView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

// MARK: - CalendarYearView
struct CalendarYearView: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    
    var body: some View {
        let yearSelection = Binding(    // TODO: 추후 수정
            get: { return CalendarServices.shared.formatDateString(year: dailyCalendarViewModel.currentDate.year) },
            set: {
                let year = CalendarServices.shared.separateSelection($0)[0]
                dailyCalendarViewModel.currentDate = CalendarServices.shared.getDate(year: year, month: 1, day: 1) ?? Date()
            }
        )
        VStack(spacing: .zero) {
            DailyCalendarHeader(type: .year)
            CustomDivider(color: Colors.reverse, height: 2, hPadding: CGFloat.fontSize * 2)
            Spacer().frame(height: CGFloat.fontSize)
            TabView(selection: yearSelection) {
                ForEach(-1 ... 10, id: \.self) { unit in
                    let year = dailyCalendarViewModel.decade + unit
                    let yearSelection = CalendarServices.shared.formatDateString(year: year)
                    Group {
                        if 0 <= unit && unit < 10 {
                            CalendarYear(
                                year: year,
                                action: {
                                    guard let currentDate = CalendarServices.shared.getDate(year: year, month: $0, day: 1) else { return }
                                    dailyCalendarViewModel.currentDate = currentDate
                                    let navigationObject = NavigationObject(viewType: .calendarMonth)
                                    navigationEnvironment.navigate(navigationObject)
                                }
                            )
                        } else { CalendarLoadView(type: .year, direction: unit < 0 ? .prev : .next) }
                    }
                    .tag(yearSelection)
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
    let year: Int
    let action: (Int) -> Void
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: .zero) {
            ForEach(1 ... 12, id: \.self) { month in
                Button {
                    action(month)
                } label: {
                    DailyMonthOnYear(year: year, month: month)
                }
            }
        }
        .padding(CGFloat.fontSize)
        .padding(.vertical, -CGFloat.fontSize * 2)
        .background(Colors.background)
        .cornerRadius(20)
        .vTop()
    }
}

// MARK: - DailyMonthOnYear
struct DailyMonthOnYear: View {
    let year: Int
    let month: Int
    let ratings: [Double]
    
    init(year: Int, month: Int, ratings: [Double] = Array(repeating: 0, count: 31)) {
        self.year = year
        self.month = month
        self.ratings = ratings
    }
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Text("\(month)월")
                .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                .padding(4)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: .zero) {
                let date: Date = CalendarServices.shared.getDate(year: year, month: month, day: 1) ?? Date()
                ForEach(CalendarServices.shared.getDaysInMonth(date: date), id: \.id) { item in
                    if item.date.month == month {
                        let day = item.date.day
                        DailyDayOnYear(day: day, rating: ratings[day - 1])
                    } else { Spacer() }
                }
            }
        }
        .foregroundStyle(Colors.reverse)
        .vTop()
        .padding(.horizontal, CGFloat.fontSize)
        .padding(.vertical, CGFloat.fontSize * 2)
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
