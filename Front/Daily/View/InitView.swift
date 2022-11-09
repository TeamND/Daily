//
//  InitView.swift
//  Daily
//
//  Created by 최승용 on 2022/11/02.
//

import SwiftUI
import Combine

struct InitView: View {
    @Binding var isLoading: Bool
    var body: some View {
        Image(systemName: "d.circle.fill")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .frame(width: 280, height: 280)
            .foregroundColor(.mint)
            .padding([.bottom], 40)
            .task {
                do {
                    // 임시 타이머
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                        isLoading = false
                    }
                }
            }
    }
}

struct InitView_Previews: PreviewProvider {
    static var previews: some View {
        InitView(isLoading: .constant(true))
    }
}
