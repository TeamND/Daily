//
//  RepeatTypeSection.swift
//  Daily
//
//  Created by seungyooooong on 6/18/25.
//

import SwiftUI

struct RepeatTypeSection: View {
    @ObservedObject var goalViewModel: GoalViewModel
    
    @State private var buttonFrame: CGRect = .zero
    
    var body: some View {
        HStack {
            Text("반복 방식")
                .font(Fonts.bodyLgSemiBold)
                .foregroundStyle(Colors.Text.primary)
            
            Spacer()
            
            Button {
                let offsetX = buttonFrame.width - 108 / 2
                let offsetY = buttonFrame.height / 2 + 12
                
                let position = CGPoint(
                    x: buttonFrame.minX + offsetX,
                    y: buttonFrame.minY + offsetY + 60
                )
                
                if goalViewModel.popoverContent != nil {
                    goalViewModel.hidePopover()
                } else {
                    goalViewModel.showPopover(at: position) {
                        VStack(spacing: .zero) {
                            ForEach(Array(RepeatTypes.allCases.enumerated()), id: \.element) { index, type in
                                if index > .zero { DailyDivider(color: Colors.Border.primary, height: 1) }
                                Button {
                                    goalViewModel.repeatType = type
                                    goalViewModel.popoverContent = nil
                                } label: {
                                    Text(type.text)
                                        .font(Fonts.bodyLgMedium)
                                        .foregroundStyle(Colors.Text.secondary)
                                        .frame(width: 108, height: 40)
                                }
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(goalViewModel.repeatType.text)
                        .font(Fonts.bodyLgMedium)
                        .foregroundStyle(Colors.Text.point)
                    
                    Image(.chevronUpDown)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Colors.Background.secondary)
                .cornerRadius(8)
            }
            .getFrame { buttonFrame = $0 }
        }
    }
}
