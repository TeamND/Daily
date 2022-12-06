//
//  MonthOnYear.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import SwiftUI

struct MonthOnYear: View {
    @State var archievements: [[Double]] = [
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0]
    ]
    var monthIndex: Int
    var fontSize: CGFloat = 6
    var isTapSelect: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
                Text(kMonths[monthIndex])
                    .font(.system(size: 20, weight: .bold))
            .padding(4)
            ForEach (0..<6) { rowIndex in
                HStack(spacing: 1) {
                    ForEach (0..<7) { colIndex in
                        ZStack {
                            Image(systemName: "circle.fill")
                                .font(.system(size: fontSize * 2))
                                .foregroundColor(.mint.opacity(archievements[rowIndex][colIndex]))
                            if isTapSelect {
                                Button {
                                    if archievements[rowIndex][colIndex] == 0 {
                                        archievements[rowIndex][colIndex] = 0.4
                                    } else {
                                        archievements[rowIndex][colIndex] = 0
                                    }
                                } label: {
                                    Text("1")
                                        .foregroundColor(.black)
                                        .font(.system(size: fontSize, weight: .bold))
                                }
                            } else {
                                Text("1")
                                    .font(.system(size: fontSize, weight: .bold))
                            }
                        }
                    }
                }
            }
        }
        .padding(12)
    }
}
