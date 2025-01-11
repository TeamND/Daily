//
//  CalendarYearView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

// MARK: - CalendarYearView
struct CalendarYearView: View {
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            DailyCalendarHeader(type: .year)
            CustomDivider(color: Colors.reverse, height: 2, hPadding: CGFloat.fontSize * 2)
            Spacer().frame(height: CGFloat.fontSize)
            TabView(selection: dailyCalendarViewModel.bindSelection(type: .year)) {
                ForEach(-1 ... 10, id: \.self) { index in
                    let (date, direction, selection) = dailyCalendarViewModel.getCalendarInfo(type: .year, index: index)
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
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    let date: Date
    let selection: String
    var ratingsOfYear: [[Double]] {
        dailyCalendarViewModel.yearDictionary[selection] ?? Array(repeating: Array(repeating: 0.0, count: 31), count: 12)
    }
    
    var body: some View {
        LazyVStack(spacing: .zero) {
            VStack(spacing: CGFloat.fontSize * 2) {
                ForEach(0 ..< 4) { row in
                    HStack(spacing: .zero) {
                        ForEach(0 ..< 3) { col in
                            let month = row * 3 + col + 1
                            Button {
                                dailyCalendarViewModel.setDate(year: date.year, month: month)
                                navigationEnvironment.navigate(NavigationObject(viewType: .calendarMonth))
                            } label: {
                                DailyMonthOnYear(year: date.year, month: month, ratingsOfMonth: ratingsOfYear[month - 1])
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
            dailyCalendarViewModel.calendarYearOnAppear(modelContext: modelContext, date: date, selection: selection)
        }
    }
}

// MARK: - DailyMonthOnYear
struct DailyMonthOnYear: View {
    let year: Int
    let month: Int
    let ratingsOfMonth: [Double]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(month)월")
                .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                .padding(CGFloat.fontSize)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: .zero) {
                let date: Date = CalendarServices.shared.getDate(year: year, month: month, day: 1) ?? Date(format: .daily)
                ForEach(CalendarServices.shared.getDaysInMonth(date: date), id: \.id) { item in
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
