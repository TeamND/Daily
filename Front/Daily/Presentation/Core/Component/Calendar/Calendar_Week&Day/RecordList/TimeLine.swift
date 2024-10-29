//
//  TimeLine.swift
//  Daily
//
//  Created by 최승용 on 6/7/24.
//

import SwiftUI

struct TimeLine: View {
    @Binding var record: RecordModel
    @State var color: Color = .primary.opacity(0.8)
    
    var body: some View {
        HStack {
            CustomDivider(color: color, height: CGFloat.fontSize / 3, hPadding: CGFloat.fontSize)
                .frame(width: CGFloat.fontSize * 5)
            Text(record.set_time)
                .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
                .foregroundStyle(color)
            CustomDivider(color: color, height: CGFloat.fontSize / 3, hPadding: CGFloat.fontSize)
        }
        .frame(height: CGFloat.fontSize * 3)
        .padding(.bottom, -CGFloat.fontSize * 1.5)
    }
}
