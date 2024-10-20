//
//  TimerViewModel.swift
//  Daily
//
//  Created by 최승용 on 4/27/24.
//

import Foundation

class TimerViewModel: ObservableObject {
    @Published var timerIndex: Int = 2
    let timeList: [Int] = [60, 180, 300, 600, 1800, 3600, 5400, 7200, 9000, 10800]
    
    func findTimerIndex(time: Int) {
        for index in 0 ..< self.timeList.count {
            if time == self.timeList[index] {
                self.timerIndex = index
            }
        }
    }
    
    func timeToString(time: Int) -> String {
        switch time {
        case 60:
            return "1분"
        case 180:
            return "3분"
        case 300:
            return "5분"
        case 600:
            return "10분"
        case 1800:
            return "30분"
        case 3600:
            return "1시간"
        case 5400:
            return "1.5시간"
        case 7200:
            return "2시간"
        case 9000:
            return "2.5시간"
        case 10800:
            return "3시간"
        default:
            return "error"
        }
    }
}
