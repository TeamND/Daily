//
//  Calendar_Week&Day.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Week_Day: View {
    @StateObject var calendar: Calendar
    var goalList: [String] = ["1", "2", "3"]
    var body: some View {
        VStack {
            HStack {
                ForEach (kWeeks[0], id: \.self) { week in
                    Spacer()
                    ZStack {
                        let isToday = week == "수"
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.green, lineWidth: 2)
                            .opacity(isToday ? 1 : 0)
                            .padding([.top, .bottom], -2)
                        Image(systemName: "circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.accentColor.opacity(0.4))
                        Text(week)
                            .font(.system(size: 16, weight: .bold))
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 30)
            CustomDivider(color: .black, height: 2, hPadding: 12)
            ScrollView {
                LazyVStack {
                    ForEach (goalList, id: \.self) { goal in
                        Goal(goal: goal)
                            .frame(height: 40)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct Calendar_Week_Day_Previews: PreviewProvider {
    static var previews: some View {
        Calendar_Week_Day(calendar: Calendar())
    }
}
