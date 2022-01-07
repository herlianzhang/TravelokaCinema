//
//  IndicatorCell.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 05/01/22.
//

import UIKit

class IndicatorCell: UICollectionViewCell {
    
    lazy var indicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .background
        
        addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(12)
        }
        indicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if !indicator.isAnimating {
            indicator.startAnimating()
        }
    }
}
