//
//  AlertEnvironment.swift
//  Daily
//
//  Created by 최승용 on 5/13/24.
//

import Foundation
import SwiftUI

class AlertEnvironment: ObservableObject {
    @Published var isShowAlert: Bool = false
    @Published var isShowToast: Bool = false
    @Published var toastIcon: ImageResource = .notice
    @Published var toastMessage: String = ""
    @Published var alertTitle: String = ""
    @Published var alertDescription: String = ""
    @Published var primaryButtonText: String = ""
    @Published var secondaryButtonText: String = ""
    
    func showAlert(alertType: NoticeAlert) {
        Task { @MainActor in
            self.alertTitle = alertType.titleText
            self.alertDescription = alertType.messageText
            self.primaryButtonText = alertType.primaryButtonText
            self.secondaryButtonText = alertType.secondaryButtonText
            try? await Task.sleep(nanoseconds: 50_000_000)
            
            self.isShowAlert = true
        }
    }
    
    func hideAlert() {
        Task { @MainActor in
            self.isShowAlert = false
            
            try? await Task.sleep(nanoseconds: 300_000_000)
            self.alertTitle = ""
            self.alertDescription = ""
            self.primaryButtonText = ""
            self.secondaryButtonText = ""
        }
    }
    
    func showToast(alertType: DailyAlert) {
        Task { @MainActor in
            self.toastIcon = alertType.icon ?? .notice
            self.toastMessage = alertType.messageText
            
            self.isShowToast = true
        }
    }
    
    func hideToast() {
        Task { @MainActor in
            self.isShowToast = false
            
            self.toastIcon = .notice
            self.toastMessage = ""
        }
    }
    
    var toastView: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack(spacing: 12) {
                Image(toastIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                
                Text(toastMessage)
                    .font(Fonts.bodyLgMedium)
                    .foregroundStyle(Colors.Brand.secondary)
            }
            .padding(.vertical, 13)
            .padding(.horizontal, 16)
            .background(Colors.Background.toast)
            .cornerRadius(12)
            .opacity(isShowToast ? 1 : 0)
            .animation(.easeInOut(duration: 0.3), value: isShowToast)
        }
        .onChange(of: isShowToast) { _, isShowToast in
            if isShowToast {
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                    self.hideToast()
                }
            }
        }
    }
    
    var alertView: some View {
        VStack(spacing: .zero) {
            Text(alertTitle)
                .font(Fonts.headingSmSemiBold)
                .foregroundStyle(Colors.Text.primary)
                .multilineTextAlignment(.center)
            Spacer().frame(height: 8)
            
            Text(alertDescription)
                .font(Fonts.bodyMdRegular)
                .foregroundStyle(Colors.Text.secondary)
            Spacer().frame(height: 28)
            
            HStack(spacing: 8) {
                Button {
                    self.hideAlert()
                } label: {
                    Text(secondaryButtonText)
                        .font(Fonts.bodyLgMedium)
                        .foregroundStyle(Colors.Brand.primary)
                        .frame(maxWidth: 134, maxHeight: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Colors.Brand.primary, lineWidth: 1)
                        }
                }
                
                Button {
                    System().openSettingApp()
                    self.hideAlert()
                } label: {
                    Text(primaryButtonText)
                        .font(Fonts.bodyLgMedium)
                        .foregroundStyle(Colors.Text.inverse)
                        .frame(maxWidth: 134, maxHeight: .infinity)
                        .background(Colors.Brand.primary)
                        .cornerRadius(8)
                }
            }
            .frame(height: 48)
        }
        .padding(.top, 28)
        .padding(.bottom, 16)
        .padding(.horizontal, 16)
        .background(Colors.Background.secondary)
        .cornerRadius(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.Background.dim)
        .opacity(isShowAlert ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: isShowAlert)
    }
}
