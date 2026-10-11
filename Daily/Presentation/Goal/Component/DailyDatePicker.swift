//
//  DailyDatePicker.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import SwiftUI

struct DailyDatePicker: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    @Binding private var selectedDate: Date?
    @Binding private var selectedDates: [Date]
    @State private var currentDate: Date
    
    private let selectType: SelectTypes
    
    init(date: Binding<Date>) {
        self.selectType = .single
        self._selectedDate = Binding(
            get: { date.wrappedValue },
            set: { date.wrappedValue = $0 ?? Date() }
        )
        self._selectedDates = .constant([])
        self._currentDate = State(initialValue: date.wrappedValue)
    }
    
    init(dates: Binding<[Date]>) {
        self.selectType = .multiple
        self._selectedDate = .constant(nil)
        self._selectedDates = dates
        self._currentDate = State(initialValue: dates.wrappedValue.first ?? Date())
    }
    
    var body: some View {
        let selection = Binding(
            get: { self.currentDate.getSelection(type: .month) },
            set: { self.currentDate = $0.formatingDaily().toDate() ?? Date() }
        )
        
        VStack(spacing: 20) {
            DailyDatePickerHeader(currentDate: $currentDate)
            
            TabView(selection: selection) {
                ForEach(-1 ... 12, id: \.self) { index in
                    let (date, direction, selection) = calendarViewModel.calendarInfo(date: currentDate, type: .month, index: index)
                    Group {
                        if direction == .current {
                            DateView(
                                selectType: selectType,
                                date: date,
                                selectedDate: $selectedDate,
                                selectedDates: $selectedDates
                            )
                        } else { CalendarLoadView(date: currentDate, type: .month, direction: direction) }
                    }
                    .tag(selection)
                    .vTop() // MARK: height를 동적으로 조절할 때 결과에 의해 필요 없을 수 있음
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            // FIXME: 16(week indicator height), 33(line hgith), 8(spacing) 등 변수화
            // FIXME: selection을 통해 line count를 계산하고 6 부분에 동적으로 height가 바뀌도록 수정
            .frame(height: 16 + (33 + 8) * 6)
            
            if selectType == .multiple {
                VStack(spacing: 8) {
                    Text("selected_date".localized)
                        .font(Fonts.bodyMdRegular)
                        .foregroundStyle(Colors.Text.tertiary)
                        .hLeading()
                    ViewThatFits(in: .horizontal) {
                        SelectedDatesView(selectedDates: $selectedDates)
                        ScrollView(.horizontal, showsIndicators: false) {
                            SelectedDatesView(selectedDates: $selectedDates)
                        }
                    }
                    .horizontalGradient()
                    .padding(.horizontal, -16)
                }
            }
        }
    }
}

struct DateView: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    let selectType: SelectTypes
    let date: Date
    
    @Binding var selectedDate: Date?
    @Binding var selectedDates: [Date]
    
    var body: some View {
        VStack(spacing: 8) {
            // FIXME: 동적 UI 방식이 달라 WeekIndicator 임의로 생성, 추후 수정
//            WeekIndicator(mode: .none)
            HStack {
                ForEach(.zero ..< GeneralServices.week, id: \.self) { index in
                    if index > 0 { Spacer() }
                    
                    let startDay = UserDefaultManager.startDay?.index ?? 0
                    let dayOfWeek = DayOfWeek.allCases[(index + startDay) % GeneralServices.week]
                    
                    Text(dayOfWeek.txt)
                        .font(Fonts.bodySmRegular)
                        .foregroundStyle(dayOfWeek.index == 0 ? Colors.Brand.holiday : Colors.Text.primary)
                        .frame(width: 33)
                }
            }
            
            let (startOfMonthWeekday, lengthOfMonth, dividerCount) = calendarViewModel.monthInfo(date: date)
            ForEach (0 ... dividerCount, id: \.self) { rowIndex in
                HStack {
                    ForEach (.zero ..< GeneralServices.week, id: \.self) { colIndex in
                        if colIndex > 0 { Spacer() }

                        let day: Int = rowIndex * GeneralServices.week + colIndex - (startOfMonthWeekday - 1) + 1
                        let date = CalendarServices.shared.getDate(year: date.year, month: date.month, day: day) ?? Date()
                        let isSelected: Bool = selectType == .single ? selectedDate == date : selectedDates.contains(date)
                        let isHoliday = UserDefaultManager.holidays?[date.year]?[date.getSelection()] != nil || date.weekday == 1
                        
                        if 1 <= day && day <= lengthOfMonth {
                            Text("\(day)")
                                .font(isSelected ? Fonts.bodyMdSemiBold : Fonts.bodySmRegular)
                                .foregroundStyle(
                                    isSelected ? Colors.Text.inverse :
                                        isHoliday ? Colors.Brand.holiday :
                                        Colors.Text.secondary
                                )
                                .frame(width: 33, height: 33)
                                .if(isSelected) { view in
                                    view
                                        .background(Colors.Icon.interactivePressed)
                                        .cornerRadius(33)
                                }
                                .onTapGesture {
                                    switch selectType {
                                    case .single:
                                        if selectedDate == date { return }
                                        AnalyticsManager.shared.log(.changeGoalProgressDate, .log_type(.event)) // FIXME: 추후에 GoalView 단으로 이동
                                        
                                        selectedDate = date
                                        
                                    case .multiple:
                                        if let index = selectedDates.firstIndex(of: date) {
                                            selectedDates.remove(at: index)
                                        } else {
                                            selectedDates.append(date)
                                        }
                                    }
                                }
                        } else {
                            Text("-")
                                .frame(width: 33, height: 33)
                                .opacity(0)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 2)
    }
}

struct SelectedDatesView: View {
    @Binding var selectedDates: [Date]
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(selectedDates, id: \.self) { date in
                Text("\(date.toString(format: .multiDate))")
                    .font(Fonts.bodyMdRegular)
                    .foregroundStyle(Colors.Text.tertiary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(Colors.Background.secondary)
                    .cornerRadius(4)
            }
        }
        .hLeading()
        .padding(.horizontal, 16)
    }
}
