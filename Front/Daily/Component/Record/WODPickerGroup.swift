//
//  WODPickerGroup.swift
//  Daily
//
//  Created by 최승용 on 6/25/24.
//

import SwiftUI

struct WODPickerGroup: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @State var selectedWOD: [Int]
    @State var isSelectedWOD: [Bool]
    
    var body: some View {
        Group {
            HStack {
                Text("[")
                Spacer()
                ForEach (userInfoViewModel.weeks.indices, id: \.self) { index in
                    ZStack {
                        Image(systemName: "circle.fill")
                            .font(.system(size: CGFloat.fontSize * 4))
                            .foregroundColor(Color("CustomColor").opacity(isSelectedWOD[index] ? 0.5 : 0))
                            .padding([.horizontal], -6) // AddGoalPopup에서 width가 늘어나는 현상 때문에 추가
                        Text(userInfoViewModel.weeks[index])
                            .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
                    }
                    .onTapGesture {
                        withAnimation {
                            isSelectedWOD[index].toggle()
                        }
                        if isSelectedWOD[index] {
                            selectedWOD.append(index)
                        } else {
                            for wodIndex in 0 ..< selectedWOD.count {
                                if selectedWOD[wodIndex] == index {
                                    selectedWOD.remove(at: wodIndex)
                                    break
                                }
                            }
                        }
                    }
                    Spacer()
                }
                Text("]")
            }
        }
    }
}
