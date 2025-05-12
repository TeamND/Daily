//
//  CalendarLoadView.swift
//  Daily
//
//  Created by seungyooooong on 12/28/24.
//

import SwiftUI

struct CalendarLoadView: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    let type: CalendarTypes
    let direction: Direction
    
    var body: some View {
        HStack(spacing: 6) {
            if direction == .prev {
                Spacer()
                Image(direction.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
            }
            Text(calendarViewModel.loadText(type: type, direction: direction))
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
        .padding(.bottom, CGFloat.screenHeight * 0.25)
        .foregroundStyle(Colors.Text.point)
    }
}

#Preview {
    CalendarLoadView(type: .year, direction: .prev)
}
