//
//  DayOnMonth.swift
//  Daily
//
//  Created by 최승용 on 3/24/24.
//

import SwiftUI

struct DayOnMonth: View {
    @StateObject var userInfo: UserInfo
    let day: Int
    let dayOnMonth: dayOnMonthModel
    var body: some View {
        let symbols = dayOnMonth.symbol
        VStack(alignment: .leading) {
            ZStack {
                Image(systemName: "circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color("CustomColor").opacity(dayOnMonth.rating*0.8))
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
                            // 추후 심볼 팝업 추가
//                            Button {
//                                print("show symbols popup")
//                            } label: {
//                                Image(systemName: "ellipsis")
//                            }
                            Image(systemName: "ellipsis")
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
