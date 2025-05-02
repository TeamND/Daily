//
//  SettingView.swift
//  Daily
//
//  Created by seungyooooong on 10/29/24.
//

import SwiftUI

struct SettingView: View {
    @AppStorage(UserDefaultKey.calendarType.rawValue) private var calendarType: String = ""
    
    var body: some View {
        VStack(spacing: 24) {
            NavigationHeader(title: "설정")
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
            if true { serviceEnvironmentSetting }  // FIXME: 구현 후 추가
            appInfo
            // TODO: 추후 튜토리얼 추가
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    private var initialCalendarSetting: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("초기 화면 설정")
                .font(Fonts.bodyLgSemiBold)
                .foregroundStyle(Colors.Text.primary)
            Spacer().frame(height: 4)
            Text("앱 실행 시 가장 먼저 보여줄 캘린더 뷰를 선택하세요.")
                .font(Fonts.bodyMdRegular)
                .foregroundStyle(Colors.Icon.secondary)
            Spacer().frame(height: 12)
            HStack(spacing: 14) {
                ForEach(CalendarTypes.allCases.filter { $0 != .week }, id: \.self) { type in
                    Button {
                        calendarType = type.rawValue
                    } label: {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(type.icon(isSelected: type.rawValue == calendarType))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 51)
                            Text(type.text)
                                .font(Fonts.bodyMdSemiBold)
                                .foregroundStyle(type.rawValue == calendarType ? Colors.Text.point :Colors.Text.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Colors.Background.secondary)
                            .stroke(type.rawValue == calendarType ? Colors.Brand.primary : .clear, lineWidth: 1)
                    }
                }
            }
        }
    }
    
    enum ServiceEnvironmentSetting: CaseIterable {
        case language
        case startWeekday
        case filterAlignment
        
        var text: String {
            switch self {
            case .language:
                return "언어"
            case .startWeekday:
                return "시작 요일"
            case .filterAlignment:
                return "필터 순서"
            }
        }
    }
    
    private var serviceEnvironmentSetting: some View {
        VStack(alignment: .leading, spacing: 16) {
            AppInfoLabel(text: "서비스 환경")
            ForEach(ServiceEnvironmentSetting.allCases, id: \.self) { serviceEnvironment in
                AppInfoContent(name: serviceEnvironment.text)
                DailyDivider(color: Colors.Border.secondary, height: 1)
            }
        }
    }
    
    enum AppInfo: CaseIterable {
        case targetOS
        case version
        case notion
        case github
        
        var text: String {
            switch self {
            case .targetOS:
                return "호환성"
            case .version:
                return "버전"
            case .notion:
                return "사용설명서"
            case .github:
                return "Github"
            }
        }
        
        var content: String? {
            switch self {
            case .targetOS:
                return "iOS 17.0"
            case .version:
                return System.appVersion
            default:
                return nil
            }
        }
        
        var link: String? {
            switch self {
            case .notion:
                return "seungyooooong.notion.site/Daily-44127143818b4a8f8d9e864d992b549f?pvs=4"
            case .github:
                return "github.com/TeamND/Daily"
            default:
                return nil
            }
        }
    }
    
    private var appInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            AppInfoLabel(text: "앱 정보")
            ForEach(AppInfo.allCases, id: \.self) { appInfo in
                AppInfoContent(name: appInfo.text, content: appInfo.content, link: appInfo.link)
                DailyDivider(color: Colors.Border.secondary, height: 1)
            }
        }
    }
}

#Preview {
    SettingView()
}
