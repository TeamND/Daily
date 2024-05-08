//
//  DailyWidget.swift
//  DailyWidget
//
//  Created by 최승용 on 5/8/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), records: [RecordModel()], emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), records: [RecordModel()], emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getCalendarDay { data in
            var entries: [SimpleEntry] = []
            
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, records: data.data.goalList, emoji: "😀")
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        getNewData { (news) in
//            let date = Date()
//            let entry = SimpleEntry(date: date, news: news)
//            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: date)
//            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate!))
//                
//            completion(timeline)
//        }
//    }
}

struct getCalendarDayModel: Codable {
    let code: String
    let message: String
    let data: getCalendarDayData
}

struct getCalendarDayData: Codable {
    let goalList: [RecordModel]
}

struct RecordModel: Codable {
    let uid: Int
    var goal_uid: Int
    let content: String
    var type: String
    let symbol: String
    var goal_time: Int
    var goal_count: Int
    var record_time: Int
    var record_count: Int
    var issuccess: Bool
    var start_time: String
    
    init() {
        self.uid = -1
        self.goal_uid = -1
        self.content = "test content"
        self.type = "check"
        self.symbol = "체크"
        self.goal_time = 0
        self.goal_count = 0
        self.record_time = 0
        self.record_count = 0
        self.issuccess = false
        self.start_time = ""
    }
}

func getCalendarDay(complete: @escaping (getCalendarDayModel) -> Void) {
    print("userID is \(UIDevice.current.identifierForVendor!.uuidString)")
    guard let requestURL = URL(string: "http://34.22.71.88:5000/calendar/day/111?date=2024-05-08") else { return }
    
    var urlRequest = URLRequest(url: requestURL)
    urlRequest.httpMethod = "GET"
    
    
    URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
        guard let data = data else { return }
        if urlResponse is HTTPURLResponse {
//            guard let data: getCalendarDayModel = JSONConverter.decodeJson(data: data) else {
//                complete(data)
//            }
            print("data is \(String(decoding: data, as: UTF8.self))")
            do {
                let data: getCalendarDayModel = try JSONDecoder().decode(getCalendarDayModel.self, from: data)
                complete(data)
            } catch {
                print("error is \(error)")
            }
        } else { return }
    }.resume()
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let records: [RecordModel]
    let emoji: String
}

struct DailyWidgetEntryView : View {
    @Environment(\.widgetFamily) private var family
    var entry: Provider.Entry

    var body: some View {
        VStack {
            switch family {
            case .systemSmall:
                Text(entry.records[0].content)
            case .systemMedium:
                Text("Medium")
            case .systemLarge:
                Text("Large")
            default:    // systemExtraLarge
                EmptyView()
            }
        }
    }
}

struct DailyWidget: Widget {
    let kind: String = "DailyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DailyWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DailyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Daily Widget")
        .description("위젯으로 더욱 간편하게! :D")
    }
}

//#Preview(as: .systemSmall) {
//    DailyWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
