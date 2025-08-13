//
//  AppInfoContent.swift
//  Daily
//
//  Created by 최승용 on 3/27/24.
//

import SwiftUI

struct AppInfoContent: View {
    @AppStorage(UserDefaultKey.startDay.rawValue) private var startDay: Int = 0
    @AppStorage(UserDefaultKey.language.rawValue) private var language: String = ""
    
    var name: String
    var content: String? = nil
    var link: String? = nil
    var serviceEnvironment: Settings.ServiceEnvironmentSetting? = nil
    
    var body: some View {
        HStack {
            Text(name)
                .font(Fonts.bodyLgSemiBold)
                .foregroundStyle(Colors.Text.primary)
            Spacer()
            if let content {
                Text(content)
                    .font(Fonts.bodyLgMedium)
                    .foregroundStyle(Colors.Text.secondary)
            } else if let link {
                Link(destination: URL(string: "https://\(link)")!) {
                    Image(.link)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .padding(-4)
                }
            } else if let serviceEnvironment {
                // FIXME: 추후 구현
                switch serviceEnvironment {
                case .language:
                    // FIXME: UI 맞춰서 적용
                    DailySegment(
                        segmentType: .component,
                        currentType: Binding<Languages>(get: { Languages(rawValue: language) ?? .korean }, set: { _ in }),
                        types: Languages.allCases
                    ) {
                        language = $0.rawValue
                    }
                    HStack(spacing: .zero) {
                        ForEach(Languages.allCases, id: \.self) { lang in
                            Button {
                                language = lang.rawValue
                            } label: {
                                Text(lang.text)
                                    .font(Fonts.bodyMdSemiBold)
                                    .foregroundStyle(lang.rawValue == language ? Colors.Text.point : Colors.Text.tertiary)
                            }
                            .frame(width: 60, height: 30)
                            .background {
                                RoundedRectangle(cornerRadius: 99)
                                    .fill(lang.rawValue == language ? Colors.Background.primary : .clear)
                                    .stroke(lang.rawValue == language ? Colors.Brand.primary : .clear, lineWidth: 1)
                            }
                        }
                    }
                    .padding(4)
                    .background {
                        RoundedRectangle(cornerRadius: 99)
                            .fill(Colors.Background.secondary)
                    }
                    .padding(-5)
                    
                case .startWeekday:
                    // FIXME: UI 맞춰서 적용
                    DailySegment(
                        segmentType: .component,
                        currentType: Binding<DayOfWeek>(get: { DayOfWeek.from(index: startDay) ?? .sun }, set: { _ in }),
                        types: [DayOfWeek.sun, DayOfWeek.mon]
                    ) {
                        startDay = $0.index
                    }
                    HStack(spacing: .zero) {
                        ForEach([DayOfWeek.sun, DayOfWeek.mon], id: \.self) { dow in
                            Button {
                                startDay = dow.index
                            } label: {
                                Text(dow.fullText)
                                    .font(Fonts.bodyMdSemiBold)
                                    .foregroundStyle(dow.index == startDay ? Colors.Text.point : Colors.Text.tertiary)
                            }
                            .frame(width: 60, height: 30)
                            .background {
                                RoundedRectangle(cornerRadius: 99)
                                    .fill(dow.index == startDay ? Colors.Background.primary : .clear)
                                    .stroke(dow.index == startDay ? Colors.Brand.primary : .clear, lineWidth: 1)
                            }
                        }
                    }
                    .padding(4)
                    .background {
                        RoundedRectangle(cornerRadius: 99)
                            .fill(Colors.Background.secondary)
                    }
                    .padding(-5)
                    
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
