//
//  ProfileCell.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 07/01/22.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .cardColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 4
        layer.cornerRadius = 12
        
        addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        addSubview(name)
        name.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
