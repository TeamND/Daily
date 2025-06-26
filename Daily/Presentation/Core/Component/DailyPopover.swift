//
//  DailyPopover.swift
//  Daily
//
//  Created by seungyooooong on 6/26/25.
//

import SwiftUI

struct DailyPopover<Content: View>: View {
    let position: CGPoint
    var content: () -> Content
    
    var body: some View {
        Group(content: content)
            .fixedSize()
            .background(Colors.Background.secondary)
            .cornerRadius(8)
            .shadow(color: Colors.Icon.primary.opacity(0.25), radius: 8)
            .position(position)
    }
}
