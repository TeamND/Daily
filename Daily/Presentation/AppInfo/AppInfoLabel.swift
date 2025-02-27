//
//  AppInfoLabel.swift
//  Daily
//
//  Created by 최승용 on 3/27/24.
//

import SwiftUI

struct AppInfoLabel: View {
    let labelText: String
    let labelImage: String
    
    var body: some View {
        HStack {
            Text(labelText.uppercased()).fontWeight(.bold)
            Spacer()
            Image(systemName: labelImage)
        }
    }
}

#Preview {
    AppInfoLabel(labelText: "AppInfoHead", labelImage: "gear")
}
