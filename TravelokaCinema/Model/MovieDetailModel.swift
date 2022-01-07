//
//  MovieDetailModel.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 07/01/22.
//

import Foundation

struct Genre: Codable {
    let name: String?
}

struct Profile: Codable {
    let name: String?
    let profilePath: String?
    let job: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
        case job
    }
    
    var avatar: String {
        guard let path = profilePath else { return "" }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
}

struct Credit: Codable {
    let cast: [Profile]?
    let crew: [Profile]?
}

struct MovieDetailModel: Codable {
    let backdropPath: String?
    let posterPath: String?
    let originalLanguage: String?
    let title: String?
    let overview: String?
    let releaseDate: String?
    let originalTitle: String?
    let revenue: Int?
    let budget: Int?
    let status: String?
    let genres: [Genre]?
    let credits: Credit?
    let duration: Int?
    let tagline: String?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case title
        case overview
        case releaseDate = "release_date"
        case originalTitle = "original_title"
        case revenue
        case budget
        case status
        case genres
        case credits
        case duration = "runtime"
        case tagline
    }
    
    var poster: String {
        guard let path = posterPath else { return "" }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
    
    var backdrop: String {
        guard let path = backdropPath else { return "" }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
    
    var prettifyGenre: String {
        guard let genres = (self.genres?.compactMap { $0.name }) else { return "" }
        return genres.joined(separator: ", ")
    }
    
    var director: String {
        guard let directorName = (credits?.crew?.filter { $0.job == "Director"}.first?.name) else { return "" }
        return directorName
    }
    
    var directorJob: String {
        guard let jobs = (credits?.crew?.filter { $0.name == director}.compactMap { $0.job }) else { return "" }
        return jobs.joined(separator: ", ")
    }
    
    var prettifyDuration: String {
        guard let duration = self.duration,
              duration != 0 else { return "" }
        let hour = duration / 60
        let minute = duration % 60
        return "\(hour)h \(minute)m"
    }
}
