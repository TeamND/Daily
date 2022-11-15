//
//  Calendar_Month.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Month: View {
    @StateObject var calendar: Calendar
    var body: some View {
        VStack {
            HStack {
                ForEach (kWeeks[0], id: \.self) { week in
                    Spacer()
                    Text(week)
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 30)
            CustomDivider(color: .black, height: 2, hPadding: 12)
            VStack {
                ForEach (0..<6) { rowIndex in
                    HStack {
                        ForEach (0..<7) { colIndex in
                            let isToday = rowIndex == 1 && colIndex == 1
                            DayOnMonth(calendar: calendar)
                                .padding(4)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.green, lineWidth: 2)
                                        .opacity(isToday ? 1 : 0)
                                }
                        }
                    }
                    if rowIndex < 5 { CustomDivider(hPadding: 20) }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct Calendar_Month_Previews: PreviewProvider {
    static var previews: some View {
        Calendar_Month(calendar: Calendar())
    }
}
