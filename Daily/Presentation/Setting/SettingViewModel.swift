//
//  SettingViewModel.swift
//  Daily
//
//  Created by seungyooooong on 12/1/25.
//

import Foundation

final class SettingViewModel: ObservableObject {
    @Published var languageManager = LanguageManager.shared
    
    @Published var startDay: DayOfWeek { didSet { UserDefaultManager.startDay = startDay } }
    @Published var language: Languages {
        didSet {
            UserDefaultManager.language = language
            languageManager.language = language
        }
    }
    @Published var calendarType: CalendarTypes { didSet { UserDefaultManager.calendarType = calendarType } }
    
    init() {
        // MARK: - init user defaults
        if UserDefaultManager.startDay == nil { UserDefaultManager.startDay = .sun }
        if UserDefaultManager.language == nil {
            let languageCode = Locale.current.language.languageCode?.identifier
            let systemLanguage = Languages.from(languageCode: languageCode)
            UserDefaultManager.language = systemLanguage ?? .korean
        }
        if UserDefaultManager.calendarType == nil { UserDefaultManager.calendarType = .month }
        
        self.startDay = UserDefaultManager.startDay!
        self.language = UserDefaultManager.language!
        self.calendarType = UserDefaultManager.calendarType!
        
        self.languageManager.language = language
    }
}
