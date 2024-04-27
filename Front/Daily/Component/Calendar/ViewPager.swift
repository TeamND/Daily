//
//  ViewPager.swift
//  Daily
//
//  Created by 최승용 on 4/21/24.
//

import SwiftUI

struct ViewPager<Content: View>: View {
    @Binding var position: Int
    let content: Content

    init(position: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._position = position
        self.content = content()
    }
    
    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            LazyHStack(spacing: 0) {
                self.content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.position) * geometry.size.width)
            .offset(x: self.translation)
            .animation(.interpolatingSpring, value: position)
            .animation(.interpolatingSpring, value: translation)
            .highPriorityGesture(
                DragGesture(minimumDistance: CGFloat.fontSize).updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let offset = value.predictedEndTranslation.width / geometry.size.width
                    
                    var newPosition = max(Int((CGFloat(self.position) - offset).rounded()), 0)
                    
                    if newPosition > self.position {
                        newPosition = self.position + 1
                    } else if newPosition < self.position {
                        newPosition = self.position - 1
                    }
                    self.position = Int(newPosition)
                }
            )
        }
    }
}
