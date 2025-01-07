//
//  TabViewModel.swift
//  Daily
//
//  Created by 최승용 on 3/12/24.
//

import Foundation

class NavigationViewModel: ObservableObject {
    @Published var tagIndex: Int = 0
    
    func getTagIndex() -> Int {
        return self.tagIndex
    }
    func setTagIndex(tagIndex: Int) {
        DispatchQueue.main.async {
            self.tagIndex = tagIndex
        }
    }
}
