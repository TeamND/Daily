//
//  InitView.swift
//  Daily
//
//  Created by 최승용 on 2022/11/02.
//

import SwiftUI
import Combine

struct InitView: View {
    @Binding var isLoading: Bool
    var body: some View {
        Image(systemName: "d.circle.fill")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .frame(width: 280, height: 280)
            .foregroundColor(.mint)
            .padding([.bottom], 40)
            .task {
                do {
                    getUserInfo(userID: "test123") { (success, data) in
                        guard let uid = data["uid"]! as? Int else { return }
                        guard let set_startday = data["set_startday"]! as? Int else { return }
                        guard let set_language = data["set_language"]! as? String else { return }
                        guard let set_dateorrepeat = data["set_dateorrepeat"]! as? String else { return }
                        userInfo = UserInfo(uid: uid, set_startday: set_startday, set_language: set_language, set_dateorrepeat: set_dateorrepeat)
                    }
                    // 임시 타이머
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                        if userInfo.uid > 0 { isLoading = false }
                        else { print("An error has occured while getUserInfo") }
                    }
                }
            }
    }
}
