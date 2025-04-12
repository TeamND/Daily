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
            .opacity(splashViewModel.isAppLoaded ? 0 : 1)
            .animation(.easeInOut(duration: 0.5), value: splashViewModel.isAppLoaded)
    }
    
    private var splashView: some View {
        VStack(spacing: .zero) {
            Spacer()
            dailyImage
            Spacer().frame(height: 24)
            dailyCatchPhrase
            if splashViewModel.isNeedUpdate {
                Spacer().frame(height: 20)
                updateNotice
                Spacer()
                updateButton
            } else { Spacer() }
        }
        .frame(maxWidth:. infinity, maxHeight: .infinity)
        .background(Colors.Background.primary)
        .animation(.easeInOut, value: splashViewModel.isNeedUpdate)
    }
    
    private var dailyImage: some View {
        Image(.appIcon)
            .resizable()
            .scaledToFit()
            .frame(width: 160)
    }
    
    private var dailyCatchPhrase: some View {
        Text(splashViewModel.catchPhrase)
            .foregroundStyle(Colors.Text.point)
            .font(Fonts.headingLgBold)
            .multilineTextAlignment(.center)
    }
    
    private var updateNotice: some View {
        Text(splashViewModel.updateNotice)
            .foregroundStyle(Colors.Text.secondary)
            .font(Fonts.bodyLgRegular)
            .multilineTextAlignment(.center)
    }
    
    private var updateButton: some View {
        Button {
            System().openAppStore()
        } label: {
            Text("업데이트 하러가기")
                .foregroundStyle(Colors.Text.inverse)
                .font(Fonts.bodyLgSemiBold)
                .frame(maxWidth: .infinity, maxHeight: 50)
        }
        .background(Colors.Brand.primary)
        .cornerRadius(8)
        .padding(.bottom, 16)
        .padding(.horizontal, 16)
    }
    
    private var noticeSheet: some View {
        NoticeSheet()
            .presentationDetents([.height(CGFloat.fontSize * 65)])
            .presentationDragIndicator(.visible)
            .onDisappear { splashViewModel.loadApp(isWait: false) }
    }
}
