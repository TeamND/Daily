//
//  Calendar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import Foundation

class Calendar: ObservableObject {
    @Published var showMonth: Bool = true
    @Published var showWeekDay: Bool = false
    
    func setState(state: String = "Month") {
        switch state {
        case "Year":
            self.showMonth = false
            self.showWeekDay = false
        case "Month":
            self.showMonth = true
            self.showWeekDay = false
        case "Week&Day":
            self.showMonth = true
            self.showWeekDay = true
        default:
            print("error")
            print("state is \(state)")
        }
    }
}
