//
//  SplashView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var alertEnvironment: AlertEnvironment
    @StateObject private var splashViewModel = SplashViewModel()
    
    var body: some View {
        splashView
            .onAppear { PushNoticeManager.shared.requestNotiAuthorization(showAlert: alertEnvironment.showAlert) }
            .onAppear { splashViewModel.onAppear() }
            .sheet(isPresented: $splashViewModel.isShowNotice) { noticeSheet }
            .alert(isPresented: $splashViewModel.isNeedUpdate) { updateAlert }
            .opacity(splashViewModel.isAppLoaded ? 0 : 1)
            .animation(.easeInOut(duration: 0.5), value: splashViewModel.isAppLoaded)
    }
    
    private var splashView: some View {
        VStack(spacing: 40) {
            dailyImage
            dailyCatchPhrase
        }
        .frame(maxWidth:. infinity, maxHeight: .infinity)
        .background(Colors.theme)
    }
    
    private var dailyImage: some View {
        Image(systemName: "d.circle.fill")
            .resizable()
            .frame(width: CGFloat.fontSize * 50, height: CGFloat.fontSize * 50)
            .foregroundStyle(Colors.daily)
    }
    
    private var dailyCatchPhrase: some View {
        Text(splashViewModel.catchPhrase)
            .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
    }
    
    private var noticeSheet: some View {
        NoticeSheet()
            .presentationDetents([.height(CGFloat.fontSize * 65)])
            .presentationDragIndicator(.visible)
            .onDisappear { splashViewModel.loadApp(isWait: false) }
    }
    
    private var updateAlert: Alert {
        Alert(
            title: Text("새로운 버전이 출시되었습니다."),
            message: Text("데일리 스케쥴러를 업데이트 해주세요"),
            dismissButton: .default(Text("확인"), action: {
                System().openAppStore()
                
//                // TODO: 추후 개선
//                splashViewModel.isNeedUpdate = false
//                splashViewModel.onAppear()
            })
        )
    }
}
