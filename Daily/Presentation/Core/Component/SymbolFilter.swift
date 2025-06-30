//
//  SymbolFilter.swift
//  Daily
//
//  Created by seungyooooong on 4/14/25.
//

import SwiftUI

struct SymbolFilter: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    @ObservedObject private var chartViewModel: ChartViewModel
    
    let type: CalendarTypes?
    
    init(type: CalendarTypes? = nil, chartViewModel: ChartViewModel = ChartViewModel()) {
        self.type = type    // MARK: type == nil ? chartView : calendarView
        self.chartViewModel = chartViewModel
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(Symbols.allCases, id: \.self) { filter in
                    let isCurrentFilter = type == nil ? chartViewModel.filter == filter : calendarViewModel.filter == filter
                    let filterNumber = type == nil ? chartViewModel.filterDatas[filter] : calendarViewModel.getData(type: type!)?.filterData[filter]
                    Button {
                        if type == nil {
                            chartViewModel.setFilter(filter: filter)
                        } else {
                            calendarViewModel.setFilter(filter: filter)
                        }
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
                                    Text("\(filterNumber ?? 0)")
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
            .padding(.horizontal, 16)
        }
        .horizontalGradient()
    }
}
