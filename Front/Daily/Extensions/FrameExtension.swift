//
//  FrameExtension.swift
//  Daily
//
//  Created by 최승용 on 3/22/24.
//

import Foundation
import SwiftUI

// MARK: - ResponsiveScreen

extension CGFloat {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    // calendar
    static let monthOnYearWidth = screenWidth / 3
    static let monthOnYearHeight = screenHeight / 6
    static let dayOnMonthWidth = screenWidth / 7
    
    static let fontSize = 6 * screenWidth / 393 // 6.7 iPhone 기준
}

// MARK: - Frame Modifier

extension View {
    // Vertical Center
    func vCenter() -> some View {
        self.frame(maxHeight: .infinity, alignment: .center)
    }
    
    // Vertical Top
    func vTop() -> some View {
        self.frame(maxHeight: .infinity, alignment: .top)
    }
    
    // Vertical Bottom
    func vBottom() -> some View {
        self.frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    // Horizontal Center
    func hCenter() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    // Horizontal Leading
    func hLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // Horizontal Trailing
    func hTrailing() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
}

// MARK: - Custom Sheet Size

extension PresentationDetent {
    static let small = Self.height(100)
}

// MARK: - Custom Gesture

extension View {
    func mainViewDragGesture(userInfoViewModel: UserInfoViewModel, calendarViewModel: CalendarViewModel, alertViewModel: AlertViewModel) -> some View {
        self.gesture(
            DragGesture().onEnded { value in
                // 좌 -> 우
                if value.translation.width > CGFloat.fontSize * 15 {
                    if value.startLocation.x < CGFloat.fontSize * 5 && calendarViewModel.getCurrentState() != "year" {
                        if calendarViewModel.getCurrentState() == "month" {
                            calendarViewModel.setCurrentState(state: "year", year: 0, month: 0, day: 0, userInfoViewModel: userInfoViewModel) { code in
                                if code == "99" { alertViewModel.showAlert() }
                            }
                        }
                        if calendarViewModel.getCurrentState() == "week" {
                            calendarViewModel.setCurrentState(state: "month", year: 0, month: 0, day: 0, userInfoViewModel: userInfoViewModel) { code in
                                if code == "99" { alertViewModel.showAlert() }
                            }
                        }
                    } else {
                        calendarViewModel.changeCalendar(amount: -1, userInfoViewModel: userInfoViewModel) { code in
                            if code == "99" { alertViewModel.showAlert() }
                        }
                    }
                }
                // 우 -> 좌
                if value.translation.width < -CGFloat.fontSize * 15 {
                    calendarViewModel.changeCalendar(amount: 1, userInfoViewModel: userInfoViewModel) { code in
                        if code == "99" { alertViewModel.showAlert() }
                    }
                }
            }
        )
    }
}

// MARK: - Keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
