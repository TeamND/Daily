//
//  CalendarDayView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI
import SwiftData
import Charts

// MARK: - CalendarDayView
struct CalendarDayView: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            DailyCalendarHeader(type: .day)
            DailyWeekIndicator(mode: .change, currentDate: calendarViewModel.currentDate)
            CustomDivider(color: Colors.reverse, height: 2, hPadding: CGFloat.fontSize * 2)
            Spacer().frame(height: CGFloat.fontSize)
            TabView(selection: calendarViewModel.bindSelection(type: .day)) {
                ForEach(-1 ... GeneralServices.week, id: \.self) { index in
                    let (date, direction, selection) = calendarViewModel.getCalendarInfo(type: .day, index: index)
                    Group {
                        if direction == .current { CalendarDay(date: date) }
                        else { CalendarLoadView(type: .day, direction: direction) }
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
        .overlay {
            DailyWeeklySummary(currentDate: calendarViewModel.currentDate)
        }
    }
}

// MARK: - CalendarDay
struct CalendarDay: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @Query private var records: [DailyRecordModel]
    let date: Date
    
    init(date: Date) {
        self.date = date
        _records = Query(CalendarViewModel.recordsForDateDescriptor(date))
    }
    
    var body: some View {
        if records.isEmpty {
            NoRecord()
        } else {
            VStack {
                ViewThatFits(in: .vertical) {
                    RecordList(date: date, records: records)
                    ScrollView {
                        RecordList(date: date, records: records)
                    }
                }
                Spacer().frame(height: CGFloat.fontSize * 15)
                Spacer()
            }
        }
    }
}

#Preview {
    CalendarDayView()
}

// MARK: - DailyWeeklySummary
struct DailyWeeklySummary: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @Query private var records: [DailyRecordModel]
    
    init(currentDate: Date) {
        _records = Query(CalendarViewModel.recordsForWeekDescriptor(currentDate))
    }
    
    private var ratingsForChart: [RatingOnWeekModel] {
        let calendar = Calendar.current
        var ratingsForChart = (.zero ..< GeneralServices.week).map { index in
            RatingOnWeekModel(day: DayOfWeek.text(for: index) ?? "", rating: .zero)
        }
        
        let recordsByDay = Dictionary(grouping: records) { record -> Int in
            calendar.dateComponents([.weekday], from: record.date).weekday! - 1
        }
        
        for (index, record) in recordsByDay {
            let successCount = record.filter { $0.isSuccess }.count
            ratingsForChart[index].rating = Double(successCount) / Double(record.count) * 100
        }
        
        return ratingsForChart
    }
    
    private var ratingOfWeek: Int {
        let validRecords = records.filter { record in
            record.date <= Date()
        }
        
        let totalRecords = validRecords.count
        guard totalRecords > 0 else { return 0 }
        
        let successCount = validRecords.filter { $0.isSuccess }.count
        let successRate = Double(successCount) / Double(totalRecords) * 100
        
        return Int(round(successRate))
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            weeklySummaryHeader
            weeklySummaryBody
        }
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation { calendarViewModel.isShowWeeklySummary.toggle() }
        }
        .offset(y: calendarViewModel.isShowWeeklySummary ? 0 : 350)
        .highPriorityGesture(
            DragGesture(minimumDistance: CGFloat.fontSize)
                .onEnded { value in
                    if value.translation.height < -50 {
                        withAnimation {
                            calendarViewModel.isShowWeeklySummary = true
                        }
                    }
                    if value.translation.height > 50 {
                        withAnimation {
                            calendarViewModel.isShowWeeklySummary = false
                        }
                    }
                }
        )
        .background {
            if calendarViewModel.isShowWeeklySummary {
                Color.black.opacity(0.5).onTapGesture { withAnimation { calendarViewModel.isShowWeeklySummary = false } }
            }
        }
    }
    
    private var weeklySummaryHeader: some View {
        Group {
            VStack(spacing: .zero) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Colors.reverse.opacity(0.3))
                    .frame(width: CGFloat.fontSize * 5, height: CGFloat.fontSize * 0.8)
                    .padding(CGFloat.fontSize)
                Text("주간 요약")
                    .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
            }
            .padding(.horizontal, CGFloat.fontSize * 3)
            .padding(.bottom, CGFloat.fontSize * 3)
            .background(Colors.background)
            .cornerRadius(20)
            .zIndex(1)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, -20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var weeklySummaryBody: some View {
        Group {
            VStack(alignment: .center, spacing: CGFloat.fontSize * 3) {
                Text("\(calendarViewModel.currentDate.month)월 \(calendarViewModel.currentDate.weekOfMonth)주차 목표 달성률")
                    .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                Chart {
                    ForEach(ratingsForChart) { data in
                        BarMark(
                            x: .value("Day", data.day),
                            y: .value("Rating", data.rating)
                        )
                        .opacity(0.3)
                        .annotation(position: .top, alignment: .center) {
                            let isLeadingPosition = data.day == "일" || data.day == "월" || data.day == "화"
                            let isSameRating = Int(round(data.rating)) == ratingOfWeek
                            let isNotZero = ratingOfWeek != 0
                            if isLeadingPosition && isSameRating && isNotZero {
                                EmptyView()
                            } else {
                                Text(data.rating.percentFormat())
                                    .font(.system(size: CGFloat.fontSize * 1.5))
                            }
                        }
                        if ratingOfWeek > 0 {
                            RuleMark(y: .value("RatingOfWeek", ratingOfWeek))
                                .lineStyle(StrokeStyle(lineWidth: 2))
                                .annotation(position: .top, alignment: .leading) {
                                    Text(" 주간 달성률 : \(ratingOfWeek)%")
                                        .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
                                }
                        }
                    }
                }
                .chartYScale(domain: 0 ... 100)
                .animation(.none, value: calendarViewModel.isShowWeeklySummary)
                .foregroundStyle(Colors.reverse)
                .frame(height: 200)
                Text("* 오늘 이후의 목표는 주간 달성률 계산에 포함되지 않습니다.")
                    .font(.system(size: CGFloat.fontSize * 1.5))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(CGFloat.fontSize * 5)
            .frame(height: 350)
        }
        .font(.system(size: CGFloat.fontSize * 3))
        .background(Colors.background)
        .cornerRadius(20)
    }
}
