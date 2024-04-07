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
    @State var isModifyRecord: Bool = false
    @State var date: Date = Date()
    @State var symbol: Symbol = .체크
    @State var isShowCalendarSheet: Bool = false
    @State var isShowSymbolSheet: Bool = false
    @State var isShowContentLengthAlert: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                if !isModifyRecord {
                    Group {
                        Label {
                            Text("\(userInfo.currentYearLabel) \(userInfo.currentMonthLabel) \(userInfo.currentDayLabel) \(userInfo.currentDOW)요일")
                        } icon: {
                            Image(systemName: "calendar")
                        }
                    }
                    .onTapGesture {
                        isShowCalendarSheet = true
                    }
                    .sheet(isPresented: $isShowCalendarSheet) {
                        CalendarSheet(userInfo: userInfo, date: $date)
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.visible)
                    }
                }
                Spacer()
                Group {
                    Image(systemName: "\(symbol.rawValue)")
                        .padding()
                    Image(systemName: "chevron.right")
                    Image(systemName: "\(symbol.rawValue).fill")
                        .padding()
                }
                .onTapGesture {
                    isShowSymbolSheet = true
                }
                .sheet(isPresented: $isShowSymbolSheet) {
                    SymbolSheet(symbol: $symbol)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
            }
            .frame(height: 40)
            
            TextField(
                "",
                text: $goalModel.content,
                prompt: Text("아침 7시 기상")
            )
            .padding()
            .background(Color("BackgroundColor"))
            .cornerRadius(5.0)
            
            HStack {
                Spacer()
                if isModifyRecord {
                    // Cancel Button
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    
                    // Modify Button
                    Button {
                        if goalModel.content.count < 2 {
                            isShowContentLengthAlert = true
                        } else {
                            DispatchQueue.main.async {
                                goalModel.user_uid = userInfo.uid
                                goalModel.symbol = symbol.toString()
                                // date 관련 변수들 추후 삭제
                                let currentDate = userInfo.currentYearStr + userInfo.currentMonthStr + userInfo.currentDayStr
                                goalModel.start_date = currentDate
                                goalModel.end_date = currentDate
                                goalModel.cycle_date = [currentDate]
                                modifyGoal(goal: goalModel) { data in
                                    if data.code == "00" {
                                        DispatchQueue.main.async {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Modify")
                    }
                } else {
                    // Reset Button
                    Button {
                        symbol = .체크
                        goalModel.content = ""
                        date = Date()
                        userInfo.currentYear = date.year
                        userInfo.currentMonth = date.month
                        userInfo.currentDay = date.day
                    } label: {
                        Text("Reset")
                    }
                    
                    // Add Button
                    Button {
                        if goalModel.content.count < 2 {
                            isShowContentLengthAlert = true
                        } else {
                            let currentDate = userInfo.currentYearStr + userInfo.currentMonthStr + userInfo.currentDayStr
                            goalModel.user_uid = userInfo.uid
                            goalModel.symbol = symbol.toString()
                            goalModel.start_date = currentDate
                            goalModel.end_date = currentDate
                            goalModel.cycle_date = [currentDate]
                            addGoal(goal: goalModel) { data in
                                if data.code == "00" {
                                    symbol = .체크
                                    goalModel.content = ""
                                    navigationViewModel.setTagIndex(tagIndex: 0)
                                }
                            }
                        }
                    } label: {
                        Text("Add")
                    }
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
            if goalModel.uid >= 0 {
                symbol = goalModel.symbol.toSymbol() ?? .체크
                isModifyRecord = true
            }
        }
    }
}

#Preview {
    RecordView(userInfo: UserInfo(), navigationViewModel: NavigationViewModel())
}
