//
//  Goal.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import SwiftUI

struct Goal: View {
    var goal: String
    var body: some View {
        HStack {
            Image(systemName: "dumbbell.fill")
            Text("\(goal)")
        }
    }
}

struct Goal_Previews: PreviewProvider {
    static var previews: some View {
        Goal(goal: "1")
            .previewLayout(.fixed(width: 500, height: 40))
    }
}
