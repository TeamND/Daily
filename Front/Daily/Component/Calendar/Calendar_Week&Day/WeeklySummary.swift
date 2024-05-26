//
//  WeeklySummary.swift
//  Daily
//
//  Created by 최승용 on 5/16/24.
//

import SwiftUI
import Charts

struct WeeklySummary: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.primary.opacity(0.3))
                        .frame(width: CGFloat.fontSize * 5, height: CGFloat.fontSize * 0.8)
                        .padding(CGFloat.fontSize)
                    Text("주간 요약")
                }
                .padding(.horizontal, CGFloat.fontSize * 3)
                .padding(.bottom, CGFloat.fontSize * 3)
                .background(Color("BackgroundColor"))
                .cornerRadius(20)
                Spacer()
            }
            .padding(.horizontal, 20)
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BackgroundColor"))
                        .frame(height: 500)
                    VStack(alignment: .leading, spacing: CGFloat.fontSize * 3) {
                        HStack {
                            Spacer()
                            Text("목표 달성률")
                                .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                            Spacer()
                        }
                        Section {
                            Chart {
                                ForEach (calendarViewModel.ratingOnWeekForCharts) { date in
                                    BarMark(
                                        x: .value("Day", date.day),
                                        y: .value("Rating", date.rating)
                                    )
                                    .opacity(0.3)
                                    .annotation(position: .top, alignment: .center) {
                                        Text(date.rating.percentFormat())
                                            .font(.system(size: CGFloat.fontSize * 1.5))
                                    }
                                    RuleMark(
                                        y: .value("Average", 30)
                                    )
                                    .lineStyle(StrokeStyle(lineWidth: 2))
                                    .annotation(position: .top, alignment: .leading) {
                                        Text(" 평균 : 30%")
                                            .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
                                    }
                                }
                            }
                            .chartYScale(domain: 0 ... 100)
                            .foregroundStyle(.primary)
                            .frame(height: 200)
                        }
//                        HStack {
//                            Text(" - ")
//                            Text("적당히 열심히 살자")
//                        }
                        Spacer()
                    }
                    .font(.system(size: CGFloat.fontSize * 3))
                    .padding(.top, CGFloat.fontSize * 5)
                    .padding(CGFloat.fontSize * 5)
                }
                .padding(.bottom, -420)
            }
            .frame(height: 20)
        }
        .padding(.bottom, 400)
    }
}

#Preview {
    WeeklySummary(calendarViewModel: CalendarViewModel())
}
