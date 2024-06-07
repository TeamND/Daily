//
//  TimeLine.swift
//  Daily
//
//  Created by 최승용 on 6/7/24.
//

import SwiftUI

struct TimeLine: View {
    @Binding var record: RecordModel
    @State var color: Color = .white
    
    var body: some View {
        if false {   // TimeLine 표시 조건 추후에 추가
            HStack {
                CustomDivider(color: color, height: 1, hPadding: CGFloat.fontSize)
                    .frame(width: CGFloat.fontSize * 5)
                Text("14 : 00")
                    .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
                    .foregroundStyle(color)
                CustomDivider(color: color, height: 1, hPadding: CGFloat.fontSize)
            }
            .frame(height: CGFloat.fontSize * 3)
        }
    }
}
