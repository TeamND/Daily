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
    @EnvironmentObject var loadingViewModel: LoadingViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            DailyCalendarHeader(type: .year)
            CustomDivider(color: Colors.reverse, height: 2, hPadding: CGFloat.fontSize * 2)
            Spacer().frame(height: CGFloat.fontSize)
            TabView(selection: $dailyCalendarViewModel.yearSelection) {
                ForEach(dailyCalendarViewModel.yearSelections, id: \.self) { yearSelection in
                    let selections = CalendarServices.shared.separateSelection(yearSelection)
                    let year = selections[0]
                    CalendarYear(
                        year: year,
                        ratingsOnYear: dailyCalendarViewModel.yearDictionary[yearSelection] ?? Array(repeating: Array(repeating: 0, count: 31), count: 12),
                        action: {
                            dailyCalendarViewModel.setDate(
                                dailyCalendarViewModel.getDate(type: .year),
                                $0,
                                1
                            )
                            let navigationObject = NavigationObject(viewType: .calendarMonth)
                            navigationEnvironment.navigate(navigationObject)
                        }
                    )
                    .onAppear {
                        dailyCalendarViewModel.calendarYearOnAppear(yearSelection: yearSelection)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, CGFloat.fontSize)
            .background(Colors.theme)
            .onChange(of: dailyCalendarViewModel.yearSelection) { yearSelection in
                dailyCalendarViewModel.checkCurrentCalendar(type: .year, selection: yearSelection)
                loadingViewModel.loading()
                if navigationEnvironment.navigationPath.last == nil {
                    guard let year = Int(yearSelection) else { return }
                    dailyCalendarViewModel.setDate(year, 1, 1)
                }
            }
        }
        .overlay {
            DailyAddGoalButton()
        }
        .onAppear {
            dailyCalendarViewModel.loadSelections(type: .year)
        }
    }
}

// MARK: - CalendarYear
struct CalendarYear: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    let year: Int
    let ratingsOnYear: [[Double]]
    let action: (Int) -> Void
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: .zero) {
            ForEach(1 ... 12, id: \.self) { month in
                Button {
                    action(month)
                } label: {
                    DailyMonthOnYear(year: year, month: month, ratings: ratingsOnYear[month - 1])
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
    
    init(year: Int, month: Int, ratings: [Double]) {
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
