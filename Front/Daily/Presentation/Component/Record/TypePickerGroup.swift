//
//  TypePickerGroup.swift
//  Daily
//
//  Created by 최승용 on 4/15/24.
//

import SwiftUI

struct TypePickerGroup: View {
    @Binding var type: String
    @Binding var count: Int
    @Binding var time: Int
    
    var body: some View {
        HStack {
//            VStack {
//                Button {
//                    type = "check"
//                    count = 1
//                } label: {
//                    Text("성공 기록")
//                        .foregroundStyle(type == "check" ? Colors.daily : .primary)
//                }
//                CustomDivider(color: type == "check" ? Colors.daily : .primary)
//            }
//            .hCenter()
            VStack {
                Button {
                    type = count == 1 ? "check" : "count"
                } label: {
                    Text("횟수")
                        .foregroundStyle(type == "timer" ? .primary : Colors.daily)
                }
                CustomDivider(color: type == "timer" ? .primary : Colors.daily)
            }
            .hCenter()
            VStack {
                Button {
                    type = "timer"
                } label: {
                    Text("시간")
                        .foregroundStyle(type == "timer" ? Colors.daily : .primary)
                }
                CustomDivider(color: type == "timer" ? Colors.daily : .primary)
            }
            .hCenter()
        }
    }
}
