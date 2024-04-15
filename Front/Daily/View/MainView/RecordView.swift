//
//  RecordView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var navigationViewModel: NavigationViewModel
    @State var goalModel: GoalModel = GoalModel()
    @State var date: Date = Date()
    @State var beforeDate: Date = Date()
    @State var isShowAlert: Bool = false
    @State var isShowContentLengthAlert: Bool = false
    @State var isShowCountRangeAlert: Bool = false
    
    var body: some View {
        VStack {
            TypePickerGroup(type: $goalModel.type, count: $goalModel.goal_count)
            Spacer()
            HStack {
                DatePickerGroup(userInfo: userInfo, date: $date)
                Spacer()
                SymbolPickerGroup(symbol: $goalModel.symbol)
            }
            .frame(height: 40)
            
            ContentTextField(content: $goalModel.content, type: $goalModel.type)
            
            HStack {
                if goalModel.type == "count" {
                    GoalCountPickerGroup(count: $goalModel.goal_count, isShowAlert: $isShowAlert, isShowCountRangeAlert: $isShowCountRangeAlert)
                }
                Spacer()
                Button {
                    goalModel.symbol = "체크"
                    goalModel.content = ""
                    goalModel.type = "check"
                    date = beforeDate
                    userInfo.currentYear = date.year
                    userInfo.currentMonth = date.month
                    userInfo.currentDay = date.day
                } label: {
                    Text("초기화")
                }
                Button {
                    print(goalModel.content)
                    print(goalModel.content.count)
                    if goalModel.content.count < 2 {
                        isShowAlert = true
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
                                goalModel.type = "check"
                                if navigationViewModel.getTagIndex() == 0 {
                                    DispatchQueue.main.async {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                } else {
                                    navigationViewModel.setTagIndex(tagIndex: 0)
                                }
                            }
                        }
                    }
                } label: {
                    Text("추가")
                }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
        .alert(isPresented: $isShowAlert, content: {
            if self.isShowContentLengthAlert {
                Alert(
                    title: Text(contentLengthAlertTitleText),
                    message: Text(contentLengthAlertMessageText),
                    dismissButton: .default(
                        Text("확인"), action: {
                            self.isShowContentLengthAlert = false
                        }
                    )
                )
            } else {
                Alert(
                    title: Text(countRangeAlertTitleText),
                    message: Text(countRangeAlertMessageText),
                    dismissButton: .default(
                        Text("확인"), action: {
                            self.isShowCountRangeAlert = false
                        }
                    )
                )
            }
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
