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
    @Published var toastMessage: String = ""
    @Published var alertTitle: String = ""
    @Published var alertDescription: String = ""
    @Published var primaryButtonText: String = ""
    @Published var secondaryButtonText: String = ""
    
    func showAlert(alertType: NoticeAlert) {
        DispatchQueue.main.async {
            self.alertTitle = alertType.titleText
            self.alertDescription = alertType.messageText
            self.primaryButtonText = alertType.primaryButtonText
            self.secondaryButtonText = alertType.secondaryButtonText
            withAnimation {
                self.isShowAlert = true
            }
        }
    }
    
    func hideAlert() {
        DispatchQueue.main.async {
            self.alertTitle = ""
            self.alertDescription = ""
            self.primaryButtonText = ""
            self.secondaryButtonText = ""
            withAnimation {
                self.isShowAlert = false
            }
        }
    }
    
    func showToast(message: String) {
        DispatchQueue.main.async {
            withAnimation {
                self.toastMessage = message
                self.isShowToast = true
            }
        }
    }
    
    func hideToast() {
        DispatchQueue.main.async {
            withAnimation {
                self.toastMessage = ""
                self.isShowToast = false
            }
        }
    }
    
    var toastView: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack(spacing: 12) {
                Image(.notice)
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
    }
}
