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
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: 30)
                    .opacity(0)
                MenuDetail(menu: menu)
                    .frame(height: menu.isSelected ? 70 : 0)
                    .opacity(menu.isSelected ? 1.0 : 0.0)
                    .scaleEffect(menu.isSelected ? 1 : 0.3, anchor: .top)
                    .animation(.default, value: menu.isSelected)
            }
            .frame(height: menu.isSelected ? 100 : 30)
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
            .frame(height: 30)
        }
    }
}
