//
//  SplashView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var splashViewModel: SplashViewModel
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "d.circle.fill")
                .resizable()
                .frame(width: CGFloat.fontSize * 50, height: CGFloat.fontSize * 50)
                .foregroundStyle(Colors.daily)
            Text(splashViewModel.subTitle)
                .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
        }
        .onAppear {
            splashViewModel.onAppear()
        }
    }
}