//
//  DailyMainView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

struct DailyMainView: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    
    var body: some View {
        NavigationStack(path: $navigationEnvironment.navigationPath) {
            DailyCalendarView()
        }
    }
}

#Preview {
    DailyMainView()
}
