//
//  DailyButton.swift
//  Daily
//
//  Created by seungyooooong on 11/25/24.
//

import SwiftUI

struct DailyButton: View {
    let action: () -> Void
    let text: String
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .padding(CGFloat.fontSize * 2)
                .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
                .foregroundStyle(Colors.theme)
        }
        .background(Colors.daily)
        .cornerRadius(10)
    }
}
