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
            ZStack {
                HStack {
                    Text("주간 요약")
                        .padding()
                        .background(Color("BackgroundColor"))
                        .cornerRadius(20)
                    Spacer()
                }
                .padding(20)
                HStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BackgroundColor"))
                        .frame(height: 500)
                        .padding(.bottom, -600)
                }
            }
        }
    }
}

#Preview {
    WeeklySummary()
}
