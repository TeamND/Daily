//
//  RecordButton.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import SwiftUI

struct RecordButton: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var record: RecordModel
    @Binding var isBeforeRecord: Bool
    
    var body: some View {
        if isBeforeRecord {
            RecordProgressBar(record: $record, color: .primary)
        } else {
            Button {
                if record.issuccess {
                    print("great")
                } else {
                    switch record.type {
                    case "check", "count":
                        increaseCount(recordUID: String(record.uid)) { (data) in
                            if data.code == "00" {
                                calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel)
                            }
                        }
                    case "timer":
                        print("timer record button press")
                        //                    record.itart.toggle()
                    default:
                        print("catch error is record button")
                    }
                }
            } label: {
                RecordProgressBar(record: $record, color: Color("CustomColor"))
            }
        }
    }
}
