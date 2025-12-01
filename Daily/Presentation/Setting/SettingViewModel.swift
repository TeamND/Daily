//
//  SettingViewModel.swift
//  Daily
//
//  Created by seungyooooong on 12/1/25.
//

import Foundation

final class SettingViewModel: ObservableObject {
    @Published var startDay: DayOfWeek { didSet { UserDefaultManager.startDay = startDay } }
    @Published var language: Languages { didSet { UserDefaultManager.language = language } }
    @Published var calendarType: CalendarTypes { didSet { UserDefaultManager.calendarType = calendarType } }
    
    init() {
        self.startDay = UserDefaultManager.startDay ?? .sun
        self.language = UserDefaultManager.language ?? .korean
        self.calendarType = UserDefaultManager.calendarType ?? .month
    }
}
