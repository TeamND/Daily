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
                    SymbolSection()
                }
            }
            ButtonSection()
            Spacer()
            Spacer()
        }
        .padding()
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
                    DailyWeekIndicator(mode: .select)
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
    }
}

// MARK: - TimeSection
struct TimeSection: View {
    var body: some View {
        Text("time")
    }
}

// MARK: - GoalSection
struct GoalSection: View {
    var body: some View {
        Text("goal")
    }
}

// MARK: - CountSection
struct CountSection: View {
    var body: some View {
        Text("count")
    }
}

// MARK: - SymbolSection
struct SymbolSection: View {
    var body: some View {
        Text("Symbol")
    }
}

// MARK: - ButtonSection
struct ButtonSection: View {
    var body: some View {
        HStack {
            Spacer()
            Button {
                print("init")
            } label: {
                Text("초기화")
            }
            Button {
                print("추가")
            } label: {
                Text("추가")
            }
        }
        .tint(Colors.daily) // TODO: 추후 수정
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    DailyGoalView()
}
