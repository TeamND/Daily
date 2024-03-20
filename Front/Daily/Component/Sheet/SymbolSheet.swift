//
//  SymbolSheet.swift
//  Daily
//
//  Created by 최승용 on 3/20/24.
//

import SwiftUI

struct SymbolSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var symbol: Symbol
    var body: some View {
        List {
            ForEach(Symbol.allCases, id: \.self) { symbol in
                HStack {
                    Image(systemName: "\(symbol.rawValue)")
                        .padding()
                    Image(systemName: "chevron.right")
                    Image(systemName: "\(symbol.rawValue).fill")
                        .padding()
                    Spacer()
                    Button {
                        self.symbol = symbol
                        presentationMode.wrappedValue.dismiss()
                    } label: { }
                }
            }
        }
    }
}
