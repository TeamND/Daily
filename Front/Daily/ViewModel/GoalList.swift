//
//  GoalList.swift
//  Daily
//
//  Created by 최승용 on 2022/12/01.
//

import Foundation

class GoalList: ObservableObject {
    @Published var goals: [Goal] = []
    
    func add() {
        goals.append(Goal())
    }
    func delete() {
        goals.removeLast()
    }
    func modify() {
        self.delete()
        self.add()
    }
}
