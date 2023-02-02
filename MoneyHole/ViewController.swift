//
//  ViewController.swift
//  MoneyHole
//
//  Created by LeeHsss on 2023/02/01.
//

import UIKit
import FirebaseFirestore
import FSCalendar
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    let viewModel: MainViewModel = MainViewModel()
//    let formatter = DateFormatter()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
//        formatter.dateFormat = "yyyy-MM-dd"
        self.historyTableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.cellId)
        self.setCalendarView()
//        self.bindUI()
    }
}

extension ViewController {
    // MARK: - Calendar Init
    func setCalendarView() {
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.scope = .month
        self.calendarView.locale = Locale(identifier: "ko_KR")
        self.calendarView.scrollDirection = .vertical
        self.calendarView.appearance.headerDateFormat = "YYYY년 MM월"
        self.calendarView.appearance.headerTitleAlignment = .left
        
        self.calendarView.appearance.titleWeekendColor = .red
        self.calendarView.appearance.todayColor = .lightGray
        
        self.calendarView.select(Date())
    }
    
    
    // MARK: - Link Obervable
    func bindUI() {
        self.viewModel.dateSubject.onNext(Date())
        self.viewModel.historySubject.bind(to: self.historyTableView.rx.items(cellIdentifier: HistoryTableViewCell.cellId, cellType: HistoryTableViewCell.self)) { row, history, cell in
            cell.setHistory(history: history)
        }.disposed(by: disposeBag)
    }
}

extension ViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        self.viewModel.dateSubject.onNext(date)
        
//        let history = History(note: "자전거 구매", price: 150_000, isFixed: false, state: 2, date: formatter.string(from: date))
//        DBUtil.shared.insertHistory(path: "History/2023/2023-2", data: history)
    }
}

extension ViewController: FSCalendarDataSource {
    
}

extension ViewController: FSCalendarDelegateAppearance {
    
}

