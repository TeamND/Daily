//
//  ProgressBar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import SwiftUI

struct ProgressBar: View {
    @StateObject var goal: Goal
    var body: some View {
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(goal: Goal())
    }
}
