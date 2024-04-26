//
//  AppInfoView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct AppInfoView: View {
    var body: some View {
        ViewThatFits(in: .vertical) {
            AppInfo()
                .padding()
            ScrollView(.vertical, showsIndicators: false) {
                AppInfo()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AppInfoView()
}
