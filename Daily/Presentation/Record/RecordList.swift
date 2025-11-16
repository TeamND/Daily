//
//  RecordList.swift
//  Daily
//
//  Created by seungyooooong on 11/29/24.
//

import SwiftUI

// MARK: - RecordList
struct RecordList: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    let recordsInList: [DailyRecordInList]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(recordsInList, id: \.record.id) { recordInList in
                let record = recordInList.record
                if let goal = record.goal {
                    if recordInList.isShowTimeline { DailyTimeLine(setTime: goal.setTime) }
                    DailyRecord(record: record)
                        .contextMenu { DailyMenu(record: record) }
                }
            }
            Spacer()
        }
    }
}

// MARK: - DailyRecord
struct DailyRecord: View {
    private let record: DailyRecordModel
    
    init(record: DailyRecordModel) {
        self.record = record
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if let goal = record.goal, let symbol = goal.symbol {
                Image(symbol.icon(isSuccess: record.isSuccess))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36)
                VStack(alignment: .leading, spacing: 8) {
                    Text(goal.content)
                        .font(Fonts.bodyLgSemiBold)
                        .foregroundStyle(Colors.Text.primary)
                    let recordCount = goal.type == .timer ? record.count.timerFormat() : String(record.count)
                    let goalCount = goal.type == .timer ? goal.count.timerFormat() : String(goal.count)
                    Text("\(recordCount) / \(goalCount)")
                        .font(Fonts.bodyMdRegular)
                        .foregroundStyle(Colors.Text.secondary)
                }
                Spacer()
                RecordButton(record: record, goal: goal).frame(maxHeight: 40)
            } else {
                // FIXME: 추후 수정
                Text("🚧🚧 예상치 못한 문제가 발생했습니다.")
                    .font(Fonts.bodyLgSemiBold)
                    .foregroundStyle(Colors.Text.primary)
            }
        }
        .frame(height: 72)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 8).fill(Colors.Background.secondary)
        }
    }
}

// MARK: - NoRecord
struct NoRecord: View {
    @EnvironmentObject private var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    let isEmpty: Bool
    
    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            Image(isEmpty ? .recordYetNormal : .recordYetFilter)
            Spacer().frame(height: 20)
            Text(GeneralServices.noRecordText(isEmpty: isEmpty))
                .font(Fonts.headingSmSemiBold)
                .foregroundStyle(Colors.Text.secondary)
            Spacer().frame(height: 4)
            Text(GeneralServices.noRecordDescriptionText(isEmpty: isEmpty))
                .font(Fonts.bodyLgRegular)
                .foregroundStyle(Colors.Text.tertiary)
            Spacer()
            Spacer()
        }
    }
}

// MARK: - HolidayView
struct HolidayView: View {
    let selection: String
    
    var body: some View {
        if let holiday = UserDefaultManager.holidays?[selection] {
            HStack(spacing: 4) {
                Image(holiday.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                Text(holiday.name)
                    .font(Fonts.bodyMdSemiBold)
                    .foregroundStyle(Colors.Brand.primary)
                Spacer()
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 16)
            .background(Colors.Brand.primary.opacity(0.1))  // MARK: 여기서만 투명도 사용
            .cornerRadius(99)
        }
    }
}
