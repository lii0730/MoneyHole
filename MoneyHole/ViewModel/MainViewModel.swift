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
///  2. 해당 월에 대한 총 지출, 수입 계산 -> UI쪽으로 전달(Observable)
class MainViewModel {
    
    var monthlyTotalSubject: PublishSubject<(Int, Int)> = PublishSubject<(Int, Int)>()
    var historySubject: BehaviorSubject<[History]> = BehaviorSubject(value: [])
    var getHistorySubject: PublishSubject<Date> = PublishSubject<Date>()
    var getMonthTotalSubject: PublishSubject<Date> = PublishSubject<Date>()
    let disposeBag = DisposeBag()
    
    init() {
        self.getHistorySubject.subscribe(onNext: { [weak self] date in
            self?.getHistory(date: date)
        })
        .disposed(by: disposeBag)
        
        self.getMonthTotalSubject.subscribe(onNext: { [weak self] date in
            self?.getTotalMonthly(date: date)
        })
        .disposed(by: disposeBag)
    }
    
    //MARK: - 선택된 날짜에 따른 History 내역 조회
    func getHistory(date: Date) {
        DBUtil.shared.getHistories(date: date) { histories in
            self.historySubject.onNext(histories)
        }
    }
    
    //MARK: - 월 지출 / 수입 총합
    func getTotalMonthly(date: Date) {
        DBUtil.shared.getTotalMonthly(date: date) { [weak self] incomeTotal, spendTotal in
            self?.monthlyTotalSubject.onNext((incomeTotal, spendTotal))
        }
    }
}
