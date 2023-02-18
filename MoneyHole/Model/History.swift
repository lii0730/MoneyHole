//
//  History.swift
//  MoneyHole
//
//  Created by LeeHsss on 2023/02/01.
//

import Foundation

//MARK: - 입,출 내역을 위한 모델
struct History {
    var uuid: String? // uuid
    let note: String // 내역
    let price: Int // 가격
    let isFixed: Bool // 고정지출 여부
    let state: Int // 입금: 1 , 출금: 2
    let date: String
    let categoryName: String
    let regTime: TimeInterval
}
