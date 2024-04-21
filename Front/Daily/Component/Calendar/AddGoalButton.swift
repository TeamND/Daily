//
//  AddGoalButton.swift
//  Daily
//
//  Created by 최승용 on 4/19/24.
//

import SwiftUI

struct AddGoalButton: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var navigationViewModel: NavigationViewModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(value: "addGoal") {
                    Label("목표 추가", systemImage: "plus")
                        .foregroundStyle(.white)
                        .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                }
                .padding()
                .background(Color("CustomColor"))
                .cornerRadius(20)
            }
            .padding()
        }
        .padding()
    }
}
