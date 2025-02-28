//
//  TaskQueueManager.swift
//  Daily
//
//  Created by seungyooooong on 2/28/25.
//

import Foundation

actor TaskQueueManager {
    static let shared = TaskQueueManager()
    
    private var tasks: [() async -> Void] = []
    private var isProcessing = false
    
    private init() { }
    
    func add(_ task: @escaping () async -> Void) {
        tasks.append(task)
        
        if !isProcessing { Task { await processTasks() } }
    }
    
    private func processTasks() async {
        guard !tasks.isEmpty, !isProcessing else { return }
        
        isProcessing = true
        
        while !tasks.isEmpty {
            let task = tasks.removeFirst()
            await task()
        }
        
        isProcessing = false
    }
}
