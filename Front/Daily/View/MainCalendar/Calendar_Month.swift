//
//  Calendar_Month.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Month: View {
    @Binding var weeks: [String]
    var body: some View {
        VStack {
            SevenHStack(weeks: $weeks)
                .frame(maxWidth: .infinity, maxHeight: 50)
            CustomDivider(color: .black, height: 2, hPadding: 12)
            MonthCalendar()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct Calendar_Month_Previews: PreviewProvider {
    static var previews: some View {
        Calendar_Month(weeks: .constant(kWeeks[0]))
    }
}
