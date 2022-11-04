//
//  DailyApp.swift
//  Daily
//
//  Created by 최승용 on 2022/10/31.
//

import SwiftUI

@main
struct DailyApp: App {
    @State var isDoneLoading: Bool = false
    var body: some Scene {
        WindowGroup {
            if isDoneLoading { LoginView() }
            else { InitView(isDoneLoading: $isDoneLoading) }
        }
    }
}
