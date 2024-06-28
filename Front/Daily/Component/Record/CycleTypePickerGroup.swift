//
//  CycleTypePickerGroup.swift
//  Daily
//
//  Created by 최승용 on 6/27/24.
//

import SwiftUI

struct CycleTypePickerGroup: View {
    @ObservedObject var goalViewModel: GoalViewModel
    
    var body: some View {
        Group {
            Menu {
                ForEach(0 ..< goalViewModel.cycle_types.count, id: \.self) { index in
                    Button {
                        withAnimation {
                            goalViewModel.setTypeIndex(typeIndex: index)
                            goalViewModel.setEndDate(end_date: goalViewModel.start_date.setDefaultEndDate())
                        }
                    } label: {
                        Text(goalViewModel.cycle_types[index])
                    }
                }
            } label: {
                Text(goalViewModel.cycle_types[goalViewModel.typeIndex])
                    .font(.system(size: CGFloat.fontSize * 2.5))
            }
        }
    }
}

#Preview {
    CycleTypePickerGroup(goalViewModel: GoalViewModel())
}
