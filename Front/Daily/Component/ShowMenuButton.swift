//
//  ShowMenuButton.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct ShowMenuButton: View {
    var body: some View {
        Button {
            print("menu")
        } label: {
            VStack {
                Spacer()
                Image(systemName: "slider.horizontal.3")
                Text("menu")
                    .font(.system(size: 12))
            }
        }
    }
}

struct ShowMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowMenuButton()
            .previewLayout(.fixed(width: 40, height: 40))
    }
}
