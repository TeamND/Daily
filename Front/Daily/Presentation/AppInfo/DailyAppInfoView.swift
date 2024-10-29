//
//  DailyAppInfoView.swift
//  Daily
//
//  Created by seungyooooong on 10/29/24.
//

import SwiftUI

struct DailyAppInfoView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    
    var body: some View {
        ViewThatFits(in: .vertical) {
            dailyAppInfoView
            ScrollView(.vertical, showsIndicators: false) {
                dailyAppInfoView
            }
        }
    }
    
    private var dailyAppInfoView: some View {
        VStack {
            DailyNavigationBar(title: "어플정보")
            // TODO: 추후 설정 추가
            AppInfo()
            // TODO: 추후 튜토리얼 추가
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DailyAppInfoView()
}
