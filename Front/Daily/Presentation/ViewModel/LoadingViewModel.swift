//
//  LoadingViewModel.swift
//  Daily
//
//  Created by seungyooooong on 12/10/24.
//

import Foundation
import SwiftUI

class LoadingViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    func loading() {
        DispatchQueue.main.async {
            self.isLoading = true
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                self.isLoading = false
            }
        }
    }
    
    var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(.black.opacity(0.1))
    }
}
