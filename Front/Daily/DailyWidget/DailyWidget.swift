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
        SimpleEntry(date: Date(), records: [RecordModel()])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), records: [RecordModel()])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getCalendarDay { data in
            var entries: [SimpleEntry] = []
            
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, records: data.data.goalList)
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct getCalendarDayModel: Codable {
    let code: String
    let message: String
    let data: getCalendarDayData
    
    init() {
        self.code = "99"
        self.message = "Network Error"
        self.data = getCalendarDayData()
    }
}

struct getCalendarDayData: Codable {
    let goalList: [RecordModel]
    
    init() {
        self.goalList = [RecordModel()]
    }
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
        self.content = "아침 7시에 일어나기 ☀️"
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
    guard let requestURL = URL(string: "http://34.22.71.88:5000/calendar/day/111?date=2024-05-09") else { return }
    
    var urlRequest = URLRequest(url: requestURL)
    urlRequest.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
        guard let data = data else { return }
        if urlResponse is HTTPURLResponse {
            print("data is \(String(decoding: data, as: UTF8.self))")
            do {
                let data: getCalendarDayModel = try JSONDecoder().decode(getCalendarDayModel.self, from: data)
                complete(data)
            } catch {
                complete(getCalendarDayModel())
            }
        } else { return }
    }.resume()
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let records: [RecordModel]
}

struct DailyWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            VStack(alignment: .leading) {
                SimpleDayRating(day: .constant(8), rating: .constant(0.5))
                SymbolListInSmallWidget(records: entry.records)
            }
            .font(.system(size: CGFloat.fontSize))
        default:
            HStack(alignment: .top) {
                SimpleDayRating(day: .constant(8), rating: .constant(0.5))
                VStack {
                    if entry.records.count > 0 {
                        ForEach(entry.records.indices, id: \.self) { index in
                            if index < 3 {
                                SimpleRecordList(record: entry.records[index])
                            }
                        }
                        Spacer()
                    } else {
                        Text("아직 목표가 없어요 😓")
                    }
                }
                .frame(height: CGFloat.screenHeight / 6)
            }
            .font(.system(size: CGFloat.fontSize))
        }
//        VStack {
//            if entry.records.count > 0 {
//                ForEach(entry.records.indices, id: \.self) { index in
//                    switch family {
//                    case .systemSmall, .systemMedium:
//                        if index < 3 {
//                            SimpleRecordList(record: entry.records[index])
//                        }
//                    case .systemLarge:
//                        if index < 7 {
//                            SimpleRecordList(record: entry.records[index])
//                        }
//                    default:    // systemExtraLarge for iPad
//                        EmptyView()
//                    }
//                }
//            } else {
//                Text("아직 목표가 없어요 😓")
//            }
//        }
    }
}

struct SimpleDayRating: View {
    @Binding var day: Int
    @Binding var rating: Double
    
    var body: some View {
        ZStack {
            Image(systemName: "circle.fill")
                .font(.system(size: CGFloat.fontSize * 2))
                .foregroundColor(Color("CustomColor").opacity(rating*0.8))
            Text("\(day)")
                .font(.system(size: CGFloat.fontSize, weight: .bold))
                .foregroundColor(.primary)
        }
    }
}

struct SymbolListInSmallWidget: View {
    @State var records: [RecordModel]
    
    var body: some View {
        ZStack {
            if records.count > 0 {
                if records[0].goal_count == 0 {
                    Text("인터넷 연결을 확인하세요 😥")
                } else {
                    VStack {
                        Spacer()
                        ForEach(0 ..< 2) { rowIndex in
                            HStack {
                                Spacer()
                                ForEach(rowIndex * 3 ..< (rowIndex + 1) * 3, id: \.self) { index in
                                    SimpleSymbol(record: index < records.count ? records[index] : RecordModel())
                                    Spacer()
                                }
                            }
                            Spacer()
                        }
                    }
                }
            } else {
                Text("아직 목표가 없어요 😓")
                    .font(.system(size: CGFloat.fontSize * 4 / 5))
            }
        }
        .frame(width: CGFloat.screenWidth / 3, height: CGFloat.screenWidth / 9 * 2)
        .background {
            RoundedRectangle(cornerRadius: 15).fill(Color("BackgroundColor"))
        }
    }
}

struct SimpleSymbol: View {
    @State var record: RecordModel
    
    var body: some View {
        if record.issuccess {
            Image(systemName: "\(symbols[record.symbol] ?? "d.circle").fill")
        } else {
            Image(systemName: "\(symbols[record.symbol] ?? "d.circle")")
                .opacity(record.goal_count > 0 ? 1 : 0)
        }
    }
}

struct SimpleRecordList: View {
    @Environment(\.widgetFamily) private var family
    @State var record: RecordModel
    
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
            }
        }
        .padding(.horizontal, family == .systemSmall ? 5 : 10)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 15).fill(Color("BackgroundColor"))
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
    "운동" : "dubbell",
    "런닝" : "figure.run.circle",
    "공부" : "book",
    "키보드" : "keyboard",
    "하트" : "heart",
    "별" : "star",
    "커플" : "person.2.crop.square.stack",
    "모임" : "person.3"
]
