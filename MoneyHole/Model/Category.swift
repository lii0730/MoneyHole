//
//  Category.swift
//  MoneyHole
//
//  Created by LeeHsss on 2023/02/01.
//

import Foundation

//MARK: - 입,출 카테고리 항목 모델
struct Category {
    var uuid: String // uuid
    let state: Int // 1, 2 [입, 출]
    let name: String // 카테고리 이름
}
