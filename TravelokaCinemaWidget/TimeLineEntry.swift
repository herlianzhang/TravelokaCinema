//
//  TimeLineEntry.swift
//  TravelokaCinemaWidgetExtension
//
//  Created by Herlian Zhang on 11/01/22.
//

import WidgetKit
import SwiftUI

struct Movie: Identifiable {
    let id: Int
    let image: UIImage?
    let title: String
    let releaseDate: String
    let overview: String
    
    init(id: Int, title: String?, releaseDate: String?, overview: String?, image: UIImage? = nil) {
        self.id = id
        self.title = title ?? ""
        self.releaseDate = releaseDate ?? ""
        self.overview = overview ?? ""
        self.image = image
    }
    
    init() {
        self.id = Int.min
        self.title = ""
        self.releaseDate = ""
        self.overview = ""
        self.image = nil
    }
    
    var deeplink: URL {
        URL(string: "traveloka.cinema://detail?id=\(id)")!
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let movie: Movie
    
    init(date: Date, movie: Movie) {
        self.date = date
        self.movie = movie
    }
    
    init(date: Date) {
        self.date = date
        self.movie = Movie()
    }
}

struct LargeEntry: TimelineEntry {
    let date: Date
    let movies: [Movie]
    let selectedId: Int
    
    init(date: Date, movies: [Movie], selectedId: Int) {
        self.date = date
        self.movies = movies
        self.selectedId = selectedId
    }
    
    init(date: Date) {
        self.date = date
        self.movies = []
        self.selectedId = Int.min
    }
}
