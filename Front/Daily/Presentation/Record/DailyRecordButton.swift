//
//  DailyRecordButton.swift
//  Daily
//
//  Created by seungyooooong on 11/28/24.
//

import SwiftUI

struct DailyRecordButton: View {
    @Environment(\.modelContext) private var modelContext
    @State var isAction: Bool = false
    let record: DailyRecordModel
    var color: Color = Colors.daily
    
    var body: some View {
        if let goal = record.goal {
            Button {
                withAnimation {
                    if record.isSuccess {
                        isAction = true
                    } else {
                        switch goal.type {
                        case .check, .count:
                            record.count += 1
                            record.isSuccess = record.count >= goal.count
                            try? modelContext.save()
//                        case "timer": // TODO: 추후 구현
                        default:
                            return
                        }
                    }
                }
            } label: {
                ZStack {
                    DailyRecordProgressBar(record: record, color: color)
                    if record.isSuccess {
                        Image(systemName: "hand.thumbsup")
                            .scaleEffect(isAction ? 1.5 : 1)
                            .animation(.bouncy, value: 5)
                    } else {    // TODO: 추후 timer 추가 시 수정
                        Image(systemName: "plus")
                    }
                }
                .foregroundColor(color)
            }
            .onChange(of: isAction) { _, isAction in
                if isAction {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                        withAnimation { self.isAction = false }
                    }
                }
            }
        }
    }
}
