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
            HStack {
                Spacer()
                Image(systemName: "\(symbol.toSymbol()!.rawValue)")
                Image(systemName: "chevron.right")
                    .frame(width: CGFloat.fontSize * 10)
                Image(systemName: "\(symbol.toSymbol()!.rawValue).fill")
                Spacer()
            }
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
