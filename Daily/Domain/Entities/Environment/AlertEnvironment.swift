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
    
    func showAlert() {
        DispatchQueue.main.async {
            self.isShowAlert = true
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
}
