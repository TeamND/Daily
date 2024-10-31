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
            TabView(selection: $dailyCalendarViewModel.monthSelection) {
                ForEach(-10 ... 10, id: \.self) { index in
                    ForEach(1 ... 12, id: \.self) { month in
                        let year = Date().year + index
                        let monthSelection = CalendarServices.shared.formatDateString(year: year, month: month)
                        CalendarMonth(year: year, month: month, symbolsOnMonth: dailyCalendarViewModel.symbolsOnMonths[0].symbolsOnMonth, action: dailyCalendarViewModel.selectDay)
                            .tag(monthSelection)
                            .onAppear {
                                dailyCalendarViewModel.calendarMonthOnAppear(monthSelection: monthSelection)
                            }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, CGFloat.fontSize)
            .background(Colors.theme)
            .onChange(of: dailyCalendarViewModel.monthSelection) { monthSelection in
                guard let year = Int(monthSelection.split(separator: DateJoiner.hyphen.rawValue)[0]) else { return }
                guard let month = Int(monthSelection.split(separator: DateJoiner.hyphen.rawValue)[1]) else { return }
                dailyCalendarViewModel.setYear(year)
                dailyCalendarViewModel.setMonth(month)
            }
        }
        .overlay {
            DailyAddGoalButton()
        }
    }
}

// MARK: - CalendarMonth
struct CalendarMonth: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    let year: Int
    let month: Int
    let symbolsOnMonth: [SymbolsOnMonthModel]
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
                                    action(day)
                                } label: {
                                    DailyDayOnMonth(day: day, symbolsOnMonth: symbolsOnMonth[day-1])
                                }
                            } else {
                                DailyDayOnMonth(day: 1, symbolsOnMonth: SymbolsOnMonthModel()).opacity(0)
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
    let symbols: [SymbolOnMonthModel]
    let rating: Double
    
    init(day: Int = 0, symbolsOnMonth: SymbolsOnMonthModel = SymbolsOnMonthModel()) {
        self.day = day
        self.symbols = symbolsOnMonth.symbol
        self.rating = symbolsOnMonth.rating
    }
    
    var body: some View {
        let maxSymbolNum = UIDevice.current.model == "iPad" ? 6 : 4
        VStack(alignment: .leading) {
            ZStack {
                Image(systemName: "circle.fill")
                    .font(.system(size: CGFloat.fontSize * 4))
                    .foregroundStyle(Colors.daily.opacity(rating*0.8))
                Text("\(day)")
                    .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
            }
            .padding(4)
            VStack(alignment: .center, spacing: 8) {
                ForEach(0 ..< maxSymbolNum, id: \.self) { index in
                    if index % 2 == 0 {
                        HStack(spacing: 0) {
                            ForEach(symbols.indices, id: \.self) { symbolIndex in
                                if index <= symbolIndex && symbolIndex < index + 2 {
                                    DailySymbolOnMonth(symbol: symbols[symbolIndex], isEllipsis: index == maxSymbolNum - 2 && symbols.count > maxSymbolNum && symbolIndex == maxSymbolNum - 1)
                                }
                            }
                            if index >= symbols.count - 1 {
                                DailySymbolOnMonth(symbol: SymbolOnMonthModel(), isEllipsis: false)
                            }
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

// MARK: - DailySymbolOnMonth
struct DailySymbolOnMonth: View {
    let symbol: SymbolOnMonthModel
    let isEllipsis: Bool
    
    var body: some View {
        VStack {
            if isEllipsis {
                Image(systemName: "ellipsis")
            } else if symbol.imageName.toSymbol() == nil {
                Image(systemName: "d.circle").opacity(0)
            } else {
                if symbol.isSuccess {
                    Image(systemName: "\(symbol.imageName.toSymbol()!.rawValue).fill")
                } else {
                    Image(systemName: "\(symbol.imageName.toSymbol()!.rawValue)")
                }
            }
        }
        .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
        .foregroundStyle(Colors.reverse)
        .frame(maxWidth: .infinity)
        .frame(height: CGFloat.fontSize * 2)
    }
}


#Preview {
    CalendarMonthView(dailyCalendarViewModel: DailyCalendarViewModel())
}
