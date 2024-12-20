//
//  Calendar_Year.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Year: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomDivider(color: .primary, height: 2, hPadding: CGFloat.fontSize)
                .padding(12)
            ForEach (0..<4) { rowIndex in
                HStack(spacing: 0) {
                    ForEach (0..<3) { colIndex in
                        let month = (rowIndex * 3) + colIndex + 1
                        Button {
                            calendarViewModel.setCurrentState(state: "month", year: 0, month: month, day: 0, userInfoViewModel: userInfoViewModel) { code in
                                if code == "99" { alertViewModel.showAlert() }
                            }
                        } label: {
                            MonthOnYear(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, month: month)
                        }
                    }
                }
            }
            Spacer()
        }
        .background(Colors.theme)
    }
}


#Preview {
    Calendar_Year(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel())
}
