//
//  TravelokaCinemaWidget.swift
//  TravelokaCinemaWidget
//
//  Created by Herlian Zhang on 04/01/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getUpComingMovie { movies in
            var entries: [SimpleEntry] = []
            let currentDate = Date()
            for i in 0..<movies.count {
                guard let entryDate = Calendar.current.date(byAdding: .minute, value: i, to: currentDate) else { return }
                let entry = SimpleEntry(date: entryDate, data: movies[i])
                entries.append(entry)
            }
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    private func getUpComingMovie(completion: @escaping ([MovieListModel])->()) {
        let request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=fb209c5f2af30f7426f4e874f4d56212")!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            guard let movies = try? decoder.decode(UpComingMovieModel.self, from: data).results else { return }
            completion(movies)
        }.resume()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: MovieListModel?
    
    init(date: Date, data: MovieListModel? = nil) {
        self.date = date
        self.data = data
    }
}

struct TravelokaCinemaWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            if let id = entry.data?.id {
                ZStack {
                    NetworkImage(url: URL(string: entry.data?.poster ?? ""))
                }
                .widgetURL(URL(string: "traveloka.cinema://detail?id=\(id)")!)
            } else {
                Image("")
                    .resizable()
                    .background(Color.gray)
            }
        case .systemMedium:
            if let id = entry.data?.id {
                GeometryReader { geometry in
                    HStack(alignment: .center, spacing: 12) {
                            NetworkImage(url: URL(string: entry.data?.poster ?? ""))
                                .frame(maxWidth: geometry.size.height / 1.5 - 16)
                                .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(entry.data?.title ?? "")
                                .font(.title3)
                                .lineLimit(3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(entry.data?.releaseDate ?? "")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(8)
                }
                .frame(maxHeight: .infinity)
                .widgetURL(URL(string: "traveloka.cinema://detail?id=\(id)")!)
            } else {
                GeometryReader { geometry in
                    HStack(alignment: .center, spacing: 12) {
                        Image("")
                            .resizable()
                            .background(Color.gray)
                            .frame(maxWidth: geometry.size.height / 1.5 - 16)
                            .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Movie Title Uwau")
                                .font(.title3)
                                .lineLimit(3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .redacted(reason: .placeholder)
                            Text("release Date")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .redacted(reason: .placeholder)
                        }
                    }
                    .padding(8)
                }
                .frame(maxHeight: .infinity)
            }
        default:
            Text("Family Not Found")
        }
        
    }
}

@main
struct TravelokaCinemaWidget: Widget {
    let kind: String = "TravelokaCinemaWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TravelokaCinemaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Traveloka Cinema Widget")
        .description("Upcoming Movie")
    }
}

struct TravelokaCinemaWidget_Previews: PreviewProvider {
    static var previews: some View {
        TravelokaCinemaWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
