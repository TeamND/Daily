//
//  TutorialSecondView.swift
//  Daily
//
//  Created by 최승용 on 7/12/24.
//

import SwiftUI

struct TutorialSecondView: View {
    @Binding var isShowThirdSheet: Bool
    
    var body: some View {
        Button {
            isShowThirdSheet = true
        } label: {
            Text("22222 apply dev branch test")
        }
    }
}

#Preview {
    TutorialSecondView(isShowThirdSheet: .constant(false))
}
