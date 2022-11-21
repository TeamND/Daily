//
//  Calendar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import Foundation

class Calendar: ObservableObject {
    @Published private var _state: String = "Year"
    var state: String {
        get {
            return _state
        }
        set(newVal) {
            switch newVal {
            case "Year", "Month", "Week&Day":
                _state = newVal
            default:
                print("catch error in set state")
            }
        }
    }
}
