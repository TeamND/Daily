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
            AppSetting()
            AppInfo()
            // TODO: 추후 튜토리얼 추가
            Spacer()
        }
        .padding(CGFloat.fontSize)
    }
}

#Preview {
    AppInfoView()
}
