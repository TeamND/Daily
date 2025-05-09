//
//  DailyDataModel.swift
//  Daily
//
//  Created by seungyooooong on 4/28/25.
//

import Foundation

protocol DailyDataModel {
    var filterData: [Symbols: Int] { get }
}
