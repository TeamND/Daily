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
            if let prevGoal = $0.goal, let nextGoal = $1.goal, prevGoal.isSetTime != nextGoal.isSetTime {
                return !prevGoal.isSetTime && nextGoal.isSetTime
            }
            if let prevGoal = $0.goal, let nextGoal = $1.goal, prevGoal.setTime != nextGoal.setTime {
                return prevGoal.setTime < nextGoal.setTime
            }
            if $0.isSuccess != $1.isSuccess {
                return !$0.isSuccess && $1.isSuccess
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

struct SimpleEntry: TimelineEntry {
    let date: Date
    let rating: Double
    let records: [SimpleRecordModel]
    let ratings: [Double?]
}

struct DailyWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    var entry: Provider.Entry

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                VStack {
                    Text("\(Date().month)월 \(Date().day)일")
                        .font(Fonts.headingSmSemiBold)
                        .foregroundStyle(Colors.Text.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Spacer()
                    ZStack {
                        RatingIndicator(rating: entry.rating, lineWidth: 5).padding(1)
                        Text("\((entry.rating * 100).percentFormat())")
                            .font(Fonts.headingMdBold)
                            .foregroundStyle(Colors.Text.primary)
                    }
                    .frame(width: 80, height: 80)
                    Spacer()
                    //                SimpleDayRating(day: entry.day, rating: entry.rating)
                    //                SymbolListInSmallWidget(records: entry.records)
                }
            case .systemMedium:
                VStack(spacing: .zero) {
                    Text("\(Date().month)월 \(Date().day)일")
                        .font(Fonts.headingSmSemiBold)
                        .foregroundStyle(Colors.Text.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer().frame(height: 14)
                    
                    if entry.records.isEmpty {
                        VStack(spacing: 4) {
                            Text("아직 목표가 없어요")
                                .font(Fonts.headingSmSemiBold)
                                .foregroundStyle(Colors.Text.secondary)
                            Text("오늘의 목표를 추가해보세요")
                                .font(Fonts.bodyLgRegular)
                                .foregroundStyle(Colors.Text.tertiary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    ForEach(Array(entry.records.enumerated()), id: \.offset) { index, record in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(record.content)
                                    .font(Fonts.bodyMdSemiBold)
                                    .foregroundStyle(Colors.Text.primary)
                                Text("\(record.recordCount)/\(record.goalCount)")
                                    .font(Fonts.bodySmRegular)
                                    .foregroundStyle(Colors.Text.tertiary)
                            }
                            Spacer()
                            Image(record.symbol.icon(isSuccess: record.isSuccess))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32)
                            //                        Image(systemName: "\(record.symbol.imageName)\(record.isSuccess ? ".fill" : "")")
                            //                        Text(record.content)
                            //                            .lineLimit(1)
                            //                        Spacer()
                            //                        if record.isSetTime { Text(record.setTime) }
                        }
                        Spacer()
                    }
                }
                //            HStack(alignment: .top) {
                //                SimpleDayRating(day: entry.day, rating: entry.rating)
                //                SimpleRecordList(records: entry.records)
                //            }
                //            .font(.system(size: CGFloat.fontSize))
                
            default:
                VStack(alignment: .leading, spacing: .zero) {
                    Text("\(Date().month)월")
                        .font(Fonts.headingSmSemiBold)
                        .foregroundStyle(Colors.Text.primary)
                        .frame(maxHeight: .infinity)
                    
                    Spacer().frame(height: 20)
                    
                    HStack {
                        ForEach(0 ..< 7) { index in
                            if index > 0 { Spacer() }
                            Text("\(DayOfWeek.text(for: index) ?? "")")
                                .font(Fonts.bodySmRegular)
                                .foregroundStyle(Colors.Text.primary)
                                .frame(width: 33)
                        }
                    }
                    
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
                                    DayIndicator(day: day, rating: entry.ratings[day - 1], isToday: day == Date().day)
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
        }
        .widgetURL(URL(string: "widget://daily?family=\(family.rawValue)")!)
    }
}

struct SimpleDayRating: View {
    @State var day: String
    @State var rating: Double
    
    var body: some View {
        ZStack {
            Image(systemName: "circle.fill")
                .font(.system(size: CGFloat.fontSize * 2))
//                .foregroundColor(Colors.daily.opacity(rating * 0.8))
            Text(day)
                .font(.system(size: CGFloat.fontSize, weight: .bold))
                .foregroundColor(.primary)
        }
    }
}

struct SymbolListInSmallWidget: View {
    @State var records: [SimpleRecordModel]
    
    var body: some View {
        Group {
            if records.count > 0 {
                VStack {
                    ForEach(0 ..< 2) { rowIndex in
                        HStack {
                            ForEach(0 ..< 3) { colIndex in
                                let index = rowIndex * 3 + colIndex
                                let record = index < records.count ? records[index] : SimpleRecordModel(isEmpty: true)
                                Image(systemName: "\(record.symbol.imageName)\(record.isSuccess ? ".fill" : "")")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .opacity(index < records.count ? 1 : 0)
                            }
                        }
                    }
                }
            } else { SimpleText() }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
//            RoundedRectangle(cornerRadius: 15).fill(Colors.background)
        }
    }
}

struct SimpleRecordList: View {
    @Environment(\.widgetFamily) private var family
    @State var records: [SimpleRecordModel]
    
    var body: some View {
        VStack {
            if records.count > 0 {
                ForEach(records.indices, id: \.self) { index in
                    switch family {
                    case .systemMedium:
                        if index < 3 {
                            SimpleRecordOnList(record: records[index])
                        }
                    default:
                        if index < 7 {
                            SimpleRecordOnList(record: records[index])
                        }
                    }
                }
                Spacer()
            } else {
                SimpleText()
                    .background {
//                        RoundedRectangle(cornerRadius: 15).fill(Colors.background)
                    }
            }
        }
    }
}

struct SimpleRecordOnList: View {
    @State var record: SimpleRecordModel
    
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                Image(systemName: "\(record.symbol.imageName)\(record.isSuccess ? ".fill" : "")")
                Text(record.content)
                    .lineLimit(1)
                Spacer()
                if record.isSetTime { Text(record.setTime) }
            }
        }
        .padding(10)
        .background {
//            RoundedRectangle(cornerRadius: 15).fill(Colors.background)
        }
    }
}

struct SimpleText: View {
    @Environment(\.widgetFamily) private var family
    
    var body: some View {
        VStack {
            Text("아직 목표가 없어요 😓")
            if family != .systemSmall {
                Text("목표 세우러 가기")
//                    .foregroundColor(Colors.daily)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(CGFloat.fontSize < 15 ? 0 : 10)
    }
}

struct DailyWidget: Widget {
    let kind: String = "DailyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyWidgetEntryView(entry: entry)
//                .containerBackground(Colors.theme, for: .widget)
        }
        .configurationDisplayName("Daily Widget")
        .description("위젯으로 더욱 간편하게! :D")
    }
}

extension CGFloat {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    static let fontSizeForiPhone15 = 15 * screenWidth / 393 // 6.7 iPhone 기준
    static let fontSize = UIDevice.current.model == "iPhone" ? fontSizeForiPhone15 : fontSizeForiPhone15 / 2
}
