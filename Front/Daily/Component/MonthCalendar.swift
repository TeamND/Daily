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
            ForEach (0..<6) { rowIndex in
                HStack {
                    ForEach (0..<7) { colIndex in
                        let isToday = rowIndex == 1 && colIndex == 1
                        DayOnMonth()
                            .padding([.leading, .bottom, .trailing], 4)
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.green, lineWidth: 2)
                                    .opacity(isToday ? 1 : 0)
                            }
                    }
                }
                if rowIndex < 5 { CustomDivider(hPadding:8) }
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
