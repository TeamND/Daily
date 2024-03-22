//
//  DayOnMonth.swift
//  Daily
//
//  Created by 최승용 on 2022/11/10.
//

import SwiftUI

struct DayOnMonth: View {
    let day: Int
    @Binding var dayObject: [String: Any]
    var body: some View {
        let ratingSymbol = dayObject[String(format: "%02d", day)] as? [String: Any]
                            ?? ["ration": 0, "symbol": Array(repeating: ["imageName": "", "isSuccess": false], count: 4)]
        let symbols: Array<[String: Any]> = ratingSymbol["symbol"] as! Array<[String: Any]>
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Image(systemName: "circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.mint.opacity(ratingSymbol["rating"] as? Double ?? 0))
                Text("\(day)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.primary)
            }
            VStack(spacing: 8) {
                HStack(spacing: 2) {
                    ForEach(symbols.indices, id: \.self) { symbolIndex in
                        if 0 <= symbolIndex && symbolIndex < 2 {
                            SymbolOnMonth(symbol: symbols[symbolIndex])
                        }
                    }
                }
                HStack(spacing: 2) {
                    ForEach(symbols.indices, id: \.self) { symbolIndex in
                        if symbols.count > 4 && symbolIndex == 3 {
                            Button {
                                print("show symbols popup")
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                            .frame(width: 20)
                        } else if 2 <= symbolIndex && symbolIndex < 4 {
                            SymbolOnMonth(symbol: symbols[symbolIndex])
                        }
                    }
                }
            }
            .frame(width: CGFloat.screenWidth / 10, height: CGFloat.screenHeight / 20)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.primary)
        }
    }
}
