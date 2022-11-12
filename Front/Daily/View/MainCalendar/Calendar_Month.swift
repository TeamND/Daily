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
            WeeklyIndicator(weeks: $weeks)
                .frame(maxWidth: .infinity, maxHeight: 30)
            CustomDivider(color: .black, height: 2, hPadding: 12)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct Calendar_Month_Previews: PreviewProvider {
    static var previews: some View {
        Calendar_Month(weeks: .constant(kWeeks[0]))
    }
}
