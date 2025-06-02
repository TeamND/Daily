//
//  DailyWidget.swift
//  DailyWidget
//
//  Created by 최승용 on 5/8/24.
//

import WidgetKit
import SwiftUI
import SwiftData
import DailyUtilities

struct Provider: TimelineProvider {
    let dailyModelContainer: ModelContainer
    
    init() {
        dailyModelContainer = try! ModelContainer(
            for: DailyGoalModel.self, DailyRecordModel.self,
            configurations: ModelConfiguration(url: FileManager.sharedContainerURL())
        )
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), rating: 0, records: [], ratings:
                        Array(repeating: nil, count: Calendar.current.range(of: .day, in: .month, for: Date())?.count ?? 0)
                    )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), rating: 0, records: [], ratings:
                                    Array(repeating: nil, count: Calendar.current.range(of: .day, in: .month, for: Date())?.count ?? 0)
                                )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let context = ModelContext(dailyModelContainer)
        let calendar = Calendar.current
        
        // MARK: - for systemSmall & systemMedium
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        let recordsDescriptor = FetchDescriptor<DailyRecordModel>(
            predicate: #Predicate<DailyRecordModel> { record in
                today <= record.date && record.date < tomorrow
            }
        )
        
        guard let recordsQuery = try? context.fetch(recordsDescriptor) else { return }
        let records = recordsQuery.sorted {
            if $0.isSuccess != $1.isSuccess {
                return !$0.isSuccess && $1.isSuccess
            }
            if let prevGoal = $0.goal, let nextGoal = $1.goal, prevGoal.isSetTime != nextGoal.isSetTime {
                return !prevGoal.isSetTime && nextGoal.isSetTime
            }
            if let prevGoal = $0.goal, let nextGoal = $1.goal, prevGoal.setTime != nextGoal.setTime {
                return prevGoal.setTime < nextGoal.setTime
            }
            return $0.date < $1.date
        }
        let rating = records.isEmpty ? 0.0 : Double(records.filter { $0.isSuccess }.count) / Double(records.count)
        let simpleRecords = records.map { SimpleRecordModel(record: $0) }
        
        // MARK: - for systemLarge
        let startOfMonth = calendar.date(from: DateComponents(year: Date().year, month: Date().month, day: 1))!
        let endOfMonth = calendar.date(from: DateComponents(year: Date().year, month: Date().month + 1, day: 1))!.addingTimeInterval(-1)
        let lengthOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
        var ratings: [Double?] = Array(repeating: nil, count: lengthOfMonth)
        
        let ratingsDescriptor = FetchDescriptor<DailyRecordModel>(
            predicate: #Predicate<DailyRecordModel> { record in
                startOfMonth <= record.date && record.date < endOfMonth
            }
        )
        
        guard let ratingsQuery = try? context.fetch(ratingsDescriptor) else { return }
        var recordsByDate: [Date: [DailyRecordModel]] = [:]
        ratingsQuery.forEach { record in
            let components = calendar.dateComponents([.year, .month, .day], from: record.date)
            if let date = calendar.date(from: components) {
                recordsByDate[date, default: []].append(record)
            }
        }
        
        for (date, dayRecords) in recordsByDate {
            if dayRecords.isEmpty { continue }
            ratings[date.day - 1] = Double(dayRecords.filter { $0.isSuccess }.count) / Double(dayRecords.count)
        }
        
        // MARK: - entry
        var entries: [SimpleEntry] = []
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: Date())!
            let entry = SimpleEntry(
                date: entryDate,
                rating: rating,
                records: simpleRecords,
                ratings: ratings
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - Model
struct SimpleRecordModel: Codable {
    let content: String
    let symbol: Symbols
    let isSuccess: Bool
    let isSetTime: Bool
    let setTime: String
    let goalCount: Int
    let recordCount: Int
    
    init(isEmpty: Bool = true) {
        self.content = ""
        self.symbol = .check
        self.isSuccess = false
        self.isSetTime = false
        self.setTime = "00:00"
        self.goalCount = 0
        self.recordCount = 0
    }
    
    init(record: DailyRecordModel) {
        self.content = record.goal?.content ?? ""
        self.symbol = record.goal?.symbol ?? .check
        self.isSuccess = record.isSuccess
        self.isSetTime = record.goal?.isSetTime ?? false
        self.setTime = record.goal?.setTime ?? "00:00"
        self.goalCount = record.goal?.count ?? 0
        self.recordCount = record.count
    }
}

// MARK: Emtry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let rating: Double
    let records: [SimpleRecordModel]
    let ratings: [Double?]
}

