//
//  RecordButton.swift
//  Daily
//
//  Created by seungyooooong on 11/28/24.
//

import SwiftUI

struct RecordButton: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    let record: DailyRecordModel
    let disabled: Bool
    
    var body: some View {
        Button {
            if record.isSuccess || disabled { return }
            calendarViewModel.actionOfRecordButton(record: record)
        } label: {
            ZStack {
                // FIXME: 아이콘 추가 후 수정
                if record.isSuccess {
                    Image(.success)
                        .resizable()
                        .scaledToFit()
                } else {    // TODO: 추후 timer 추가 시 수정
                    Image(.start)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 40, height: 40)
        }
    }
}
