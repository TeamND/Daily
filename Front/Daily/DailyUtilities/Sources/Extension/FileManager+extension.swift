//
//  FileManager+extension.swift
//  DailyUtilities
//
//  Created by seungyooooong on 1/4/25.
//

import Foundation

extension FileManager {
    public static func sharedContainerURL() -> URL {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.seungyong96.Daily"
        )!.appendingPathComponent("Daily.sqlite")
    }
}
