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
    @State var modifyGoalModel: modifyGoalModel
    @State var isShowSymbolSheet: Bool = false
    @State var isShowContentLengthAlert: Bool = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Group {
                    Image(systemName: "\(modifyGoalModel.symbol.toSymbol()!.rawValue)")
                        .padding()
                    Image(systemName: "chevron.right")
                    Image(systemName: "\(modifyGoalModel.symbol.toSymbol()!.rawValue).fill")
                        .padding()
                }
                .onTapGesture {
                    isShowSymbolSheet = true
                }
                .sheet(isPresented: $isShowSymbolSheet) {
                    SymbolSheet(symbol: $modifyGoalModel.symbol)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
            }
            .frame(height: 40)
            
            TextField(
                "",
                text: $modifyGoalModel.content,
                prompt: Text("아침 7시 기상")
            )
            .padding()
            .background(Color("BackgroundColor"))
            .cornerRadius(5.0)
            
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
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
                    Text("Modify")
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
    }
}
