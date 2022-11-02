//
//  UserInfo.swift
//  Daily
//
//  Created by 최승용 on 2022/11/01.
//

import Foundation
import SwiftUI

struct UserInfo: Identifiable {
    let id: String
    var pw: String
    var phone: String
    
    init(id: String, pw: String, phone: String) {
        self.id = id
        self.pw = pw
        self.phone = phone
    }
}
