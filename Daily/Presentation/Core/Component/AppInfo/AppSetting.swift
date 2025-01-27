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
                AppInfoContent(name: "Initial CalendarType", settingType: .calendarType)
                AppInfoContent(name: "StartDay", settingType: .startDay)
                AppInfoContent(name: "Language", settingType: .language)
            } label: {
                AppInfoLabel(labelText: "Setting", labelImage: "gear")
            }
        }
    }
}

#Preview {
    AppSetting()
}
