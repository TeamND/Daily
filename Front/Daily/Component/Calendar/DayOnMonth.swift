//
//  DayOnMonth.swift
//  Daily
//
//  Created by 최승용 on 2022/11/10.
//

import SwiftUI

struct DayOnMonth: View {
    @StateObject var userInfo: UserInfo
    let day: Int
    @Binding var dayObject: [String: Any]
    var body: some View {
        let ratingSymbol = dayObject[String(format: "%02d", day)] as? [String: Any]
                            ?? ["ration": 0, "symbol": Array(repeating: ["imageName": "", "isSuccess": false], count: 4)]
        let symbols: Array<[String: Any]> = ratingSymbol["symbol"] as! Array<[String: Any]>
        VStack(alignment: .leading) {
            ZStack {
                Image(systemName: "circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.mint.opacity(ratingSymbol["rating"] as? Double ?? 0))
                Text("\(day)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.primary)
            }
            .padding(4)
            VStack(alignment: .center, spacing: 8) {
                HStack(spacing: 0) {
                    ForEach(symbols.indices, id: \.self) { symbolIndex in
                        if 0 <= symbolIndex && symbolIndex < 2 {
                            SymbolOnMonth(symbol: symbols[symbolIndex])
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                HStack(spacing: 0) {
                    ForEach(symbols.indices, id: \.self) { symbolIndex in
                        if symbols.count > 4 && symbolIndex == 3 {
                            Button {
                                print("show symbols popup")
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                            .frame(maxWidth: .infinity)
                        } else if 2 <= symbolIndex && symbolIndex < 4 {
                            SymbolOnMonth(symbol: symbols[symbolIndex])
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                Spacer()
            }
            .frame(height: 40)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.primary)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.green, lineWidth: 2)
                .opacity(userInfo.isToday(day: day) ? 1 : 0)
        }
        .padding(4)
        .frame(width: CGFloat.dayOnMonthWidth)
        .frame(idealHeight: CGFloat.dayOnMonthHeight)
    }
}
