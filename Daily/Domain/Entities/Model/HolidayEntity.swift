//
//  HolidayEntity.swift
//  Daily
//
//  Created by seungyooooong on 11/14/25.
//

import Foundation

struct HolidayEntity: Codable {
    let imageName: String
    let name: String
    
    init(imageName: String, name: String) {
        self.imageName = imageName
        self.name = name
    }
}
