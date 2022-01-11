//
//  Networking.swift
//  TravelokaCinemaWidgetExtension
//
//  Created by Herlian Zhang on 11/01/22.
//

import SDWebImage
import SwiftUI

func getUpComingMovie(completion: @escaping ([MovieListModel])->()) {
    let request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=fb209c5f2af30f7426f4e874f4d56212")!)
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return }
        let decoder = JSONDecoder()
        guard let movies = try? decoder.decode(UpComingMovieModel.self, from: data).results else { return }
        completion(movies)
    }.resume()
}

func downloadImages(paths: [String], completion: @escaping ([String: UIImage?])->()) {
    let imageRequestGroup = DispatchGroup()
    var images: [String: UIImage?] = [:]
    for path in paths {
        imageRequestGroup.enter()
        SDWebImageManager.shared.loadImage(with: URL(string: path), options: SDWebImageOptions(rawValue: 0), progress: nil) { image, _, _, _, _, _ in
            if let data = image?.jpegData(compressionQuality: 0.25) {
                images[path] = UIImage(data: data)
            }
            imageRequestGroup.leave()
        }
    }
    imageRequestGroup.notify(queue: .main) {
        completion(images)
    }
}
