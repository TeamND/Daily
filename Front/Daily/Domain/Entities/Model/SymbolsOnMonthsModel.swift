//
//  SymbolsOnMonthsModel.swift
//  Daily
//
//  Created by seungyooooong on 10/31/24.
//

import Foundation

struct SymbolsOnMonthsModel {
    var monthSelection: String
    var symbolsOnMonth: [SymbolsOnMonthModel]
    
    init(
        monthSelection: String = CalendarServices.shared.formatDateString(year: Date().year, month: Date().month),
        symbolsOnMonth: [SymbolsOnMonthModel] = Array(repeating: SymbolsOnMonthModel(), count: 31)
    ) {
        self.monthSelection = monthSelection
        self.symbolsOnMonth = symbolsOnMonth
    }
}
