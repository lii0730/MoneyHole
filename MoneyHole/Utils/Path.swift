//
//  Path.swift
//  MoneyHole
//
//  Created by LeeHsss on 2023/02/18.
//

import Foundation


class Path {
    static func getCategoryPath() -> String {
        return "Category"
    }
    
    static func getHistoryPath(date: Date) -> String {
        return "History/\(date.year)/\(date.yearMonth)"
    }
}
