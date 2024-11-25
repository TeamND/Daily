//
//  DailyGoalView.swift
//  Daily
//
//  Created by seungyooooong on 10/27/24.
//

import SwiftUI

struct DailyGoalView: View {
    @StateObject var dailyGoalViewModel: DailyGoalViewModel = DailyGoalViewModel()
    
    var body: some View {
        VStack(spacing: .zero) {
            DailyNavigationBar(title: "목표추가")
            VStack(spacing: .zero) {
                Spacer()
                DailySection(type: .date) {
                    DateSection(dailyGoalViewModel: dailyGoalViewModel)
                }
                DailySection(type: .time) {
                    TimeSection()
                }
                DailySection(type: .content, essentialConditions: false) {
                    GoalSection()
                }
                HStack {
                    DailySection(type: .count) {
                        CountSection()
                    }
                    DailySection(type: .symbol) {
                        SymbolSection(symbol: $dailyGoalViewModel.symbol)
                    }
                }
                ButtonSection(dailyGoalViewModel: dailyGoalViewModel)
                Spacer()
                Spacer()
            }
            .padding()
        }
        .background(Colors.theme)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

// MARK: - DateSection
struct DateSection: View {
    @ObservedObject var dailyGoalViewModel: DailyGoalViewModel
    @Namespace var ns
    @State var opacity: [Double] = Array(repeating: 0, count: 7)
    
    var body: some View {
        VStack {
            HStack {
                DailyCycleTypePicker(cycleType: $dailyGoalViewModel.cycleType)
                Spacer()
                if dailyGoalViewModel.cycleType == .date {
                    DailyDatePicker(currentDate: .constant(Date()))
                        .matchedGeometryEffect(id: "start_date", in: ns)
                        .matchedGeometryEffect(id: "end_date", in: ns)
                } else if dailyGoalViewModel.cycleType == .rept {
                    DailyWeekIndicator(mode: .select, opacity: $opacity)
                }
            }
            if dailyGoalViewModel.cycleType == .rept {
                HStack {
                    DailyDatePicker(currentDate: .constant(Date()))
                        .matchedGeometryEffect(id: "start_date", in: ns)
                    Spacer()
                    Text("~")
                    Spacer()
                    DailyDatePicker(currentDate: .constant(Date()))
                        .matchedGeometryEffect(id: "end_date", in: ns)
                }
            }
        }
        .onAppear {
            for item in dailyGoalViewModel.cycleDate {
                if let dowIndex = Int(item) {
                    opacity[dowIndex] = 0.8
                }
            }
        }
    }
}

// MARK: - TimeSection
struct TimeSection: View {
    var body: some View {
        HStack {
            Text("하루 종일")
                .opacity(false ? 0.5 : 1)
            Spacer()
            Toggle("", isOn: .constant(false))
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Colors.daily))
                .scaleEffect(CGSize(width: 0.9, height: 0.9))
            Spacer()
            DatePicker("", selection: .constant(Date()), displayedComponents: [.hourAndMinute])
                .datePickerStyle(.compact)
                .disabled(true)
                .labelsHidden()
                .opacity(false ? 1 : 0.5)
                .scaleEffect(CGSize(width: 0.9, height: 0.9))
                .frame(height: CGFloat.fontSize * 4)
        }
        .font(.system(size: CGFloat.fontSize * 2.5))
    }
}

// MARK: - GoalSection
struct GoalSection: View {
    var body: some View {
        ContentTextField(content: .constant(""), type: .constant("check"))
    }
}

// MARK: - CountSection
struct CountSection: View {
    var body: some View {
        GoalCountPickerGroup(type: .constant("check"), count: .constant(1), time: .constant(0), isShowAlert: .constant(false))
    }
}

// MARK: - SymbolSection
struct SymbolSection: View {
    @Binding var symbol: Symbols
    @State var isShowSymbolSheet: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "\(symbol.imageName)")
            Image(systemName: "chevron.right")
                .frame(width: CGFloat.fontSize * 10)
            Image(systemName: "\(symbol.imageName).fill")
            Spacer()
        }
        .onTapGesture {
            isShowSymbolSheet = true
        }
        .sheet(isPresented: $isShowSymbolSheet) {
            SymbolsSheet(symbol: $symbol)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }

    }
}

// MARK: - ButtonSection
struct ButtonSection: View {
    @ObservedObject var dailyGoalViewModel: DailyGoalViewModel
    
    var body: some View {
        HStack {
            Spacer()
            DailyButton(action: {
                dailyGoalViewModel.reset()
            }, text: "초기화")
            DailyButton(action: {
                dailyGoalViewModel.add()
            }, text: "추가")
        }
        .padding(.top, CGFloat.fontSize)
    }
}

#Preview {
    DailyGoalView()
}
