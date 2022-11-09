//
//  DateFormatter.swift
//  Daily
//
//  Created by 최승용 on 2022/11/07.
//

import SwiftUI

let YYYYMdformat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY년 M월 d일"
    return formatter
}()

let YYYYformat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY년"
    return formatter
}()

let Mformat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "M월"
    return formatter
}()

let dformat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d일"
    return formatter
}()
