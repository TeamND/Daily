//
//  InitView.swift
//  Daily
//
//  Created by 최승용 on 2022/11/02.
//

import SwiftUI
import Combine

struct InitView: View {
    @ObservedObject var userInfo: UserInfo
    @Binding var isLoading: Bool
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "d.circle.fill")
                .resizable()
                .frame(width: 280, height: 280)
                .foregroundColor(Color("CustomColor"))
                .task {
                    do {
                        getUserInfo2(userID: UIDevice.current.identifierForVendor!.uuidString) { data in
                            userInfo.uid = data.data.uid
                            userInfo.set_startday = data.data.set_startday
                            userInfo.set_language = data.data.set_language
                            userInfo.set_dateorrepeat = data.data.set_dateorrepeat
                            userInfo.set_calendarstate = data.data.set_calendarstate
                            
                            userInfo.currentState = userInfo.set_calendarstate
                        }
                        // 임시 타이머
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                            if userInfo.uid >= 0 { isLoading = false }
                            else { print("An error has occured while getUserInfo") }
                        }
                    }
                }
            Text("Design 🎨, Record 📝\n\n\t\t, and Check 👏 'Daily'!!")
                .font(.headline)
        }
    }
}
