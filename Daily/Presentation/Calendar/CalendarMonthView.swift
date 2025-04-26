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
            SymbolFilter()
            Spacer().frame(height: 12)
            WeekIndicator(mode: .none)
            DailyWeekIndicator()
            CustomDivider(color: Colors.reverse, height: 2, hPadding: CGFloat.fontSize * 2)
            Spacer().frame(height: CGFloat.fontSize)
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
            .padding(.horizontal, CGFloat.fontSize)
            .background(Colors.theme)
        }
        .overlay {
            AddGoalButton()
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
        let monthDatas = calendarViewModel.monthData[selection] ?? Array(repeating: MonthDataModel(), count: lengthOfMonth)
        LazyVStack {
            ForEach (0 ... dividerCount, id: \.self) { rowIndex in
                HStack(spacing: 0) {
                    ForEach (.zero ..< GeneralServices.week, id: \.self) { colIndex in
                        let day: Int = rowIndex * GeneralServices.week + colIndex - (startOfMonthWeekday - 1) + 1
                        if 1 <= day && day <= lengthOfMonth {
                            Button {
                                calendarViewModel.setDate(year: date.year, month: date.month, day: day)
                                navigationEnvironment.navigate(NavigationObject(viewType: .calendarDay))
                            } label: {
                                DailyDayOnMonth(year: date.year, month: date.month, day: day, monthData: monthDatas[day - 1])
                            }
                        } else { DailyDayOnMonth().opacity(0) }
                    }
                }
                if rowIndex < dividerCount { CustomDivider(hPadding: 20) }
            }
        }
        .padding(CGFloat.fontSize)
        .foregroundStyle(Colors.reverse)
        .background(Colors.background)
        .cornerRadius(20)
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
    private let rating: Double
    
    init(year: Int = 0, month: Int = 0, day: Int = 0, monthData: MonthDataModel = MonthDataModel()) {
        self.year = year
        self.month = month
        self.day = day
        self.dailySymbols = monthData.symbols
        self.rating = monthData.rating
    }
    
    var body: some View {
        TimelineView(.everyDay) { context in
            let maxSymbolNum = UIDevice.current.model == "iPad" ? 6 : 4
            VStack(alignment: .leading, spacing: .zero) {
                ZStack {
                    Image(systemName: "circle.fill")
                        .font(.system(size: CGFloat.fontSize * 4))
                        .foregroundStyle(Colors.daily.opacity(rating * 0.8))
                    Text("\(day)")
                        .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
                }
                .padding(CGFloat.fontSize)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: .zero), count: 2), spacing: CGFloat.fontSize * 2) {
                    ForEach(0 ..< maxSymbolNum, id: \.self) { symbolIndex in
                        if symbolIndex < dailySymbols.count {
                            DailySymbolOnMonth(
                                dailySymbol: dailySymbols[symbolIndex],
                                isEllipsis: dailySymbols.count > maxSymbolNum && symbolIndex == maxSymbolNum - 1
                            )
                        } else { DailySymbolOnMonth(dailySymbol: DailySymbol(), isEllipsis: false) }
                    }
                }
                .padding(.vertical, CGFloat.fontSize)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.green, lineWidth: 2)
                    .opacity(year == context.date.year && month == context.date.month && day == context.date.day ? 1 : 0)
            }
        }
    }
}

// MARK: - DailySymbolOnMonth
struct DailySymbolOnMonth: View {
    let dailySymbol: DailySymbol
    let isEllipsis: Bool
    
    var body: some View {
        VStack {
            if isEllipsis { Image(systemName: "ellipsis") }
            else if let symbol = dailySymbol.symbol {
                Image(systemName: "\(symbol.imageName)\(dailySymbol.isSuccess ? ".fill" : "")")
            }
        }
        .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
        .frame(maxWidth: .infinity)
        .frame(height: CGFloat.fontSize * 2)
    }
}


#Preview {
    CalendarMonthView()
}
