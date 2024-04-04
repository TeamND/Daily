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
    func mainViewDragGesture(userInfo: UserInfo, calendarViewModel: CalendarViewModel, tabViewModel: TabViewModel) -> some View {
        self.gesture(
            DragGesture().onEnded { value in
                // 세로 제스처가 우선순위가 높음
                if abs(value.translation.height) > 100 {
                    // 상 -> 하
                    if value.translation.height > 100 {
                        if tabViewModel.getTagIndex() == 0 {
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
                        }
                    }
                    // 하 -> 상
                    if value.translation.height < -100 {
                        if tabViewModel.getTagIndex() == 0 {
                            if userInfo.currentState == "month" {
                                withAnimation {
                                    userInfo.currentState = "week"
                                }
                            }
                            if userInfo.currentState == "year" {
                                withAnimation {
                                    userInfo.currentState = "month"
                                }
                            }
                        }
                    }
                }
                // 가로 제스처가 우선순위가 낮음
                else {
                    // 좌 -> 우
                    if value.translation.width > 100 {
                        if tabViewModel.getTagIndex() == 0 && value.startLocation.x > 30 {
                            userInfo.changeCalendar(direction: "prev", calendarViewModel: calendarViewModel)
                        } else {
                            tabViewModel.setTagIndex(tagIndex: (tabViewModel.getTagIndex()+2)%3)
                        }
                    }
                    // 우 -> 좌
                    if value.translation.width < -100 {
                        if tabViewModel.getTagIndex() == 0 && value.startLocation.x < CGFloat.screenWidth-30 {
                            userInfo.changeCalendar(direction: "next", calendarViewModel: calendarViewModel)
                        } else {
                            tabViewModel.setTagIndex(tagIndex: (tabViewModel.getTagIndex()+1)%3)
                        }
                    }
                }
            }
        )
    }
}
