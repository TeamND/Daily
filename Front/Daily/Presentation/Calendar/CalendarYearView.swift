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
        VStack {
            VStack(spacing: CGFloat.fontSize * 4) {
                ForEach (0 ..< 4) { rowIndex in
                    HStack {
                        ForEach (0 ..< 3) { colIndex in
                            let month = (rowIndex * 3) + colIndex + 1
                            Button {
                                action(month)
                            } label: {
                                DailyMonthOnYear(year: year, month: month, ratings: ratingsOnYear[month - 1])
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
    let ratings: [Double]
    let startDayIndex: Int
    let lengthOfMonth: Int
    
    init(year: Int, month: Int, ratings: [Double]) {
        self.year = year
        self.month = month
        self.ratings = ratings
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
                                    .foregroundStyle(Colors.daily.opacity(ratings[day-1]*0.8))
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
    CalendarYearView()
}
