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
        SimpleEntry(date: Date(), rating: 0, day: String(Calendar.current.component(.day, from: Date())), records: [SimpleRecordModel()])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), rating: 0, day: String(Calendar.current.component(.day, from: Date())), records: [SimpleRecordModel()])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getCalendarWidget { data in
            var entries: [SimpleEntry] = []
            
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, rating: data.data.rating, day: data.data.date, records: data.data.goalList)
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct getCalendarWidgetModel: Codable {
    let code: String
    let message: String
    let data: getCalendarWidgetData
    
    init() {
        self.code = "99"
        self.message = "Network Error"
        self.data = getCalendarWidgetData(isError: true)
    }
}

struct getCalendarWidgetData: Codable {
    let rating: Double
    let date: String
    let goalList: [SimpleRecordModel]
    
    init(isError: Bool) {
        self.rating = 0.0
        self.date = String(Calendar.current.component(.day, from: Date()))
        self.goalList = [SimpleRecordModel(isEmpty: isError)]
    }
}

struct SimpleRecordModel: Codable {
    let content: String
    let symbol: String
    let issuccess: Bool
    let is_set_time: Bool
    let set_time: String
    
    init() {
        self.content = "아침 7시에 일어나기 ☀️"
        self.symbol = "체크"
        self.issuccess = false
        self.is_set_time = false
        self.set_time = "00:00"
    }
    
    init(isEmpty: Bool) {
        self.content = ""
        self.symbol = "체크"
        self.issuccess = false
        self.is_set_time = false
        self.set_time = "00:00"
    }
}

func getCalendarWidget(complete: @escaping (getCalendarWidgetModel) -> Void) {
    //let serverUrl: String = "http://34.22.71.88:5000/"    // gcp
    let serverUrl: String = "http://43.202.215.185:5000/"   // aws
    guard let requestURL = URL(string: "\(serverUrl)calendar/widget/\(UIDevice.current.identifierForVendor!.uuidString)") else { return }
    
    var urlRequest = URLRequest(url: requestURL)
    urlRequest.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
        guard let data = data else {
            complete(getCalendarWidgetModel())
            return
        }
        if urlResponse is HTTPURLResponse {
            do {
                let data: getCalendarWidgetModel = try JSONDecoder().decode(getCalendarWidgetModel.self, from: data)
                complete(data)
            } catch {
                complete(getCalendarWidgetModel())
            }
        } else { complete(getCalendarWidgetModel()) }
    }.resume()
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
                .foregroundColor(Color("CustomColor").opacity(rating*0.8))
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
                if records[0].content.count < 2 {
                    SimpleText(type: "networkError")
                } else {
                    VStack {
                        Spacer()
                        ForEach(0 ..< 2) { rowIndex in
                            HStack {
                                Spacer()
                                ForEach(rowIndex * 3 ..< (rowIndex + 1) * 3, id: \.self) { index in
                                    SimpleSymbol(record: index < records.count ? records[index] : SimpleRecordModel(isEmpty: true))
                                    Spacer()
                                }
                            }
                            Spacer()
                        }
                    }
                }
            } else {
                SimpleText(type: "noData")
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 15).fill(Color("BackgroundColor"))
        }
    }
}

struct SimpleSymbol: View {
    @State var record: SimpleRecordModel
    
    var body: some View {
        if record.issuccess {
            Image(systemName: "\(symbols[record.symbol] ?? "d.circle").fill")
        } else {
            Image(systemName: "\(symbols[record.symbol] ?? "d.circle")")
                .opacity(record.content.count < 2 ? 0 : 1)
        }
    }
}
struct SimpleRecordList: View {
    @Environment(\.widgetFamily) private var family
    @State var records: [SimpleRecordModel]
    
    var body: some View {
        VStack {
            if records.count > 0 {
                if records[0].content.count < 2 {
                    SimpleText(type: "networkError")
                        .background {
                            RoundedRectangle(cornerRadius: 15).fill(Color("BackgroundColor"))
                        }
                } else {
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
                }
            } else {
                SimpleText(type: "noData")
                    .background {
                        RoundedRectangle(cornerRadius: 15).fill(Color("BackgroundColor"))
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
                if record.issuccess {
                    Image(systemName: "\(symbols[record.symbol] ?? "d.circle").fill")
                } else {
                    Image(systemName: "\(symbols[record.symbol] ?? "d.circle")")
                }
                Text(record.content)
                    .lineLimit(1)
                Spacer()
                if record.is_set_time {
                    Text(record.set_time)
                }
            }
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 15).fill(Color("BackgroundColor"))
        }
    }
}

struct SimpleText: View {
    @Environment(\.widgetFamily) private var family
    @State var type: String
    
    var body: some View {
        if type == "noData" {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("아직 목표가 없어요 😓")
                    if family != .systemSmall {
                        Text("목표 세우러 가기")
                            .foregroundColor(Color("CustomColor"))
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(CGFloat.fontSize < 15 ? 0 : 10)
        }
        if type == "networkError" {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("인터넷 연결을 확인하세요 😥")
                    Spacer()
                }
                Spacer()
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
                    .containerBackground(Color("ThemeColor"), for: .widget)
            } else {
                DailyWidgetEntryView(entry: entry)
                    .padding()
                    .background(Color("ThemeColor"))
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



extension CGFloat {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    static let fontSizeForiPhone15 = 15 * screenWidth / 393 // 6.7 iPhone 기준
    static let fontSize = UIDevice.current.model == "iPhone" ? fontSizeForiPhone15 : fontSizeForiPhone15 / 2
}

let symbols: [String: String] = [
    "체크" : "checkmark.circle",
    "운동" : "dumbbell",
    "런닝" : "figure.run.circle",
    "공부" : "book",
    "키보드" : "keyboard",
    "하트" : "heart",
    "별" : "star",
    "커플" : "person.2.crop.square.stack",
    "모임" : "person.3"
]
