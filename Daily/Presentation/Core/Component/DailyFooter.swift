//
//  DailyFooter.swift
//  Daily
//
//  Created by seungyooooong on 3/18/25.
//

import Foundation
import SwiftUI

struct DailyFooter: View {
    @State var status: FooterStatus = .calendar
    
    var body: some View {
        HStack {
            calendarButton
            chartButton
            settingButton
        }
        .frame(maxWidth: .infinity)
        .frame(height: 68)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.background)   // TODO: 임시 색상 추후 수정
        .cornerRadius(.infinity)
    }
    
    private var calendarButton: some View {
        Button {
            status = .calendar
        } label: {
            Label(status == .calendar ? "목표 추가" : "캘린더", systemImage: status == .calendar ? "plus" : "house")
                .foregroundStyle(status == .calendar ? .black : .gray)    // TODO: 임시 색상 추후 수정
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(status == .calendar ? Colors.daily : Colors.background)  // TODO: 임시 색상 추후 수정
        .cornerRadius(.infinity)
    }
    
    private var chartButton: some View {
        Button {
            status = .chart
        } label: {
            Image(systemName: "chart.bar")
                .foregroundStyle(status == .chart ? Colors.daily : .gray) // TODO: 임시 색상 추후 수정
                .frame(maxWidth: 24, maxHeight: 24)
                .padding(14)
        }
    }
    
    private var settingButton: some View {
        Button {
            status = .setting
        } label: {
            Image(systemName: "gear")
                .foregroundStyle(status == .setting ? Colors.daily : .gray) // TODO: 임시 색상 추후 수정
                .frame(maxWidth: 24, maxHeight: 24)
                .padding(14)
        }
    }
}
