//
//  Calendar_Week&Day.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Week_Day: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var isShowWeeklySummary: Bool = false
    @GestureState private var translation: CGFloat = 0
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                WeekIndicator(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, tapPurpose: "change")
                CustomDivider(color: .primary, height: 2, hPadding: CGFloat.fontSize * 2)
                if calendarViewModel.recordsOnWeek.count > 0 {
                    ViewThatFits(in: .vertical) {
                        RecordList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                        ScrollView {
                            RecordList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                        }
                    }
                    .padding(.top, CGFloat.fontSize)
                    .padding(.bottom, CGFloat.fontSize * 15)
                    Spacer()
                    // swipeAction 고민
                } else {
                    NoRecord(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                }
            }
            .background(Color("ThemeColor"))
            AddGoalButton(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
            WeeklySummary(calendarViewModel: calendarViewModel)
                .padding(.bottom, isShowWeeklySummary ? 0 : -420)
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
        .onTapGesture {
            if isShowWeeklySummary {
                withAnimation {
                    isShowWeeklySummary = false
                }
            }
        }
    }
}
