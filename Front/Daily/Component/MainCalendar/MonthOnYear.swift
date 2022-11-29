//
//  MonthOnYear.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import SwiftUI

struct MonthOnYear: View {
    var monthIndex: Int
    var fontSize: CGFloat = 6
    var body: some View {
        VStack {
            HStack {
                Text(kMonths[monthIndex])
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding(4)
            ForEach (0..<6) { rowIndex in
                HStack(spacing: 1) {
                    ForEach (0..<7) { colIndex in
                        ZStack {
                            Image(systemName: "circle.fill")
                                .font(.system(size: fontSize*2))
                                .foregroundColor(.mint.opacity(0.4))
                            Text("1")
                                .font(.system(size: fontSize, weight: .bold))
                        }
                    }
                }
            }
        }
        .padding(12)
    }
}
