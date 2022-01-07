//
//  Int+Extensions.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 07/01/22.
//

import Foundation

extension Int {
    func currencyFormatting() -> String {
        let value = Double(self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        if let str = formatter.string(for: value), value != 0 {
            return str
        } else {
            return "-"
        }
    }
}
