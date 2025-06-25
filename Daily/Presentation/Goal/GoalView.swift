//
//  GoalView.swift
//  Daily
//
//  Created by seungyooooong on 10/27/24.
//

import SwiftUI

struct GoalView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var alertEnvironment: AlertEnvironment
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @StateObject var goalViewModel: GoalViewModel
    
    init(goalData: GoalDataModel) {
        _goalViewModel = StateObject(wrappedValue: GoalViewModel(goalData: goalData))
    }
    
    var body: some View {
        ViewThatFits(in: .vertical) {
            goalView
            ScrollView(.vertical, showsIndicators: false) {
                goalView
            }
        }
        .background(Colors.Background.primary)
        .onTapGesture { hideKeyboard() }
    }
    var goalView: some View {
        VStack(spacing: .zero) {
            NavigationHeader(title: "목표추가", trailingText: "추가") {
                goalViewModel.add(
                    successAction: { newDate in
                        dismiss()
                        if let newDate { calendarViewModel.setDate(date: newDate) }
                    },
                    validateAction: { alertEnvironment.showToast(message: $0.messageText) }
                )
            }
            
            Spacer().frame(height: 16)
            
            DailyCycleTypePicker(cycleType: $goalViewModel.goal.cycleType)
            
            Spacer().frame(height: 24)
            
            VStack(spacing: 20) {
                DateSection(goalViewModel: goalViewModel)
                TimeSection(isSetTime: $goalViewModel.goal.isSetTime, setTime: goalViewModel.setTime)
                
                DailyDivider(color: Colors.Border.secondary, height: 1, hPadding: 16)
                
                ContentSection(content: $goalViewModel.goal.content, goalType: $goalViewModel.goal.type)
                SymbolSection(symbol: $goalViewModel.goal.symbol)
                GoalCountSection(goalType: $goalViewModel.goal.type, goalCount: $goalViewModel.goal.count)
            }
            
            Spacer()
        }
    }
}

// MARK: - DateSection
struct DateSection: View {
    @ObservedObject var goalViewModel: GoalViewModel
    
    @State var isShowStartDatePicker: Bool = false
    @State var isShowEndDatePicker: Bool = false
    
    var body: some View {
        VStack(spacing: .zero) {
            switch goalViewModel.goal.cycleType {
            case .date:
                SingleDateSection(date: $goalViewModel.startDate, title: "날짜")
                
            case .rept:
                RepeatTypeSection(repeatType: $goalViewModel.repeatType)
                
                Spacer().frame(height: 16)
                
                switch goalViewModel.repeatType {
                case .weekly:
                    RepeatWeekdayPicker(selectedWeekday: $goalViewModel.selectedWeekday)
                    
                    Spacer().frame(height: 20)
                    
                    SingleDateSection(date: $goalViewModel.startDate, title: "시작일")
                    
                    Spacer().frame(height: 20)
                    
                    SingleDateSection(date: $goalViewModel.endDate, title: "종료일")
                    
                case .custom:
                    DailyMultiDatePicker(dates: $goalViewModel.selectedDates)
                }
            }
        }
        .padding(.horizontal, 16)
        
//        if let modifyType = goalViewModel.modifyType {
//            switch modifyType {
//            case .all:
//                EmptyView()
//            case .record, .single:
//                HStack {
////                    DailyCycleTypePicker(cycleType: Binding(get: { .date }, set: { _ in }), isDisabled: true)
//                    Spacer()
//                    DailyDatePicker(currentDate: $goalViewModel.record.date)
//                }
//            }
//        } else {
//            VStack {
//                HStack {
////                    DailyCycleTypePicker(cycleType: $goalViewModel.goal.cycleType, isDisabled: false)
//                    Spacer()
//                    if goalViewModel.goal.cycleType == .date {
//                        DailyDatePicker(currentDate: $goalViewModel.startDate)
//                    } else if goalViewModel.goal.cycleType == .rept {
//                        DailyWeekIndicator(mode: .select, opacity: $goalViewModel.selectedWeekday)
//                    }
//                }
//                if goalViewModel.goal.cycleType == .rept {
//                    HStack {
//                        DailyDatePicker(currentDate: $goalViewModel.startDate)
//                        Spacer()
//                        Text("~")
//                        Spacer()
//                        DailyDatePicker(currentDate: $goalViewModel.endDate)
//                    }
//                }
//            }
//        }
    }
}

// MARK: - TimeSection
struct TimeSection: View {
    @Binding var isSetTime: Bool
    @Binding var setTime: Date
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text("시간 지정")
                    .font(Fonts.bodyLgSemiBold)
                    .foregroundStyle(Colors.Text.primary)
                
