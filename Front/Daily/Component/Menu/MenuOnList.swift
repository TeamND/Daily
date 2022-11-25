//
//  MenuOnList.swift
//  Daily
//
//  Created by 최승용 on 2022/11/25.
//

import SwiftUI

struct MenuOnList: View {
    @StateObject var menu: Menu
    var body: some View {
        HStack {
            Text(menu.title)
            Spacer()
            Button {
                menu.isSelected.toggle()
            } label: {
                HStack {
                    Text(menu.selectedOption)
                    Image(systemName: "chevron.right")
                        .rotationEffect(menu.isSelected ? Angle(degrees: 90) : Angle(degrees: 0))
                        .animation(.default, value: menu.isSelected)
                }
                .foregroundColor(.mint)
            }
        }
    }
}
