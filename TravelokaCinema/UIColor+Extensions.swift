//
//  UIColor+Extensions.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 04/01/22.
//

import UIKit

extension UIColor {
    static let background = UIColor(named: "BackgroundColor")
    static let cardColor = UIColor(named: "CardColor")
    static let textColor: UIColor = UIColor(named: "TextColor") ?? .black
    
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50
    }
}
