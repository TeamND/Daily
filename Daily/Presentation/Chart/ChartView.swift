//
//  ChartView.swift
//  Daily
//
//  Created by seungyooooong on 5/3/25.
//

import SwiftUI

struct ChartView: View {
    @StateObject private var chartViewModel = ChartViewModel()
    
    var body: some View {
        VStack(spacing: .zero) {
            NavigationHeader(title: "통계")
            Spacer().frame(height: 16)
            
            HStack(spacing: .zero) {
                ForEach(CalendarTypes.allCases.filter { $0 != .week }, id: \.self) { type in
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
            Spacer().frame(height: 32)
            
            HStack(spacing: .zero) {
                VStack(spacing: 4) {
                    Text("전체")
                        .font(Fonts.bodyMdRegular)
                        .foregroundStyle(Colors.Text.secondary)
                    Text("50개")
                        .font(Fonts.headingMdBold)
                        .foregroundStyle(Colors.Text.point)
                }
                .frame(maxWidth: .infinity)
//                DailyDivider(color: Colors.Border.primary)
//                    .frame(width: 1)
//                    .frame(maxHeight: .infinity)
                VStack(spacing: 4) {
                    Text("완료")
                        .font(Fonts.bodyMdRegular)
                        .foregroundStyle(Colors.Text.secondary)
                    Text("0개")
                        .font(Fonts.headingMdBold)
                        .foregroundStyle(Colors.Text.point)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 16)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.Background.secondary)
            }
            
            Spacer().frame(height: 24)
            
            SymbolFilter(type: chartViewModel.type)
                .padding(.horizontal, -16)
            
            Spacer().frame(height: 16)
            
            Rectangle().fill(Colors.Background.secondary).frame(maxWidth: .infinity).frame(height: 371)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Colors.Background.primary)
    }
}
