//
//  WeekIndicator.swift
//  Daily
//
//  Created by 최승용 on 2022/11/17.
//

import SwiftUI

struct WeekIndicator: View {
    var body: some View {
        HStack {
            ForEach (kWeeks[0], id: \.self) { week in
                Spacer()
                Text(week)
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
        }
    }
}

struct WeekIndicator_Previews: PreviewProvider {
    static var previews: some View {
        WeekIndicator()
    }
}
