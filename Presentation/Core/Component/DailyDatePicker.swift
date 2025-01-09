//
//  DailyDatePicker.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import SwiftUI

struct DailyDatePicker: View {
    @Binding var currentDate: Date
    @State var isShowCalendarSheet: Bool = false
    
    var body: some View {
        Group {
            Label("\(CalendarServices.shared.formatDateString(date: currentDate, joiner: .dot, hasSpacing: true, hasLastJoiner: true))\(currentDate.getKoreaDOW())", systemImage: "calendar")
                .font(.system(size: CGFloat.fontSize * 2.5))
        }
        .onTapGesture {
            isShowCalendarSheet = true
        }
        .sheet(isPresented: $isShowCalendarSheet) {
            CalendarSheet(currentDate: $currentDate)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    DailyDatePicker(currentDate: .constant(Date()))
}
