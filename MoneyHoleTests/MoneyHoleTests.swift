//
//  MoneyHoleTests.swift
//  MoneyHoleTests
//
//  Created by LeeHsss on 2023/02/02.
//

import XCTest
@testable import MoneyHole

final class MoneyHoleTests: XCTestCase {
    
    var sut: DBUtil!
    
    // 실행 전 세팅
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DBUtil()
    }

    // 실행 후 세팅
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
}
