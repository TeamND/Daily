//
//  CalendarServices.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import SwiftUI

class CalendarServices {
    static let shared = CalendarServices()
    private var calendar: Calendar = Calendar.current
    
    private(set) var row: Int = 0
    private(set) var col: Int = 0
    
    private init() {
        calendar.timeZone = .current
    }
    
    // MARK: 월 달력에서 하루에 심볼이 몇 개 들어갈지 계산하는 함수, calendarMonth UI 수치가 변경되면 같이 수정해줘야 함, SplashView onAppear에서 호출
    func calculateSymbolNum() {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = scene?.keyWindow ?? scene?.windows.first
        let safeAreaInsets = window?.safeAreaInsets ?? .zero
        
        // MARK: - width
        let width = UIScreen.main.bounds.width - (safeAreaInsets.left + safeAreaInsets.right)
        
        let horizontalPaddings = CGFloat(16 * 2)
        let daySpacings = CGFloat(GeneralServices.daySpacing * 6)
        
        let symbolWidth = (width - horizontalPaddings - daySpacings) / CGFloat(GeneralServices.week)
        
        // MARK: - height
        let height = UIScreen.main.bounds.height - (safeAreaInsets.top + safeAreaInsets.bottom)
        
        let header = 86
        let headerFilterSpacing = 12
        let filter = 28
        let filterCalendarSpacing = 12
        let weekIndicator = 16
        let bottomSpacing = 8
        let fixedHeight: CGFloat = CGFloat(header + headerFilterSpacing + filter + filterCalendarSpacing + weekIndicator + bottomSpacing)
        
        let lineHeight = (height - fixedHeight) / CGFloat(GeneralServices.maxLineCount)
        
        let topSpacing = 4
        let dayIndicator = 33
        let daySymbolSpacing = 6
        let bottomMinSpacing = 4
        let exceptSymbolHeight: CGFloat = CGFloat(topSpacing + dayIndicator + daySymbolSpacing + bottomMinSpacing)
        
        let symbolHeight = (lineHeight - exceptSymbolHeight)
        
        // MARK: - calculate
        let symbol: CGFloat = 14    // FIXME: 추후 symbol size 16 x 16 고려 및 수정
        let symbolSpacing: CGFloat = 1
        
        row = Int((symbolHeight + symbolSpacing) / (symbol + symbolSpacing))
        col = Int((symbolWidth + symbolSpacing) / (symbol + symbolSpacing))
    }
    
    func formatDateString(date: Date = Date(format: .daily), joiner: DateJoiner = .hyphen, hasSpacing: Bool = false, hasLastJoiner: Bool = false) -> String {
        self.formatDateString(year: date.year, month: date.month, day: date.day, joiner: joiner, hasSpacing: hasSpacing, hasLastJoiner: hasLastJoiner)
    }
    func formatDateString(year: Int, month: Int = 0, day: Int = 0, joiner: DateJoiner = .hyphen, hasSpacing: Bool = false, hasLastJoiner: Bool = false) -> String {
        let y = year.formatDateString(type: .year)
        let yj = month > 0 || (hasLastJoiner && month == 0) ? joiner.joinString(type: .year, hasSpacing: hasSpacing) : ""
        let m = month.formatDateString(type: .month)
        let mj = day > 0 || (hasLastJoiner && day == 0) ? joiner.joinString(type: .month, hasSpacing: hasSpacing) : ""
        let d = day.formatDateString(type: .day)
        let dj = hasLastJoiner ? joiner.joinString(type: .day, hasSpacing: hasSpacing) : ""
        return month == 0 ? y + yj : day == 0 ? y + yj + m + mj : y + yj + m + mj + d + dj
    }
    
    func getDate(year: Int, month: Int, day: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        return calendar.date(from: components)
    }
    
    func separateSelection(_ selection: String) -> [Int] {
        selection.split(separator: DateJoiner.hyphen.rawValue).compactMap { Int($0) }
    }
    
    // TODO: 추후 수정
    func getDaysInMonth(date: Date, startDay: Int) -> [(date: Date, id: String)] {
        let interval = calendar.dateInterval(of: .month, for: date)!
        let firstDate = interval.start
        
        let firstWeekday = firstDate.dailyWeekday(startDay: startDay) + 1
        let previousDates = (1..<firstWeekday).map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: firstDate)!
            return (date: date, id: "prev_\(offset)_\(date.timeIntervalSince1970)")
        }.reversed()
        
        let numberOfDays = calendar.range(of: .day, in: .month, for: date)!.count
        let currentMonthDates = (0..<numberOfDays).map { day in
            let date = calendar.date(byAdding: .day, value: day, to: firstDate)!
            return (date: date, id: "current_\(day)_\(date.timeIntervalSince1970)")
        }
        
        let totalCells = 42
        let remainingCells = totalCells - previousDates.count - currentMonthDates.count
        let nextDates = (1..<remainingCells).map { day in
            let date = calendar.date(byAdding: .day, value: day, to: currentMonthDates.last!.date)!
            return (date: date, id: "next_\(day)_\(date.timeIntervalSince1970)")
        }
        
        return Array(previousDates) + currentMonthDates + nextDates
    }
    
    func noticeDate(date: Date, setTime: String, notice: Int) -> Date? {
        let timeComponents = setTime.split(separator: ":").compactMap { Int($0) }
        let hour = timeComponents[0]
        let minute = timeComponents[1]
        
        var components = DateComponents()
        components.calendar = Calendar.current
        components.year = date.year
        components.month = date.month
        components.day = date.day
        components.hour = hour
        components.minute = minute
        
        return calendar.date(from: components)?.addingTimeInterval(TimeInterval(-notice * 60))
    }
}

// MARK: Daily Custom
extension CalendarServices {
    func getRating(records: [DailyRecordModel]) -> Double? {
        return records.isEmpty ? nil : Double(records.filter { $0.isSuccess }.count) / Double(records.count)
    }
}
