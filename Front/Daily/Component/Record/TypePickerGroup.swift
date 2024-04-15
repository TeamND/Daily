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
    
    var body: some View {
        HStack {
            VStack {
                Button {
                    type = "check"
                    count = 1
                } label: {
                    Text("성공 / 실패")
                        .foregroundStyle(type == "check" ? Color("CustomColor") : .primary)
                }
                CustomDivider(color: type == "check" ? Color("CustomColor") : .primary)
            }
            .hCenter()
            VStack {
                Button {
                    type = "count"
                    count = 5
                } label: {
                    Text("목표 횟수 설정")
                        .foregroundStyle(type == "check" ? .primary : Color("CustomColor"))
                }
                CustomDivider(color: type == "check" ? .primary : Color("CustomColor"))
            }
            .hCenter()
        }
    }
}
