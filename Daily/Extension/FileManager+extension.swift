//
//  FileManager+extension.swift
//  Daily
//
//  Created by seungyooooong on 11/6/25.
//

import Foundation

extension FileManager {
    public static func sharedContainerURL() -> URL {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.seungyong96.Daily"
        )!.appendingPathComponent("Daily.sqlite")
    }
}
