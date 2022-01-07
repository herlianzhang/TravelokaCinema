//
//  LoadingView.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 06/01/22.
//

import UIKit
import Lottie

class LoadingView: UIView {
    
    private lazy var lottie: AnimationView = {
        let animationView = AnimationView(name: "loading")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .cardColor?.withAlphaComponent(0.7)
        layer.cornerRadius = 24
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 12
        
        addSubview(lottie)
        lottie.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
            make.size.equalTo(200)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hide() {
        lottie.stop()
        isHidden = true
    }
    
    func show() {
        lottie.play()
        isHidden = false
    }
}
