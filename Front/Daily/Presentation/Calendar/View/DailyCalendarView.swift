//
//  DailyCalendarView.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import SwiftUI

struct DailyCalendarView: View {
    @StateObject var dailyCalendarViewModel: DailyCalendarViewModel = DailyCalendarViewModel()
    @State var currentCalendar = "2024-10"
    
    var body: some View {
        TabView(selection: $currentCalendar) {
            ForEach(-10 ... 10, id: \.self) { year in
                ForEach(1 ... 12, id: \.self) { month in
                    let tag = String(2024 + year) + "-" + String(month)
                    dailyCalendarView(currentCalendar)
                        .onAppear {
                            dailyCalendarViewModel.onAppear(tag)
                        }
                        .tag(tag)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private func dailyCalendarView(_ currentCalendar: String) -> some View {
        Button {
            dailyCalendarViewModel.test(userID: "123")
        } label: {
            Text("getUserInfo@@@@ \(currentCalendar)")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.red)
        }
    }
}

#Preview {
    DailyCalendarView()
}
