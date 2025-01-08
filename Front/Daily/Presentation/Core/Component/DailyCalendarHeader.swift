//
//  DailyCalendarHeader.swift
//  Daily
//
//  Created by seungyooooong on 10/25/24.
//

import SwiftUI

struct DailyCalendarHeader: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    @Environment(\.dismiss) var dismiss
    let type: CalendarType
    
    var body: some View {
        HStack {
            // MARK: - leading
            HStack {
                if type != .year {
                    Button {
                        dismiss()
                    } label: {
                        Label(dailyCalendarViewModel.headerText(type: type, textPosition: .backButton), systemImage: "chevron.left")
                            .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                    }
                    .padding(CGFloat.fontSize)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - center
            HStack {
                Button {
                    dailyCalendarViewModel.setDate(byAdding: type.byAdding, value: Direction.prev.value)
                } label: {
                    Image(systemName: "chevron.left")
                }
                Menu {
                    switch type {
                    case .year:
                        ForEach((dailyCalendarViewModel.currentDate.year / 10) * 10 ..< (dailyCalendarViewModel.currentDate.year / 10 + 1) * 10, id: \.self) { year in
                            Button {
                                dailyCalendarViewModel.setDate(year: year)
                            } label: {
                                Text("\(String(year)) 년")
                            }
                        }
                    case .month:
                        ForEach(1 ... 12, id: \.self) { month in
                            Button {
                                dailyCalendarViewModel.setDate(year: dailyCalendarViewModel.currentDate.year, month: month)
                            } label: {
                                Text("\(String(month)) 월")
                            }
                        }
                    case .day:
                        let lengthOfMonth = Calendar.current.range(of: .day, in: .month, for: dailyCalendarViewModel.currentDate)?.count ?? 0
                        ForEach(1 ... lengthOfMonth, id: \.self) { day in
                            Button {
                                dailyCalendarViewModel.setDate(year: dailyCalendarViewModel.currentDate.year, month: dailyCalendarViewModel.currentDate.month, day: day)
                            } label: {
                                Text("\(String(day)) 일")
                            }
                        }
                    }
                } label: {
                    Text(dailyCalendarViewModel.headerText(type: type, textPosition: .title))
                        .foregroundStyle(Colors.reverse)
                        .fixedSize(horizontal: true, vertical: false)   // MARK: 텍스트가 줄어들지 않도록 설정
                }
                Button {
                    dailyCalendarViewModel.setDate(byAdding: type.byAdding, value: Direction.next.value)
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
            
            // MARK: - trailing
            HStack(spacing: 0) {
                Button {
                    dailyCalendarViewModel.setDate(date: Date())
                    navigationEnvironment.navigateDirect(from: type, to: .day)
                } label: {
                    Label("오늘", systemImage: "chevron.right")
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
    DailyCalendarHeader(type: CalendarType.day)
}
