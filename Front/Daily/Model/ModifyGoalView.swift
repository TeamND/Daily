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
    @State var beforeSymbol: String = "체크"
    @State var beforeContent: String = ""
    @State var isShowContentLengthAlert: Bool = false
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
                
                ContentTextField(content: $modifyGoalModel.content)
                
                HStack {
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
            .alert(isPresented: $isShowContentLengthAlert, content: {
                Alert(
                    title: Text("목표의 길이가 너무 짧습니다."),
                    message: Text("최소 2글자 이상의 목표를 설정해주세요."),
                    dismissButton: .default(
                        Text("확인")
                    )
                )
            })
            Spacer()
        }
        .onAppear {
            beforeSymbol = modifyGoalModel.symbol
            beforeContent = modifyGoalModel.content
        }
    }
}
