//
//  CalendarLoadView.swift
//  Daily
//
//  Created by seungyooooong on 12/28/24.
//

import SwiftUI

struct CalendarLoadView: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    let type: CalendarType
    let direction: Direction
    
    var body: some View {
        HStack {
            if direction == .prev {
                Spacer()
                Image(systemName: direction.imageName)
            }
            Text(calendarViewModel.loadText(type: type, direction: direction))
                .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
            if direction == .next {
                Image(systemName: direction.imageName)
                Spacer()
            }
        }
        .padding()
        .padding(.bottom, CGFloat.screenHeight * 0.25)
        .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
    }
}

#Preview {
    CalendarLoadView(type: .year, direction: .prev)
}
