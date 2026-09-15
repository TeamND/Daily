//
//  DailyDatePicker.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import SwiftUI

struct DailyDatePicker: View {
    private let selectType: SelectTypes
    
    @Binding private var selectedDate: Date?
    @Binding private var selectedDates: [Date]
    @State private var currentDate: Date
    
    let calendar = Calendar.current
    
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
        DailyDatePickerHeader(currentDate: $currentDate)
        
        Spacer().frame(height: 20)
        
        VStack(spacing: 8) {
            WeekIndicator(mode: .none)
            
            let startOfMonth = calendar.date(from: DateComponents(year: currentDate.year, month: currentDate.month, day: 1))!
            let lengthOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
            let rowCount = Int((lengthOfMonth + startOfMonth.weekday - 1 - 1) / 7)
            
            ForEach(0 ... rowCount, id: \.self) { row in
                HStack {
                    ForEach(0 ..< 7) { col in
                        if col > 0 { Spacer() }
                        
                        let day = row * 7 + col - (startOfMonth.weekday - 1) + 1
                        let date = calendar.date(from: DateComponents(year: currentDate.year, month: currentDate.month, day: day))!
                        
                        if 0 < day && day <= lengthOfMonth {
                            let isSelected: Bool = selectType == .single ? selectedDate == date : selectedDates.contains(date)
                            
                            let isHoliday = UserDefaultManager.holidays?[date.year]?[date.getSelection()] != nil || date.weekday == 1
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
        
        if selectType == .multiple {
            Spacer().frame(height: 20)
            
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
