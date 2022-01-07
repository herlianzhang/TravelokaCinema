//
//  ViewController.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 04/01/22.
//

import UIKit
import SnapKit
import RxDataSources
import SDWebImage
import RxSwift

class MovieListViewController: UIViewController {
    private let viewModel: MovieListViewModel
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.backgroundColor = .background
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(IndicatorCell.self, forCellWithReuseIdentifier: "indicator")
        collectionView.contentInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        return collectionView
    }()
    
    private lazy var loadingView = LoadingView()
    
    private lazy var refreshControl = UIRefreshControl()

    private lazy var dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Movie>>(
        configureCell: { (_, collectionView, indexPath, data) in
            switch data.type {
            case .content(let movie):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MovieCell else {
                    break
                }
                cell.poster.sd_imageIndicator = self.traitCollection.userInterfaceStyle == .dark ? SDWebImageActivityIndicator.white : SDWebImageActivityIndicator.gray
                cell.poster.sd_imageIndicator?.startAnimatingIndicator()
                cell.poster.sd_setImage(with: URL(string: movie.poster)) { image, _, _, _ in
                    cell.poster.sd_imageIndicator = nil
                    self.viewModel.updateBackgroundColor(path: movie.poster, image: image, index: indexPath.item)
                }
                cell.setBackgroundColor(data.backgroundColor)
                cell.setTextcolor(data.textColor)
                cell.title.text = movie.title
                cell.releaseDate.text = movie.releaseDate
                return cell
            case .footer:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "indicator", for: indexPath) as? IndicatorCell else {
                    break
                }
                return cell
            }
            return UICollectionViewCell()
        })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming Movie"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        viewModel
            .data
            .asObserver()
            .asDriver(onErrorJustReturn: [])
            .map { [AnimatableSectionModel(model: "", items: $0)] }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel
            .isLoading
            .asObserver()
            .bind { isLoading in
                if isLoading {
                    self.loadingView.show()
                } else {
                    self.loadingView.hide()
                    self.refreshControl.endRefreshing()
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc
    private func refreshData() {
        viewModel.refreshData()
    }
}

extension MovieListViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, columnWidth width: CGFloat, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let movie: MovieListModel = viewModel.getMovie(indexPath.item) else { return 50 }
        let approximateWidth = width - 24
        let size = CGSize(width: approximateWidth, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let estimateFrame = NSString(string: movie.title ?? "").boundingRect(with: size,
                                                                             options: .usesLineFragmentOrigin,
                                                                             attributes: attributes,
                                                                             context: nil)
        return estimateFrame.height + (width - 4) * 1.5 + 48
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.fetchNextPageIfNeeded(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel.getMovie(indexPath.item) else { return }
        let viewModel = MovieDetailViewModel(service: MovieService(), movieId: movie.id)
        let vc = MovieDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
