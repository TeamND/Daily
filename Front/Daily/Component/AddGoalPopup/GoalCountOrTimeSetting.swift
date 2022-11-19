//
//  GoalCountOrTimeSetting.swift
//  Daily
//
//  Created by 최승용 on 2022/11/17.
//

import SwiftUI

struct GoalCountOrTimeSetting: View {
    @State var countOrTime: String = "횟수" {
        didSet {
            count = 1
            timeIndex = 2
        }
    }
    @State var count: Int = 1
    @State var timeIndex: Int = 2
    var body: some View {
        Text("횟수 or 시간 설정")
            .font(.system(size: 20, weight: .bold))
        HStack {
            Picker("", selection: $countOrTime) {
                ForEach(["횟수", "시간"], id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(2)
            .cornerRadius(15)
        }
        .font(.system(size: 16))
        switch countOrTime {
        case "횟수":
            HStack {
                Spacer()
                Button {
                    if count > 1 { count -= 1 }
                } label: {
                    Image(systemName: "minus.circle")
                }
                Spacer()
                Text(String(count))
                Spacer()
                Button {
                    if count < 10 { count += 1}
                } label: {
                    Image(systemName: "plus.circle")
                }
                Spacer()
            }
        case "시간":
            HStack {
                Spacer()
                Button {
                    if timeIndex > 0 { timeIndex -= 1 }
                } label: {
                    Image(systemName: "chevron.down.circle")
                }
                Spacer()
                Text(times[timeIndex])
                Spacer()
                Button {
                    if timeIndex < 9 { timeIndex += 1 }
                } label: {
                    Image(systemName: "chevron.up.circle")
                }
                Spacer()
            }
        default:
            Text("")
        }
    }
}

struct GoalCountOrTimeSetting_Previews: PreviewProvider {
    static var previews: some View {
        GoalCountOrTimeSetting()
    }
}
