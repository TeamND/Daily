//
//  RecordView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct RecordView: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var tabViewModel: TabViewModel
    @State var content: String = ""
    
    var body: some View {
        VStack {
            Text("\(userInfo.currentYearLabel) \(userInfo.currentMonthLabel) \(userInfo.currentDayLabel) \(userInfo.currentDOW)")
            
            TextField(
                "",
                text: $content,
                prompt: Text("deadlift 120kg 10reps 3set")
            )
            .padding()
            .background(Color.gray.opacity(0.3))
            .cornerRadius(5.0)
            .padding()
            
            HStack {
                Spacer()
                Button {
                    content = ""
                } label: {
                    Text("Erase")
                }
                
                Button {
                    let currentDate = userInfo.currentYearStr + userInfo.currentMonthStr + userInfo.currentDayStr
                    let goal = Goal(user_uid: userInfo.uid, content: content, cycle_date: [currentDate])
                    addGoal(goal: goal)
                    content = ""
                    tabViewModel.setTagIndex(tagIndex: 0)
                    // socket error 수정 필요, 추후 적용
//                    let goalModel = GoalModel(user_uid: userInfo.uid, content: content, symbol: "운동", cycle_date: [currentDate])
//                    addGoal2(goal: goalModel) { data in
//                        if data.code == "00" {
//                            content = ""
//                            tabViewModel.setTagIndex(tagIndex: 0)
//                        }
//                    }
                } label: {
                    Text("Add")
                }
            }
            .padding(.horizontal)
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    RecordView(userInfo: UserInfo(), tabViewModel: TabViewModel())
}
