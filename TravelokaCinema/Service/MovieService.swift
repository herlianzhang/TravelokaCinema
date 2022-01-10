//
//  MovieService.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 05/01/22.
//

import Foundation
import Alamofire

protocol MovieServiceDelegate: AnyObject {
    func fetchUpComingMovie(page: Int,
                            success: @escaping (_ data: [MovieListModel]) -> Void,
                            failure: @escaping (_ message: String?, _ errorCode: Int?) -> Void)
    
    func fetchMovieDetail(id: Int,
                          success: @escaping (_ data: MovieDetailModel) -> Void,
                          failure: @escaping (_ message: String?, _ errorCode: Int?) -> Void)
}

class MovieService: MovieServiceDelegate {
    func fetchUpComingMovie(page: Int,
                            success: @escaping ([MovieListModel]) -> Void,
                            failure: @escaping (String?, Int?) -> Void) {
        let params: Parameters = [
            "page": page
        ]
        AF.request("https://api.themoviedb.org/3/movie/upcoming", parameters: params, headers: movieHeader)
            .responseDecodable(of: UpComingMovieModel.self) { response in
                if let data = response.value, let movies = data.results {
                    success(movies)
                } else {
                    failure(response.error?.errorDescription, response.error?.responseCode)
                }
            }
    }
    
    func fetchMovieDetail(id: Int,
                          success: @escaping (MovieDetailModel) -> Void,
                          failure: @escaping (String?, Int?) -> Void) {
        let params: Parameters = [
            "append_to_response": "credits"
        ]
        AF.request("https://api.themoviedb.org/3/movie/\(id)", parameters: params, headers: movieHeader)
            .validate()
            .responseDecodable(of: MovieDetailModel.self) { response in
                if let data = response.value {
                    success(data)
                } else {
                    failure(response.error?.errorDescription, response.error?.responseCode)
                }
            }
    }
}
