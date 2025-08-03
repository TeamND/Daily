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
        case .goal, .modify:
            guard let goalData = data as? GoalDataEntity else { return EmptyView() }    // TODO: 추후에 에러 화면으로 이동하도록 수정
            return GoalView(goalData: goalData, viewType: viewType)
        case .setting:
            return SettingView()
        case .chart:
            return ChartView()
        }
    }
}
