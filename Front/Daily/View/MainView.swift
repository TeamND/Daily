//
//  MainView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @StateObject var calendarViewModel: CalendarViewModel = CalendarViewModel()
    @StateObject var navigationViewModel: NavigationViewModel = NavigationViewModel()
    @State var updateVersion: Bool = true
    
    var body: some View {
        NavigationStack(path: $navigationViewModel.currentPath) {
            if updateVersion {
                VStack(spacing: 0) {
                    Calendar_Year(userInfo: userInfo, calendarViewModel: calendarViewModel, updateVersion: updateVersion)
                        .calendarViewNavigationBar(userInfo: userInfo, userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel, calendarState: "year")
                        .navigationDestination(for: String.self) { value in
                            if value.contains("month") {
                                Calendar_Month(userInfo: userInfo, calendarViewModel: calendarViewModel, updateVersion: updateVersion)
                                    .calendarViewNavigationBar(userInfo: userInfo, userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel, calendarState: "month")
                                    .onAppear {
                                        if value.split(separator: "_").count > 1 {
                                            calendarViewModel.setCurrentMonth(month: Int(value.split(separator: "_")[1])!)
                                        }
                                    }
                            }
                            if value.contains("day") {
                                Calendar_Week_Day(userInfo: userInfo, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel, updateVersion: updateVersion)
                                    .calendarViewNavigationBar(userInfo: userInfo, userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel, calendarState: "day")
                                    .onAppear {
                                        if value.split(separator: "_").count > 1 {
                                            calendarViewModel.setCurrentDay(day:Int(value.split(separator: "_")[1])!)
                                        }
                                    }
                            }
                            if value == "addGoal" {
                                RecordView(userInfo: userInfo, navigationViewModel: navigationViewModel)
                                    .navigationBarTitleDisplayMode(.inline)
                            }
                            if value == "appInfo" {
                                AppInfoView()
                                    .navigationBarTitleDisplayMode(.inline)
                            }
                        }
                }
            } else {
                TabView (selection: $navigationViewModel.tagIndex) {
                    CalendarView(userInfo: userInfo, userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel)
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("목표 확인")
                        }
                        .tag(0)
                    RecordView(userInfo: userInfo, navigationViewModel: navigationViewModel)
                        .tabItem {
                            Image(systemName: "pencil")
                            Text("목표 추가")
                        }
                        .tag(1)
                    AppInfoView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("어플 정보")
                        }
                        .tag(2)
                }
                .navigationBarTitle("이전")
                .navigationBarHidden(true)
                .mainViewDragGesture(userInfo: userInfo, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel)
            }
        }
        .tint(Color("CustomColor"))
        .accentColor(Color("CustomColor"))
        // 추후 수정: initView로 옮기기
        .onAppear {
            if updateVersion && userInfo.currentState != "year" {
                navigationViewModel.appendPath(path: "month")
            }
        }
    }
}

#Preview {
    MainView(userInfo: UserInfo(), userInfoViewModel: UserInfoViewModel())
}
