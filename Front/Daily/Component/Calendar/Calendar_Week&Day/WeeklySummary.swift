//
//  WeeklySummary.swift
//  Daily
//
//  Created by 최승용 on 5/16/24.
//

import SwiftUI

struct WeeklySummary: View {
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.primary.opacity(0.3))
                        .frame(width: CGFloat.fontSize * 5, height: CGFloat.fontSize * 0.8)
                        .padding(CGFloat.fontSize)
                    Text("주간 요약")
                }
                .padding(.horizontal, CGFloat.fontSize * 3)
                .padding(.bottom, CGFloat.fontSize * 3)
                .background(Color("BackgroundColor"))
                .cornerRadius(20)
                Spacer()
            }
            .padding(.horizontal, 20)
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BackgroundColor"))
                        .frame(height: 500)
                    VStack {
                        Text("주간어쩌구 저쩌구")
                        Text("주간어쩌구 저쩌구")
                        Text("주간어쩌구 저쩌구")
                        Text("주간어쩌구 저쩌구")
                        Text("주간어쩌구 저쩌구")
                        Text("주간어쩌구 저쩌구")
                        Text("주간어쩌구 저쩌구")
                    }
                }
                .padding(.bottom, -420)
            }
            .frame(height: 20)
        }
        .padding(.bottom, 400)
    }
}

#Preview {
    WeeklySummary()
}
