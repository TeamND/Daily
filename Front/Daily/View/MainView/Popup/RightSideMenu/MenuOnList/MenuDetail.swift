//
//  MenuDetail.swift
//  Daily
//
//  Created by 최승용 on 2022/11/30.
//

import SwiftUI

struct MenuDetail: View {
    @StateObject var menu: Menu
    let index: Int
    var body: some View {
        HStack {
            Picker("", selection: $menu.selectedOption) {
                ForEach(menu.options[index], id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(.segmented)
            .padding(2)
            .cornerRadius(15)
            .padding(-8)
        }
        .font(.system(size: 16))
    }
}
