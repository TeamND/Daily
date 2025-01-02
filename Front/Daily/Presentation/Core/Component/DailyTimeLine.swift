//
//  DailyTimeLine.swift
//  Daily
//
//  Created by seungyooooong on 11/28/24.
//

import SwiftUI

struct DailyTimeLine: View {
    let setTime: String
    
    var body: some View {
        CustomDivider(
            color: Colors.reverse.opacity(0.8),
            height: CGFloat.fontSize / 3,
            hPadding: CGFloat.fontSize
        )
        .overlay {
            Text(setTime)
                .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
                .padding(.horizontal, CGFloat.fontSize * 2)
                .background(Colors.theme)
                .hLeading()
                .padding(.leading, CGFloat.fontSize * 7)
        }
        .frame(height: CGFloat.fontSize * 3)
        .padding(.bottom, -CGFloat.fontSize * 1.5)
    }
}
