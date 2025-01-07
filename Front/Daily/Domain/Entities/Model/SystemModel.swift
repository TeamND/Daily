//
//  SystemModel.swift
//  Daily
//
//  Created by 최승용 on 5/1/24.
//

import Foundation

struct SystemModel: Codable {
    let resultCount: Int
    let results: [SystemResultsModel]
}

struct SystemResultsModel: Codable {
    let version: String
}
