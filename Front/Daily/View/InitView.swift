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
    @State var isShowOpenStoreAlert: Bool = false
    
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
            System().getStoreVersion() { storeVersion in
                let storeVersion = storeVersion.split(separator: ".").map {$0}
                let appVersion = System.appVersion!.split(separator: ".").map {$0}
                if storeVersion[0] > appVersion[0] || storeVersion[1] > appVersion[1] {
                    isShowOpenStoreAlert = true
                } else {
                    getUserInfo(userID: UIDevice.current.identifierForVendor!.uuidString) { data in
                        if data.code == "00" {
                            DispatchQueue.main.async {
                                userInfoViewModel.setUserInfo(userInfo: data.data)
                                calendarViewModel.setCurrentState(state: userInfoViewModel.userInfo.set_calendarstate, year: 0, month: 0, day: 0, userInfoViewModel: userInfoViewModel)
                                
                                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                                    isLoading = false
                                }
                            }
                        } else {
                            isShowTerminateAlert = true
                        }
                    }
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
        .alert(isPresented: $isShowOpenStoreAlert, content: {
            Alert(
                title: Text("업데이트가 필요합니다."),
                message: Text("업데이트 이후 사용해주세요"),
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
