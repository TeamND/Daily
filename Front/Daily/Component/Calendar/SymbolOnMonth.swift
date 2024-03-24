//
//  SymbolOnMonth.swift
//  Daily
//
//  Created by 최승용 on 3/24/24.
//

import SwiftUI

struct SymbolOnMonth: View {
    let symbol: symbolOnMonthModel
    
    var body: some View {
        if symbol.imageName.toSymbol() == nil {
            Image(systemName: "d.circle").opacity(0)
        } else {
            if symbol.isSuccess {
                Image(systemName: "\(symbol.imageName.toSymbol()!.rawValue).fill")
            } else {
                Image(systemName: "\(symbol.imageName.toSymbol()!.rawValue)")
            }
        }
    }
}
