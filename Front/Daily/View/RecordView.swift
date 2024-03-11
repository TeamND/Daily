//
//  RecordView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct RecordView: View {
    @ObservedObject var userInfo: UserInfo
    @State var testText: String = ""
    
    var body: some View {
        VStack {
            Text("\(userInfo.currentYearLabel) \(userInfo.currentMonthLabel) \(userInfo.currentDayLabel) \(userInfo.currentDOW)")
            TextField(
                "",
                text: $testText,
                prompt: Text("데드리프트 120kg 10reps 3set")
            )
            .padding()
            .background(Color.gray.opacity(0.3))
            .cornerRadius(5.0)
            .padding()
        }
    }
}

#Preview {
    RecordView(userInfo: UserInfo())
}
