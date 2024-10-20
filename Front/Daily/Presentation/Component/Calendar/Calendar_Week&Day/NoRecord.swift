//
//  NoRecord.swift
//  Daily
//
//  Created by 최승용 on 3/15/24.
//

import SwiftUI

struct NoRecord: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text(noRecordText)
            NavigationLink {
                RecordView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
            } label: {
                Text(goRecordViewText)
            }
            Spacer()
        }
    }
}
