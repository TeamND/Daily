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
        VStack(spacing: .zero) {
            NavigationHeader(title: "목표 추가", trailingText: "추가") {
                goalViewModel.add(
                    successAction: { newDate in
                        dismiss()
                        if let newDate { calendarViewModel.setDate(date: newDate) }
                    },
                    validateAction: { alertEnvironment.showToast(message: $0.messageText) }
                )
            }
            
            ViewThatFits(in: .vertical) {
                goalView
                ScrollView(.vertical, showsIndicators: false) {
                    goalView
                }
            }
        }
        .background(Colors.Background.primary)
    }
    
    var goalView: some View {
        VStack(spacing: .zero) {
            Spacer().frame(height: 16)
            
            DailyCycleTypePicker(cycleType: $goalViewModel.goal.cycleType)
            
            Spacer().frame(height: 24)
            
            VStack(spacing: 20) {
                DateSection(goalViewModel: goalViewModel)
                TimeSection(goalViewModel: goalViewModel)
                
                DailyDivider(color: Colors.Border.secondary, height: 1, hPadding: 16)
                
                ContentSection(content: $goalViewModel.goal.content, goalType: $goalViewModel.goal.type)
                SymbolSection(symbol: $goalViewModel.goal.symbol)
                GoalCountSection(goalViewModel: goalViewModel)
            }
            
            Spacer()
        }
        .coordinateSpace(name: "goalView")
        .background(Colors.Background.primary)
        .onTapGesture { hideKeyboard() }
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    goalViewModel.hidePopover()
                }
        )
        .overlay {
            if let content = goalViewModel.popoverContent {
                DailyPopover(position: goalViewModel.popoverPosition) { content }
            }
        }
    }
}

// MARK: - DateSection
struct DateSection: View {
    @ObservedObject var goalViewModel: GoalViewModel
    
    @State var isShowSingleDatePicker: Bool = false
    @State var isShowStartDatePicker: Bool = false
    @State var isShowEndDatePicker: Bool = false
    
    var body: some View {
        VStack(spacing: .zero) {
            switch goalViewModel.goal.cycleType {
            case .date:
                SingleDateSection(title: "날짜", date: $goalViewModel.startDate, isShowDatePicker: $isShowSingleDatePicker)
                
            case .rept:
                RepeatTypeSection(goalViewModel: goalViewModel)
                
                Spacer().frame(height: 16)
                
                switch goalViewModel.repeatType {
                case .weekly:
                    VStack(spacing: 20) {
                        RepeatWeekdayPicker(selectedWeekday: $goalViewModel.selectedWeekday)
                        SingleDateSection(title: "시작일", date: $goalViewModel.startDate, isShowDatePicker: $isShowStartDatePicker) {
                            isShowEndDatePicker = false
                        }
                        SingleDateSection(title: "종료일", date: $goalViewModel.endDate, isShowDatePicker: $isShowEndDatePicker) {
                            isShowStartDatePicker = false
                        }
                    }
                    
                case .custom:
                    DailyMultiDatePicker(dates: $goalViewModel.selectedDates)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - TimeSection
struct TimeSection: View {
    @ObservedObject var goalViewModel: GoalViewModel
    
    @State private var buttonFrame: CGRect = .zero
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text("시간 지정")
                    .font(Fonts.bodyLgSemiBold)
                    .foregroundStyle(Colors.Text.primary)
                
                Spacer()
                
                Toggle("", isOn: $goalViewModel.goal.isSetTime)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Colors.Brand.primary))
            }
            
            if goalViewModel.goal.isSetTime {
                Spacer().frame(height: 16)
                
                HStack {
                    Spacer()
                    
                    Button {
                        let offsetX = buttonFrame.width - 210 / 2
                        let offsetY = buttonFrame.height * 2 + 4    // ???: 왜 4인지 모르겠다
                        
                        let position = CGPoint(
                            x: buttonFrame.minX + offsetX,
                            y: buttonFrame.minY + offsetY + 60
                        )
                        
                        if goalViewModel.popoverContent != nil {
                            goalViewModel.hidePopover()
                        } else {
                            goalViewModel.showPopover(at: position) {
                                // FIXME: custom picker 두개로 수정
                                DatePicker("",
                                           selection: Binding(
                                             get: { goalViewModel.goal.setTime.toDate(format: .setTime) ?? Date(format: .daily) },
                                             set: { goalViewModel.goal.setTime = $0.toString(format: .setTime) }
                                           ), displayedComponents: [.hourAndMinute]
                                )
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                .scaleEffect(CGSize(width: 0.8, height: 0.8))
                                .frame(maxWidth: 210, maxHeight: 186)
                            }
                        }
                    } label: {
                        Text(goalViewModel.goal.setTime)
                            .font(Fonts.bodyLgMedium)
                            .foregroundStyle(Colors.Text.point)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Colors.Background.secondary)
                            .cornerRadius(8)
                    }
                    .getFrame { buttonFrame = $0 }
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
    
    @ObservedObject var goalViewModel: GoalViewModel
    
    @State private var buttonFrame: CGRect = .zero
    
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
                            goalViewModel.goal.type = type
                        } label: {
                            Text(type.text)
                                .font(Fonts.bodyMdSemiBold)
                                .foregroundStyle(goalViewModel.goal.type == type ? Colors.Text.point : Colors.Text.tertiary)
                        }
                        .frame(width: 60, height: 30)
                        .background {
                            RoundedRectangle(cornerRadius: 99)
                                .fill(goalViewModel.goal.type == type ? Colors.Background.primary : .clear)
                                .stroke(goalViewModel.goal.type == type ? Colors.Brand.primary : .clear, lineWidth: 1)
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
                    let offsetX = CGFloat(121 / 2 + 12)
                    let offsetY = buttonFrame.height / 2 + 174 / 2
                    
                    let position = CGPoint(
                        x: buttonFrame.minX - offsetX,
                        y: buttonFrame.minY - offsetY + 60
                    )
                    
                    if goalViewModel.popoverContent != nil {
                        goalViewModel.hidePopover()
                    } else {
                        goalViewModel.showPopover(at: position) {
                            Picker("", selection: $goalViewModel.goal.count) {
                                ForEach(1 ... 10, id: \.self) { count in
                                    Text("\(count)")
                                        .tag(count)
                                        .font(Fonts.bodyXlMedium)
                                        .foregroundStyle(Colors.Text.secondary)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(maxWidth: 121, maxHeight: 174)
                        }
                    }
                } label: {
                    Text("\(goalViewModel.goal.count)")
                        .font(Fonts.bodyLgMedium)
                        .foregroundStyle(Colors.Text.point)
                        .frame(width: 58, height: 40)
                        .background(Colors.Background.secondary)
                        .cornerRadius(8)
                }
                .getFrame { buttonFrame = $0 }
                
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
