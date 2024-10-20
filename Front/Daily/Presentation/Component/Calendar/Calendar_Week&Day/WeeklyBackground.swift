//
//  WeeklyBackground.swift
//  Daily
//
//  Created by 최승용 on 6/6/24.
//

import SwiftUI

struct WeeklyBackground: View {
    @Binding var isShowWeeklySummary: Bool
    
    var body: some View {
        Rectangle()
            .fill(.black.opacity(0.5))
            .opacity(isShowWeeklySummary ? 1 : 0)
            .onTapGesture {
                if isShowWeeklySummary {
                    withAnimation {
                        isShowWeeklySummary = false
                    }
                }
            }
            .highPriorityGesture(DragGesture())
    }
}
