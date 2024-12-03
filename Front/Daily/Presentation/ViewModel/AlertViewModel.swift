//
//  AlertViewModel.swift
//  Daily
//
//  Created by 최승용 on 5/13/24.
//

import Foundation
import SwiftUI

class AlertViewModel: ObservableObject {
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
        VStack {
            Spacer()
            Text(toastMessage)
                .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                .padding(CGFloat.fontSize)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Colors.background)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.primary, lineWidth: 1)
                }
                .padding(CGFloat.fontSize)
                .hCenter()
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
