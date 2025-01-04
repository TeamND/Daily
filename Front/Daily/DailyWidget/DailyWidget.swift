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
        SimpleEntry(date: Date(), rating: 0, day: String(Calendar.current.component(.day, from: Date())), records: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), rating: 0, day: String(Calendar.current.component(.day, from: Date())), records: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let context = ModelContext(dailyModelContainer)
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        let descriptor = FetchDescriptor<DailyRecordModel>(
            predicate: #Predicate<DailyRecordModel> { record in
                record.date >= today && record.date < tomorrow
            }
//            },
//            sortBy: [
//                SortDescriptor(\DailyRecordModel.goal?.isSetTime),
//                SortDescriptor(\DailyRecordModel.goal?.setTime),
//                SortDescriptor(\DailyRecordModel.isSuccess),
//                SortDescriptor(\DailyRecordModel.date)
//            ]
        )
        
        do {
            let records = try context.fetch(descriptor)
            let simpleRecords = records.map { record in
                SimpleRecordModel(
                    content: record.goal?.content ?? "",
                    symbol: record.goal?.symbol ?? .check,
                    isSuccess: record.isSuccess,
                    isSetTime: record.goal?.isSetTime ?? false,
                    setTime: record.goal?.setTime ?? "00:00"
                )
            }
            let rating = records.isEmpty ? 0.0 : Double(records.filter { $0.isSuccess }.count) / Double(records.count)
            
            var entries: [SimpleEntry] = []
            
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(
                    date: entryDate,
                    rating: rating,
                    day: String(Calendar.current.component(.day, from: Date())),
                    records: simpleRecords
                )
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } catch {
            print("Error fetching records: \(error)")
            
            let entry = SimpleEntry(
                date: Date(),
                rating: 0,
                day: String(Calendar.current.component(.day, from: Date())),
                records: []
            )
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleRecordModel: Codable {
    let content: String
    let symbol: Symbols
    let isSuccess: Bool
    let isSetTime: Bool
    let setTime: String
    
    init(content: String = "아침 7시에 일어나기 ☀️", symbol: Symbols = .check, isSuccess: Bool = false, isSetTime: Bool = false, setTime: String = "00:00") {
        self.content = content
        self.symbol = symbol
        self.isSuccess = isSuccess
        self.isSetTime = isSetTime
        self.setTime = setTime
    }
    
    init(isEmpty: Bool) {
        self.content = ""
        self.symbol = .check
        self.isSuccess = false
        self.isSetTime = false
        self.setTime = "00:00"
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let rating: Double
    let day: String
    let records: [SimpleRecordModel]
}

struct DailyWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            VStack(alignment: .leading) {
                SimpleDayRating(day: entry.day, rating: entry.rating)
                SymbolListInSmallWidget(records: entry.records)
            }
            .font(.system(size: CGFloat.fontSize))
        default:
            HStack(alignment: .top) {
                SimpleDayRating(day: entry.day, rating: entry.rating)
                SimpleRecordList(records: entry.records)
            }
            .font(.system(size: CGFloat.fontSize))
        }
    }
}

struct SimpleDayRating: View {
    @State var day: String
    @State var rating: Double
    
    var body: some View {
        ZStack {
            Image(systemName: "circle.fill")
                .font(.system(size: CGFloat.fontSize * 2))
                .foregroundColor(Colors.daily.opacity(rating*0.8))
            Text(day)
                .font(.system(size: CGFloat.fontSize, weight: .bold))
                .foregroundColor(.primary)
        }
        Spacer()
    }
}

struct SymbolListInSmallWidget: View {
    @State var records: [SimpleRecordModel]
    
    var body: some View {
        ZStack {
            if records.count > 0 {
                VStack {
                    Spacer()
                    ForEach(0 ..< 2) { rowIndex in
                        HStack {
                            Spacer()
                            ForEach(rowIndex * 3 ..< (rowIndex + 1) * 3, id: \.self) { index in
                                SimpleSymbol(record: index < records.count ? records[index] : SimpleRecordModel(isEmpty: true))
                                    .opacity(index < records.count ? 1 : 0)
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                }
            } else {
                SimpleText()
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 15).fill(Colors.background)
        }
    }
}

struct SimpleSymbol: View {
    @State var record: SimpleRecordModel
    
    var body: some View {
        Image(systemName: "\(record.symbol.imageName)\(record.isSuccess ? ".fill" : "")")
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
                        RoundedRectangle(cornerRadius: 15).fill(Colors.background)
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
            RoundedRectangle(cornerRadius: 15).fill(Colors.background)
        }
    }
}

struct SimpleText: View {
    @Environment(\.widgetFamily) private var family
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("아직 목표가 없어요 😓")
                if family != .systemSmall {
                    Text("목표 세우러 가기")
                        .foregroundColor(Colors.daily)
                }
                Spacer()
            }
            Spacer()
        }
        .padding(CGFloat.fontSize < 15 ? 0 : 10)
    }
}

struct DailyWidget: Widget {
    let kind: String = "DailyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DailyWidgetEntryView(entry: entry)
                    .containerBackground(Colors.theme, for: .widget)
                    .widgetURL(URL(string: "widget://daily")!)
            } else {
                DailyWidgetEntryView(entry: entry)
                    .padding()
                    .background(Colors.theme)
                    .widgetURL(URL(string: "widget://daily")!)
            }
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
