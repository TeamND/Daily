//
//  View+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation
import SwiftUI

// MARK: - Frame Modifier
extension View {
    func vTop() -> some View {
        self.frame(maxHeight: .infinity, alignment: .top)
    }
    func vCenter() -> some View {
        self.frame(maxHeight: .infinity, alignment: .center)
    }
    func vBottom() -> some View {
        self.frame(maxHeight: .infinity, alignment: .bottom)
    }
    func hLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    func hCenter() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    func hTrailing() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Custom Gesture
extension View {
    func mainViewDragGesture(userInfoViewModel: UserInfoViewModel, calendarViewModel: CalendarViewModel, alertViewModel: AlertViewModel) -> some View {
        self.gesture(
            DragGesture().onEnded { value in
                // MARK: swipe to right
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
                // MARK: swipe to left
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

