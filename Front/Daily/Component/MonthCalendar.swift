//
//  MonthCalendar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/10.
//

import SwiftUI

struct MonthCalendar: View {
    var body: some View {
        VStack {
            ForEach (0..<6) { row in
                HStack {
                    ForEach (0..<7) { num in
                        Spacer()
                        DayOnMonth()
                            .padding([.top, .bottom], 4)
                    }
                    Spacer()
                }
                if row < 5 { CustomDivider(hPadding:8) }
            }
            Spacer()
        }
    }
}

struct MonthCalendar_Previews: PreviewProvider {
    static var previews: some View {
        MonthCalendar()
    }
}
