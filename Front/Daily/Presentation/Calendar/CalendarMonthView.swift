//
//  CalendarMonthView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

// MARK: - CalendarMonthView
struct CalendarMonthView: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
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
                        if direction == .current {
                            CalendarMonth(
                                year: date.year, month: date.month,
                                action: {
                                    guard let currentDate = CalendarServices.shared.getDate(year: date.year, month: date.month, day: $0) else { return }
                                    dailyCalendarViewModel.currentDate = currentDate
                                    let navigationObject = NavigationObject(viewType: .calendarDay)
                                    navigationEnvironment.navigate(navigationObject)
                                }
                            )
                        } else { CalendarLoadView(type: .month, direction: direction) }
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
    let year: Int
    let month: Int
    let action: (Int) -> Void
    
    var body: some View {
        let startDayIndex = CalendarServices.shared.startDayIndex(year: year, month: month)
        let lengthOfMonth = CalendarServices.shared.lengthOfMonth(year: year, month: month)
        let dividerIndex = (lengthOfMonth + startDayIndex - 1) / 7
        
        LazyVStack {
            ForEach (0 ... dividerIndex, id: \.self) { rowIndex in
                HStack(spacing: 0) {
                    ForEach (0 ..< 7) { colIndex in
                        let day: Int = rowIndex * 7 + colIndex - startDayIndex + 1
                        if 1 <= day && day <= lengthOfMonth {
                            Button {
                                action(day)
                            } label: {
                                DailyDayOnMonth(year: year, month: month, day: day)
                            }
                        } else { DailyDayOnMonth().opacity(0) }
                    }
                }
                if rowIndex < dividerIndex { CustomDivider(hPadding: 20) }
            }
        }
        .padding(CGFloat.fontSize)
        .background(Colors.background)
        .cornerRadius(20)
        .vTop()
    }
}

// MARK: - DailyDayOnMonth
struct DailyDayOnMonth: View {
    let year: Int
    let month: Int
    let day: Int
    let symbols: [SymbolOnMonthModel]
    let rating: Double
    
    init(year: Int = 0, month: Int = 0, day: Int = 0, symbolsOnMonth: SymbolsOnMonthModel = SymbolsOnMonthModel()) {
        self.year = year
        self.month = month
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
                .opacity(CalendarServices.shared.isToday(year: year, month: month, day: day) ? 1 : 0)
        }
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
    CalendarMonthView()
}
