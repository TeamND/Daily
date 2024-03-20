//
//  SymbolOnMonth.swift
//  Daily
//
//  Created by 최승용 on 3/18/24.
//

import SwiftUI

struct SymbolOnMonth: View {
    let symbol: [String: Any]
    
    var body: some View {
        let symbolImageName = symbol["imageName"] as! String
        let isSuccess = symbol["isSuccess"] as! Bool
        
        if symbolImageName == "" {
            Image(systemName: "dumbbell").opacity(0)
        } else {
            if isSuccess {
                Image(systemName: "\(symbolImageName.toSymbol().rawValue).fill")
            } else {
                Image(systemName: "\(symbolImageName.toSymbol().rawValue)")
            }
        }
    }
}
