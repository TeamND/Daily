//
//  MenuOnList.swift
//  Daily
//
//  Created by 최승용 on 2022/11/25.
//

import SwiftUI

struct MenuOnList: View {
    @StateObject var menu: Menu
    let index: Int
    var body: some View {
        HStack {
            Text(menu.title)
            Spacer()
            Picker("", selection: $menu.selectedOption) {
                ForEach(menu.options[index], id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(.segmented)
            .padding(2)
            .frame(width: 150)
        }
    }
}
