//
//  NotificationIndicator.swift
//  Daily
//
//  Created by seungyooooong on 3/14/26.
//

import SwiftUI

struct NotificationIndicator: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Colors.Background.primary)
                .frame(width: 16, height: 16)
            Image(.notification)
                .resizable()
                .scaledToFit()
                .frame(width: 12)
        }
        .padding(.top, -3)
        .padding(.trailing, -2)
        .vTop()
        .hTrailing()
    }
}
