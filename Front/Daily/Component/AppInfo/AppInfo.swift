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
                AppInfoContent(name: "Version", content: "1.0.0")
//                AppInfoContent(name: "Notion", linkLabel: "Go to Warehouse TIL", linkDestination: "notion.so/seungyooooong/Warehouse-5f82fe5b62814bb7b8482377b70ec4c3")
                AppInfoContent(name: "Github", linkLabel: "Go to Repository", linkDestination: "github.com/TeamND/Daily")
            } label: {
                AppInfoLabel(labelText: "Application", labelImage: "apps.iphone")
            }
            .padding(.vertical)
            Spacer()
        }
    }
}

#Preview {
    AppInfo()
}

