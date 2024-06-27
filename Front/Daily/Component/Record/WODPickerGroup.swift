//
//  WODPickerGroup.swift
//  Daily
//
//  Created by 최승용 on 6/25/24.
//

import SwiftUI

struct WODPickerGroup: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var goalViewModel: GoalViewModel
    
    var body: some View {
        Group {
            HStack {
                ForEach (userInfoViewModel.weeks.indices, id: \.self) { index in
                    Spacer()
                    ZStack {
                        Image(systemName: "circle.fill")
                            .font(.system(size: CGFloat.fontSize * 4))
                            .foregroundColor(Color("CustomColor").opacity(goalViewModel.isSelectedWOD[index] ? 0.5 : 0))
                            .padding([.horizontal], -6) // AddGoalPopup에서 width가 늘어나는 현상 때문에 추가
                        Text(userInfoViewModel.weeks[index])
                            .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
                    }
                    .onTapGesture {
                        withAnimation {
                            goalViewModel.isSelectedWOD[index].toggle()
                        }
                        if goalViewModel.isSelectedWOD[index] {
                            goalViewModel.selectedWOD.append(index)
                        } else {
                            for wodIndex in 0 ..< goalViewModel.selectedWOD.count {
                                if goalViewModel.selectedWOD[wodIndex] == index {
                                    goalViewModel.selectedWOD.remove(at: wodIndex)
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
