//
//  AddGoalButton.swift
//  Daily
//
//  Created by 최승용 on 4/19/24.
//

import SwiftUI

struct AddGoalButton: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var updateVersion: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                if updateVersion {
                    NavigationLink(value: "addGoal") {
                        Label("목표 추가", systemImage: "plus")
                            .foregroundStyle(.white)
                            .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                    }
                    .padding()
                    .background(Color("CustomColor"))
                    .cornerRadius(20)
                } else {
                    NavigationLink {
                        RecordView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                    } label: {
                        Label("목표 추가", systemImage: "plus")
                            .foregroundStyle(.white)
                            .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                    }
                    .padding()
                    .background(Color("CustomColor"))
                    .cornerRadius(20)
                }
            }
            .padding()
        }
        .padding()
    }
}
