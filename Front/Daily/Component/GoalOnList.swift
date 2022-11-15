//
//  Goal.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import SwiftUI

struct GoalOnList: View {
    var goal: Goal
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: goal.symbol)
                Text(goal.content)
                Spacer()
                Button {
                    print("test")
                } label: {
                    switch goal.type {
                    case "check":
                        Label("성공", systemImage: "checkmark.circle.fill")
                    case "count":
                        Label("더하기", systemImage: "plus.circle.fill")
                    case "timer":
                        Label("시작", systemImage: "play.circle.fill")
                    default:
                        Text("")
                    }
                }
            }
            .padding(12)
            if goal.type == "count" {
                VStack {
                    Spacer()
                    ZStack {
                        HStack(spacing: 2) {
                            ForEach(0 ..< goal.recordCount, id: \.self) { index in
                                Rectangle()
                                    .fill(.mint)
                            }
                            ForEach(goal.recordCount ..< goal.goalCount, id: \.self) { index in
                                Rectangle()
                                    .fill(.mint.opacity(0.2))
                            }
                        }
                        HStack {
                            Text(String(goal.recordCount))
                            Spacer()
                            Text(String(goal.goalCount))
                        }
                        .font(.system(size: 6, weight: .bold))
                        .padding([.leading, .trailing], 12)
                    }
                    .frame(height: 8)
                }
                .padding(1)
            }
            if goal.type == "timer" {
                
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
