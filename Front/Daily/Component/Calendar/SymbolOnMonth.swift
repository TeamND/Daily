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
        
        switch (symbolImageName) {
        case "운동":
            if isSuccess {
                Image(systemName: "dumbbell.fill")
            } else {
                Image(systemName: "dumbbell")
            }
        default:
            Image(systemName: "dumbbell").opacity(0)
        }
//        else if symbolImageName == "운동" { Image(systemName: "dumbbell.fill") }
//        else { Image(systemName: "dumbbell") }
    }
}
