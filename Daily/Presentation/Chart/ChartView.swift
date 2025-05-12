//
//  ChartView.swift
//  Daily
//
//  Created by seungyooooong on 5/3/25.
//

import SwiftUI
import Charts

struct ChartView: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    @StateObject private var chartViewModel = ChartViewModel()
    
    var body: some View {
        VStack(spacing: .zero) {
            NavigationHeader(title: "통계")
            Spacer().frame(height: 16)
            
            typeIndicator.padding(.horizontal, 16)
            Spacer().frame(height: 24)
            
            summaryIndicator.padding(.horizontal, 16)
            Spacer().frame(height: 32)
            
            SymbolFilter(type: chartViewModel.type)
            Spacer().frame(height: 24)
            
            chartView.padding(.horizontal, 16)
            Spacer()
        }
        .background(Colors.Background.primary)
        .onAppear {
            chartViewModel.onAppear(navigationPath: navigationEnvironment.navigationPath)
        }
    }
    
    private var typeIndicator: some View {
        HStack(spacing: .zero) {
            ForEach(CalendarTypes.allCases.reversed(), id: \.self) { type in
                Button {
                    chartViewModel.type = type
                } label: {
                    Text(type.text)
                        .font(Fonts.bodyLgSemiBold)
                        .foregroundStyle(type == chartViewModel.type ? Colors.Text.inverse : Colors.Text.secondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 34)
                .background {
                    RoundedRectangle(cornerRadius: 99)
                        .fill(type == chartViewModel.type ? Colors.Brand.primary : .clear)
                }
            }
        }
        .padding(2)
        .background {
            RoundedRectangle(cornerRadius: 99)
                .fill(Colors.Background.secondary)
        }
    }
    
    private var summaryIndicator: some View {
        HStack(spacing: .zero) {
            VStack(spacing: 4) {
                Text("전체")
                    .font(Fonts.bodyMdRegular)
                    .foregroundStyle(Colors.Text.secondary)
                Text("\(chartViewModel.totalCount)개")
                    .font(Fonts.headingMdBold)
                    .foregroundStyle(Colors.Text.point)
            }
            .frame(maxWidth: .infinity)
            Rectangle().fill(Colors.Border.primary).frame(width: 1, height: 44)
            VStack(spacing: 4) {
                Text("완료")
                    .font(Fonts.bodyMdRegular)
                    .foregroundStyle(Colors.Text.secondary)
                Text("\(chartViewModel.successCount)개")
                    .font(Fonts.headingMdBold)
                    .foregroundStyle(Colors.Text.point)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Colors.Background.secondary)
        }
    }
    
    private var chartView: some View {
        VStack(spacing: .zero) {
            Chart {
                ForEach(calendarViewModel.weekData["2025-05-11"]!.ratingsForChart) { data in
                    BarMark(
                        x: .value("Day", data.day),
                        y: .value("Rating", data.rating)
                    )
                    .annotation(position: .top, alignment: .center) {
                        let isLeadingPosition = data.day == "일" || data.day == "월" || data.day == "화"
                        let isSameRating = Int(round(data.rating)) == calendarViewModel.weekData["2025-05-11"]!.ratingOfWeek
                        let isNotZero = calendarViewModel.weekData["2025-05-11"]!.ratingOfWeek != 0
                        if isLeadingPosition && isSameRating && isNotZero {
                            EmptyView()
                        } else {
                            Text(data.rating.percentFormat())
                                .font(.system(size: CGFloat.fontSize * 1.5))
                        }
                    }
//                    if weekData.ratingOfWeek > 0 {
//                        RuleMark(y: .value("RatingOfWeek", weekData.ratingOfWeek))
//                            .lineStyle(StrokeStyle(lineWidth: 2))
//                            .annotation(position: .top, alignment: .leading) {
//                                Text(" 주간 달성률 : \(weekData.ratingOfWeek)%")
//                                    .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
//                            }
//                    }
                }
            }
            .chartYScale(domain: 0 ... 100)
            .foregroundStyle(Colors.Brand.primary)
            .frame(height: 326)
            Spacer().frame(height: 3)
            
            Image(.commentTail)
                .resizable()
                .frame(width: 14, height: 14)
                .padding(.bottom, -5)
            Text(chartViewModel.type.chartUnit)
                .font(Fonts.bodyMdSemiBold)
                .foregroundStyle(Colors.Text.inverse)
                .padding(.vertical, 4)
                .frame(width: 45)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Colors.Icon.interactivePressed)
                }
        }
        
    }
}
