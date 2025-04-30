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
        HStack(spacing: 8) {
            Text(setTime)
                .font(Fonts.bodySmRegular)
                .foregroundStyle(Colors.Text.secondary)
            DailyDivider(color: Colors.Border.primary, height: 1)
        }
    }
}
