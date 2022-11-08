//
//  Calendar_Year.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Year: View {
    @Binding var isActive: Bool
    var body: some View {
        VStack {
            NavigationLink(destination: Calendar_Month(), isActive: $isActive) {
                Text("Year Calender")
            }
        }
        .navigationBarTitle("\(today, formatter: YYYYformat)", displayMode: .inline)
        .navigationBarItems(trailing: AddGoalButton())
    }
}

struct Calendar_Year_Previews: PreviewProvider {
    static var previews: some View {
        Calendar_Year(isActive: .constant(true))
    }
}
