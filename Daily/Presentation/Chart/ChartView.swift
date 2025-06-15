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
            
            SymbolFilter(chartViewModel: chartViewModel)
            Spacer().frame(height: 24)
            
            chartView.padding(.horizontal, 16)
            Spacer()
        }
        .background(Colors.Background.primary)
        .onAppear {
            chartViewModel.onAppear(navigationPath: navigationEnvironment.navigationPath, filter: calendarViewModel.filter)
        }
    }
    
    private var typeIndicator: some View {
        HStack(spacing: .zero) {
            ForEach(CalendarTypes.allCases.reversed(), id: \.self) { type in
                Button {
                    chartViewModel.setType(type: type)
                } label: {
                    Text(type.text)
                        .font(Fonts.bodyLgSemiBold)
                        .foregroundStyle(type == chartViewModel.type ? Colors.Text.inverse : Colors.Text.secondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 34)
                        .background {
                            RoundedRectangle(cornerRadius: 99)
                                .fill(type == chartViewModel.type ? Colors.Brand.primary : .clear)
                        }
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
                    let todayWeekday = DayOfWeek.text(for: Date().weekday - 1) ?? ""
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
                            .padding(.vertical, 4)
                            .frame(width: 45)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Colors.Icon.interactivePressed)
                            }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.trailing, 25)
    }
    
}
