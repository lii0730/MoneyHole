//
//  AddViewModel.swift
//  MoneyHole
//
//  Created by LeeHsss on 2023/02/01.
//

import Foundation
import RxSwift


/// 기능정의
/// 1. 입, 출 내역 추가 기능
/// 2. 입, 출 내역 수정 기능
/// 3. 입, 출 내역 삭제 기능
class AddViewModel {
    //MARK: - Rx
    let disposeBag = DisposeBag()
    let getCategorySubject: BehaviorSubject<(Int, Int)> = BehaviorSubject(value: (0,0))
    let lastCategorySubject: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    
    
    let firstCategory: [String] = ["고정", "가변"]
    let secondCategory: [String] = ["수입", "지출"]
    var lastCategory: [String] = []
    var categoryName: String = ""
    
    var isFixed: Bool = true
    var isIncome: Bool = true
    
    init() {
        self.setBind()
    }
    
    func setBind() {
        self.getCategorySubject.subscribe(onNext: { row, component in
           //MARK: - 넘어온 값에 따라 fixed, income 여부 결정 -> 해당하는 카테고리를 가져온다.
            
            if component == 0 {
                row == 0 ? self.setFixed(isFixed: true) : self.setFixed(isFixed: false)
            } else if component == 1 {
                row == 0 ? self.setIncome(isIncome: true) : self.setIncome(isIncome: false)
            } else {
                self.categoryName = self.lastCategory[row]
            }
            
            if component < 2 {
                if self.isIncome {
                    DBUtil.shared.getCategories(state: 1, isFixed: self.isFixed) { categories in
                        if categories.count > 0 {
                            self.lastCategorySubject.onNext(categories.map{$0.name})
                            self.categoryName = categories.map{$0.name}[0]
                        } else {
                            self.lastCategorySubject.onNext([])
                            self.categoryName = ""
                        }
                    }
                } else {
                    DBUtil.shared.getCategories(state: 2, isFixed: self.isFixed) { categories in
                        if categories.count > 0 {
                            self.lastCategorySubject.onNext(categories.map{$0.name})
                            self.categoryName = categories.map{$0.name}[0]
                        } else {
                            self.lastCategorySubject.onNext([])
                            self.categoryName = ""
                        }
                    }
                }
            }
        })
        .disposed(by: disposeBag)
    }
    
    
    func setFixed(isFixed: Bool) {
        self.isFixed = isFixed
    }
    
    func setIncome(isIncome: Bool) {
        self.isIncome = isIncome
    }
    
    func insertHistory(date: Date, note: String, price: Int) {
        let history = History(note: note, price: price, isFixed: self.isFixed, state: self.isIncome ? 1 : 2, date: date.dateString, categoryName: self.categoryName, regTime: Date.now.timeIntervalSince1970)
        DBUtil.shared.insertHistory(date: date, data: history)
    }
}
