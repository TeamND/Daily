//
//  AppInfo.swift
//  Daily
//
//  Created by 최승용 on 3/27/24.
//

import SwiftUI

struct AppInfo: View {
    var body: some View {
        VStack {
            GroupBox {
                AppInfoContent(name: "Developer", content: "TeamND")
                AppInfoContent(name: "Compatibility", content: "iOS16.0")
                AppInfoContent(name: "Version", content: System.appVersion)
//                AppInfoContent(name: "Notion", linkLabel: "Go to Warehouse TIL", linkDestination: "notion.so/seungyooooong/Warehouse-5f82fe5b62814bb7b8482377b70ec4c3")
                AppInfoContent(name: "Notion", linkLabel: "Go to Manual", linkDestination: "seungyooooong.notion.site/Daily-44127143818b4a8f8d9e864d992b549f?pvs=4")
                AppInfoContent(name: "Github", linkLabel: "Go to Repository", linkDestination: "github.com/TeamND/Daily")
            } label: {
                AppInfoLabel(labelText: "Application", labelImage: "apps.iphone")
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    AppInfo()
}

