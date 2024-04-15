//
//  GoalCountPickerGroup.swift
//  Daily
//
//  Created by 최승용 on 4/15/24.
//

import SwiftUI

struct GoalCountPickerGroup: View {
    @Binding var count: Int
    @Binding var isShowCountRangeAlert: Bool
    
    var body: some View {
        HStack {
            Text("목표 횟수 : ")
            Button {
                if count > 2 {
                    count -= 1
                } else {
                    isShowCountRangeAlert = true
                }
            } label: {
                Image(systemName: "minus.circle")
            }
            Text("\(count)")
            Button {
                if count < 10 {
                    count += 1
                } else {
                    isShowCountRangeAlert = true
                }
            } label: {
                Image(systemName: "plus.circle")
            }
        }
        .buttonStyle(.plain)
        .alert(isPresented: $isShowCountRangeAlert, content: {
            Alert(
                title: Text(countRangeAlertTitleText),
                message: Text(countRangeAlertMessageText),
                dismissButton: .default(
                    Text("확인")
                )
            )
        })
    }
}
