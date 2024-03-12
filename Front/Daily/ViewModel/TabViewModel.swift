//
//  TabViewModel.swift
//  Daily
//
//  Created by 최승용 on 3/12/24.
//

import Foundation

class TabViewModel: ObservableObject {
    @Published var tagIndex: Int = 0
    
    func setTagIndex(tagIndex: Int) {
        self.tagIndex = tagIndex
    }
}
