//
//  NavigationViewModel.swift
//  Daily
//
//  Created by 최승용 on 3/12/24.
//

import Foundation

class NavigationViewModel: ObservableObject {
    // MARK: - about tabView
    @Published var tagIndex: Int = 0
    
    func getTagIndex() -> Int {
        return self.tagIndex
    }
    func setTagIndex(tagIndex: Int) {
        DispatchQueue.main.async {
            self.tagIndex = tagIndex
        }
    }
    
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
    
    func getNavigationBarTitle(userInfo: UserInfo, calendarState: String) -> String {
        var title = ""
        switch calendarState {
        case "year":
            title = userInfo.currentYearLabel
        case "month":
            title = userInfo.currentMonthLabel
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
