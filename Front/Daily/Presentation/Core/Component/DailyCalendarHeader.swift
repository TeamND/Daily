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
                    
                } label: {
                    Text(dailyCalendarViewModel.headerText(type: type, textPosition: .title))
                        .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
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
            
            // MARK: - trailing
            HStack(spacing: 0) {
                Button {
                    dailyCalendarViewModel.setDate(date: Date())
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
                    let navigationObject = NavigationObject(viewType: .appInfo)
                    navigationEnvironment.navigate(navigationObject)
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
