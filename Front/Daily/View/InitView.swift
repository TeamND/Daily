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
    @State var subTitleText: String = "Design 🎨, Record 📝\n\n\t\t, and Check 👏 'Daily'!!"
    @State var isShowAlert: Bool = false
    @State var isShowTerminateAlert: Bool = false
    @State var isShowOpenStoreAlert: Bool = false
    @State var isShowOpenSettingAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "d.circle.fill")
                .resizable()
                .frame(width: CGFloat.fontSize * 50, height: CGFloat.fontSize * 50)
                .foregroundColor(Color("CustomColor"))
            Text(subTitleText)
                .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
        }
        .onAppear {
            System().getStoreVersion() { storeVersion in
                let storeVersion = storeVersion.split(separator: ".").map {$0}
                let appVersion = System.appVersion!.split(separator: ".").map {$0}
                if storeVersion[0] > appVersion[0] || storeVersion[1] > appVersion[1] {
                    isShowAlert = true
                    isShowOpenStoreAlert = true
                } else {
                    getUserInfo(userID: UIDevice.current.identifierForVendor!.uuidString) { data in
                        if data.code == "00" || data.code == "01" { // "00": 기존 사용자, "01": 신규 사용자 (추후 튜토리얼 추가)
                            DispatchQueue.main.async {
                                userInfoViewModel.setUserInfo(userInfo: data.data)
                                calendarViewModel.setCurrentState(state: userInfoViewModel.userInfo.set_calendarstate, year: 0, month: 0, day: 0, userInfoViewModel: userInfoViewModel) { code in
                                    if code == "99" {
                                        isShowAlert = true
                                        isShowTerminateAlert = true
                                    }
                                }
                                
                                PushNoticeManager().requestNotiAuthorization() { isShowAlert in
                                    if isShowAlert {
                                        self.isShowAlert = isShowAlert
                                        self.isShowOpenSettingAlert = isShowAlert
                                    }
                                }
                                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                                    if !isShowAlert {
                                        isLoading = false
                                    }
                                }
                            }
                        } else {
                            isShowAlert = true
                            isShowTerminateAlert = true
                        }
                    }
                }
            }
        }
        .alert(isPresented: $isShowAlert, content: {
            if self.isShowTerminateAlert {
                Alert(
                    title: Text("오류가 발생했습니다."),
                    message: Text("네트워크 연결 상태를 먼저 확인해주세요"),
                    dismissButton: .default(
                        Text("확인"),
                        action: {
                            isShowTerminateAlert = false
                            System().terminateApp()
                        }
                    )
                )
            } else {
                if isShowOpenStoreAlert {
                    Alert(
                        title: Text("업데이트가 필요합니다."),
                        message: Text("업데이트 이후 사용해주세요"),
                        dismissButton: .default(
                            Text("확인"),
                            action: {
                                isShowOpenStoreAlert = false
                                System().openAppStore()
                                subTitleText = "업데이트 이후 사용해주세요"
                            }
                        )
                    )
                } else {
                    Alert(
                        title: Text("알림 설정이 꺼져있습니다."),
                        message: Text("Daily의 알림을 받아보세요"),
                        primaryButton: .default(
                            Text("설정으로 이동"),
                            action: {
                                isShowOpenSettingAlert = false
                                System().openSettingApp()
                                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                                    isLoading = false
                            }
                        }),
                        secondaryButton: .destructive(
                            Text("다음에 하기"),
                            action: {
                                isShowOpenSettingAlert = false
                                isLoading = false
                            }
                        )
                    )
                }
            }
        })
    }
}
