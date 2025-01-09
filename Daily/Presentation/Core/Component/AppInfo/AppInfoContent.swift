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
                        switch settingType {
                        case .calendarType:
                            Picker("", selection: Binding(get: { calendarType }, set: { UserDefaultManager.calendarType = $0 })) {
                                ForEach(CalendarType.allCases, id: \.self) { calendarType in
                                    Text("\(calendarType)").tag(calendarType.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                        default:
                            EmptyView()
                        }
                    } else {
                        EmptyView()
                    }
                }
                .fontWeight(.bold)
            }
        }
    }
}
