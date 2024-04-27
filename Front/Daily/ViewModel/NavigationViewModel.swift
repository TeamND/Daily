//
//  NavigationViewModel.swift
//  Daily
//
//  Created by 최승용 on 3/12/24.
//

import Foundation

class NavigationViewModel: ObservableObject {
    // MARK: - about navigationStack
    @Published var currentPath: [String] = []
    
    func getCurrentPath() -> String {
        if self.currentPath.count == 0 {
            return "year"
        } else {
            return self.currentPath[self.currentPath.count - 1]
        }
    }
    
    func getPrevPath() -> String {
        if self.currentPath.count <= 1 {
            return "year"
        } else {
            return self.currentPath[self.currentPath.count - 2]
        }
    }
    
    func appendPath(path: String) {
        DispatchQueue.main.async {
            self.currentPath.append(path)
        }
    }
    
    func getNavigationBarTitle(userInfoViewModel: UserInfoViewModel, calendarViewModel: CalendarViewModel, calendarState: String) -> String {
        var title = ""
        switch calendarState {
        case "year":
            title = calendarViewModel.getCurrentYearLabel(userInfoViewModel: userInfoViewModel)
        case "month":
            title = calendarViewModel.getCurrentMonthLabel(userInfoViewModel: userInfoViewModel)
        default:
            title = "이전"
        }
        if self.getPrevPath().contains(calendarState) &&
            !self.getCurrentPath().contains("year") &&
            !self.getCurrentPath().contains("month") &&
            !self.getCurrentPath().contains("day") {
                title = "이전"
        }
        return title
    }
}
