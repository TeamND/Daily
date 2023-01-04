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
        let ratingSymbol = dayObject[String(format: "%02d", day)] as? [String: Any] ?? ["": []]
        let symbols = ratingSymbol["symbol"] as? Array ?? []
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
                    Image(systemName: "dumbbell.fill")
                    Image(systemName: "highlighter")
                }
                HStack(spacing: 2) {
                    Image(systemName: "highlighter")
                    Image(systemName: "dumbbell.fill")
                }
            }
            .font(.system(size: 12, weight: .bold))
//            Button {
//                for symbol in symbols {
//                    let test = symbol as! [String: Bool]
//                    print(test)
//                    print(test["여행"])
//                }
//            } label: {
//                Text("test")
//            }
        }
    }
}
