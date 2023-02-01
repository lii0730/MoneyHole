//
//  ViewController.swift
//  MoneyHole
//
//  Created by LeeHsss on 2023/02/01.
//

import UIKit
import FirebaseFirestore
import FSCalendar

class ViewController: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    let database = Firestore.firestore()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.scope = .month
        self.calendarView.locale = Locale(identifier: "ko_KR")
        self.calendarView.scrollDirection = .vertical
        self.calendarView.appearance.headerDateFormat = "YYYY년 MM월"
        self.calendarView.appearance.headerTitleAlignment = .left
        
        formatter.dateFormat = "yyyy-MM-dd"
        
//        let docRef = database.document("iosacademy/example")
//        docRef.getDocument { snp, err in
//            guard let data = snp?.data(), err == nil else { return }
//            print(data)
//        }
        
//        writeData(text: "Hello")
    }

    func writeData(path: String) {
        let docRef = database.document(path).setData([
            "1" : 1,
            "2" : 2,
            "3" : 3
        ], merge: false)
        
    }
}

extension ViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
        
//        print("\(components.year)")
//        print("\(components.month)")
//        print("\(components.day)")
        print("Selected:: \(formatter.string(from:date))")
        
        
        writeData(path: "History/" + "\(components.year!)/" + "\(components.year!)-\(components.month!)/" + "\(formatter.string(from:date))")
    }
}

extension ViewController: FSCalendarDataSource {
    
}

extension ViewController: FSCalendarDelegateAppearance {
    
}

