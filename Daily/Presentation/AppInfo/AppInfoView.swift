//
//  AppInfoView.swift
//  Daily
//
//  Created by seungyooooong on 10/29/24.
//

import SwiftUI

struct AppInfoView: View {
    var body: some View {
        DailyNavigationBar(title: "어플정보")
        ViewThatFits(in: .vertical) {
            appInfoView
            ScrollView(.vertical, showsIndicators: false) {
                appInfoView
            }
        }
    }
    
    private var appInfoView: some View {
        VStack {
            appSetting
            appInfo
            // TODO: 추후 튜토리얼 추가
            Spacer()
        }
        .padding(CGFloat.fontSize)
    }
    
    private var appSetting: some View {
        VStack {
            GroupBox {
//                AppInfoContent(name: "StartDay", settingType: .startDay)
//                AppInfoContent(name: "Language", settingType: .language)
                AppInfoContent(name: "Initial CalendarType", settingType: .calendarType)
            } label: {
                AppInfoLabel(labelText: "Setting", labelImage: "gear")
            }
        }
    }
    
    private var appInfo: some View {
        VStack {
            GroupBox {
                AppInfoContent(name: "Developer", content: "TeamND")
                AppInfoContent(name: "Compatibility", content: "iOS 17.0")
                AppInfoContent(name: "Version", content: System.appVersion)
                AppInfoContent(name: "Notion", linkLabel: "Go to Manual", linkDestination: "seungyooooong.notion.site/Daily-44127143818b4a8f8d9e864d992b549f?pvs=4")
                AppInfoContent(name: "Github", linkLabel: "Go to Repository", linkDestination: "github.com/TeamND/Daily")
            } label: {
                AppInfoLabel(labelText: "Application", labelImage: "apps.iphone")
            }
        }
    }
}

#Preview {
    AppInfoView()
}
