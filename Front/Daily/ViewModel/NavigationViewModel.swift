//
//  NavigationViewModel.swift
//  Daily
//
//  Created by 최승용 on 3/12/24.
//

import Foundation

class NavigationViewModel: ObservableObject {
    // MARK: - about tabView
    @Published var tagIndex: Int = 0
    
    func getTagIndex() -> Int {
        return self.tagIndex
    }
    func setTagIndex(tagIndex: Int) {
        DispatchQueue.main.async {
            self.tagIndex = tagIndex
        }
    }
    
    // MARK: - about RecordView
    @Published var isModifyRecord: Bool = false
    
    func setIsMidfyRecord(isModifyRecord: Bool) {
        DispatchQueue.main.async {
            self.isModifyRecord = isModifyRecord
        }
    }
}
