//
//  AppInfoContent.swift
//  Daily
//
//  Created by 최승용 on 3/27/24.
//

import SwiftUI

struct AppInfoContent: View {
    var name: String
    var content: String? = nil
    var linkLabel: String? = nil
    var linkDestination: String? = nil
    var settingType: SettingTypes? = nil
    @AppStorage(UserDefaultKey.startDay.rawValue) var startDay: Int = 0
    @AppStorage(UserDefaultKey.language.rawValue) var language: String = ""
    @AppStorage(UserDefaultKey.calendarType.rawValue) var calendarType: String = ""
    
    var body: some View {
        VStack {
            Divider().padding(.vertical, 5)
            HStack {
                Text(name).foregroundStyle(.gray)
                Spacer()
                Group {
                    if let content {
                        Text(content)
                    } else if let linkLabel, let linkDestination {
                        Group {
                            Link(destination: URL(string: "https://\(linkDestination)")!) { Text(linkLabel) }
                            Image(systemName: "arrow.up.right.square")
                        }
                        .foregroundStyle(Colors.daily)
                    } else if let settingType {
                        Group {
                            switch settingType {
                            case .startDay:
                                Picker("", selection: Binding(get: { startDay }, set: { UserDefaultManager.startDay = $0 })) {
                                    Text("\(DayOfWeek.sun)").tag(DayOfWeek.sun.index)
                                    Text("\(DayOfWeek.mon)").tag(DayOfWeek.mon.index)
                                }
                            case .language:
                                Picker("", selection: Binding(get: { language }, set: { UserDefaultManager.language = $0 })) {
                                    ForEach(Languages.allCases, id: \.self) { language in
                                        Text("\(language)").tag(language.rawValue)
                                    }
                                }
                            case .calendarType:
                                Picker("", selection: Binding(get: { calendarType }, set: { UserDefaultManager.calendarType = $0 })) {
                                    ForEach(CalendarType.allCases, id: \.self) { calendarType in
                                        Text("\(calendarType)").tag(calendarType.rawValue)
                                    }
                                }
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: CGFloat.fontSize * 35)
                    } else {
                        EmptyView()
                    }
                }
                .fontWeight(.bold)
            }
        }
    }
}
