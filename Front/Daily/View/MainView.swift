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
    @StateObject var popupInfo: PopupInfo = PopupInfo()
    @State var updateVersion: Bool = false
    @State var calendarPath: [String] = []
    
    var body: some View {
        NavigationStack(path: $calendarPath) {
            if updateVersion {
                ZStack {
                    VStack(spacing: 0) {
                        CalendarView(userInfo: userInfo, userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel, popupInfo: popupInfo, updateVersion: updateVersion)
                            .navigationBarTitle(calendarPath.count > 0 && calendarPath[calendarPath.count - 1] == "addGoal" ? "이전" : "\(userInfo.currentYearLabel)")
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarItems(trailing:
                                                    NavigationLink {
                                AppInfoView()
                            } label: {
                                VStack {
                                    Image(systemName: "info.circle")
                                        .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                                }
                            }
                                .padding(CGFloat.fontSize)
                            )
                            .navigationDestination(for: String.self) { value in
                                if value == "month" {
                                    Calendar_Month(userInfo: userInfo, calendarViewModel: calendarViewModel)
                                        .navigationBarTitle(calendarPath.count > 0 && calendarPath[calendarPath.count - 1] == "month" ? "\(userInfo.currentMonthLabel)" : "이전")
                                        .navigationBarTitleDisplayMode(.inline)
                                        .navigationBarItems(trailing:
                                                                NavigationLink {
                                            AppInfoView()
                                        } label: {
                                            VStack {
                                                Image(systemName: "info.circle")
                                                    .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                                            }
                                        }
                                            .padding(CGFloat.fontSize)
                                        )
                                }
                                if value == "addGoal" {
                                    RecordView(userInfo: userInfo, navigationViewModel: navigationViewModel)
                                        .navigationBarTitleDisplayMode(.inline)
                                }
                            }
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            AddGoalButton(userInfo: userInfo, navigationViewModel: navigationViewModel)
                        }
                        .padding()
                    }
                    .padding()
    //                .mainViewDragGesture(userInfo: userInfo, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel)
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
        .onAppear {
            if updateVersion && userInfo.currentState != "year" {
                calendarPath.append("month")
            }
        }
    }
}

#Preview {
    MainView(userInfo: UserInfo(), userInfoViewModel: UserInfoViewModel())
}
