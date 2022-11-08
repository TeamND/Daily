//
//  Calendar_Month.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Month: View {
    var body: some View {
        VStack {
            NavigationLink(destination: Calendar_Week_Day()) {
                Text("Month Calendar")
            }
        }
        .navigationBarTitle("\(today, formatter: Mformat)", displayMode: .inline)
        .navigationBarItems(trailing: AddGoalButton())
    }
}

struct Calendar_Month_Previews: PreviewProvider {
    static var previews: some View {
        Calendar_Month()
    }
}