// MARK: - EntryView
struct DailyWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: .zero) {
            switch family {
            case .systemSmall:
                dailyWidgetDateText
                Spacer()
                Spacer()
                
                SmallWidgetView(rating: entry.rating)
                Spacer()
            case .systemMedium:
                dailyWidgetDateText
                Spacer().frame(height: 2)
                
                if entry.records.isEmpty {
                    dailyWidgetNoRecordText
                    Spacer()
                } else {
                    Spacer().frame(height: 6)
                    MediumWidgetView(records: entry.records)
                }
            default:
                dailyWidgetDateText.frame(maxHeight: .infinity)
                Spacer().frame(height: 20)
                
                dailyWidgetWeekIndicator
                LargeWidgetView(ratings: entry.ratings)
            }
        }
        .widgetURL(URL(string: "widget://daily?family=\(family.rawValue)")!)
    }
    
    private var dailyWidgetDateText: some View {
        HStack(spacing: .zero) {
            Text("\(Date().month)월")
            if family.rawValue < WidgetFamily.systemLarge.rawValue { Text(" \(Date().day)일") }
        }
        .font(family == .systemMedium ? Fonts.bodyLgSemiBold : Fonts.headingSmSemiBold)
        .foregroundStyle(Colors.Text.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var dailyWidgetNoRecordText: some View {
        VStack(spacing: 4) {
            Image(.recordYetNormal)
                .resizable()
                .scaledToFit()
                .frame(width: 40)
            Text("아직 목표가 없어요")
                .font(Fonts.bodyLgSemiBold)
                .foregroundStyle(Colors.Text.secondary)
            Text("오늘의 목표를 추가해보세요")
                .font(Fonts.bodyMdRegular)
                .foregroundStyle(Colors.Text.tertiary)
        }
    }
    
    private var dailyWidgetWeekIndicator: some View {
        HStack {
            ForEach(DayOfWeek.allCases, id: \.self.index) {
                if $0.index > 0 { Spacer() }
                Text($0.text)
                    .font(Fonts.bodySmRegular)
                    .foregroundStyle(Colors.Text.primary)
                    .frame(width: 33)
            }
        }
    }
}

// MARK: - systemSmall View
struct SmallWidgetView: View {
    @State var rating: Double
    
    var body: some View {
        ZStack {
            RatingIndicator(rating: rating, lineWidth: 5).padding(1)
            Text("\((rating * 100).percentFormat())")
                .font(Fonts.headingMdBold)
                .foregroundStyle(Colors.Text.primary)
        }
        .frame(width: 80, height: 80)
    }
}

// FIXME: 회의 후 수정
// MARK: - systemMedium View
struct MediumWidgetView: View {
    @State var records: [SimpleRecordModel]

    var body: some View {
        ForEach(Array(records.enumerated()), id: \.offset) { index, record in
            if index < 3 {
                HStack(spacing: 4) {
                    Image(record.symbol.icon(isSuccess: record.isSuccess))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26)
                    
                    HStack(spacing: 8) {
                        Text(record.content)
                            .font(Fonts.bodyMdSemiBold)
                            .foregroundStyle(Colors.Text.primary)
                        
                        Spacer()
                        
                        Text(record.setTime)
                            .font(Fonts.bodySmRegular)
                            .foregroundStyle(Colors.Text.tertiary)
                            .opacity(record.isSetTime ? 1 : 0)
                    }
                    .padding(.horizontal, 10)
                    .frame(maxHeight: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Colors.Background.secondary)
                    }
                }
                .frame(height: 26)
                DailySpacer()
            }
        }
    }
}

// MARK: - systemLarge View
struct LargeWidgetView: View {
    @State var ratings: [Double?]
    
    var body: some View {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: DateComponents(year: Date().year, month: Date().month, day: 1))!
        let lengthOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
        let dividerCount = (lengthOfMonth + startOfMonth.weekday - 1 - 1) / 7
        
        ForEach(0 ..< 6) { row in
            DailySpacer()
            HStack {
                ForEach(0 ..< 7) { col in
                    if col > 0 { Spacer() }
                    
                    let day = row * 7 + col - (startOfMonth.weekday - 1) + 1
                    if 0 < day && day <= lengthOfMonth {
                        DayIndicator(day: day, rating: ratings[day - 1], isToday: day == Date().day)
                    } else {
                        DayIndicator(day: 0, rating: nil, isToday: false).opacity(0)
                    }
                }
            }
            
            if row < 5 {
                DailySpacer()
                DailyDivider(color: Colors.Border.secondary, height: 1).opacity(row < dividerCount ? 1 : 0)
            }
        }
    }
}

// MARK: - Widget
struct DailyWidget: Widget {
    let kind: String = "DailyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Widget")
        .description("위젯으로 더욱 간편하게! :D")
    }
}
