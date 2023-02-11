//
//  Int+.swift
//  MoneyHole
//
//  Created by LeeHsss on 2023/02/11.
//

import Foundation

extension Int {
    var currency: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "ko_KR")
        numberFormatter.numberStyle = .currency
        
        return numberFormatter.string(for: self)!
    }
}
