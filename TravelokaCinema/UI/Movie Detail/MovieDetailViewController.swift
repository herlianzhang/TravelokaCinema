//
//  MovieDetailViewController.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 06/01/22.
//

import UIKit
import RxSwift

struct DetailModel {
    let header: String
    let body: String
}

class MovieDetailViewController: UIViewController {
    private let viewModel: MovieDetailViewModel
    
    private let disposeBag = DisposeBag()
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var contentView = UIView()
    
    private lazy var headerView = UIView()
    
    private lazy var loadingView = LoadingView()
    
    private lazy var refreshControl = UIRefreshControl()
    
    private var castsData: [Profile] = []
    
    private lazy var coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var languageBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.textColor.cgColor
        return view
    }()
    
    private lazy var language: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var releaseDate: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var dot: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        view.backgroundColor = UIColor.textColor
        return view
    }()
    
    private lazy var duration: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var genre: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var tagline: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 16)
        label.alpha = 0.6
        return label
    }()
    
    private lazy var overviewHeader: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var overview: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var director: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var directorJob: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var topBilledCast: UILabel = {
        let label = UILabel()
        label.text = "Top Billed Cast"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let estimateWidth = view.frame.width / 3.5
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .background
        collectionView.contentInset = UIEdgeInsets(top: 6, left: 24, bottom: 6, right: 24)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var detailStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 24
        stackView.alignment = .leading
        return stackView
    }()
    
    required init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Detail"
        
        view.backgroundColor = .background
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        headerView.addSubview(coverImage)
        coverImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(coverImage.snp.width).dividedBy(2)
        }
        
        headerView.addSubview(posterImage)
        posterImage.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(coverImage).inset(16)
            make.width.equalTo(posterImage.snp.height).dividedBy(1.5)
        }
        
        headerView.addSubview(movieTitle)
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(coverImage.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        headerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        languageBackground.addSubview(language)
        language.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        [languageBackground, releaseDate, dot, duration]
            .forEach { stackView.addArrangedSubview($0) }
        
        dot.snp.makeConstraints { make in
            make.size.equalTo(4)
        }
        
        headerView.addSubview(genre)
        genre.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        headerView.addSubview(tagline)
        tagline.snp.makeConstraints { make in
            make.top.equalTo(genre.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        headerView.addSubview(overviewHeader)
        overviewHeader.snp.makeConstraints { make in
            make.top.equalTo(tagline.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        headerView.addSubview(overview)
        overview.snp.makeConstraints { make in
            make.top.equalTo(overviewHeader.snp.bottom).offset(12)
            make.leading.trailing.equalTo(overviewHeader)
        }
        
        headerView.addSubview(director)
        director.snp.makeConstraints { make in
            make.top.equalTo(overview.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().offset(24)
        }
        
        headerView.addSubview(directorJob)
        directorJob.snp.makeConstraints { make in
            make.top.equalTo(director.snp.bottom).offset(8)
            make.leading.trailing.equalTo(director)
            make.bottom.equalToSuperview().inset(24)
        }
        
        contentView.addSubview(topBilledCast)
        topBilledCast.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topBilledCast.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        contentView.addSubview(detailStack)
        detailStack.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.leading.trailing.bottom.equalToSuperview().inset(24)
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        scrollView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        viewModel
            .data
            .asObserver()
            .bind(onNext: setupData(detail:))
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
        viewModel.fetchMovieDetail()
    }
    
    private func setupData(detail: MovieDetailModel) {
        coverImage.sd_setImage(with: URL(string: detail.backdrop)) { image, _, _, _ in
            if let color = image?.averageColor {
                self.setupHeaderColor(color)
            }
        }
        posterImage.sd_setImage(with: URL(string: detail.poster))
        movieTitle.text = detail.title
        language.text = detail.originalLanguage?.uppercased()
        releaseDate.text = detail.releaseDate
        duration.text = detail.prettifyDuration
        genre.text = detail.prettifyGenre
        tagline.text = detail.tagline
        overview.text = detail.overview
        director.text = detail.director
        directorJob.text = detail.directorJob
        
        if let casts = (detail.credits?.cast?.compactMap { $0 }) {
            castsData = casts
            collectionView.reloadData()
        }
        
        detailStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        [DetailModel(header: "Original Title", body: detail.originalTitle ?? "-"),
         DetailModel(header: "Status", body: detail.status ?? "-"),
         DetailModel(header: "Original Language", body: detail.originalLanguage ?? "-"),
         DetailModel(header: "Budget", body: detail.budget?.currencyFormatting() ?? "-"),
         DetailModel(header: "Revenue", body: detail.revenue?.currencyFormatting() ?? "-"),]
            .map({ DetailView(header: $0.header, body: $0.body) })
            .forEach { detailStack.addArrangedSubview($0)}
    }
    
    private func setupHeaderColor(_ color: UIColor) {
        headerView.backgroundColor = color
        let tintColor: UIColor = color.isDarkColor ? .white : .black
        [movieTitle, releaseDate, language, duration, genre, tagline, overviewHeader, overview, director, directorJob]
            .forEach { $0.textColor = tintColor}
        languageBackground.layer.borderColor = tintColor.cgColor
        dot.backgroundColor = tintColor
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProfileCell else {
            return UICollectionViewCell()
        }
        let cast = castsData[indexPath.item]
        cell.name.text = cast.name
        cell.avatar.sd_setImage(with: URL(string: cast.avatar))
        return cell
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimateHeight = collectionView.frame.height - 12
        return CGSize(width: estimateHeight * 0.7, height: estimateHeight)
    }
}
