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
            } else {
                // FIXME: 추후 구현
//                switch serviceEnvironment {
//                case .language:
                    HStack(spacing: .zero) {
                        ForEach(Languages.allCases, id: \.self) { lang in
                            Button {
                                language = lang.rawValue
                            } label: {
                                Text(lang.text)
                                    .font(Fonts.bodyMdSemiBold)
                                    .foregroundStyle(lang.rawValue == language ? Colors.Text.point : Colors.Text.tertiary)
                            }
                            .padding(.horizontal, 10.5)
                            .padding(.vertical, 5.5)
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
                    .padding(-6)
                    
//                case .startWeekday:
//                    Text("test12")
//                        Picker("", selection: Binding(get: { startDay }, set: { UserDefaultManager.startDay = $0 })) {
//                            Text("\(DayOfWeek.sun)").tag(DayOfWeek.sun.index)
//                            Text("\(DayOfWeek.mon)").tag(DayOfWeek.mon.index)
//                        }
                    
//                case .filterAlignment:
//                    Text("test")
//                }
            }
        }
    }
}
