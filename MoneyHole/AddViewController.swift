//
//  AddViewController.swift
//  MoneyHole
//
//  Created by LeeHsss on 2023/02/13.
//

import UIKit
import RxSwift
import RxCocoa

class AddViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let viewModel: AddViewModel = AddViewModel()
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        self.initBind()
    }
    
    // 창 닫기
    @IBAction func closeHistory(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // 기록 DB 저장
    @IBAction func saveHistory(_ sender: UIButton) {
        
        if let note = self.memoTextField.text, let priceString = self.priceTextField.text {
            guard let selectedDate = self.selectedDate else { return }
            let price: Int = Int(priceString) ?? 0
            
            
            self.viewModel.insertHistory(date: selectedDate, note: note, price: price)
            self.dismiss(animated: true)
        }
    }
    
    private func initBind() {
        self.pickerView.rx.itemSelected.asObservable()
            .subscribe(onNext: { row, component in
                self.viewModel.getCategorySubject.onNext((row, component))
            })
            .disposed(by: disposeBag)
        
        self.viewModel.lastCategorySubject
            .subscribe(onNext: { categories in
                self.viewModel.lastCategory = categories
                self.pickerView.reloadComponent(2)
            })
            .disposed(by: disposeBag)
    }
}

extension AddViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.viewModel.firstCategory[row]
        } else if component == 1 {
            return self.viewModel.secondCategory[row]
        } else {
            return self.viewModel.lastCategory[row]
        }
    }
}

extension AddViewController: UIPickerViewDataSource {
    // 고정 / 가변, 지출/수입, 카테고리별 리스트
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            // 고정 / 가변
            return self.viewModel.firstCategory.count
        } else if component == 1 {
            // 지출 / 수입
            return self.viewModel.secondCategory.count
        } else {
            // 카테고리별 리스트
            return self.viewModel.lastCategory.count
        }
    }
}
