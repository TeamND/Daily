//
//  DailySymbolFilter.swift
//  Daily
//
//  Created by seungyooooong on 4/14/25.
//

import SwiftUI

struct DailySymbolFilter: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    var body: some View {
        // FIXME: 추후 디자인 나오면 수정
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(Symbols.allCases, id: \.self) { filter in
                    Button {
                        calendarViewModel.setFilter(filter: filter)
                    } label: {
                        Text(filter.rawValue)
                            .foregroundStyle(Colors.reverse)
                            .frame(width: 60, height: 30)
                            .background(calendarViewModel.filter == filter ? Colors.daily : Colors.theme)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}
