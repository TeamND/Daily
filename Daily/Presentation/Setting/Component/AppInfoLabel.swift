//
//  AppInfoLabel.swift
//  Daily
//
//  Created by 최승용 on 3/27/24.
//

import SwiftUI

struct AppInfoLabel: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(Fonts.bodySmRegular)
            .foregroundStyle(Colors.Text.tertiary)
    }
}
