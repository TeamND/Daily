//
//  SplashViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

final class SplashViewModel: ObservableObject {
    private let appLaunchUseCase: AppLaunchUseCase
    
    @Published var catchPhrase: String = ""
    @Published var updateNotice: String = ""
    @Published var isMainReady: Bool = false
    @Published var isMainLoaded: Bool = false
    @Published var notices: [NoticeModel] = []
    @Published var isNeedUpdate: Bool = false
    
    init() {
        let appLaunchRepository = AppLaunchRepository()
        self.appLaunchUseCase = AppLaunchUseCase(repository: appLaunchRepository)
    }

    func onAppear() {
        setUserDefault()
        Task { @MainActor in
            // FIXME: 추후 수정(이동)
            await fetchHolidays(year: 2025, countryCode: "KR")
            
            catchPhrase = appLaunchUseCase.getCatchPhrase()
            
            isNeedUpdate = await appLaunchUseCase.checkUpdate()
            if isNeedUpdate {
                (catchPhrase, updateNotice) = appLaunchUseCase.getUpdateNotice()
                return
            }
            
            await appLaunchUseCase.migrate()
            await appLaunchUseCase.fetch()
            isMainReady = true
            
            notices = await appLaunchUseCase.getNotices()
            isMainLoaded = await appLaunchUseCase.loadMain()
        }
    }
    
    private func setUserDefault() {
        UserDefaultManager.startDay = UserDefaultManager.startDay ?? DayOfWeek.sun.index
        UserDefaultManager.language = UserDefaultManager.language ?? Languages.korean.rawValue
        UserDefaultManager.calendarType = UserDefaultManager.calendarType ?? CalendarTypes.month.rawValue
    }
}

// FIXME: 추후 수정(이동)
func fetchHolidays(year: Int, countryCode: String) async {
    let urlString = "https://date.nager.at/api/v3/PublicHolidays/\(year)/\(countryCode)"
    guard let url = URL(string: urlString) else {
        print("❌ Invalid URL")
        return
    }
    
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status:", httpResponse.statusCode)
        }
        
        print(String(decoding: data, as: UTF8.self))
        
        let holidays = try JSONDecoder().decode([HolidayModel].self, from: data)
        print("✅ Holidays Count:", holidays.count)
        for holiday in holidays {
            print("📅 \(holiday.date) — \(holiday.localName) (\(holiday.name))")
        }
    } catch {
        print("❌ Error:", error)
    }
}
