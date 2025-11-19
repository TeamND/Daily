//
//  HolidayModel.swift
//  Daily
//
//  Created by seungyooooong on 11/7/25.
//

import Foundation

struct HolidayModel: Codable {
    let date: String
    let localName: String
    let name: String
    let countryCode: String
    let fixed: Bool
    let global: Bool
    let counties: [String]?
    let launchYear: Int?
    let types: [String]
}
