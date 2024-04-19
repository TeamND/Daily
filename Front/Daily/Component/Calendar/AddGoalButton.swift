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
        NavigationLink {
            RecordView(userInfo: userInfo, navigationViewModel: navigationViewModel)
        } label: {
            Label("목표 추가", systemImage: "plus")
                .foregroundStyle(Color("ThemeColor"))
                .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
        }
        .padding()
        .background(Color("CustomColor"))
        .cornerRadius(20)
    }
}
