//
//  InitView.swift
//  Daily
//
//  Created by 최승용 on 2022/11/02.
//

import SwiftUI

struct InitView: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var isLoading: Bool
    @State var isShowTerminateAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "d.circle.fill")
                .resizable()
                .frame(width: CGFloat.fontSize * 50, height: CGFloat.fontSize * 50)
                .foregroundColor(Color("CustomColor"))
            Text("Design 🎨, Record 📝\n\n\t\t, and Check 👏 'Daily'!!")
                .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
        }
        .onAppear {
            getUserInfo(userID: UIDevice.current.identifierForVendor!.uuidString) { data in
                if data.code == "00" {
                    DispatchQueue.main.async {
                        userInfoViewModel.setUserInfo(userInfo: data.data)
                        calendarViewModel.currentState = userInfoViewModel.userInfo.set_calendarstate
                        
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                            isLoading = false
                        }
                    }
                } else {
                    isShowTerminateAlert = true
                }
            }
        }
        .alert(isPresented: $isShowTerminateAlert, content: {
            Alert(
                title: Text("오류가 발생했습니다."),
                message: Text("네트워크 연결 상태를 먼저 확인해주세요"),
                dismissButton: .default(
                    Text("확인"),
                    action: {
                        terminateApp()
                    }
                )
            )
        })
    }
}
