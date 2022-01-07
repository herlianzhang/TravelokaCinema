//
//  DetailView.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 07/01/22.
//

import UIKit

class DetailView: UIView {
    
    private lazy var header: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var body: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var value: (header: String, body: String)? = nil {
        didSet {
            header.text = value?.header
            body.text = value?.body
        }
    }
    
    required init(header: String, body: String) {
        super.init(frame: .zero)
        self.header.text = header
        self.body.text = body
        setupView()
    }
    
    private func setupView() {
        addSubview(header)
        header.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        addSubview(body)
        body.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
