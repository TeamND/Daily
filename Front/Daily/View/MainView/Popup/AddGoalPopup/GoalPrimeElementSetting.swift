//
//  GoalPrimeElementSetting.swift
//  Daily
//
//  Created by 최승용 on 2022/11/17.
//

import SwiftUI

struct GoalPrimeElementSetting: View {
    @StateObject var goal: Goal
    var body: some View {
        Text("기본 설정")
            .font(.system(size: 20, weight: .bold))
        HStack {
            TextField("목표", text: $goal.content)
            Button {
                print("symbol")
            } label: {
                Image(systemName: goal.beforeSymbol)
            Image(systemName: "arrow.forward")
                .font(.system(size: 8, weight: .bold))
            }
            Button {
                print("symbol")
            } label: {
                Image(systemName: goal.afterSymbol)
            }
        }
        .font(.system(size: 16))
    }
}
