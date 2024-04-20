//
//  TestView.swift
//  Daily
//
//  Created by 최승용 on 4/21/24.
//

import SwiftUI

struct TestView: View {
    @State private var position = marginRange
    @State private var currentIndex = 99
    
    var body: some View {
        VStack {
            // ✅ TabView 대신 LazyHStack을 사용
            ViewPager(position: $position) {
                ForEach(currentIndex - marginRange ... currentIndex + marginRange, id: \.self) { index in
                    Text("\(index)")
                        .frame(width: CGFloat.screenWidth, height: 200)
                        .background(.red)
                }
            }
        }
        .onChange(of: position) { newValue in
            if newValue == marginRange {
                return
            } else {
                currentIndex = newValue > marginRange ? currentIndex + 1 : currentIndex - 1
                position = marginRange
            }
        }
    }
}
