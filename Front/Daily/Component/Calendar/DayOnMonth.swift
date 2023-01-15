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
            }
            VStack(spacing: 8) {
                HStack(spacing: 2) {
                    ForEach(symbols.indices, id: \.self) { symbolIndex in
                        if 0 <= symbolIndex && symbolIndex < 2 {
                            let symbolImageName = symbols[symbolIndex]["imageName"] as! String
                            if symbolImageName == "" { Image(systemName: "dumbbell").opacity(0) }
                            else if symbolImageName == "운동" { Image(systemName: "dumbbell.fill") }
                            else { Image(systemName: "dumbbell") }
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
                        } else
                        if 2 <= symbolIndex && symbolIndex < 4 {
                            let symbolImageName = symbols[symbolIndex]["imageName"] as! String
                            if symbolImageName == "" { Image(systemName: "dumbbell").opacity(0) }
                            else if symbolImageName == "운동" { Image(systemName: "dumbbell.fill") }
                            else { Image(systemName: "dumbbell") }
                        }
                    }
                }
            }
            .font(.system(size: 12, weight: .bold))
        }
    }
}
