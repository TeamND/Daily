//
//  RecordView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct RecordView: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var navigationViewModel: NavigationViewModel
    @State var goalModel: GoalModel = GoalModel()
    @State var date: Date = Date()
    @State var beforeDate: Date = Date()
    @State var isShowContentLengthAlert: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                DatePickerGroup(userInfo: userInfo, date: $date)
                Spacer()
                SymbolPickerGroup(symbol: $goalModel.symbol)
            }
            .frame(height: 40)
            
            ContentTextField(content: $goalModel.content)
            
            HStack {
                Spacer()
                Button {
                    goalModel.symbol = "체크"
                    goalModel.content = ""
                    date = beforeDate
                    userInfo.currentYear = date.year
                    userInfo.currentMonth = date.month
                    userInfo.currentDay = date.day
                } label: {
                    Text("초기화")
                }
                Button {
                    if goalModel.content.count < 2 {
                        isShowContentLengthAlert = true
                    } else {
                        let currentDate = userInfo.currentYearStr + userInfo.currentMonthStr + userInfo.currentDayStr
                        goalModel.user_uid = userInfo.uid
                        goalModel.start_date = currentDate
                        goalModel.end_date = currentDate
                        goalModel.cycle_date = [currentDate]
                        addGoal(goal: goalModel) { data in
                            if data.code == "00" {
                                goalModel.symbol = "체크"
                                goalModel.content = ""
                                navigationViewModel.setTagIndex(tagIndex: 0)
                            }
                        }
                    }
                } label: {
                    Text("추가")
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .alert(isPresented: $isShowContentLengthAlert, content: {
            Alert(
                title: Text("목표의 길이가 너무 짧습니다."),
                message: Text("최소 2글자 이상의 목표를 설정해주세요."),
                dismissButton: .default(
                    Text("확인")
                )
            )
        })
        .onAppear {
            date = Calendar.current.date(from: DateComponents(year: userInfo.currentYear, month: userInfo.currentMonth, day: userInfo.currentDay))!
            beforeDate = date
        }
    }
}

#Preview {
    RecordView(userInfo: UserInfo(), navigationViewModel: NavigationViewModel())
}
