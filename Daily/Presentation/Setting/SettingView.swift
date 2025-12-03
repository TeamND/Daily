//
//  SettingView.swift
//  Daily
//
//  Created by seungyooooong on 10/29/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var settingViewModel: SettingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            NavigationHeader(title: "setting".localized)
            ViewThatFits(in: .vertical) {
                settingView
                ScrollView(.vertical, showsIndicators: false) {
                    settingView
                }
            }
        }
    }
    
    private var settingView: some View {
        VStack(spacing: 30) {
            initialCalendarSetting
            serviceEnvironmentSetting
            appInfo
            // TODO: 추후 튜토리얼 추가
            Spacer()    // FIXME: 높이가 애매한 경우 scrollView로 안넘어가고 View 제일 하단이 Spacer()에 밀리는 부분이 생김
        }
        .padding(.horizontal, 16)
    }
    
    private var initialCalendarSetting: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("default_view".localized)
                .font(Fonts.bodyLgSemiBold)
                .foregroundStyle(Colors.Text.primary)
            Spacer().frame(height: 4)
            Text("default_view_description".localized)
                .font(Fonts.bodyMdRegular)
                .foregroundStyle(Colors.Icon.secondary)
            Spacer().frame(height: 12)
            HStack(spacing: 14) {
                ForEach(CalendarTypes.allCases.filter { $0 != .week }, id: \.self) { type in
                    let isSelected = type == settingViewModel.calendarType
                    Button {
                        settingViewModel.calendarType = type
                    } label: {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(type.icon(isSelected: isSelected))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 51)
                            Text(type.text)
                                .font(Fonts.bodyMdSemiBold)
                                .foregroundStyle(isSelected ? Colors.Text.point :Colors.Text.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Colors.Background.secondary)
                            .stroke(isSelected ? Colors.Brand.primary : .clear, lineWidth: 1)
                    }
                }
            }
        }
    }
    
    private var serviceEnvironmentSetting: some View {
        VStack(alignment: .leading, spacing: 16) {
            AppInfoLabel(text: Settings.serviceEnvironment.label)
            // FIXME: 구현된 부분만 적용
//            ForEach(Settings.ServiceEnvironmentSetting.allCases, id: \.self) { serviceEnvironment in
//                AppInfoContent(name: serviceEnvironment.text, serviceEnvironment: serviceEnvironment)
//                DailyDivider(color: Colors.Border.secondary, height: 1)
//            }
            AppInfoContent(
                name: Settings.ServiceEnvironmentSetting.language.text,
                serviceEnvironment: Settings.ServiceEnvironmentSetting.language
            )
            DailyDivider(color: Colors.Border.secondary, height: 1)
            AppInfoContent(
                name: Settings.ServiceEnvironmentSetting.startWeekday.text,
                serviceEnvironment: Settings.ServiceEnvironmentSetting.startWeekday
            )
            DailyDivider(color: Colors.Border.secondary, height: 1)
        }
    }
    
    private var appInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            AppInfoLabel(text: Settings.appInfo.label)
            ForEach(Settings.AppInfo.allCases, id: \.self) { appInfo in
                AppInfoContent(name: appInfo.text, content: appInfo.content, link: appInfo.link)
                DailyDivider(color: Colors.Border.secondary, height: 1)
            }
        }
    }
}

#Preview {
    SettingView()
}
