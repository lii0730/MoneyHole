//
//  MainViewModel.swift
//  MoneyHole
//
//  Created by LeeHsss on 2023/02/01.
//

import Foundation
import RxSwift


/// 기능정의
///  1. 캘린더에서 날짜를 선택하면 해당 날짜에 맞는 입,출 내역 조회 -> UI쪽으로 전달 (Subject, Observable)
class MainViewModel {
    
    var historySubject: BehaviorSubject<[History]> = BehaviorSubject(value: [])
    var dateSubject: PublishSubject<Date> = PublishSubject<Date>()
    let disposeBag = DisposeBag()
    
    init() {
        self.dateSubject.subscribe(onNext: { [weak self] date in
            self?.getHistory(date: date)
        })
        .disposed(by: disposeBag)
    }
    
    //MARK: - 선택된 날짜에 따른 History 내역 조회
    func getHistory(date: Date) {
        DBUtil.shared.getData4Histories(date: date) { histories in
            self.historySubject.onNext(histories)
        }
    }
}
