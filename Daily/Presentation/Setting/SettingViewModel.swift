//
//  SettingViewModel.swift
//  Daily
//
//  Created by seungyooooong on 12/1/25.
//

import Foundation

final class SettingViewModel: ObservableObject {
    @Published var calendarType: CalendarTypes { didSet { UserDefaultManager.calendarType = calendarType } }
    @Published var language: Languages { didSet { UserDefaultManager.language = language } }
    
    init() {
        self.calendarType = UserDefaultManager.calendarType ?? .month
        self.language = UserDefaultManager.language ?? .korean
    }
}
