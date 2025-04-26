//
//  CalendarDayView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI
import Charts

// MARK: - CalendarDayView
struct CalendarDayView: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    var body: some View {
        let weekSelection = calendarViewModel.currentDate.getSelection(type: .week)
        VStack(spacing: .zero) {
            CalendarHeader(type: .day)
            Spacer().frame(height: 12)
            SymbolFilter()
            Spacer().frame(height: 12)
            WeekIndicator(mode: .change)
            DailyWeekIndicator(mode: .change, selection: weekSelection)
            Spacer().frame(height: 20)
            TabView(selection: calendarViewModel.bindSelection(type: .day)) {
                ForEach(-1 ... GeneralServices.week, id: \.self) { index in
                    let (date, direction, selection) = calendarViewModel.calendarInfo(type: .day, index: index)
                    Group {
                        if direction == .current { CalendarDay(date: date, selection: selection) }
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
            AddGoalButton()
        }
        .overlay {
            DailyWeeklySummary(selection: weekSelection)
        }
    }
}

// MARK: - CalendarDay
struct CalendarDay: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    let date: Date
    let selection: String
    
    var body: some View {
        let dayData = calendarViewModel.dayData[selection] ?? DayDataModel()
        VStack {
            // TODO: 추후 records.isEmpty or filteredRecords.isEmpty 구분
            if dayData.recordsInList.isEmpty {
                NoRecord()
            } else {
                ViewThatFits(in: .vertical) {
                    RecordList(date: date, selection: selection, recordsInList: dayData.recordsInList)
                    ScrollView {
                        RecordList(date: date, selection: selection, recordsInList: dayData.recordsInList)
                    }
                }
                Spacer().frame(height: CGFloat.fontSize * 15)
                Spacer()
            }
        }
        .onAppear {
            calendarViewModel.fetchDayData(selection: selection)
        }
    }
}

#Preview {
    CalendarDayView()
}

// MARK: - DailyWeeklySummary
struct DailyWeeklySummary: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    @AppStorage(UserDefaultKey.startDay.rawValue) private var startDay: Int = 0
    
    let selection: String
    
    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            weeklySummaryHeader
            weeklySummaryBody
        }
        .onAppear {
            calendarViewModel.fetchWeekData(selection: selection)
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
            let weekData = calendarViewModel.weekData[selection] ?? WeekDataModel()
            VStack(alignment: .center, spacing: CGFloat.fontSize * 3) {
                Text("\(calendarViewModel.currentDate.month)월 \(calendarViewModel.currentDate.weekOfMonth)주차 목표 달성률")
                    .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                Chart {
                    ForEach(weekData.ratingsForChart) { data in
                        BarMark(
                            x: .value("Day", data.day),
                            y: .value("Rating", data.rating)
                        )
                        .opacity(0.3)
                        .annotation(position: .top, alignment: .center) {
                            let isLeadingPosition = data.day == "일" || data.day == "월" || data.day == "화"
                            let isSameRating = Int(round(data.rating)) == weekData.ratingOfWeek
                            let isNotZero = weekData.ratingOfWeek != 0
                            if isLeadingPosition && isSameRating && isNotZero {
                                EmptyView()
                            } else {
                                Text(data.rating.percentFormat())
                                    .font(.system(size: CGFloat.fontSize * 1.5))
                            }
                        }
                        if weekData.ratingOfWeek > 0 {
                            RuleMark(y: .value("RatingOfWeek", weekData.ratingOfWeek))
                                .lineStyle(StrokeStyle(lineWidth: 2))
                                .annotation(position: .top, alignment: .leading) {
                                    Text(" 주간 달성률 : \(weekData.ratingOfWeek)%")
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
