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
