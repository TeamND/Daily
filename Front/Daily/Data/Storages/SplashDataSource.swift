//
//  SplashDataSource.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

class SplashDataSource {
    static let shared = SplashDataSource()
    private var subTitle: String = "Design 🎨, Record 📝\n\n\t\t, and Check 👏 'Daily'!!"
    
    private init() { }
    
    func getSubTitle() -> String {
        return self.subTitle
    }
    func setSubTitle(subTitle: String) {
        self.subTitle = subTitle
    }
}
