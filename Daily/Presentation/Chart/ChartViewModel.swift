//
//  ChartViewModel.swift
//  Daily
//
//  Created by seungyooooong on 5/4/25.
//

import Foundation

final class ChartViewModel: ObservableObject {
    private let chartUseCase = ChartUseCase()
    
    @Published var type: CalendarTypes = .day
    @Published var totalCount: Int = 0
    @Published var successCount: Int = 0
    
    func onAppear(navigationPath: [NavigationObject]) {
        setType(type: CalendarTypes.from(navigationCount: navigationPath.count))
        // TODO: type별로 selection계산 & 데이터 로딩 필요(calendarViewModel 사용)
    }
}

extension ChartViewModel {
    private func setType(type: CalendarTypes) {
        self.type = type
    }
}
