//
//  DailyCalendarHeader.swift
//  Daily
//
//  Created by seungyooooong on 10/25/24.
//

import SwiftUI

struct DailyCalendarHeader: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @Environment(\.dismiss) var dismiss
    let type: CalendarType
    @Binding var backButton: Int
    @Binding var title: Int
    
    var body: some View {
        HStack {
            // MARK: - leading
            HStack {
                if type != .year {
                    Button {
                        dismiss()
                    } label: {
                        Label("\(String(backButton))\(type.headerBackButton)", systemImage: "chevron.left")
                            .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                    }
                    .padding(CGFloat.fontSize)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - center
            HStack {
                Button {
                    print("go left")
                } label: {
                    Image(systemName: "chevron.left")
                }
                Menu {
                    
                } label: {
                    Text("\(String(title))\(type.headerTitle)")
                        .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                        .foregroundStyle(Colors.reverse)
                        .fixedSize(horizontal: true, vertical: false)   // MARK: 텍스트가 줄어들지 않도록 설정
                }
                Button {
                    print("go right")
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            // MARK: - trailing
            HStack(spacing: 0) {
                Button {
                    print("today")
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

#Preview {
    DailyCalendarHeader(type: CalendarType.day, backButton: .constant(10), title: .constant(26))
}
