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
            VStack {
                Spacer()
                Text(alertViewModel.toastMessage)
                    .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                    .padding(CGFloat.fontSize)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Colors.background)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primary, lineWidth: 1)
                        }
                    )
                    .padding(CGFloat.fontSize)
                    .hCenter()
                    .opacity(alertViewModel.isShowToast ? 1 : 0)
            }
        }
        .tint(Colors.daily)
        .accentColor(Colors.daily)
        .onOpenURL { openUrl in
            let url = openUrl.absoluteString.removingPercentEncoding ?? ""
            if url.contains("widget") {
                calendarViewModel.goToday(userInfoViewModel: userInfoViewModel) { code in
                    if code == "99" { alertViewModel.showAlert() }
                }
            }
        }
        .onChange(of: alertViewModel.isShowToast) { _, newValue in
            if newValue {
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                    withAnimation {
                        alertViewModel.hideToast()
                    }
                }
            }
        }
    }
}

#Preview {
    MainView(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel()).environmentObject(AlertViewModel())
}
