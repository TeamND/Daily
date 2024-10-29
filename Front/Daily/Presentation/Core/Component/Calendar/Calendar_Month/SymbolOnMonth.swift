//
//  SymbolOnMonth.swift
//  Daily
//
//  Created by 최승용 on 3/24/24.
//

import SwiftUI

struct SymbolOnMonth: View {
    let symbol: symbolOnMonthModel
    let isEllipsis: Bool
    
    var body: some View {
        VStack {
            if isEllipsis {
                Image(systemName: "ellipsis")
            } else if symbol.imageName.toSymbol() == nil {
                Image(systemName: "d.circle").opacity(0)
            } else {
                if symbol.isSuccess {
                    Image(systemName: "\(symbol.imageName.toSymbol()!.rawValue).fill")
                } else {
                    Image(systemName: "\(symbol.imageName.toSymbol()!.rawValue)")
                }
            }
        }
        .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity)
        .frame(height: CGFloat.fontSize * 2)
    }
}
