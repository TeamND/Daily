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
            Spacer()
            TextField(
                "",
                text: $testText,
                prompt: Text("test")
            )
        }
    }
}

#Preview {
    RecordView(userInfo: UserInfo())
}
