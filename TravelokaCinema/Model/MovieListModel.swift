//
//  MovieListModel.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 05/01/22.
//

import Foundation

struct MovieListModel: Codable, Equatable {
    let id: Int
    let title: String?
    let posterPath: String?
    let releaseDate: String?
    let overview: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview
    }
    
    var poster: String {
        guard let path = posterPath else { return "" }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
}
