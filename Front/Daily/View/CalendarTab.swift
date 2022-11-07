//
//  CalendarTab.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct CalendarTab: View {
    @State var isActice: Bool = true
    var body: some View {
        NavigationView {
            Calendar_Year(isActive: $isActice)
        }
    }
    
}

struct CalendarTab_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTab()
    }
}
