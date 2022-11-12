//
//  GoPrevButton.swift
//  Daily
//
//  Created by 최승용 on 2022/11/09.
//

import SwiftUI

struct GoPrevButton: View {
    @StateObject var calendar: Calendar
    var body: some View {
        Button {
            switch calendar.state {
            case "Month":
                calendar.state = "Year"
            case "Week&Day":
                calendar.state = "Month"
            default:
                break
            }
        } label: {
            Label(calendar.naviLabel, systemImage: "chevron.left")
        }
    }
}

struct GoPrevButton_Previews: PreviewProvider {
    static var previews: some View {
        GoPrevButton(calendar: Calendar())
            .previewLayout(.fixed(width: 150, height: 40))
    }
}
