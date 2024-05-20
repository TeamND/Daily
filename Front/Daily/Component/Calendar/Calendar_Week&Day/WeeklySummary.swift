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
                    VStack(alignment: .leading, spacing: CGFloat.fontSize) {
                        HStack {
                            Text("이번 주 목표 달성률 : ")
                            Spacer()
                            Text("80%")
                        }
                        Section {
//                            Chart(calendarViewModel.ratingOnWeek) { item in
//                                LineMark(
//                                    x: .value("Day", item.day),
//                                    y: .value("Weight", item.weight)
//                                )
//        //                        .interpolationMethod(.catmullRom)
//        //                        .foregroundStyle(by: .value("Day", item.day))
//                                .symbol {
//                                    Circle()
//                                        .fill(.yellow)
//                                        .frame(width: 10)
//                                        .shadow(radius: 2)
//                                }
//                                .lineStyle(.init(lineWidth: 5))
//        //                                            .lineStyle(StrokeStyle(lineWidth: 10))
//        //                                            .symbol(by: .value("Day", item.day))
//        //                                            .interpolationMethod(.catmullRom)
//        //                                            .interpolationMethod(.stepEnd)
//                                .annotation(position: .overlay, alignment: .top) {
//                                    Text("\(Int(item.weight))")
//                                }
//                            }
//                            .frame(height: 200)
                        }
                        HStack {
                            Text(" - ")
                            Text("적당히 열심히 살자")
                        }
                        Spacer()
                    }
                    .font(.title2)
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
