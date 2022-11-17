//
//  GoalCountOrTimeSetting.swift
//  Daily
//
//  Created by 최승용 on 2022/11/17.
//

import SwiftUI

struct GoalCountOrTimeSetting: View {
    @State var countOrTime: String = "횟수"
    var body: some View {
        Text("수행 횟수 & 시간 선택")
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
                    print("minus")
                } label: {
                    Image(systemName: "minus.circle")
                }
                Spacer()
                Text("1")
                Spacer()
                Button {
                    print("plus")
                } label: {
                    Image(systemName: "plus.circle")
                }
                Spacer()
            }
        case "시간":
            HStack {
                Spacer()
                Button {
                    print("down")
                } label: {
                    Image(systemName: "chevron.down.circle")
                }
                Spacer()
                Text("5분")
                Spacer()
                Button {
                    print("up")
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
