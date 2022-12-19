//
//  MonthOnYear.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import SwiftUI

struct MonthOnYear: View {
    @StateObject var userInfo: UserInfo
    @State var archievements: [[Double]] = [
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0]
    ]
    var month: Int
    var fontSize: CGFloat = 6
    var isTapSelect: Bool = false
    var body: some View {
        let startDayIndex = userInfo.startDayIndex(year: userInfo.currentYear, month: month)
        let lengthOfMonth = userInfo.lengthOfMonth(year: userInfo.currentYear, month: month)
        VStack(alignment: .leading) {
            Text(kMonths[month - 1])
                .font(.system(size: 20, weight: .bold))
                .padding(4)
            ForEach (0..<6) { rowIndex in
                HStack(spacing: 1) {
                    ForEach (0..<7) { colIndex in
                        ZStack {
                            let day: Int = rowIndex * 7 + colIndex - startDayIndex + 1
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
                                    if 1 <= day && day <= lengthOfMonth {
                                        Text("\(day)")
                                            .foregroundColor(.black)
                                            .font(.system(size: fontSize, weight: .bold))
                                    } else {
                                        Text("1")
                                            .font(.system(size: fontSize, weight: .bold))
                                            .opacity(0)
                                    }
                                }
                            } else {
                                if 1 <= day && day <= lengthOfMonth {
                                    Text("\(day)")
                                        .font(.system(size: fontSize, weight: .bold))
                                } else {
                                    Text("1")
                                        .font(.system(size: fontSize, weight: .bold))
                                        .opacity(0)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(12)
    }
}
