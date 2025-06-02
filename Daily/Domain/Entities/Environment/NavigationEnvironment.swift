//
//  NavigationEnvironment.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

final class NavigationEnvironment: ObservableObject {
    @Published var navigationPath: [NavigationObject] = []
    
    func navigate(_ navigationObject: NavigationObject) {
        if navigationPath.contains(where: { $0.viewType == navigationObject.viewType }) { return }
        Task { @MainActor in navigationPath.append(navigationObject) }
    }
    
    func navigateDirect(from: CalendarTypes, to: CalendarTypes = .day) {
        Task { @MainActor in
            switch from {
            case .year:
                if to == .year { return }
                var contentsOf: [NavigationObject] = []
                if to.navigationCount >= CalendarTypes.month.navigationCount { contentsOf.append(NavigationObject(viewType: .calendarMonth)) }
                if to.navigationCount >= CalendarTypes.day.navigationCount { contentsOf.append(NavigationObject(viewType: .calendarDay)) }
                
                navigationPath.append(contentsOf: contentsOf)
            case .month:
                switch to {
                case .year:
                    navigationPath.removeLast()
                case .day:
                    navigate(NavigationObject(viewType: .calendarDay))
                default:
                    return
                }
            case .day:
                navigationPath.removeLast(3 - to.navigationCount)
            default:
                return
            }
        }
    }
}
