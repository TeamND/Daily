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
            CustomDivider(color: .primary, height: 2, hPadding: CGFloat.fontSize).padding(12)
            TabView(selection: $dailyCalendarViewModel.yearSelection) {
                ForEach(dailyCalendarViewModel.yearSelections, id: \.self) { year in
                    CalendarYear(
                        year: Int(year)!,
                        ratingsOnYear: dailyCalendarViewModel.yearDictionary[year] ?? Array(repeating: Array(repeating: 0, count: 31), count: 12),
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
                        dailyCalendarViewModel.calendarYearOnAppear(yearSelection: year)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, CGFloat.fontSize)
            .background(Colors.theme)
            .onChange(of: dailyCalendarViewModel.yearSelection) { yearSelection in
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
            ForEach(1 ..< 13) { month in
                Button {
                    action(month)
                } label: {
                    DailyMonthOnYear(year: year, month: month, ratings: ratingsOnYear[month - 1])
                }
            }
        }
        .padding(CGFloat.fontSize)
        .background(Colors.background)
        .cornerRadius(20)
        .frame(maxHeight: .infinity, alignment: .top)
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
        VStack(alignment: .leading) {
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
            Spacer()
        }
        .foregroundStyle(Colors.reverse)
        .frame(maxWidth: .infinity, alignment: .top)
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
