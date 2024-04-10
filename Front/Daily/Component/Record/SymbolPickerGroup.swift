//
//  SymbolPickerGroup.swift
//  Daily
//
//  Created by 최승용 on 4/11/24.
//

import SwiftUI

struct SymbolPickerGroup: View {
    @Binding var symbol: String
    @State var isShowSymbolSheet: Bool = false
    var body: some View {
        Group {
            Image(systemName: "\(symbol.toSymbol()!.rawValue)")
                .padding()
            Image(systemName: "chevron.right")
            Image(systemName: "\(symbol.toSymbol()!.rawValue).fill")
                .padding()
        }
        .onTapGesture {
            isShowSymbolSheet = true
        }
        .sheet(isPresented: $isShowSymbolSheet) {
            SymbolSheet(symbol: $symbol)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}
