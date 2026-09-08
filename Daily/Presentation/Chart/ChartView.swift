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
            NavigationHeader(title: "stats".localized)
            Spacer().frame(height: 16)
            
            DailySegment(
                segmentType: .header,
                currentType: $chartViewModel.type,
                types: CalendarTypes.allCases.reversed()
            ) {
                chartViewModel.setType(type: $0)
                
                AnalyticsManager.shared.log(.changeStatisticsType, .statistics_type($0.statisticsType))
            }.padding(.horizontal, 16)
            Spacer().frame(height: 24)
            
            summaryIndicator.padding(.horizontal, 16)
            Spacer().frame(height: 32)
            
            SymbolFilter(chartViewModel: chartViewModel)
            Spacer().frame(height: 24)
            
            chartView.padding(.horizontal, 16)
            Spacer()
        }
        .background(Colors.Background.primary)
        .onAppear {
            chartViewModel.onAppear(navigationPath: navigationEnvironment.navigationPath, filter: calendarViewModel.filter)
            
            AnalyticsManager.shared.log(.openStatistics)
        }
    }
    
    private var summaryIndicator: some View {
        HStack(spacing: .zero) {
            VStack(spacing: 4) {
                Text("total_goals".localized)
                    .font(Fonts.bodyMdRegular)
                    .foregroundStyle(Colors.Text.secondary)
                Text("count_unit".localized(chartViewModel.totalCount))
                    .font(Fonts.headingMdBold)
                    .foregroundStyle(Colors.Text.point)
            }
            .frame(maxWidth: .infinity)
            
            Rectangle().fill(Colors.Border.primary).frame(width: 1, height: 44)
            
            VStack(spacing: 4) {
                Text("completed".localized)
                    .font(Fonts.bodyMdRegular)
                    .foregroundStyle(Colors.Text.secondary)
                Text("count_unit".localized(chartViewModel.successCount))
                    .font(Fonts.headingMdBold)
                    .foregroundStyle(Colors.Text.point)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 12)
        .background(Colors.Background.secondary)
        .cornerRadius(8)
    }
    
    private var chartView: some View {
        VStack(spacing: .zero) {
            Chart {
                ForEach([25.0, 50.0, 75.0], id: \.self) { y in
                    RuleMark(y: .value("Y", y))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundStyle(Colors.Border.primary)
                }
                
                ForEach(chartViewModel.chartDatas) { data in
                    BarMark(
                        x: .value("", data.unit.string),
                        y: .value("Rating", data.rating ?? 0.0) // TODO: 추후 y축 애니메이션을 고려
                    )
                    .cornerRadius(8, style: .continuous)
                    .annotation(position: .top, alignment: .center) {
                        Text(data.rating?.percentFormat() ?? "0%")
                            .font(Fonts.bodySmRegular)
                            .foregroundStyle(Colors.Text.tertiary)
                    }
                }
            }
            .animation(
                chartViewModel.isAnimationYet ? nil : .easeInOut(duration: 1),
                value: chartViewModel.chartDatas.map { $0.rating }
            )
            .chartXAxis(.hidden)
            .chartYScale(domain: 0 ... 100)
            .chartYAxisStyle { style in
                style
                    .font(Fonts.bodySmRegular)
                    .foregroundStyle(Colors.Text.tertiary)
            }
            .chartPlotStyle { plotArea in
                plotArea
                    .background(Colors.Background.primary)
                    .border(Colors.Border.primary, width: 1)
            }
            .foregroundStyle(Colors.Brand.primary)
            .frame(height: 277)
            
            Spacer().frame(height: 10)
            
            chartXAxis
        }
    }
    
    private var chartXAxis: some View {
        HStack(alignment: .top, spacing: .zero) {
            ForEach(chartViewModel.chartDatas) { data in
                VStack(spacing: 3) {
                    let todayWeekday = DayOfWeek.txt(for: Date().weekday - 1) ?? ""
                    let todayString = Date().toString(format: chartViewModel.type.dateFormat)
                    
                    if chartViewModel.type == .day {
                        Text(data.unit.weekday)
                            .font(Fonts.bodyMdSemiBold)
                            .foregroundStyle(
                                data.unit.weekday == todayWeekday ? Colors.Text.point :
                                    data.rating == nil ? Colors.Text.tertiary : Colors.Text.primary
                            )
                    }
                    
                    Text(data.unit.string)
                        .font(data.unit.string == todayString ? Fonts.bodyMdSemiBold : Fonts.bodySmRegular)
                        .foregroundStyle(
                            data.unit.string == todayString ? Colors.Text.point :
                                data.rating == nil ? Colors.Text.tertiary : Colors.Text.secondary
                        )
                    
                    if data.isNow {
                        Image(.commentTail)
                            .resizable()
                            .frame(width: 14, height: 14)
                            .padding(.bottom, -5)
                        Text(chartViewModel.type.chartUnit)
                            .font(Fonts.bodyMdSemiBold)
                            .foregroundStyle(Colors.Text.inverse)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 4)
                            .frame(width: 45)
                            .background(Colors.Icon.interactivePressed)
                            .cornerRadius(8)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.trailing, 25)
        .animation(.easeInOut(duration: 0.3), value: chartViewModel.chartDatas.map { $0.unit.string })
    }
}
