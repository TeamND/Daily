//
//  AlertViewModel.swift
//  Daily
//
//  Created by 최승용 on 5/13/24.
//

import Foundation

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
        self.toastMessage = message
        self.isShowToast = true
    }
    
    func hideToast() {
        self.toastMessage = ""
        self.isShowToast = false
    }
}
