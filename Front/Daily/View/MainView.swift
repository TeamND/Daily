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
    
    var body: some View {
        NavigationStack {
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
            .mainViewDragGesture(userInfo: userInfo, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel)
            .navigationBarTitle("이전")
            .navigationBarHidden(true)
        }
        .tint(Color("CustomColor"))
    }
}

#Preview {
    MainView(userInfo: UserInfo(), userInfoViewModel: UserInfoViewModel())
}
