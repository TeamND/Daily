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
    @StateObject var navigationViewModel: NavigationViewModel = NavigationViewModel()
    @State var updateVersion: Bool = false
    
    var body: some View {
        NavigationStack(path: $navigationViewModel.currentPath) {
            if updateVersion {
                VStack(spacing: 0) {
                    Calendar_Year(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, updateVersion: updateVersion)
                        .calendarViewNavigationBar(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel, calendarState: "year")
                        .navigationDestination(for: String.self) { value in
                            if value.contains("month") {
                                Calendar_Month(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, updateVersion: updateVersion)
                                    .calendarViewNavigationBar(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel, calendarState: "month")
                                    .onAppear {
                                        if value.split(separator: "_").count > 1 {
                                            calendarViewModel.setCurrentMonth(month: Int(value.split(separator: "_")[1])!)
                                        }
                                    }
                            }
                            if value.contains("day") {
                                Calendar_Week_Day(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, updateVersion: updateVersion)
                                    .calendarViewNavigationBar(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel, calendarState: "day")
                                    .onAppear {
                                        if value.split(separator: "_").count > 1 {
                                            calendarViewModel.setCurrentDay(day: Int(value.split(separator: "_")[1])!)
                                        }
                                    }
                            }
                            if value == "addGoal" {
                                RecordView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                                    .navigationBarTitleDisplayMode(.inline)
                            }
                            if value == "appInfo" {
                                AppInfoView()
                                    .navigationBarTitleDisplayMode(.inline)
                            }
                        }
                }
            } else {
                CalendarView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                    .navigationBarTitle("이전")
                    .navigationBarHidden(true)
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
            }
        }
        .tint(Color("CustomColor"))
        .accentColor(Color("CustomColor"))
        // 추후 수정: initView로 옮기기
        .onAppear {
            if updateVersion && calendarViewModel.getCurrentState() != "year" {
                navigationViewModel.appendPath(path: "month")
            }
        }
    }
}

#Preview {
    MainView(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel())
}
