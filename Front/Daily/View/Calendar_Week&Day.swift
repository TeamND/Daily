//
//  Calendar_Week&Day.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Week_Day: View {
    var body: some View {
        VStack {
            Text("Week&Year Calender")
        }
        .navigationBarTitle("\(today, formatter: Mdformat)", displayMode: .inline)
        .navigationBarItems(trailing: AddGoalButton())
    }
}

struct Calendar_Week_Day_Previews: PreviewProvider {
    static var previews: some View {
        Calendar_Week_Day()
    }
}
