//
//  MovieViewModel.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 05/01/22.
//

import Foundation
import RxDataSources
import RxSwift

enum MovieType {
    case content(data: MovieListModel)
    case footer
}

struct Movie: IdentifiableType, Equatable {
    let type: MovieType
    var backgroundColor: UIColor?
    var textColor: UIColor?
    
    init(type: MovieType, backgroundColor: UIColor? = nil, textColor: UIColor? = nil) {
        self.type = type
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    var identity: Int {
        switch type {
        case .content(let data):
            return data.id
        case .footer:
            return Int.max
        }
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        if lhs.backgroundColor != rhs.backgroundColor || lhs.textColor != rhs.textColor {
            return false
        }
        
        switch (lhs.type, rhs.type) {
        case (let .content(lhsData), let .content(rhsData)):
            return lhsData == rhsData
        case (.footer, .footer):
            return true
        default:
            return false
        }
    }
}

class MovieListViewModel {
    let service: MovieServiceDelegate

    private var movies: [MovieListModel] = []
    let data: BehaviorSubject<[Movie]> = BehaviorSubject(value: [])
    let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    
    private var cacheBackgroundColor: [String: (backgroundColor: UIColor?, textColor: UIColor?)] = [:]
    
    private var page = 1
    private var isFetching = false

    init(service: MovieServiceDelegate) {
        self.service = service
        fetchUpComingMovie()
    }
    
    func fetchUpComingMovie() {
        isFetching = true
        service.fetchUpComingMovie(page: page) { movies in
            self.movies += movies
            var showedData = self.movies.map { (movie) -> Movie in
                let tmp = self.cacheBackgroundColor[movie.poster]
                return Movie(type: .content(data: movie), backgroundColor: tmp?.backgroundColor, textColor: tmp?.textColor)
            }
            if !movies.isEmpty {
                showedData.append(Movie(type: .footer))
            }
            self.data.onNext(showedData)
            self.page += 1
            self.isFetching = false
            self.isLoading.onNext(false)
        } failure: { message, code in
            // TODO - if needed
            self.isFetching = false
            self.isLoading.onNext(false)
        }
    }
    
    func refreshData() {
        movies = []
        page = 1
        isFetching = false
        self.isLoading.onNext(true)
        fetchUpComingMovie()
    }
    
    func getMovie(_ index: Int) -> MovieListModel? {
        if !(0..<movies.count).contains(index) { return nil }
        return movies[index]
    }
    
    func fetchNextPageIfNeeded(index: Int) {
        if !isFetching && index == movies.count {
            fetchUpComingMovie()
        }
    }
    
    func updateBackgroundColor(path: String, image: UIImage?, index: Int) {
        guard cacheBackgroundColor[path] == nil,
              let backgroundColor = image?.averageColor else {
            return
        }
        let textColor: UIColor? = backgroundColor.isDarkColor ? .white : .black
        cacheBackgroundColor[path] = (backgroundColor, textColor)
        guard var currentData = try? data.value() else { return }
        currentData[index].backgroundColor = backgroundColor
        currentData[index].textColor = textColor
        data.onNext(currentData)
        
    }
}
