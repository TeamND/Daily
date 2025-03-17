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
    
    private var catchPhraseString: AttributedString {
        splashViewModel.catchPhrase.accent(keywords: ["daily", "scheduler", "데일리", "스케쥴러"]) {
            $0.font = .body.bold()
        }
    }
    
    var body: some View {
        splashView
            .onAppear { PushNoticeManager.shared.requestNotiAuthorization(showAlert: alertEnvironment.showAlert) }
            .onAppear { splashViewModel.onAppear() }
            .sheet(isPresented: $splashViewModel.isShowNotice) { noticeSheet }
            .opacity(splashViewModel.isAppLoaded ? 0 : 1)
            .animation(.easeInOut(duration: 0.5), value: splashViewModel.isAppLoaded)
    }
    
    private var splashView: some View {
        VStack(spacing: 25) {
            dailyImage
            dailyCatchPhrase
        }
        .frame(maxWidth:. infinity, maxHeight: .infinity)
        .background(Colors.theme)
        .if(splashViewModel.isNeedUpdate, transform: { view in
            view.overlay {
                updateButton
            }
        })
    }
    
    private var dailyImage: some View {
        Image(.dailyIcon)
            .resizable()
            .frame(width: 113, height: 113)
    }
    
    private var dailyCatchPhrase: some View {
        Text(catchPhraseString)
            .multilineTextAlignment(.center)
    }
    
    private var updateButton: some View {
        Button {
            System().openAppStore()
        } label: {
            // TODO: 추후 버튼 폰트 및 색상 등 조정
            Text("업데이트 하러가기")
                .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                .foregroundStyle(Colors.theme)
                .frame(maxWidth: .infinity, maxHeight: 50)
        }
        .background(Colors.daily)
        .cornerRadius(8)
        .padding(.bottom, 12)
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    private var noticeSheet: some View {
        NoticeSheet()
            .presentationDetents([.height(CGFloat.fontSize * 65)])
            .presentationDragIndicator(.visible)
            .onDisappear { splashViewModel.loadApp(isWait: false) }
    }
}