                Spacer()
                
                Toggle("", isOn: $isSetTime)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Colors.Brand.primary))
            }
            
            if isSetTime {
                Spacer().frame(height: 16)
                
                HStack {
                    Spacer()
                    
                    DatePicker("", selection: $setTime, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .tint(Colors.Brand.primary)
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .frame(height: 40)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - ContentSection
struct ContentSection: View {
    @Binding var content: String
    @Binding var goalType: GoalTypes
    @FocusState var focusedField : Int?
    
    var body: some View {
        VStack(spacing: 12) {
            Text("목표")
                .font(Fonts.bodyLgSemiBold)
                .foregroundStyle(Colors.Text.primary)
                .hLeading()
            
            TextField(
                "",
                text: $content,
                prompt: Text("목표를 입력하세요 (최소 2자)")
                    .font(Fonts.bodyLgRegular)
                    .foregroundStyle(Colors.Text.tertiary)
            )
            .font(Fonts.bodyLgMedium)
            .foregroundStyle(Colors.Text.primary)
            .padding(12)
            .background(Colors.Background.secondary)
            .cornerRadius(8)
            .focused($focusedField, equals: 0)
            .onSubmit {
                hideKeyboard()
            }
            .onAppear {
                self.focusedField = 0
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - SymbolSection
struct SymbolSection: View {
    @Binding var selectedSymbol: Symbols
    
    init(symbol: Binding<Symbols>) {
        self._selectedSymbol = symbol
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("심볼 선택")
                .font(Fonts.bodyLgSemiBold)
                .foregroundStyle(Colors.Text.primary)
                .hLeading()
            
            VStack(spacing: 12) {
                ForEach(0 ..< 2) { row in
                    HStack {
                        ForEach(Array(Symbols.allCases.filter { $0 != .all }.enumerated()), id: \.element) { index, symbol in
                            if row * 5 <= index && index < (row + 1) * 5 {
                                if row * 5 < index { Spacer() }
                                Image(symbol.icon(isSuccess: selectedSymbol == symbol))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32)
                                    .background {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Colors.Background.secondary)
                                            .stroke(selectedSymbol == symbol ? Colors.Brand.primary : .clear, lineWidth: 1)
                                            .frame(width: 48, height: 48)
                                    }
                                    .frame(width: 48, height: 48)
                                    .onTapGesture {
                                        selectedSymbol = symbol
                                    }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - GoalCountSection
struct GoalCountSection: View {
    @EnvironmentObject var alertEnvironment: AlertEnvironment
    @Binding var goalType: GoalTypes
    @Binding var goalCount: Int
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("진행 방식")
                    .font(Fonts.bodyLgSemiBold)
                    .foregroundStyle(Colors.Text.primary)
                
                Spacer()
                
                HStack(spacing: .zero) {
                    ForEach([GoalTypes.count, GoalTypes.timer], id: \.self) { type in
                        Button {
                            goalType = type
                        } label: {
                            Text(type.text)
                                .font(Fonts.bodyMdSemiBold)
                                .foregroundStyle(goalType == type ? Colors.Text.point : Colors.Text.tertiary)
                        }
                        .frame(width: 60, height: 30)
                        .background {
                            RoundedRectangle(cornerRadius: 99)
                                .fill(goalType == type ? Colors.Background.primary : .clear)
                                .stroke(goalType == type ? Colors.Brand.primary : .clear, lineWidth: 1)
                        }
                    }
                }
                .padding(4)
                .background {
                    RoundedRectangle(cornerRadius: 99)
                        .fill(Colors.Background.secondary)
                }
            }
            
            HStack(spacing: 4) {
                Spacer()
                
                Button {
                    print("goalCount is \(goalCount)")
                    // TODO: Picker 추가
                } label: {
                    Text("\(goalCount)")
                        .font(Fonts.bodyLgMedium)
                        .foregroundStyle(Colors.Text.point)
                        .frame(width: 58, height: 40)
                        .background(Colors.Background.secondary)
                        .cornerRadius(8)
                }
//                .overlay {
//                    if
//                }
                
                Text("회 반복")
                    .font(Fonts.bodyLgMedium)
                    .foregroundStyle(Colors.Text.secondary)
            }
        }
        .padding(.horizontal, 16)
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

// MARK: - ButtonSection
struct ButtonSection: View {
    @Environment(\.dismiss) var dismiss
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
                        successAction: {
                            dismiss()
                            if let newDate = $0 { calendarViewModel.setDate(date: newDate) }
                        },
                        validateAction: { alertEnvironment.showToast(message: $0.messageText) }
                    )
                case .modify:
                    goalViewModel.modify(
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
