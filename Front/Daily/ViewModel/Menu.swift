//
//  Menu.swift
//  Daily
//
//  Created by 최승용 on 2022/11/25.
//

import Foundation

class Menu: ObservableObject, Identifiable {
    @Published var id: UUID = UUID()
    @Published var isSelected: Bool
    @Published var title: String
    @Published var selectedOption: String
    @Published var options: [[String]] = [["일요일", "월요일"], ["날짜", "요일"], ["On", "Off"]]
    
    init(isSelected: Bool, title: String, selectedOption: String) {
        self.isSelected = isSelected
        self.title = title
        self.selectedOption = selectedOption
    }
}
