//
//  AddGoalButton.swift
//  Daily
//
//  Created by 최승용 on 4/19/24.
//

import SwiftUI

struct AddGoalButton: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    init() {
        self.userInfoViewModel = UserInfoViewModel()
        self.calendarViewModel = CalendarViewModel()
    }
    
    init(userInfoViewModel: UserInfoViewModel, calendarViewModel: CalendarViewModel) {
        self.userInfoViewModel = userInfoViewModel
        self.calendarViewModel = calendarViewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink {
                    RecordView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                } label: {
                    Label("목표 추가", systemImage: "plus")
                        .foregroundStyle(.white)
                        .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                }
                .padding()
                .background(Colors.daily)
                .cornerRadius(20)
            }
            .padding()
        }
        .padding()
    }
}
