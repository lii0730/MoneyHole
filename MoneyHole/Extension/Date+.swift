//
//  Date+.swift
//  MoneyHole
//
//  Created by LeeHsss on 2023/02/02.
//

import Foundation


extension Date {
    var year: String {
        let dateComponents = Calendar.current.dateComponents([.year], from: self)
        return "\(dateComponents.year!)"
    }
    
    var yearMonth: String {
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: self)
        return "\(dateComponents.year!)-\(dateComponents.month!)"
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: self)
    }
    
    var navigationTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        
        return formatter.string(from: self)
    }
}
