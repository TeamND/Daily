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
            CalendarHeader(type: .year)
            Spacer().frame(height: 12)
            SymbolFilter(type: .year)
            Spacer().frame(height: 12)
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
            Spacer().frame(height: 48)
        }
        .overlay {
            AddGoalButton()
        }
        .background(Colors.Background.primary)
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
        VStack(spacing: .zero) {
            ForEach(0 ..< 4) { row in
                if .zero < row { DailySpacer() }
                HStack(spacing: .zero) {
                    ForEach(0 ..< 3) { col in
                        if .zero < col { DailySpacer() }
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
        .padding(.horizontal, 16)
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
    let ratingsOfMonth: [Double?]
    
    // TODO: 좀 더 확실한 분기처리 방식을 찾아 적용
    let spacing = (UIScreen.main.bounds.width - 16 * 2 - 13 * 7 * 3) / 22
    let ratio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
    
    var body: some View {
        VStack(alignment: .leading, spacing: max(spacing, spacing * (ratio - 1))) {
            Text("\(month)월")
                .font(ratio < 2 ? Fonts.bodyLgSemiBold : Fonts.headingSmSemiBold)
                .foregroundStyle(Colors.Text.primary)
            
            VStack(spacing: spacing * (ratio - 1)) {
                let date = CalendarServices.shared.getDate(year: year, month: month, day: 1) ?? Date(format: .daily)
                let startWeekday = date.dailyWeekday(startDay: startDay)
                let lengthOfMonth = Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
                
                ForEach(0 ..< 6) { row in
                    HStack(spacing: spacing) {
                        ForEach(0 ..< 7) { col in
                            let day = row * 7 + col + 1 - startWeekday
                            if 1 <= day && day <= lengthOfMonth {
                                DailyDayOnYear(day: day, rating: ratingsOfMonth[day - 1])
                            } else { DailyDayOnYear().opacity(0) }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - DailyDayOnYear
struct DailyDayOnYear: View {
    private let day: Int
    private let rating: Double?
    
    init(day: Int = 0, rating: Double? = nil) {
        self.day = day
        self.rating = rating
    }
    
    var body: some View {
        Text("\(day)")
            .font(Fonts.bodyXsmRegular)
            .foregroundStyle(rating ?? .zero < 1.0 ? Colors.Text.primary : Colors.Text.inverse)
            .frame(width: 13, height: 13)
            .if(rating != nil) { view in
                view.background {
                    Circle().stroke(Colors.Icon.interactivePressed, style: StrokeStyle(lineWidth: 1, lineCap: .round))
                }
            }
            .if(rating ?? .zero >= 1.0) { view in
                view.background {
                    Circle().fill(Colors.Icon.interactivePressed)
                }
            }
    }
}

#Preview {
    CalendarYearView()
}
