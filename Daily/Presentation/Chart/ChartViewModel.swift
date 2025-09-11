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
    @Published var filter: Symbols = .all
    @Published var totalCount: Int = 0
    @Published var successCount: Int = 0
    
    @Published var isAnimationYet: Bool = true
    @Published var chartDatas: [ChartDataModel] = []
    @Published var filterDatas: [Symbols: Int] = [:]
    
    init() {
        let chartRepository = ChartRepository()
        self.chartUseCase = ChartUseCase(repository: chartRepository)
    }
    
    func onAppear(navigationPath: [NavigationObject], filter: Symbols) {
        chartDatas = (1 ... 7).map { i in
            ChartDataModel(id: 7 - i, isNow: false, unit: ChartUnit(weekday: "", string: String(i)), rating: 0.0)
        }
        isAnimationYet = false
        
        setType(type: CalendarTypes.from(navigationCount: navigationPath.count))
        setFilter(filter: filter)
    }
}

// MARK: - set func
extension ChartViewModel {
    func setType(type: CalendarTypes) {
        self.type = type
        
        setChartDatas()
    }
    
    func setFilter(filter: Symbols) {
        if self.filter == filter {
            self.filter = .all
        } else {
            self.filter = filter
        }
        
        setChartDatas()
    }
    
    private func setChartDatas() {
        Task { [weak self] in
            guard let self else { return }
            
            await TaskQueueManager.shared.add { [weak self] in
                guard let self else { return }
                
                let (chartDatas, filterDatas, totalCount, successCount) = await chartUseCase.getChartDatas(type: type, filter: filter)
                await MainActor.run {
                    self.chartDatas = chartDatas
                    self.filterDatas = filterDatas
                    self.totalCount = totalCount
                    self.successCount = successCount
                }
            }
        }
    }
}
