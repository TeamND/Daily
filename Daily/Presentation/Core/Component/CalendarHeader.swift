//
//  CalendarHeader.swift
//  Daily
//
//  Created by seungyooooong on 10/25/24.
//

import SwiftUI

enum TextPositionInHeader {
    case backButton
    case title
}

struct CalendarHeader: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @Environment(\.dismiss) var dismiss
    
    let type: CalendarTypes
    
    var body: some View {
        VStack(spacing: .zero) {
            Spacer().frame(height: 8)
            navigationArea.frame(height: 24)
            Spacer().frame(height: 12)
            dateArea.frame(height: 26)
            Spacer().frame(height: 16)
        }
        .padding(.horizontal, 16)
        .background(Colors.Background.secondary)
    }
    
    private var navigationArea: some View {
        HStack {
            HStack(alignment: .center) {
                if type != .year {
                    Button {
                        dismiss()
                    } label: {
                        Label(calendarViewModel.headerText(type: type, textPosition: .backButton), systemImage: "chevron.left")
                            .font(Fonts.bodyLgMedium)
                    }
                    .foregroundStyle(Colors.Text.point)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                Button {
                    navigationEnvironment.navigate(NavigationObject(viewType: .chart))
                } label: {
                    Image(.chart)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                }
                
                Button {
                    navigationEnvironment.navigate(NavigationObject(viewType: .setting))
                } label: {
                    Image(.setting)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    private var dateArea: some View {
        HStack {
            Spacer().frame(maxWidth: .infinity)
            
            HStack(spacing: 12) {
                Button {
                    calendarViewModel.setDate(byAdding: type.byAdding, value: Direction.prev.value)
                } label: {
                    Image(.circleChevronLeft)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
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
                        .font(Fonts.headingMdBold)
                        .fixedSize(horizontal: true, vertical: false)   // MARK: 텍스트가 줄어들지 않도록 설정
                }
                .foregroundStyle(Colors.Text.primary)
                
                Button {
                    calendarViewModel.setDate(byAdding: type.byAdding, value: Direction.next.value)
                } label: {
                    Image(.circleChevronRight)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                Button {
                    calendarViewModel.setDate(date: Date(format: .daily))
                    navigationEnvironment.navigateDirect(from: type, to: .day)
                } label: {
                    Text(GeneralServices.today)
                        .font(Fonts.bodyMdSemiBold)
                        .foregroundStyle(Colors.Text.point)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Colors.Brand.primary, lineWidth: 1)
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    CalendarHeader(type: CalendarTypes.day)
}
