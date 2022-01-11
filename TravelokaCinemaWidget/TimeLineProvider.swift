//
//  TimeLineProvider.swift
//  TravelokaCinemaWidgetExtension
//
//  Created by Herlian Zhang on 11/01/22.
//

import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        getUpComingMovie { movies in
            let imagePaths = movies.compactMap { $0.poster }
            downloadImages(paths: imagePaths) { images in
                var entries: [SimpleEntry] = []
                let currentDate = Date()
                for i in 0..<movies.count {
                    guard let entryDate = Calendar.current.date(byAdding: .minute, value: i, to: currentDate) else { return }
                    let entry = SimpleEntry(date: entryDate,
                                            movie: Movie(id: movies[i].id,
                                                         title: movies[i].title,
                                                         releaseDate: movies[i].releaseDate,
                                                         overview: movies[i].overview,
                                                         image: images[movies[i].poster, default: nil]))
                    entries.append(entry)
                }
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct LargeProvider: TimelineProvider {
    func placeholder(in context: Context) -> LargeEntry {
        LargeEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LargeEntry) -> Void) {
        let entry = LargeEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LargeEntry>) -> Void) {
        getUpComingMovie { movies in
            let imagePaths = movies.compactMap { $0.poster }
            downloadImages(paths: imagePaths) { images in
                var entries: [LargeEntry] = []
                let currentDate = Date()
                let cellCount = 3
                let tmp = Float(movies.count) / Float(cellCount)
                let remain = Int(tmp.rounded(.down))
                
                for i in 0..<movies.count {
                    guard let entryDate = Calendar.current.date(byAdding: .minute, value: i, to: currentDate) else { return }
                    var start: Int
                    var end: Int
                    if i < remain * cellCount {
                        start = i - (i % cellCount)
                        end = start + cellCount
                    } else {
                        end = movies.count
                        start = end - cellCount + 1
                    }
                    let subMovies: [Movie] = Array(movies[start..<end]).map {
                        Movie(id: $0.id,
                              title: $0.title,
                              releaseDate: $0.releaseDate,
                              overview: $0.overview,
                              image: images[$0.poster, default: nil])
                    }
                    let entry = LargeEntry(date: entryDate,
                                           movies: subMovies,
                                           selectedId: movies[i].id)
                    entries.append(entry)
                }
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
    }
}
