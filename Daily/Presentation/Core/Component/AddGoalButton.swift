//
//  AddGoalButton.swift
//  Daily
//
//  Created by seungyooooong on 10/25/24.
//

import SwiftUI

struct AddGoalButton: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    let data = GoalDataModel(date: calendarViewModel.currentDate)
                    let navigationObject = NavigationObject(viewType: .goal, data: data)
                    navigationEnvironment.navigate(navigationObject)
                } label: {
                    Image(.circlePlus)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48)
                }
            }
            .padding(16)
        }
        .padding(8)
    }
}

#Preview {
    AddGoalButton()
}
