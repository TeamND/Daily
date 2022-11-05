//
//  DailyApp.swift
//  Daily
//
//  Created by 최승용 on 2022/10/31.
//

import SwiftUI

@main
struct DailyApp: App {
    @State var isLoading: Bool = true
    @State var isLogin: Bool = false
    var body: some Scene {
        WindowGroup {
            if isLoading { InitView(isLoading: $isLoading) }
            else {
                if isLogin { MainView() }
                else { LoginView() }
            }
        }
    }
}
