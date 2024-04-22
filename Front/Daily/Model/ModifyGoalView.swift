//
//  ModifyGoalView.swift
//  Daily
//
//  Created by 최승용 on 4/8/24.
//

import SwiftUI

struct ModifyGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var navigationViewModel: NavigationViewModel
    @Binding var record: RecordModel
    @State var modifyGoalModel: modifyGoalModel
    @State var isShowAlert: Bool = false
    @State var isShowContentLengthAlert: Bool = false
    @State var isShowCountRangeAlert: Bool = false
    
    var body: some View {
        VStack {
            BeforeRecord(record: $record)
            CustomDivider(color: .primary, height: 1)
            Spacer()
            VStack {
                HStack {
                    Spacer()
                    SymbolPickerGroup(symbol: $modifyGoalModel.symbol)
                }
                .frame(height: 40)
                
                ContentTextField(content: $modifyGoalModel.content, type: $record.type)
                
                HStack {
                    GoalCountPickerGroup(type: $modifyGoalModel.type, count: $modifyGoalModel.goal_count, isShowAlert: $isShowAlert, isShowCountRangeAlert: $isShowCountRangeAlert)
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("취소")
                    }
                    Button {
                        if modifyGoalModel.content.count < 2 {
                            isShowContentLengthAlert = true
                        } else {
                            DispatchQueue.main.async {
                                modifyGoal(modifyGoalModel: modifyGoalModel) { data in
                                    if data.code == "00" {
                                        DispatchQueue.main.async {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("수정")
                    }
                }
                .buttonStyle(.borderedProminent)
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
            Spacer()
        }
    }
}
