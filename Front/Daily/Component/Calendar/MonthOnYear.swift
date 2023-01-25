//
//  MonthOnYear.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import SwiftUI

struct MonthOnYear: View {
    @StateObject var userInfo: UserInfo
    @Binding var archievements: [Double]
    var month: Int
    var fontSize: CGFloat = 6
    var isTapSelect: Bool = false
    var body: some View {
        let startDayIndex = userInfo.startDayIndex(month: month)
        let lengthOfMonth = userInfo.lengthOfMonth(month: month)
        VStack(alignment: .leading) {
            Text(userInfo.months[month - 1])
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .padding(4)
            ForEach (0..<6) { rowIndex in
                HStack(spacing: 1) {
                    ForEach (0..<7) { colIndex in
                        ZStack {
                            let day: Int = rowIndex * 7 + colIndex - startDayIndex + 1
                            Image(systemName: "circle.fill")
                                .font(.system(size: fontSize * 2))
                                .foregroundColor(.mint.opacity(archievements[rowIndex * 7 + colIndex]))
                            if isTapSelect {
                                Button {
                                    if archievements[rowIndex * 7 + colIndex] == 0 {
                                        archievements[rowIndex * 7 + colIndex] = 0.4
                                    } else {
                                        archievements[rowIndex * 7 + colIndex] = 0
                                    }
                                } label: {
                                    if 1 <= day && day <= lengthOfMonth {
                                        Text("\(day)")
                                            .font(.system(size: fontSize, weight: .bold))
                                            .foregroundColor(.primary)
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
                                        .foregroundColor(.primary)
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
