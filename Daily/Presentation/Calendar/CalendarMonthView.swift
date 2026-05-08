//
//  CalendarMonthView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

// MARK: - CalendarMonthView
struct CalendarMonthView: View {
    @EnvironmentObject private var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            CalendarHeader(type: .month)
            Spacer().frame(height: 12)
            SymbolFilter(type: .month)
            Spacer().frame(height: 12)
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
        }
        .overlay {
            AddGoalButton()
        }
        .background(Colors.Background.primary)
        .onAppear {
            if UserDefaultManager.calendarType == .month {
//                calendarViewModel.fetchMonthData(selection: calendarViewModel.currentDate.getSelection(type: .month))
                AnalyticsManager.shared.log(.viewMonthlyCalendar)
            }
        }
        .onChange(of: calendarViewModel.currentDate.getSelection(type: .month) ) { _, selection in
            if navigationEnvironment.navigationPath.last?.viewType == .calendarMonth {
//                calendarViewModel.fetchMonthData(selection: selection)
                // FIXME: 이동에 대한 로그를 찍을지? 버튼으로 인한 이동과 스와이프 이동을 어떻게 구분할지?
            }
        }
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
        
        LazyVStack(spacing: .zero) {
            WeekIndicator(mode: .none)
            VStack(spacing: .zero) {
                ForEach (0 ..< GeneralServices.maxLineCount, id: \.self) { rowIndex in
                    Spacer().frame(height: 4)
                    HStack(spacing: GeneralServices.daySpacing) {
                        ForEach (.zero ..< GeneralServices.week, id: \.self) { colIndex in
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
                    Spacer().frame(minHeight: 4)
                    if rowIndex < dividerCount { DailyDivider(color: Colors.Border.secondary, height: 1) }
                }
            }
        }
        .vTop()
        .padding(.horizontal, 16)
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
            let date = CalendarServices.shared.formatDateString(year: year, month: month, day: day)
            let isHoliday = UserDefaultManager.holidays?[year]?[date] != nil || date.toDate()?.weekday == 1
            let isToday = year == context.date.year && month == context.date.month && day == context.date.day
            
            VStack(alignment: .center, spacing: 6) {
                DayIndicator(day: day, rating: rating, isToday: isToday, isHoliday: isHoliday)
                DailySymbolsOnMonth(dailySymbols: dailySymbols)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - DailySymbolsOnMonth
struct DailySymbolsOnMonth: View {
    let dailySymbols: [DailySymbol]
    
    var body: some View {
        let maxSymbolRow = CalendarServices.shared.row
        let maxSymbolCol = CalendarServices.shared.col
        let maxSymbolNum = maxSymbolRow * maxSymbolCol
        
        VStack(spacing: 1) {
            ForEach(.zero ..< maxSymbolRow, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(.zero ..< maxSymbolCol, id: \.self) { col in
                        let symbolIndex = row * maxSymbolCol + col
                        if symbolIndex < dailySymbols.count {
                            DailySymbolOnMonth(
                                dailySymbol: dailySymbols[symbolIndex],
                                isMore: dailySymbols.count > maxSymbolNum && symbolIndex == maxSymbolNum - 1
                            )
                        } else { DailySymbolOnMonth(dailySymbol: DailySymbol(), isMore: false) }
                    }
                }
            }
        }
    }
}

// MARK: - DailySymbolOnMonth
struct DailySymbolOnMonth: View {
    let dailySymbol: DailySymbol
    let isMore: Bool
    
    var body: some View {
        Group {
            if isMore {
                Image(.more)
                    .resizable()
                    .scaledToFit()
            } else if let symbol = dailySymbol.symbol {
                Image(symbol.icon(isSuccess: dailySymbol.isSuccess))
                    .resizable()
                    .scaledToFit()
            } else {
                Spacer()
            }
        }
        // FIXME: 화면 너비에 따라 16px 크기 확장(?)
        .frame(width: 14, height: 14)
    }
}


#Preview {
    CalendarMonthView()
}
