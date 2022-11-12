//
//  Calendar_Year.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Year: View {
    @StateObject var calendar: Calendar
    var body: some View {
        VStack {
            Button {
                calendar.state = "Month"
            } label: {
                Text("Year Calender")
            }
        }
    }
}

struct Calendar_Year_Previews: PreviewProvider {
    static var previews: some View {
        Calendar_Year(calendar: Calendar())
    }
}
