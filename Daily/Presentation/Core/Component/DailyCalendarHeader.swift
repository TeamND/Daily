//
//  DailyCalendarHeader.swift
//  Daily
//
//  Created by seungyooooong on 10/25/24.
//

import SwiftUI

struct DailyCalendarHeader: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @Environment(\.dismiss) var dismiss
    let type: CalendarTypes
    
    var body: some View {
        HStack {
            // MARK: - leading
            HStack {
                if type != .year {
                    Button {
                        dismiss()
                    } label: {
                        Label(calendarViewModel.headerText(type: type, textPosition: .backButton), systemImage: "chevron.left")
                            .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                    }
                    .padding(CGFloat.fontSize)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - center
            HStack {
                Button {
                    calendarViewModel.setDate(byAdding: type.byAdding, value: Direction.prev.value)
                } label: {
                    Image(systemName: "chevron.left")
                }
                Menu {
                    switch type {
                    case .year:
                        ForEach((calendarViewModel.currentDate.year / 10) * 10 ..< (calendarViewModel.currentDate.year / 10 + 1) * 10, id: \.self) { year in
                            Button {
                                calendarViewModel.setDate(year: year)
                            } label: {
                                Text("\(String(year)) 년")
                            }
                        }
                    case .month:
                        ForEach(1 ... 12, id: \.self) { month in
                            Button {
                                calendarViewModel.setDate(year: calendarViewModel.currentDate.year, month: month)
                            } label: {
                                Text("\(String(month)) 월")
                            }
                        }
                    case .week, .day:
                        let lengthOfMonth = Calendar.current.range(of: .day, in: .month, for: calendarViewModel.currentDate)?.count ?? 0
                        ForEach(1 ... lengthOfMonth, id: \.self) { day in
                            Button {
                                calendarViewModel.setDate(year: calendarViewModel.currentDate.year, month: calendarViewModel.currentDate.month, day: day)
                            } label: {
                                Text("\(String(day)) 일")
                            }
                        }
                    }
                } label: {
                    Text(calendarViewModel.headerText(type: type, textPosition: .title))
                        .foregroundStyle(Colors.reverse)
                        .fixedSize(horizontal: true, vertical: false)   // MARK: 텍스트가 줄어들지 않도록 설정
                }
                Button {
                    calendarViewModel.setDate(byAdding: type.byAdding, value: Direction.next.value)
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
            
            // MARK: - trailing
            HStack(spacing: 0) {
                Button {
                    calendarViewModel.setDate(date: Date(format: .daily))
                    navigationEnvironment.navigateDirect(from: type, to: .day)
                } label: {
                    Label(GeneralServices.today, systemImage: "chevron.right")
                        .labelStyle(.trailingIcon(spacing: CGFloat.fontSize / 2))
                        .padding(CGFloat.fontSize * 1.5)
                        .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
                        .foregroundStyle(Colors.reverse)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Colors.reverse, lineWidth: 1)
                        )
                }
                Button {
                    navigationEnvironment.navigate(NavigationObject(viewType: .appInfo))
                } label: {
                    Image(systemName: "info.circle")
                        .font(.system(size: CGFloat.fontSize * 2.5))
                        .padding(CGFloat.fontSize * 2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .foregroundStyle(Colors.daily)
    }
}

enum TextPositionInHeader {
    case backButton
    case title
}

#Preview {
    DailyCalendarHeader(type: CalendarTypes.day)
}
