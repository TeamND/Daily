//
//  GoPrevButton.swift
//  Daily
//
//  Created by 최승용 on 2022/11/09.
//

import SwiftUI

struct GoPrevButton: View {
    @Binding var naviLabel: String
    var body: some View {
        Button {
            print("prev")
        } label: {
            Label(naviLabel, systemImage: "chevron.left")
        }
    }
}

struct GoPrevButton_Previews: PreviewProvider {
    static var previews: some View {
        GoPrevButton(naviLabel: .constant("2022 년"))
            .previewLayout(.fixed(width: 150, height: 40))
    }
}
