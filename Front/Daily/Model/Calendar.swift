//
//  Calendar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import Foundation

class Calendar: ObservableObject {
    @Published var state: String {
        didSet {
            switch state {
            case "Year":
                self.naviLabel = ""
                self.naviTitle = YYYYformat.string(from: today)
            case "Month":
                self.naviLabel = YYYYformat.string(from: today)
                self.naviTitle = Mformat.string(from: today)
            case "Week&Day":
                self.naviLabel = Mformat.string(from: today)
                self.naviTitle = dformat.string(from: today)
            default:
                self.naviLabel = ""
                self.naviTitle = ""
            }
        }
    }
    var today: Date

    var naviLabel: String = ""
    var naviTitle: String = ""

    init(state: String, today: Date) {
        self.state = ""
        self.today = today
        
        self.state = state
    }
}

extension Calendar {
    static let sample: [Calendar] = [
        Calendar(state: "Year", today: Date()),
        Calendar(state: "Month", today: Date()),
        Calendar(state: "Week&Day", today: Date())
    ]
}
