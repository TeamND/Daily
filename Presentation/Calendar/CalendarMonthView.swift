//
//  CalendarMonthView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

// MARK: - CalendarMonthView
struct CalendarMonthView: View {
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            DailyCalendarHeader(type: .month)
            DailyWeekIndicator()
            CustomDivider(color: Colors.reverse, height: 2, hPadding: CGFloat.fontSize * 2)
            Spacer().frame(height: CGFloat.fontSize)
            TabView(selection: dailyCalendarViewModel.bindSelection(type: .month)) {
                ForEach(-1 ... 12, id: \.self) { index in
                    let (date, direction, selection) = dailyCalendarViewModel.getCalendarInfo(type: .month, index: index)
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
            DailyAddGoalButton()
        }
    }
}

// MARK: - CalendarMonth
struct CalendarMonth: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    let date: Date
    let selection: String
    var monthDatas: [MonthDatas] {
        dailyCalendarViewModel.monthDictionary[selection] ?? Array(repeating: MonthDatas(), count: 31)
    }
    
    var body: some View {
        let (startOfMonthWeekday, lengthOfMonth, dividerCount) = dailyCalendarViewModel.getMonthInfo(date: date)
        LazyVStack {
            ForEach (0 ... dividerCount, id: \.self) { rowIndex in
                HStack(spacing: 0) {
                    ForEach (0 ..< 7) { colIndex in
                        let day: Int = rowIndex * 7 + colIndex - (startOfMonthWeekday - 1) + 1
                        if 1 <= day && day <= lengthOfMonth {
                            Button {
                                dailyCalendarViewModel.setDate(year: date.year, month: date.month, day: day)
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
            dailyCalendarViewModel.calendarMonthOnAppear(modelContext: modelContext, date: date, selection: selection)
        }
    }
}

// MARK: - DailyDayOnMonth
struct DailyDayOnMonth: View {
    let year: Int
    let month: Int
    let day: Int
    let dailySymbols: [DailySymbol]
    let rating: Double
    
    init(year: Int = 0, month: Int = 0, day: Int = 0, monthData: MonthDatas = MonthDatas()) {
        self.year = year
        self.month = month
        self.day = day
        self.dailySymbols = monthData.symbol
        self.rating = monthData.rating
    }
    
    var body: some View {
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
                ForEach(0 ..< 4, id: \.self) { symbolIndex in
                    if symbolIndex < min(maxSymbolNum, dailySymbols.count) {
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
                .opacity(year == Date().year && month == Date().month && day == Date().day ? 1 : 0)
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
