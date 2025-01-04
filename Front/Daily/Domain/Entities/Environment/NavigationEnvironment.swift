//
//  NavigationEnvironment.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

class NavigationEnvironment: ObservableObject {
    @Published var navigationPath: [NavigationObject] = []
    
    func navigate(_ navigationObject: NavigationObject) {
        if let currentPath = self.navigationPath.last {
            if currentPath.viewType == navigationObject.viewType { return }
        }
        DispatchQueue.main.async {
            self.navigationPath.append(navigationObject)
        }
    }
    
    func navigateDirect(from: CalendarType, to: CalendarType = .day) {
        switch from {
        case .year:
            DispatchQueue.main.async {
                self.navigationPath.append(NavigationObject(viewType: .calendarMonth))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.navigationPath.append(NavigationObject(viewType: .calendarDay))
                }
            }
        case .month:
            DispatchQueue.main.async {
                self.navigationPath.append(NavigationObject(viewType: .calendarDay))
            }
        default:
            return
        }
    }
}

protocol Navigatable: Hashable {}

struct NavigationObject: Navigatable {
    let viewType: ViewTypes
    let data: AnyHashable?
    
    init(viewType: ViewTypes, data: AnyHashable? = nil) {
        self.viewType = viewType
        self.data = data
    }
}

enum ViewTypes {
    case calendarMonth
    case calendarDay
    
    case goal
    case modify
    
    case appInfo
}
