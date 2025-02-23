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
        Task { @MainActor in
            navigationPath.append(navigationObject)
        }
    }
    
    func navigateDirect(from: CalendarType, to: CalendarType = .day) {
        Task { @MainActor in
            switch from {
            case .year:
                navigate(NavigationObject(viewType: .calendarMonth))
                if to == .month { return }
                try? await Task.sleep(nanoseconds: 100_000_000)
                navigate(NavigationObject(viewType: .calendarDay))
            case .month:
                navigate(NavigationObject(viewType: .calendarDay))
            default:
                return
            }
        }
    }
}
