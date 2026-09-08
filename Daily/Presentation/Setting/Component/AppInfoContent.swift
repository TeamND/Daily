//
//  AppInfoContent.swift
//  Daily
//
//  Created by 최승용 on 3/27/24.
//

import SwiftUI

struct AppInfoContent: View {
    @EnvironmentObject private var settingViewModel: SettingViewModel
    
    var appInfo: Settings.AppInfo? = nil
    var serviceEnvironment: Settings.ServiceEnvironmentSetting? = nil
    
    var body: some View {
        HStack {
            Text(appInfo?.text ?? serviceEnvironment?.text ?? "")
                .font(Fonts.bodyLgSemiBold)
                .foregroundStyle(Colors.Text.primary)
            Spacer()
            if let appInfo {
                if let content = appInfo.content {
                    Text(content)
                        .font(Fonts.bodyLgMedium)
                        .foregroundStyle(Colors.Text.secondary)
                } else if let link = appInfo.link {
                    Link(destination: URL(string: "https://\(link)")!) {
                        Image(.link)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .padding(-4)
                    }
                }
            } else if let serviceEnvironment {
                switch serviceEnvironment {
                case .language:
                    DailySegment(
                        segmentType: .component,
                        currentType: $settingViewModel.language,
                        types: Languages.allCases
                    ) { language in
                        settingViewModel.language = language
                        
                        AnalyticsManager.shared.log(.changeLanguage, .language(language))
                    }.padding(-9)
                    
                case .startWeekday:
                    DailySegment(
                        segmentType: .component,
                        currentType: $settingViewModel.startDay,
                        types: [DayOfWeek.sun, DayOfWeek.mon]
                    ).padding(-9)
                    
                case .filterAlignment:
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Colors.Icon.secondary)
                        .frame(width: 24, height: 24)
                        .padding(-2)
                }
            }
        }
    }
}
