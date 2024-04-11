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
    static let dayOnMonthWidth = screenWidth / 7
    static let dayOnMonthHeight = screenHeight / 10
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
    func mainViewDragGesture(userInfo: UserInfo, calendarViewModel: CalendarViewModel, navigationViewModel: NavigationViewModel) -> some View {
        self.gesture(
            DragGesture().onEnded { value in
                // 좌 -> 우
                if value.translation.width > 100 {
                    if navigationViewModel.getTagIndex() == 0 {
                        if value.startLocation.x < 30 && userInfo.currentState != "year" {
                            if userInfo.currentState == "month" {
                                withAnimation {
                                    userInfo.currentState = "year"
                                }
                            }
                            if userInfo.currentState == "week" {
                                withAnimation {
                                    userInfo.currentState = "month"
                                }
                            }
                        } else {
                            userInfo.changeCalendar(direction: "prev", calendarViewModel: calendarViewModel)
                        }
                    }
                }
                // 우 -> 좌
                if value.translation.width < -100 {
                    if navigationViewModel.getTagIndex() == 0 {
                        userInfo.changeCalendar(direction: "next", calendarViewModel: calendarViewModel)
                    }
                }
            }
        )
    }
    
// MARK: - Custom Popup
    
//    func popup(isPresented: Binding<Bool>) -> some View {
//        if isPresented.wrappedValue {
//            return PopupView
//        }
//        return self
//    }
}

// MARK: - Keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
