//
//  SplashView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var alertEnvironment: AlertEnvironment
    @ObservedObject var splashViewModel: SplashViewModel
    
    var body: some View {
        splashView
            .onAppear {
                PushNoticeManager.shared.requestNotiAuthorization(
                    showAlert: alertEnvironment.showAlert,
                    alertType: .deniedAtAppOpen
                )
            }
            .onAppear { splashViewModel.onAppear() }
            .opacity(splashViewModel.isMainLoaded ? 0 : 1)
            .animation(.easeInOut(duration: 0.5), value: splashViewModel.isMainLoaded)
    }
    
    private var splashView: some View {
        VStack(spacing: .zero) {
            Spacer()
            dailyImage
            Spacer().frame(height: 24)
            if splashViewModel.isNeedUpdate {
                updateTitle
                Spacer().frame(height: 20)
                updateDescritpion
                Spacer()
                updateButton
            } else {
                dailyCatchPhrase
                Spacer()
            }
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
        Text("catch_phrase".localized)
            .foregroundStyle(Colors.Text.point)
            .font(Fonts.headingLgBold)
            .multilineTextAlignment(.center)
    }
    
    private var updateTitle: some View {
        Text("update_title".localized)
            .foregroundStyle(Colors.Text.point)
            .font(Fonts.headingLgBold)
            .multilineTextAlignment(.center)
    }
    
    private var updateDescritpion: some View {
        Text("update_description".localized)
            .foregroundStyle(Colors.Text.secondary)
            .font(Fonts.bodyLgRegular)
            .multilineTextAlignment(.center)
    }
    
    private var updateButton: some View {
        Button {
            System().openAppStore()
        } label: {
            Text("update_now".localized)
                .foregroundStyle(Colors.Text.inverse)
                .font(Fonts.bodyLgSemiBold)
                .frame(maxWidth: .infinity, maxHeight: 50)
        }
        .background(Colors.Brand.primary)
        .cornerRadius(8)
        .padding(.bottom, 16)
        .padding(.horizontal, 16)
    }
}
