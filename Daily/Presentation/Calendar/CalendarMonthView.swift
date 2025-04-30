//
//  CalendarMonthView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

// MARK: - CalendarMonthView
struct CalendarMonthView: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            CalendarHeader(type: .month)
            Spacer().frame(height: 12)
            SymbolFilter(type: .month)
            Spacer().frame(height: 12)
            WeekIndicator(mode: .none)
            Spacer().frame(height: 6)
            TabView(selection: calendarViewModel.bindSelection(type: .month)) {
                ForEach(-1 ... 12, id: \.self) { index in
                    let (date, direction, selection) = calendarViewModel.calendarInfo(type: .month, index: index)
                    Group {
                        if direction == .current { CalendarMonth(date: date, selection: selection) }
                        else { CalendarLoadView(type: .month, direction: direction) }
                    }
                    .tag(selection)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, 16)
        }
        .overlay {
            AddGoalButton()
        }
        .background(Colors.Background.primary)
    }
}

// MARK: - CalendarMonth
struct CalendarMonth: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    @EnvironmentObject private var navigationEnvironment: NavigationEnvironment
    
    let date: Date
    let selection: String
    
    var body: some View {
        let (startOfMonthWeekday, lengthOfMonth, dividerCount) = calendarViewModel.monthInfo(date: date)
        let monthData = calendarViewModel.monthData[selection] ?? MonthDataModel()
        LazyVStack {
            ForEach (0 ... dividerCount, id: \.self) { rowIndex in
                HStack(spacing: 4) {
                    ForEach (.zero ..< GeneralServices.week, id: \.self) { colIndex in
                        if .zero < colIndex { Spacer() }
                        let day: Int = rowIndex * GeneralServices.week + colIndex - (startOfMonthWeekday - 1) + 1
                        if 1 <= day && day <= lengthOfMonth {
                            Button {
                                calendarViewModel.setDate(year: date.year, month: date.month, day: day)
                                navigationEnvironment.navigate(NavigationObject(viewType: .calendarDay))
                            } label: {
                                DailyDayOnMonth(year: date.year, month: date.month, day: day, dayOnMonth: monthData.daysOnMonth[day - 1])
                            }
                        } else { DailyDayOnMonth().opacity(0) }
                    }
                }
                .padding(.horizontal, 2)
                if rowIndex < dividerCount { DailyDivider(color: Colors.Border.secondary, height: 1) }
            }
        }
        .vTop()
        .onAppear {
            calendarViewModel.fetchMonthData(selection: selection)
        }
    }
}

// MARK: - DailyDayOnMonth
struct DailyDayOnMonth: View {
    private let year: Int
    private let month: Int
    private let day: Int
    private let dailySymbols: [DailySymbol]
    private let rating: Double?
    
    init(year: Int = 0, month: Int = 0, day: Int = 0, dayOnMonth: DayOnMonth = DayOnMonth()) {
        self.year = year
        self.month = month
        self.day = day
        self.dailySymbols = dayOnMonth.symbols
        self.rating = dayOnMonth.rating
    }
    
    var body: some View {
        TimelineView(.everyDay) { context in
            let maxSymbolNum = 6/*UIDevice.current.model == "iPad" ? 6 : 4*/
            let isToday = year == context.date.year && month == context.date.month && day == context.date.day
            VStack(spacing: .zero) {
                DayIndicator(day: day, rating: rating, isToday: isToday)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 2), spacing: 1) {
                    ForEach(0 ..< maxSymbolNum, id: \.self) { symbolIndex in
                        if symbolIndex < dailySymbols.count {
                            DailySymbolOnMonth(
                                dailySymbol: dailySymbols[symbolIndex],
                                isEllipsis: dailySymbols.count > maxSymbolNum && symbolIndex == maxSymbolNum - 1
                            )
                        } else { DailySymbolOnMonth(dailySymbol: DailySymbol(), isEllipsis: false) }
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 6)
            }
            .frame(width: 33)   // FIXME: (아마 LazyVGrid의 특성 때문에) width의 사용이 강제되고 symbolGrid자체에도 horizontal padding이 강제됨, 추후 minWidth를 사용하고 자식뷰로부터 너비를 가져오도록 수정
        }
    }
}

// MARK: - DailySymbolOnMonth
struct DailySymbolOnMonth: View {
    let dailySymbol: DailySymbol
    let isEllipsis: Bool
    
    var body: some View {
        Group {
            if isEllipsis { Image(systemName: "ellipsis") } // FIXME: 추후 디자인 아이콘으로 수정
            else if let symbol = dailySymbol.symbol {
                Image(symbol.icon(isSuccess: dailySymbol.isSuccess))
                    .resizable()
                    .scaledToFit()
            } else {
                Spacer()
            }
        }
        .frame(width: 14, height: 14)
    }
}


#Preview {
    CalendarMonthView()
}
