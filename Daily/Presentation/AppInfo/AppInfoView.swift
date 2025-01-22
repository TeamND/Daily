//
//  AppInfoView.swift
//  Daily
//
//  Created by seungyooooong on 10/29/24.
//

import SwiftUI

struct AppInfoView: View {
    var body: some View {
        ViewThatFits(in: .vertical) {
            appInfoView
            ScrollView(.vertical, showsIndicators: false) {
                appInfoView
            }
        }
    }
    
    private var appInfoView: some View {
        VStack {
            DailyNavigationBar(title: "어플정보")
            AppSetting()
            AppInfo()
            // TODO: 추후 튜토리얼 추가
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AppInfoView()
}
