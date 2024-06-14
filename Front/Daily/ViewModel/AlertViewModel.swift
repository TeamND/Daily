//
//  AlertViewModel.swift
//  Daily
//
//  Created by 최승용 on 5/13/24.
//

import Foundation

class AlertViewModel: ObservableObject {
    @Published var isShowAlert: Bool = false
    
    func showAlert() {
        DispatchQueue.main.async {
            self.isShowAlert = true
        }
    }
}
