//
//  RecordList.swift
//  Daily
//
//  Created by 최승용 on 3/31/24.
//

import SwiftUI

struct RecordList: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            ForEach ($calendarViewModel.recordsOnWeek, id:\.self.uid) { record in
                ZStack {
                    RecordOnList(userInfo: userInfo, calendarViewModel: calendarViewModel, record: record)
                        .recordListGesture(userInfo: userInfo, calendarViewModel: calendarViewModel, goalUID: String(record.goal_uid.wrappedValue))
                }
            }
        }
    }
}

#Preview {
    RecordList(userInfo: UserInfo(), calendarViewModel: CalendarViewModel())
}
