//
//  AppDelegate.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 04/01/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let service = MovieService()
        let viewModel = MovieListViewModel(service: service)
        let vc = MovieListViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
        
        window?.rootViewController = nav
        window?.rootViewController?.view.backgroundColor = .background
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme,
           scheme.localizedCaseInsensitiveCompare("traveloka.cinema") == .orderedSame,
           let view = url.host {
            var parameters: [String: String] = [:]
            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                parameters[$0.name] = $0.value
            }
            
            if view == "detail", let id: Int = Int(parameters["id"] ?? "") {
                let topViewController = self.window?.rootViewController as? UINavigationController
                let viewModel = MovieDetailViewModel(service: MovieService(), movieId: id)
                //438695
                let detailVc = MovieDetailViewController(viewModel: viewModel)
                topViewController?.pushViewController(detailVc, animated: false)
            }
            
            print(scheme)
            print(view)
            print(parameters)
        }
        
        return true
    }
}

