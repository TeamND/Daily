//
//  SevenHStack.swift
//  Daily
//
//  Created by 최승용 on 2022/11/10.
//

import SwiftUI

struct WeeklyIndicator: View {
    @Binding var weeks: [String]
    var body: some View {
        HStack {
            ForEach (weeks, id: \.self) { week in
                Spacer()
                Text(week)
                Spacer()
            }
        }
    }
}

struct SevenHStack_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyIndicator(weeks: .constant(kWeeks[0]))
    }
}
