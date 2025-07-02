//
//  NavigationObject.swift
//  Daily
//
//  Created by seungyooooong on 2/24/25.
//

import Foundation
import SwiftUI

protocol Navigatable: Hashable {}

struct NavigationObject: Navigatable {
    let viewType: ViewTypes
    let data: AnyHashable?
    
    init(viewType: ViewTypes, data: AnyHashable? = nil) {
        self.viewType = viewType
        self.data = data
    }
    
    func dailyView() -> any View {
        switch viewType {
        case .calendarMonth:
            return CalendarMonthView()
        case .calendarDay:
            return CalendarDayView()
        case .goal:
            let data = data as! GoalDataModel
            return GoalView(goalData: data, viewType: viewType)
        case .modify:
            let data = data as! ModifyDataModel
            return GoalView(modifyData: data, viewType: viewType)
        case .setting:
            return SettingView()
        case .chart:
            return ChartView()
        }
    }
}
