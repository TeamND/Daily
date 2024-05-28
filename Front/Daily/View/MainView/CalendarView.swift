//
//  CalendarView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var isShowWeeklySummary: Bool = false
    @GestureState private var translation: CGFloat = 0
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CalendarHeader(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                if calendarViewModel.getCurrentState() == "year" { Calendar_Year(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel) }
                if calendarViewModel.getCurrentState() == "month" { Calendar_Month(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel) }
                if calendarViewModel.getCurrentState() == "week" { Calendar_Week_Day(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel) }
            }
            AddGoalButton(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
            if calendarViewModel.getCurrentState() == "week" {
                Rectangle()
                    .fill(.black.opacity(0.5))
                    .opacity(isShowWeeklySummary ? 1 : 0)
                    .onTapGesture {
                        if isShowWeeklySummary {
                            withAnimation {
                                isShowWeeklySummary = false
                            }
                        }
                    }
                    .highPriorityGesture(DragGesture())
                WeeklySummary(calendarViewModel: calendarViewModel)
                    .padding(.bottom, isShowWeeklySummary ? 0 : -320)
                    .onTapGesture {
                        withAnimation {
                            isShowWeeklySummary.toggle()
                        }
                    }
                    .offset(y: !isShowWeeklySummary && self.translation < -200 ? -200 : isShowWeeklySummary && self.translation < 0 ? 0 :self.translation)
                    .animation(.interpolatingSpring, value: translation)
                    .highPriorityGesture(
                        DragGesture(minimumDistance: CGFloat.fontSize).updating(self.$translation) { value, state, _ in
                            state = value.translation.height
                        }.onEnded { value in
                            if value.translation.height < -50 {
                                withAnimation {
                                    isShowWeeklySummary = true
                                }
                            }
                            if value.translation.height > 50 {
                                withAnimation {
                                    isShowWeeklySummary = false
                                }
                            }
                        }
                    )
            }
        }
    }
}

#Preview {
    CalendarView(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel())
}
