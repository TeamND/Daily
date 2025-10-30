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
    
    private let viewType: ViewTypes
    
    init(goalData: GoalDataEntity, viewType: ViewTypes) {
        _goalViewModel = StateObject(wrappedValue: GoalViewModel(goalData: goalData))
        self.viewType = viewType
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            headerView
            
            ScrollView(.vertical, showsIndicators: false) {
                goalView
            }
        }
        .background(Colors.Background.primary)
    }
    
    var headerView: some View {
        NavigationHeader(title: viewType.headerTitle, trailingText: viewType.trailingText) {
            if viewType == .goal {
                goalViewModel.add(successAction: successAction, validateAction: validateAction)
            } else {
                goalViewModel.modify(successAction: successAction, validateAction: validateAction)
            }
        }
    }
    
    private func successAction(newDate: Date?) {
        dismiss()
        if let newDate { calendarViewModel.setDate(date: newDate) }
    }
    
    private func validateAction(alert: DailyAlert) {
        alertEnvironment.showToast(message: alert.messageText)
    }
    
    var goalView: some View {
        VStack(spacing: .zero) {
            Spacer().frame(height: 16)

            if viewType == .goal {
                DailySegment(
                    segmentType: .header,
                    currentType: $goalViewModel.goal.cycleType,    // FIXME: 추후 수정
                    types: CycleTypes.allCases
                ) { cycleType in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        goalViewModel.goal.cycleType = cycleType
                    }
                }.padding(.horizontal, 16)
                Spacer().frame(height: 24)
            }
            
            VStack(spacing: 20) {
                if viewType == .goal || (viewType == .modify && goalViewModel.modifyType != .all) {
                    DateSection(goalViewModel: goalViewModel)
                }
                TimeSection(goalViewModel: goalViewModel)
                
                DailyDivider(color: Colors.Border.secondary, height: 1, hPadding: 16)
                
                ContentSection(content: $goalViewModel.goal.content)
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
            if let modifyType = goalViewModel.modifyType, modifyType != .all {
                SingleDateSection(title: "날짜", date: $goalViewModel.record.date, isShowDatePicker: $isShowSingleDatePicker)
            } else if goalViewModel.modifyType == nil, let cycleType = goalViewModel.goal.cycleType {
                switch cycleType {
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
            } else {
                // FIXME: 추후 수정
                Text("🚧🚧 예상치 못한 문제가 발생했습니다.")
                    .font(Fonts.bodyLgSemiBold)
                    .foregroundStyle(Colors.Text.primary)
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - TimeSection
struct TimeSection: View {
    @EnvironmentObject private var alertEnvironment: AlertEnvironment
    
    @ObservedObject var goalViewModel: GoalViewModel
    
    @State private var buttonFrame: CGRect = .zero
    @State private var HH: Int = 0
    @State private var mm: Int = 0
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text("시간 지정")
                    .font(Fonts.bodyLgSemiBold)
                    .foregroundStyle(Colors.Text.primary)
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { goalViewModel.goal.isSetTime },
                    set: { newValue in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            goalViewModel.goal.isSetTime = newValue
                        }
                    }
                ))
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Colors.Brand.primary))
                .onChange(of: goalViewModel.goal.isSetTime) {
                    if $1 {
                        PushNoticeManager.shared.requestNotiAuthorization(
                            showAlert: alertEnvironment.showAlert, alertType: .deniedAtSetTime
                        )
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if alertEnvironment.isShowAlert {
                                goalViewModel.goal.isSetTime = false
                            }
                        }
                    }
                }
            }
            
            if goalViewModel.goal.isSetTime {
                Spacer().frame(height: 16)
                
                HStack {
                    Spacer()
                    
                    Button {
                        let width: CGFloat = 190
                        let height: CGFloat = 176
                        
                        let offsetX = buttonFrame.width - width / 2
                        let offsetY = buttonFrame.height * 2 + 4    // ???: 왜 4인지 모르겠다
                        
                        let position = CGPoint(
                            x: buttonFrame.minX + offsetX,
                            y: buttonFrame.minY + offsetY + 60
                        )
                        
                        if goalViewModel.popoverContent != nil {
                            goalViewModel.hidePopover()
                        } else {
                            goalViewModel.showPopover(at: position) {
                                HStack(spacing: 8) {
                                    DailyPicker(range: 0 ..< 24, selection: $HH) {
                                        guard let oldSetTime = goalViewModel.goal.setTime.toDate(format: .setTime),
                                              let newSetTime = Calendar.current.date(
                                                bySettingHour: $0,
                                                minute: Calendar.current.component(.minute, from: oldSetTime),
                                                second: 0,
                                                of: oldSetTime
                                              ) else { return }
                                        goalViewModel.goal.setTime = newSetTime.toString(format: .setTime)
                                    }
                                    DailyPicker(range: 0 ..< 60, selection: $mm) {
                                        guard let oldSetTime = goalViewModel.goal.setTime.toDate(format: .setTime),
                                              let newSetTime = Calendar.current.date(
                                                bySettingHour: Calendar.current.component(.hour, from: oldSetTime),
                                                minute: $0,
                                                second: 0,
                                                of: oldSetTime
                                              ) else { return }
                                        goalViewModel.goal.setTime = newSetTime.toString(format: .setTime)
                                    }
                                }
                                .padding(.horizontal, 8)
                                .frame(maxWidth: width, maxHeight: height)
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
        .onAppear {
            HH = Int(goalViewModel.goal.setTime.split(separator: ":")[0]) ?? 0
            mm = Int(goalViewModel.goal.setTime.split(separator: ":")[1]) ?? 0
        }
    }
}

// MARK: - ContentSection
struct ContentSection: View {
    @Binding var content: String
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
            .task {
                await MainActor.run {
                    focusedField = 0
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - SymbolSection
struct SymbolSection: View {
    @Binding var selectedSymbol: Symbols?
    
    init(symbol: Binding<Symbols?>) {
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
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            selectedSymbol = symbol
                                        }
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
    
    @State private var recordButtonFrame: CGRect = .zero
    @State private var recordHH: Int = 0
    @State private var recordmm: Int = 0
    @State private var recordss: Int = 0
    @State private var goalButtonFrame: CGRect = .zero
    @State private var goalHH: Int = 0
    @State private var goalmm: Int = 0
    @State private var goalss: Int = 0
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("진행 방식")
                    .font(Fonts.bodyLgSemiBold)
                    .foregroundStyle(Colors.Text.primary)
                
                Spacer()

                if goalViewModel.modifyType == nil {
                    DailySegment(
                        segmentType: .component,
                        currentType: $goalViewModel.goal.type,
                        types: [GoalTypes.count, GoalTypes.timer]
                    ) {
                        goalViewModel.goal.type = $0
                        goalViewModel.goal.count = $0.defaultCount
                        if $0 == .timer {
                            goalHH = 0
                            goalmm = 0
                            goalss = 0
                        }
                    }
                }
            }
            
            if let modifyType = goalViewModel.modifyType, modifyType != .all {
                HStack(spacing: 4) {
                    Text("기록")
                        .font(Fonts.bodyMdSemiBold)
                        .foregroundStyle(Colors.Text.tertiary)
                    
                    Spacer()
                    
                    if goalViewModel.goal.type == .timer {
                        Button {
                            let width: CGFloat = 281
                            let height: CGFloat = 176
                            
                            let offsetX = width / 2 - recordButtonFrame.width
                            let offsetY = height / 2 + recordButtonFrame.height * 3 / 2 + 12
                            
                            let position = CGPoint(
                                x: recordButtonFrame.minX - offsetX,
                                y: recordButtonFrame.minY - offsetY + 60
                            )
                            
                            if goalViewModel.popoverContent != nil {
                                goalViewModel.hidePopover()
                            } else {
                                goalViewModel.showPopover(at: position) {
                                    HStack(spacing: 8) {
                                        DailyPicker(range: 0 ..< 24, selection: $recordHH) {
                                            goalViewModel.record.count = $0 * 3600 + recordmm * 60 + recordss
                                        }
                                        DailyPicker(range: 0 ..< 60, selection: $recordmm) {
                                            goalViewModel.record.count = recordHH * 3600 + $0 * 60 + recordss
                                        }
                                        DailyPicker(range: 0 ..< 60, selection: $recordss) {
                                            goalViewModel.record.count = recordHH * 3600 + recordmm * 60 + $0
                                        }
                                    }
                                    .padding(.horizontal, 8)
                                    .frame(maxWidth: width, maxHeight: height)
                                }
                            }
                        } label: {
                            Text(goalViewModel.record.count.timerFormat())
                                .font(Fonts.bodyLgMedium)
                                .foregroundStyle(Colors.Text.point)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Colors.Background.secondary)
                                .cornerRadius(8)
                        }
                        .getFrame { recordButtonFrame = $0 }
                    } else {
                        Button {
                            let width: CGFloat = 99
                            let height: CGFloat = 174
                            
                            let offsetX = CGFloat(width / 2 + 12)
                            let offsetY = recordButtonFrame.height / 2 + height / 2
                            
                            let position = CGPoint(
                                x: recordButtonFrame.minX - offsetX,
                                y: recordButtonFrame.minY - offsetY + 60
                            )
                            
                            if goalViewModel.popoverContent != nil {
                                goalViewModel.hidePopover()
                            } else {
                                goalViewModel.showPopover(at: position) {
                                    DailyPicker(range: 0 ... 10, selection: $goalViewModel.record.count, maxWidth: width)
                                }
                            }
                        } label: {
                            Text("\(goalViewModel.record.count)")
                                .font(Fonts.bodyLgMedium)
                                .foregroundStyle(Colors.Text.point)
                                .frame(width: 58, height: 40)
                                .background(Colors.Background.secondary)
                                .cornerRadius(8)
                        }
                        .getFrame { recordButtonFrame = $0 }
                        
                        Text("회 반복")
                            .font(Fonts.bodyLgMedium)
                            .foregroundStyle(Colors.Text.secondary)
                    }
                }
                DailyDivider(color: Colors.Border.secondary, height: 1)
            }
            
            HStack(spacing: 4) {
                Text("목표")
                    .font(Fonts.bodyMdSemiBold)
                    .foregroundStyle(Colors.Text.tertiary)
                
                Spacer()
                
                if goalViewModel.goal.type == .timer {
                    Button {
                        let width: CGFloat = 281
                        let height: CGFloat = 176
                        
                        let offsetX = width / 2 - goalButtonFrame.width
                        let offsetY = height / 2 + goalButtonFrame.height * 3 / 2 + 12
                        
                        let position = CGPoint(
                            x: goalButtonFrame.minX - offsetX,
                            y: goalButtonFrame.minY - offsetY + 60
                        )
                        
                        if goalViewModel.popoverContent != nil {
                            goalViewModel.hidePopover()
                        } else {
                            goalViewModel.showPopover(at: position) {
                                HStack(spacing: 8) {
                                    DailyPicker(range: 0 ..< 24, selection: $goalHH) {
                                        goalViewModel.goal.count = $0 * 3600 + goalmm * 60 + goalss
                                    }
                                    DailyPicker(range: 0 ..< 60, selection: $goalmm) {
                                        goalViewModel.goal.count = goalHH * 3600 + $0 * 60 + goalss
                                    }
                                    DailyPicker(range: 0 ..< 60, selection: $goalss) {
                                        goalViewModel.goal.count = goalHH * 3600 + goalmm * 60 + $0
                                    }
                                }
                                .padding(.horizontal, 8)
                                .frame(maxWidth: width, maxHeight: height)
                            }
                        }
                    } label: {
                        Text(goalViewModel.goal.count.timerFormat())
                            .font(Fonts.bodyLgMedium)
                            .foregroundStyle(Colors.Text.point)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Colors.Background.secondary)
                            .cornerRadius(8)
                    }
                    .getFrame { goalButtonFrame = $0 }
                } else {
                    Button {
                        let width: CGFloat = 99
                        let height: CGFloat = 174
                        
                        let offsetX = CGFloat(width / 2 + 12)
                        let offsetY = goalButtonFrame.height / 2 + height / 2
                        
                        let position = CGPoint(
                            x: goalButtonFrame.minX - offsetX,
                            y: goalButtonFrame.minY - offsetY + 60
                        )
                        
                        if goalViewModel.popoverContent != nil {
                            goalViewModel.hidePopover()
                        } else {
                            goalViewModel.showPopover(at: position) {
                                DailyPicker(range: 1 ... 10, selection: $goalViewModel.goal.count, maxWidth: width)
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
                    .getFrame { goalButtonFrame = $0 }
                    
                    Text("회 반복")
                        .font(Fonts.bodyLgMedium)
                        .foregroundStyle(Colors.Text.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .onAppear {
            recordHH = goalViewModel.record.count / 3600
            recordmm = goalViewModel.record.count % 3600 / 60
            recordss = goalViewModel.record.count % 60
            goalHH = goalViewModel.goal.count / 3600
            goalmm = goalViewModel.goal.count % 3600 / 60
            goalss = goalViewModel.goal.count % 60
        }
    }
}
