//
//  MainView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        ZStack {
            CalendarView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                .mainViewDragGesture(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                .alert(isPresented: $alertViewModel.isShowAlert, content: {
                    Alert(
                        title: Text("오류가 발생했습니다."),
                        message: Text("네트워크 연결 상태를 먼저 확인해주세요"),
                        dismissButton: .default(
                            Text("확인"),
                            action: {
                                terminateApp()
                            }
                        )
                    )
                })
                .tint(Color("CustomColor"))
                .accentColor(Color("CustomColor"))
        }
    }
}

#Preview {
    MainView(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel()).environmentObject(AlertViewModel())
}
