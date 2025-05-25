//
//  ChartViewModel.swift
//  Daily
//
//  Created by seungyooooong on 5/4/25.
//

import Foundation

final class ChartViewModel: ObservableObject {
    private let chartUseCase: ChartUseCase
    
    @Published var type: CalendarTypes = .day
    @Published var totalCount: Int = 0
    @Published var successCount: Int = 0
    
    @Published var chartDatas: [ChartDataModel] = []
    
    init() {
        let chartRepository = ChartRepository()
        self.chartUseCase = ChartUseCase(repository: chartRepository)
    }
    
    func onAppear(navigationPath: [NavigationObject]) {
        setType(type: CalendarTypes.from(navigationCount: navigationPath.count))
    }
}

// MARK: set
extension ChartViewModel {
    func setType(type: CalendarTypes) {
        self.type = type
        
        setChartDatas()
    }
    
    private func setChartDatas() {
        Task { [weak self] in
            guard let self else { return }
            
            let (chartDatas, totalCount, successCount) = await chartUseCase.getChartDatas(type: type)
            await MainActor.run {
                self.chartDatas = chartDatas
                self.totalCount = totalCount
                self.successCount = successCount
            }
        }
    }
}
