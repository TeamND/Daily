//
//  DailyPicker.swift
//  Daily
//
//  Created by seungyooooong on 6/27/25.
//

import SwiftUI

struct DailyPicker: View {
    @Binding var selection: Int
    
    let range: [Int]
    let maxWidth: CGFloat
    let onChange: ((Int) -> Void)?
    
    init<S: Sequence<Int>>(range: S, selection: Binding<Int>, maxWidth: CGFloat = 83, onChange: ((Int) -> Void)? = nil) {
        self._selection = selection
        self.range = Array(range)
        self.maxWidth = maxWidth
        self.onChange = onChange
    }
    
    var body: some View {
        Picker("", selection: $selection) {
            ForEach(range, id: \.self) { value in
                Text(String(format: "%02d", value))
                    .tag(value)
                    .font(Fonts.bodyXlMedium)
                    .foregroundStyle(Colors.Text.secondary)
            }
        }
        .pickerStyle(.wheel)
        .frame(maxWidth: maxWidth, maxHeight: 174)
        .onChange(of: selection) { onChange?($1) }
    }
}

