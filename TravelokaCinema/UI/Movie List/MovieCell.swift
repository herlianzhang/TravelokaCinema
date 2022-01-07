//
//  MovieCell.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 05/01/22.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    lazy var poster: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var releaseDate: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 6
        layer.cornerRadius = 12
        
        addSubview(poster)
        poster.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(2)
            make.height.equalTo(poster.snp.width).multipliedBy(1.5)
        }
        
        addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(poster.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        addSubview(releaseDate)
        releaseDate.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview().inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextcolor(_ color: UIColor?) {
        let textColor = color ?? .textColor
        title.textColor = textColor
        releaseDate.textColor = textColor
    }
    
    func setBackgroundColor(_ color: UIColor?) {
        backgroundColor = color ?? .cardColor
    }
}
