//
//  DailyAddGoalButton.swift
//  Daily
//
//  Created by seungyooooong on 10/25/24.
//

import SwiftUI

struct DailyAddGoalButton: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    let navigationObject = NavigationObject(viewType: .goal)
                    navigationEnvironment.navigationPath.append(navigationObject)
                } label: {
                    Label("목표 추가", systemImage: "plus")
                        .foregroundStyle(.white)
                        .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                }
                .padding()
                .background(Colors.daily)
                .cornerRadius(20)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    DailyAddGoalButton()
}
