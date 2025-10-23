//
//  NoticeModel.swift
//  Daily
//
//  Created by seungyooooong on 10/23/25.
//

import Foundation

struct NoticeModel {
    let id: Int
    let type: NoticeTypes
    let image: String?
    let title: String?
    let subTitle: String?
    let content: String?
    
    init(
        id: Int,
        type: NoticeTypes,
        image: String? = nil,
        title: String? = nil,
        subTitle: String? = nil,
        content: String? = nil
    ) {
        self.id = id
        self.type = type
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.content = content
    }
}
