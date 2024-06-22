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
        NavigationStack {
            CalendarView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                .navigationBarTitle("이전")
                .navigationBarHidden(true)
                .mainViewDragGesture(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, alertViewModel: alertViewModel)
                .alert(isPresented: $alertViewModel.isShowAlert, content: {
                    Alert(
                        title: Text("오류가 발생했습니다."),
                        message: Text("네트워크 연결 상태를 먼저 확인해주세요"),
                        dismissButton: .default(
                            Text("확인"),
                            action: {
                                System().terminateApp()
                            }
                        )
                    )
                })
        }
        .tint(Color("CustomColor"))
        .accentColor(Color("CustomColor"))
        .onOpenURL { openUrl in
            let url = openUrl.absoluteString.removingPercentEncoding ?? ""
            if url.contains("widget") && url.contains("day=") {
                let day = Int(url.split(separator: "day=")[1])!
                calendarViewModel.setCurrentState(state: "week", year: 0, month: 0, day: day, userInfoViewModel: userInfoViewModel) { code in
                    if code == "99" { alertViewModel.showAlert() }
                }
            }
        }
    }
}

#Preview {
    MainView(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel()).environmentObject(AlertViewModel())
}
