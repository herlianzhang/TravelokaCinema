//
//  MovieDetailViewModel.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 07/01/22.
//

import Foundation
import RxSwift

class MovieDetailViewModel {
    let service: MovieServiceDelegate
    let movieId: Int
    
    let data: PublishSubject<MovieDetailModel> = PublishSubject()
    
    let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    
    init(service: MovieServiceDelegate, movieId: Int) {
        self.service = service
        self.movieId = movieId
        fetchMovieDetail()
    }
    
    func fetchMovieDetail() {
        isLoading.onNext(true)
        service.fetchMovieDetail(id: movieId) { detail in
            self.data.onNext(detail)
            self.isLoading.onNext(false)
        } failure: { _, _ in
            // TODO - if needed
            self.isLoading.onNext(false)
        }
    }
}
