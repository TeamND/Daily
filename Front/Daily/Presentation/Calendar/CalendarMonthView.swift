//
//  CalendarMonthView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

// MARK: - CalendarMonthView
struct CalendarMonthView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var dailyCalendarViewModel: DailyCalendarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            DailyCalendarHeader(type: .month, backButton: $dailyCalendarViewModel.year, title: $dailyCalendarViewModel.month)
            DailyWeekIndicator()
            CustomDivider(color: .primary, height: 2, hPadding: CGFloat.fontSize * 2)
            TabView(selection: $dailyCalendarViewModel.selection) {
                ForEach(-10 ... 10, id: \.self) { year in
                    ForEach(1 ... 12, id: \.self) { month in
                        let tag = "\(String(2024 + year))-\(String(month))-\(String(dailyCalendarViewModel.day))"
                        CalendarMonth(year: dailyCalendarViewModel.year + year, month: month, action: action)
                            .tag(tag)
                            .onAppear {
                                dailyCalendarViewModel.onAppear(tag)
                            }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, CGFloat.fontSize)
            .background(Colors.theme)
        }
        .overlay {
            DailyAddGoalButton()
        }
        .onAppear {
            print("month onAppear")
        }
    }
    
    private func action(day: Int) {
        print("selected day is \(day)")
    }
}

// MARK: - CalendarMonth
struct CalendarMonth: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    let year: Int
    let month: Int
    let action: (Int) -> Void
    
    var body: some View {
        let startDayIndex = CalendarServices.shared.startDayIndex(year: year, month: month)
        let lengthOfMonth = CalendarServices.shared.lengthOfMonth(year: year, month: month)
        let dividerIndex = (lengthOfMonth + startDayIndex - 1) / 7
        
        VStack {
            VStack {
                ForEach (0 ... dividerIndex, id: \.self) { rowIndex in
                    HStack(spacing: 0) {
                        ForEach (0 ..< 7) { colIndex in
                            let day: Int = rowIndex * 7 + colIndex - startDayIndex + 1
                            if 1 <= day && day <= lengthOfMonth {
                                Button {
                                    print("select day is \(day)")
                                    let navigationObject = NavigationObject(viewType: .calendarDay)
                                    navigationEnvironment.navigationPath.append(navigationObject)
                                } label: {
                                    DailyDayOnMonth(day: day)
//                                    DayOnMonth(calendarViewModel: calendarViewModel, day: day, dayOnMonth: calendarViewModel.getDaysOnMonth(dayIndex: day-1))
                                }
                            } else {
                                DailyDayOnMonth(day: 1).opacity(0)
                            }
                        }
                    }
                    if rowIndex < dividerIndex { CustomDivider() }
                }
            }
            .padding(CGFloat.fontSize)
            .background(Colors.background)
            .cornerRadius(20)
            Spacer()
        }
    }
}

// MARK: - DailyDayOnMonth
struct DailyDayOnMonth: View {
    let day: Int
    
    var body: some View {
//        let symbols = dayOnMonth.symbol
        let maxSymbolNum = UIDevice.current.model == "iPad" ? 6 : 4
        VStack(alignment: .leading) {
            ZStack {
                Image(systemName: "circle.fill")
                    .font(.system(size: CGFloat.fontSize * 4))
                    .foregroundColor(Colors.daily.opacity(0.8))
//                    .foregroundColor(Colors.daily.opacity(dayOnMonth.rating*0.8))
                Text("\(day)")
                    .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
            }
            .padding(4)
            VStack(alignment: .center, spacing: 8) {
                ForEach(0 ..< maxSymbolNum, id: \.self) { index in
                    if index % 2 == 0 {
                        HStack(spacing: 0) {
                            ForEach(0 ..< 4, id: \.self) { symbolIndex in
//                            ForEach(symbols.indices, id: \.self) { symbolIndex in
                                if index <= symbolIndex && symbolIndex < index + 2 {
//                                    SymbolOnMonth(symbol: symbols[symbolIndex], isEllipsis: index == maxSymbolNum - 2 && symbols.count > maxSymbolNum && symbolIndex == maxSymbolNum - 1)
                                    SymbolOnMonth(symbol: symbolOnMonthModel(), isEllipsis: true)
                                }
                            }
//                            if index >= symbols.count - 1 {
//                                SymbolOnMonth(symbol: symbolOnMonthModel(), isEllipsis: false)
//                            }
                        }
                    }
                }
            }
            .padding(.bottom, 4)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.green, lineWidth: 2)
//                .opacity(calendarViewModel.isToday(day: day) ? 1 : 0)
        }
        .padding(4)
        .frame(maxWidth: .infinity)
        .foregroundStyle(Colors.reverse)
    }
}

#Preview {
    CalendarMonthView(dailyCalendarViewModel: DailyCalendarViewModel())
}
