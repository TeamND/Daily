//
//  Calendar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import Foundation

class Calendar: ObservableObject {
    @Published private var _state: String = "Month"
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
    var today: Date = Date()

    var naviLabel: String {
        get {
            switch _state {
            case "Month":
                return YYYYformat.string(from: today)
            case "Week&Day":
                return Mformat.string(from: today)
            default:
                return ""
            }
        }
    }
    var naviTitle: String {
        get {
            switch _state {
            case "Year":
                return YYYYformat.string(from: today)
            case "Month":
                return Mformat.string(from: today)
            case "Week&Day":
                return dformat.string(from: today)
            default:
                return ""
            }
        }
    }
}
