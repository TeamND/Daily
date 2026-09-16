//
//  CalendarLoadView.swift
//  Daily
//
//  Created by seungyooooong on 12/28/24.
//

import SwiftUI

struct CalendarLoadView: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    let date: Date?
    let type: CalendarTypes
    let direction: Direction
    
    init(date: Date? = nil, type: CalendarTypes, direction: Direction) {
        self.date = date
        self.type = type
        self.direction = direction
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 6) {
                if direction == .prev {
                    Spacer()
                    Image(direction.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                }
                Text(calendarViewModel.loadText(date: date, type: type, direction: direction))
                    .font(Fonts.bodyLgSemiBold)
                if direction == .next {
                    Image(direction.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                    Spacer()
                }
            }
            .padding(24)
            Spacer()
            Spacer()
        }
        .foregroundStyle(Colors.Text.point)
    }
}

#Preview {
    CalendarLoadView(type: .year, direction: .prev)
}
