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
    
    static let fontSizeForiPhone15 = 6 * screenWidth / 393 // 6.7 iPhone 기준
    static let fontSize = UIDevice.current.model == "iPhone" ? fontSizeForiPhone15 : fontSizeForiPhone15 / 2
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
                if value.translation.width > CGFloat.fontSize * 15 {
                    if navigationViewModel.getTagIndex() == 0 {
                        if value.startLocation.x < CGFloat.fontSize * 5 && userInfo.currentState != "year" {
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

// MARK: - NavigationBar
extension View {
    func calendarViewNavigationBar(userInfo: UserInfo, userInfoViewModel: UserInfoViewModel, calendarViewModel: CalendarViewModel, navigationViewModel: NavigationViewModel, calendarState: String) -> some View {
        self.navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(
                navigationViewModel.getNavigationBarTitle(userInfo: userInfo, calendarState: calendarState)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Button {
                            userInfo.changeCalendar(direction: "prev", calendarViewModel: calendarViewModel)
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        if calendarState == "year" {
                            Menu {
                                ForEach(Date().year - 5 ... Date().year + 5, id: \.self) { year in
                                    Button {
                                        userInfo.changeCalendar(direction: "next", calendarViewModel: calendarViewModel, amount: year - userInfo.currentYear)
                                    } label: {
                                        Text("\(String(year)) 년")
                                    }
                                }
                            } label: {
                                Text(calendarViewModel.getCurrentYearLabel(userInfoViewModel: userInfoViewModel))
                                    .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                        }
                        if calendarState == "month" {
                            Menu {
                                ForEach(1 ... 12, id:\.self) { month in
                                    Button {
                                        userInfo.changeCalendar(direction: "next", calendarViewModel: calendarViewModel, amount: month - userInfo.currentMonth)
                                    } label: {
                                        Text("\(String(month)) 월")
                                    }
                                }
                            } label: {
                                Text(calendarViewModel.getCurrentMonthLabel(userInfoViewModel: userInfoViewModel))
                                    .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                        }
                        if calendarState == "day" {
                            Menu {
                                ForEach(1 ... userInfo.lengthOfMonth(), id:\.self) { day in
                                    Button {
                                        userInfo.changeCalendar(direction: "next", calendarViewModel: calendarViewModel, amount: day - userInfo.currentDay)
                                    } label: {
                                        Text("\(String(day)) 일")
                                    }
                                }
                            } label: {
                                Text(calendarViewModel.getCurrentDayLabel(userInfoViewModel: userInfoViewModel))
                                    .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                        }
                        Button {
                            userInfo.changeCalendar(direction: "next", calendarViewModel: calendarViewModel)
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
            .navigationBarItems(trailing:
                NavigationLink(value: "appInfo") { Image(systemName: "info.circle").font(.system(size: CGFloat.fontSize * 2.5)) }
            )
    }
}
