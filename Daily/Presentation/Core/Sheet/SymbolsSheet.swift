//
//  SymbolsSheet.swift
//  Daily
//
//  Created by seungyooooong on 11/25/24.
//

import SwiftUI

struct SymbolsSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var symbol: Symbols
    
    var body: some View {
        List {
            ForEach(Symbols.allCases.filter { $0 != .all }, id: \.self) { symbol in
                Button {
                    self.symbol = symbol
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "\(symbol.imageName)")
                            .padding()
                        Image(systemName: "chevron.right")
                        Image(systemName: "\(symbol.imageName).fill")
                            .padding()
                        Spacer()
                    }
                    .foregroundStyle(Colors.reverse)
                }
            }
        }
    }
}
