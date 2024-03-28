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
    @State var date: Date = Date()
    @State var symbol: Symbol = .체크
    @State var isShowCalendarSheet: Bool = false
    @State var isShowSymbolSheet: Bool = false
    @State var content: String = ""
    
    var body: some View {
        VStack {
            HStack {
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
                text: $content,
                prompt: Text("deadlift 120kg 10reps 3set")
            )
            .padding()
            .background(Color.gray.opacity(0.3))
            .cornerRadius(5.0)
            
            HStack {
                Spacer()
                Button {
                    symbol = .체크
                    content = ""
                } label: {
                    Text("Reset")
                }
                
                Button {
                    let currentDate = userInfo.currentYearStr + userInfo.currentMonthStr + userInfo.currentDayStr
                    let goalModel = GoalModel(user_uid: userInfo.uid, content: content, symbol: symbol.toString(), cycle_date: [currentDate])
                    addGoal2(goal: goalModel) { data in
                        if data.code == "00" {
                            symbol = .체크
                            content = ""
                            tabViewModel.setTagIndex(tagIndex: 0)
                        }
                    }
                } label: {
                    Text("Add")
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    RecordView(userInfo: UserInfo(), tabViewModel: TabViewModel())
}
