//
//  AutoSizedCollectionView.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 07/01/22.
//

import UIKit

class AutoSizedCollectionView: UICollectionView {

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
