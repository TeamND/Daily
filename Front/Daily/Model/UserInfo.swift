//
//  UserInfo.swift
//  Daily
//
//  Created by 최승용 on 2022/11/10.
//

import Foundation

class UserInfo: ObservableObject{
    @Published var week: Int = 0
    @Published var language: String = "Korean"
}
