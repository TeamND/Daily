//
//  WeekIndicator.swift
//  Daily
//
//  Created by 최승용 on 2022/11/17.
//

import SwiftUI

struct WeekIndicator: View {
    @StateObject var userInfo: UserInfo
    @State var archievements: [Double] = [0, 0, 0, 0, 0, 0, 0]
    var tapPurpose: String = ""
    var body: some View {
        HStack {
            ForEach (userInfo.weeks.indices, id: \.self) { index in
                Spacer()
                ZStack {
                    let isToday = userInfo.weeks[index] == userInfo.currentDOW
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                        .opacity(isToday && tapPurpose == "change" ? 1 : 0)
                    Image(systemName: "circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.mint.opacity(archievements[index]))
                        .padding([.horizontal], -6) // AddGoalPopup에서 width가 늘어나는 현상 때문에 추가
                    Text(userInfo.weeks[index])
                        .font(.system(size: 16, weight: .bold))
                }
                .onTapGesture {
                    switch tapPurpose {
                    case "change":
                        userInfo.changeDay(DOWIndex: index)
                    case "select":
                        if archievements[index] == 0 { archievements[index] = 0.4 }
                        else                         { archievements[index] = 0 }
                    default:
                        break
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
    }
}
