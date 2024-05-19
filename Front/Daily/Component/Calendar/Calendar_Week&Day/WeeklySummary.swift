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
                Text("주간 요약")
                    .padding()
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
//        .ignoresSafeArea()
    }
}

#Preview {
    WeeklySummary()
}
