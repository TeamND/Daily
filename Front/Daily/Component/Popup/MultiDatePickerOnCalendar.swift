//
//  MultiDatePickerOnCalendar.swift
//  Daily
//
//  Created by 최승용 on 2023/01/29.
//

import SwiftUI

struct MultiDatePickerOnCalendar: View {
    @State var year: String
    @State var month: String
    var startDayIndex = 0
    var lengthOfMonth = 40

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(year)-\(month)")
                .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                .foregroundColor(.primary)
                .padding(4)
            ForEach (0..<6) { rowIndex in
                HStack(spacing: 1) {
                    ForEach (0..<7) { colIndex in
                        ZStack {
                            let day: Int = rowIndex * 7 + colIndex - startDayIndex + 1
                            Image(systemName: "circle.fill")
                                .font(.system(size: CGFloat.fontSize * 2))
                                .foregroundColor(Color("CustomColor").opacity(0.4))
                            Button {
//                                if archievements[rowIndex * 7 + colIndex] == 0 {
//                                    archievements[rowIndex * 7 + colIndex] = 0.4
//                                } else {
//                                    archievements[rowIndex * 7 + colIndex] = 0
//                                }
                                print("testt")
                            } label: {
                                if 1 <= day && day <= lengthOfMonth {
                                    Text("\(day)")
                                        .font(.system(size: CGFloat.fontSize, weight: .bold))
                                        .foregroundColor(.primary)
                                } else {
                                    Text("1")
                                        .font(.system(size: CGFloat.fontSize, weight: .bold))
                                        .opacity(0)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
