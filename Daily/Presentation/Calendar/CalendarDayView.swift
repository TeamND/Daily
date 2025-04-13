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
    
    private var weekSelection: String {
        calendarViewModel.currentDate.getSelection(type: .week)
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            DailyCalendarHeader(type: .day)
            
            Menu {
                ForEach(Symbols.allCases, id: \.self) { filter in
                    Button {
                        calendarViewModel.setFilter(filter: filter)
                    } label: {
                        Text(filter.rawValue)
                    }
                }
            } label: {
                Text(calendarViewModel.filter.rawValue)
                    .foregroundStyle(.white)
                    .frame(width: 60, height: 30)
                    .background(Colors.daily)
                    .cornerRadius(8)
            }
            
            DailyWeekIndicator(mode: .change, selection: weekSelection)
            CustomDivider(color: Colors.reverse, height: 2, hPadding: CGFloat.fontSize * 2)
            Spacer().frame(height: CGFloat.fontSize)
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
            DailyAddGoalButton()
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
    
    private var records: [DailyRecordModel] {
        let records = calendarViewModel.dayDictionary[selection] ?? []
        let filteredRecords = calendarViewModel.filterRecords(records: records)
        return filteredRecords
    }
    
    var body: some View {
        VStack {
            // TODO: 추후 records.isEmpty or filteredRecords.isEmpty 구분
            if records.isEmpty {
                NoRecord()
            } else {
                ViewThatFits(in: .vertical) {
                    RecordList(date: date, selection: selection)
                    ScrollView {
                        RecordList(date: date, selection: selection)
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
    
    private var ratingsOfWeek: [Double] {
        let records = calendarViewModel.weekDictionary[selection] ?? []
        let filteredRecords = calendarViewModel.filterRecords(records: records)
        let ratingsOfWeek = calendarViewModel.getRatingsOfWeek(records: filteredRecords)
        return ratingsOfWeek
    }
    
    private var ratingsForChart: [RatingOnWeekModel] {
        (.zero ..< GeneralServices.week).map { index in
            let dayOfWeek = DayOfWeek.allCases[(index + startDay) % GeneralServices.week]
            return RatingOnWeekModel(day: dayOfWeek.text, rating: ratingsOfWeek[index] * 100)
        }
    }
    
    private var ratingOfWeek: Int {
        let records = calendarViewModel.weekDictionary[selection] ?? []
        let filteredRecords = calendarViewModel.filterRecords(records: records)
        let ratingOfWeek = calendarViewModel.getRatingOfWeek(records: filteredRecords)
        return ratingOfWeek
    }
    
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
