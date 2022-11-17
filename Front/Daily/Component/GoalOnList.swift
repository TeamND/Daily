//
//  Goal.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import SwiftUI

struct GoalOnList: View {
    @StateObject var goal: Goal
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                Image(systemName: goal.afterSymbol)
                Text(goal.content)
                Spacer()
                RecordButton(goal: goal)
            }
            .padding(12)
            if goal.type != "check" {
                VStack {
                    Spacer()
                    ProgressView(value: Double(goal.recordCount), total: Double(goal.goalCount))
                        .progressViewStyle(LinearProgressViewStyle(tint: .mint.opacity(0.8)))
                }
                .padding([.top, .bottom], 4)
                .padding([.leading, .trailing], 12)
            }
        }
//        .background(.green.opacity(0.3))
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.green, lineWidth: 2)
        }
        .padding(24)
    }
}

struct Goal_Previews: PreviewProvider {
    static var previews: some View {
        GoalOnList(goal: Goal())
            .previewLayout(.fixed(width: 500, height: 50))
    }
}
