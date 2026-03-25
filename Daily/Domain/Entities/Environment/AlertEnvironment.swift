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
    
    private var toastQueue: [DailyAlert] = []
    private var toastTask: Task<Void, Never>?
    
    func showAlert(alertType: NoticeAlert) {
        Task { @MainActor in
            alertTitle = alertType.titleText
            alertDescription = alertType.messageText
            primaryButtonText = alertType.primaryButtonText
            secondaryButtonText = alertType.secondaryButtonText
            try? await Task.sleep(nanoseconds: 50_000_000)
            
            isShowAlert = true
        }
    }
    
    func hideAlert() {
        Task { @MainActor in
            isShowAlert = false
            
            try? await Task.sleep(nanoseconds: 300_000_000)
            alertTitle = ""
            alertDescription = ""
            primaryButtonText = ""
            secondaryButtonText = ""
        }
    }
    
    func showToast(alerts: [DailyAlert]) {
        Task { @MainActor in
            guard let alert = alerts.first else { hideToast(); return }
            toastQueue = Array(alerts.dropFirst())
            
            toastIcon = alert.icon ?? .notice
            toastMessage = alert.messageText
            
            isShowToast = true
            
            toastTask?.cancel()

            toastTask = Task {
                try? await Task.sleep(nanoseconds: 3_000_000_000)

                if Task.isCancelled { return }
                showToast(alerts: toastQueue)
            }
        }
    }
    
    func hideToast() {
        Task { @MainActor in
            isShowToast = false
            
            toastIcon = .notice
            toastMessage = ""
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
            .animation(.easeInOut(duration: 0.3), value: toastIcon)
            .animation(.easeInOut(duration: 0.3), value: toastMessage)
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
