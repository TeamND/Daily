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
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            DailyCalendarHeader(type: .day)
            DailyWeekIndicator(mode: .change, currentDate: dailyCalendarViewModel.currentDate)
            CustomDivider(color: Colors.reverse, height: 2, hPadding: CGFloat.fontSize * 2)
            Spacer().frame(height: CGFloat.fontSize)
            TabView(selection: dailyCalendarViewModel.bindSelection(type: .day)) {
                ForEach(-1 ... 7, id: \.self) { index in
                    let (date, direction, selection) = dailyCalendarViewModel.getCalendarInfo(type: .day, index: index)
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
            DailyWeeklySummary(currentDate: dailyCalendarViewModel.currentDate)
        }
    }
}

// MARK: - CalendarDay
struct CalendarDay: View {
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    @Query private var records: [DailyRecordModel]
    let date: Date
    
    init(date: Date) {
        self.date = date
        _records = Query(DailyCalendarViewModel.recordsForDateDescriptor(date))
    }
    
    var body: some View {
        if records.isEmpty {
            DailyNoRecord()
        } else {
            VStack {
                ViewThatFits(in: .vertical) {
                    DailyRecordList(date: date, records: records)
                    ScrollView {
                        DailyRecordList(date: date, records: records)
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
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    @Query private var records: [DailyRecordModel]
    
    init(currentDate: Date) {
        _records = Query(DailyCalendarViewModel.recordsForWeekDescriptor(currentDate))
    }
    
    private var ratingsForChart: [RatingOnWeekModel] {
        let calendar = Calendar.current
        var ratingsForChart = (0 ..< 7).map { index in
            RatingOnWeekModel(day: DayOfWeek.text(for: index) ?? "", rating: 0.0)
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
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let validRecords = records.filter { record in
            calendar.startOfDay(for: record.date) <= today
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
            withAnimation { dailyCalendarViewModel.isShowWeeklySummary.toggle() }
        }
        .offset(y: dailyCalendarViewModel.isShowWeeklySummary ? 0 : 350)
        .highPriorityGesture(
            DragGesture(minimumDistance: CGFloat.fontSize)
                .onEnded { value in
                    if value.translation.height < -50 {
                        withAnimation {
                            dailyCalendarViewModel.isShowWeeklySummary = true
                        }
                    }
                    if value.translation.height > 50 {
                        withAnimation {
                            dailyCalendarViewModel.isShowWeeklySummary = false
                        }
                    }
                }
        )
        .background {
            if dailyCalendarViewModel.isShowWeeklySummary {
                Color.black.opacity(0.5).onTapGesture { withAnimation { dailyCalendarViewModel.isShowWeeklySummary = false } }
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
                Text("\(dailyCalendarViewModel.currentDate.month)월 \(dailyCalendarViewModel.currentDate.weekOfMonth)주차 목표 달성률")
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
                .animation(.none, value: dailyCalendarViewModel.isShowWeeklySummary)
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
