//
//  MainView.swift
//  Daily
//
//  Created by 최승용 on 2022/11/05.
//

import SwiftUI

struct MainView: View {
    @State private var calendar: Calendar = Calendar(state: "Month", today: Date())
    var body: some View {
        VStack {
            MainHeader(calendar: calendar)
                .frame(maxWidth: .infinity, maxHeight: 40)
            MainCalendar(calendar: calendar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .accentColor(.mint)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
