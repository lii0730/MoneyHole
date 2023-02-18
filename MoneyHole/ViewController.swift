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
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var totalSpendLabel: UILabel!
    
    let viewModel: MainViewModel = MainViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = Date().navigationTitle
        
        self.historyTableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.cellId)
        self.setCalendarView()
        self.bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.getMonthTotalSubject.onNext(self.calendarView.currentPage)
        self.viewModel.getHistorySubject.onNext(self.calendarView.selectedDate ?? Date.now)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddVC" {
            guard let AddVC = segue.destination as? AddViewController else { return }
            AddVC.selectedDate = self.calendarView.selectedDate!
        }
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
        self.calendarView.appearance.headerTitleOffset = CGPoint(x: 30, y: 0)
        self.calendarView.headerHeight = 0
        
        self.calendarView.appearance.titleWeekendColor = .red
        self.calendarView.appearance.todayColor = .lightGray
        self.calendarView.select(Date())
    }
    
    
    // MARK: - Link Obervable
    func bindUI() {
        self.viewModel.getHistorySubject.onNext(Date())
        self.viewModel.getMonthTotalSubject.onNext(Date())
        self.viewModel.historySubject.bind(to: self.historyTableView.rx.items(cellIdentifier: HistoryTableViewCell.cellId, cellType: HistoryTableViewCell.self)) { row, history, cell in
            cell.setHistory(history: history)
        }.disposed(by: disposeBag)
        
        self.viewModel.monthlyTotalSubject.subscribe(onNext: { (incomeTotal, spendTotal) in
            // Main VC header에 표시
            
            DispatchQueue.main.async {
                self.totalIncomeLabel.textColor = .tintColor
                self.totalSpendLabel.textColor = .red
                
                self.totalIncomeLabel.text = incomeTotal.currency
                self.totalSpendLabel.text = spendTotal.currency
            }
        }).disposed(by: disposeBag)
    }
}

extension ViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.viewModel.getHistorySubject.onNext(date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        DispatchQueue.main.async {
            self.navigationItem.title = calendar.currentPage.navigationTitle
        }
        self.viewModel.getMonthTotalSubject.onNext(calendar.currentPage)
    }
}

extension ViewController: FSCalendarDataSource {
    
}

extension ViewController: FSCalendarDelegateAppearance {
    
}

