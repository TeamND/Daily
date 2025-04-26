//
//  SymbolFilter.swift
//  Daily
//
//  Created by seungyooooong on 4/14/25.
//

import SwiftUI

struct SymbolFilter: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(Symbols.allCases, id: \.self) { filter in
                    let isCurrentFilter = calendarViewModel.filter == filter
                    Button {
                        calendarViewModel.setFilter(filter: filter)
                    } label: {
                        Group {
                            if filter == .all {
                                Text(filter.rawValue)
                                    .font(Fonts.bodyMdSemiBold)
                                    .foregroundStyle(isCurrentFilter ? Colors.Text.point : Colors.Text.tertiary)
                            } else {
                                HStack(alignment: .center, spacing: 4) {
                                    Image(filter.icon(isSuccess: isCurrentFilter))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16)
                                    Text("\(calendarViewModel.filterData[filter] ?? 0)")
                                        .font(Fonts.bodyMdSemiBold)
                                        .foregroundStyle(isCurrentFilter ? Colors.Text.point : Colors.Text.tertiary)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(isCurrentFilter ? Colors.Background.primary : Colors.Background.secondary)
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(isCurrentFilter ? Colors.Brand.primary : .clear, lineWidth: 1)
                        )
                    }
                }
            }
            .frame(height: 28)
            .padding(.horizontal, 1)    // MARK: border 표시를 위한 padding
        }
        .padding(.horizontal, 16)
    }
}
