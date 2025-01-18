//
//  DailyCycleTypePicker.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import SwiftUI

struct DailyCycleTypePicker: View {
    @Binding var cycleType: CycleTypes
    let isModify: Bool
    
    var body: some View {
        if isModify {
            Text(cycleType.text)
                .font(.system(size: CGFloat.fontSize * 2.5))
        } else {
            Menu {
                ForEach(CycleTypes.allCases, id: \.self) { cycleType in
                    Button {
                        withAnimation {
                            self.cycleType = cycleType
                        }
                    } label: {
                        Text(cycleType.text)
                    }
                }
            } label: {
                Text(cycleType.text)
                    .font(.system(size: CGFloat.fontSize * 2.5))
                    .foregroundStyle(Colors.daily)
            }
        }
    }
}

#Preview {
    DailyCycleTypePicker(cycleType: .constant(.date), isModify: false)
}
