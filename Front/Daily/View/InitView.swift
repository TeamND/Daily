//
//  InitView.swift
//  Daily
//
//  Created by 최승용 on 2022/11/02.
//

import SwiftUI
import Combine

struct InitView: View {
    @StateObject var userInfo: UserInfo
    @Binding var isLoading: Bool
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "d.circle.fill")
                .resizable()
                .frame(width: 280, height: 280)
                .foregroundColor(Color("CustomColor"))
                .task {
                    do {
                        getUserInfo(userID: UIDevice.current.identifierForVendor!.uuidString) { (success, data) in
                            userInfo.uid = data["uid"] as! Int
                            userInfo.set_startday = data["set_startday"] as! Int
                            userInfo.set_language = data["set_language"] as! String
                            userInfo.set_dateorrepeat = data["set_dateorrepeat"] as! String
                            userInfo.set_calendarstate = data["set_calendarstate"] as! String
                            
                            userInfo.currentState = userInfo.set_calendarstate
                        }
                        // 임시 타이머
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                            if userInfo.uid > 0 { isLoading = false }
                            else { print("An error has occured while getUserInfo") }
                        }
                    }
                }
            Text("Design 🎨, Record 📝\n\n\t\t, and Check 👏 'Daily'!!")
                .font(.headline)
        }
    }
}
