//
//  AppSetting.swift
//  Daily
//
//  Created by seungyooooong on 1/8/25.
//

import SwiftUI

struct AppSetting: View {
    var body: some View {
        VStack {
            GroupBox {
                AppInfoContent(name: "Initial CalendarType", settingType: .calendarState)
            } label: {
                AppInfoLabel(labelText: "Setting", labelImage: "gear")
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    AppSetting()
}
