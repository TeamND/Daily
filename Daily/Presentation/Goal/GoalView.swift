//
//  GoalView.swift
//  Daily
//
//  Created by seungyooooong on 10/27/24.
//

import SwiftUI
import SwiftData

struct GoalView: View {
    @StateObject var goalViewModel: GoalViewModel
    
    init(goalData: GoalDataModel) {
        _goalViewModel = StateObject(wrappedValue: GoalViewModel(goalData: goalData))
    }
    
    var body: some View {
        VStack {
            DailyNavigationBar(title: "목표추가")
            VStack(spacing: .zero) {
                Spacer()
                DailySection(type: .date) {
                    DateSection(goalViewModel: goalViewModel)
                }
                DailySection(type: .time) {
                    TimeSection(isSetTime: $goalViewModel.isSetTime, setTime: $goalViewModel.setTime)
                }
                DailySection(type: .content, essentialConditions: goalViewModel.content.count >= 2) {
                    ContentSection(content: $goalViewModel.content, goalType: $goalViewModel.goalType)
                }
                HStack {
                    DailySection(type: .goalCount) {
                        GoalCountSection(
                            goalType: $goalViewModel.goalType,
                            goalCount: $goalViewModel.goalCount
                        )
                    }
                    DailySection(type: .symbol) {
                        SymbolSection(symbol: $goalViewModel.symbol)
                    }
                }
                ButtonSection(goalViewModel: goalViewModel, buttonType: .add)
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
    @ObservedObject var goalViewModel: GoalViewModel
    private let isModify: Bool
    @Namespace var ns
    @State var opacity: [Double] = Array(repeating: 0, count: 7)
    
    init(goalViewModel: GoalViewModel, isModify: Bool = false) {
        self.goalViewModel = goalViewModel
        self.isModify = isModify
    }
    
    var body: some View {
        if let modifyType = goalViewModel.modifyType, modifyType == .all { EmptyView() }
        else {
            VStack {
                HStack {
                    DailyCycleTypePicker(cycleType: $goalViewModel.cycleType, isModify: isModify)
                    Spacer()
                    if goalViewModel.cycleType == .date {
                        DailyDatePicker(currentDate: $goalViewModel.startDate)
                            .matchedGeometryEffect(id: "start_date", in: ns)
                            .matchedGeometryEffect(id: "end_date", in: ns)
                    } else if goalViewModel.cycleType == .rept {
                        DailyWeekIndicator(mode: .select, opacity: $opacity)
                    }
                }
                if goalViewModel.cycleType == .rept {
                    HStack {
                        DailyDatePicker(currentDate: $goalViewModel.startDate)
                            .matchedGeometryEffect(id: "start_date", in: ns)
                        Spacer()
                        Text("~")
                        Spacer()
                        DailyDatePicker(currentDate: $goalViewModel.endDate)
                            .matchedGeometryEffect(id: "end_date", in: ns)
                    }
                }
            }
            .onChange(of: opacity) { _, opacity in
                goalViewModel.selectedWeekday = opacity.enumerated().compactMap { $1 == 0.8 ? $0 + 1 : nil }
            }
        }
    }
}

// MARK: - TimeSection
struct TimeSection: View {
    @Binding var isSetTime: Bool
    @Binding var setTime: Date
    
    var body: some View {
        HStack {
            Text("하루 종일")
                .opacity(isSetTime ? 0.5 : 1)
            Spacer()
            Toggle("", isOn: $isSetTime)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Colors.daily))
                .scaleEffect(CGSize(width: 0.9, height: 0.9))
            Spacer()
            DatePicker("", selection: $setTime, displayedComponents: [.hourAndMinute])
                .datePickerStyle(.compact)
                .disabled(!isSetTime)
                .labelsHidden()
                .opacity(isSetTime ? 1 : 0.5)
                .scaleEffect(CGSize(width: 0.9, height: 0.9))
                .frame(height: CGFloat.fontSize * 4)
        }
        .font(.system(size: CGFloat.fontSize * 2.5))
    }
}

// MARK: - ContentSection
struct ContentSection: View {
    @Binding var content: String
    @Binding var goalType: GoalTypes
    @FocusState var focusedField : Int?
    
    var body: some View {
        TextField(
            "",
            text: $content,
            prompt: Text(contentOfGoalHintText(type: goalType.rawValue))
        )
        .focused($focusedField, equals: 0)
        .onSubmit {
            hideKeyboard()
        }
        .onAppear {
            self.focusedField = 0
        }
    }
}

// MARK: - GoalCountSection
struct GoalCountSection: View {
    @EnvironmentObject var alertEnvironment: AlertEnvironment
    @Binding var goalType: GoalTypes
    @Binding var goalCount: Int
    @State var isShowAlert: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            if goalType == .timer {
                // TODO: 추후 타이머 추가
            } else {
                countButton(direction: .minus)
                Text("\(goalCount)")
                    .frame(width: CGFloat.fontSize * 10)
                countButton(direction: .plus)
            }
            Spacer()
        }
    }
    
    private func countButton(direction: Direction) -> some View {
        Button {
            let afterCount = goalCount + direction.value
            if afterCount < GeneralServices.minimumGoalCount ||
                afterCount > GeneralServices.maximumGoalCount {
                alertEnvironment.showToast(message: countRangeToastMessageText)
            } else {
                goalCount = afterCount
                goalType = goalCount == 1 ? .check : .count
            }
        } label: {
            Image(systemName: direction.imageName)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - CountSection
struct CountSection: View {
    @Binding var recordCount: Int
    @Binding var goalCount: Int
    
    var body: some View {
        HStack {
            Menu {
                ForEach(0 ... goalCount, id: \.self) { count in
                    Button {
                        recordCount = count
                    } label: {
                        Text("\(count)")
                    }
                }
            } label: {
                Text("\(recordCount)")
                    .frame(maxWidth: .infinity)
            }
            Text("/")
            Menu {
                ForEach(1 ... 10, id: \.self) { count in
                    Button {
                        goalCount = count
                        if recordCount > goalCount {
                            recordCount = count
                        }
                    } label: {
                        Text("\(count)")
                    }
                }
            } label: {
                Text("\(goalCount)")
                    .frame(maxWidth: .infinity)
            }
        }
        .foregroundStyle(Colors.reverse)
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
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var alertEnvironment: AlertEnvironment
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @ObservedObject var goalViewModel: GoalViewModel
    let buttonType: ButtonTypes
    
    var body: some View {
        HStack {
            Spacer()
            DailyButton(action: {
                goalViewModel.reset()
            }, text: "초기화")
            DailyButton(action: {
                switch buttonType {
                case .add:
                    goalViewModel.add(
                        modelContext: modelContext,
                        successAction: {
                            dismiss()
                            if let newDate = $0 { calendarViewModel.setDate(date: newDate) }
                        },
                        validateAction: { alertEnvironment.showToast(message: $0.messageText) }
                    )
                case .modify:
                    goalViewModel.modify(
                        modelContext: modelContext,
                        successAction: {
                            dismiss()
                            if let newDate = $0 { calendarViewModel.setDate(date: newDate) }
                        },
                        validateAction: { alertEnvironment.showToast(message: $0.messageText) }
                    )
                }
            }, text: buttonType.text)
        }
        .padding(.top, CGFloat.fontSize)
    }
}
