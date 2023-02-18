//
//  DBUtil.swift
//  MoneyHole
//
//  Created by LeeHsss on 2023/02/01.
//

import Foundation
import FirebaseFirestore
import RxSwift

class DBUtil {
    static let shared = DBUtil()
    let database = Firestore.firestore()
    
    //MARK: - Get
    // 날짜에 해당하는 내역 조회
    func getHistories(date: Date, completion: @escaping ([History]) -> Void) {
        var histories: [History] = []
        
        let query = self.database.collection(Path.getHistoryPath(date: date))
            .whereField("date", isEqualTo: date.dateString)
        
        query.getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            
            for doc in docs {
                
                guard let uuid = doc.get("uuid") as? String else { return }
                guard let note = doc.get("note") as? String else { return }
                guard let price = doc.get("price") as? Int else { return }
                guard let isFixed = doc.get("isFixed") as? Bool else { return }
                guard let state = doc.get("state") as? Int else { return }
                guard let date = doc.get("date") as? String else { return }
                guard let categoryName = doc.get("categoryName") as? String else { return }
                guard let regTime = doc.get("regTime") as? TimeInterval else { return }
                
                let history = History(uuid: uuid, note: note, price: price, isFixed: isFixed, state: state, date: date, categoryName: categoryName, regTime: regTime)
                histories.append(history)
            }
            
            completion(histories.sorted(by: {
                $0.regTime < $1.regTime
            }))
        }
        
    }
        
    // 입, 출 상태에 카테고리 목록 조회
    func getCategories(state: Int, isFixed: Bool, completion: @escaping ([Category]) -> Void) {
        var categories: [Category] = []
        
        let query = self.database.collection(Path.getCategoryPath())
            .whereField("state", isEqualTo: state)
            .whereField("isFixed", isEqualTo: isFixed)
        
        query.getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            
            for doc in docs {
                
                guard let uuid = doc.get("uuid") as? String else { return }
                guard let state = doc.get("state") as? Int else { return }
                guard let isFixed = doc.get("isFixed") as? Bool else { return }
                guard let name = doc.get("name") as? String else { return }
                
                let category = Category(uuid: uuid, state: state, isFixed: isFixed, name: name)
                categories.append(category)
            }
            
            completion(categories)
        }
    }
    
    func getCategory(uuid: String, completion: @escaping (Category) -> Void) {
        let query = self.database.collection(Path.getCategoryPath())
            .whereField("uuid", isEqualTo: uuid)
        
        query.getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            
            if docs.count == 1 {
                
                guard let uuid = docs[0].get("uuid") as? String else { return }
                guard let state = docs[0].get("state") as? Int else { return }
                guard let isFixed = docs[0].get("isFixed") as? Bool else { return }
                guard let name = docs[0].get("name") as? String else { return }
                
                let category = Category(uuid: uuid, state: state, isFixed: isFixed, name: name)
                completion(category)
            }
            
        }
    }
    
    /// state: 1 이면 해당 월에 총 수입 조회
    /// state: 2 이면 해당 월에 총 지출 조회
    func getTotalMonthly(date: Date, completion: @escaping (Int, Int) -> Void) {
        var incomeTotal: Int = 0
        var spendTotal: Int = 0
        
        let query = self.database.collection(Path.getHistoryPath(date: date))
        
        query.getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            
            for doc in docs {
                guard let state = doc.get("state") as? Int else { return }
                guard let price = doc.get("price") as? Int else { return }
                
                if state == 1 {
                    incomeTotal += price
                } else {
                    spendTotal += price
                }
            }
            
            completion(incomeTotal, -spendTotal)
        }
    }
    
    //MARK: - Insert
    // 입,출 내역 입력
    func insertHistory(date: Date, data: History) {
        let newDoc = self.database.collection(Path.getHistoryPath(date: date)).document()
        let model = History(uuid: newDoc.documentID, note: data.note, price: data.price, isFixed: data.isFixed, state: data.state, date: data.date, categoryName: data.categoryName, regTime: data.regTime)
        newDoc.setData([
            "uuid" : model.uuid ?? newDoc.documentID,
            "note" : model.note,
            "price" : model.price,
            "isFixed" : model.isFixed,
            "state": model.state,
            "date" : model.date,
            "categoryName": model.categoryName,
            "regTime": model.regTime
        ], merge: true)
    }
    
    // 카테고리 추가
    func insertCategory(data: Category) {
        let newDoc = self.database.collection(Path.getCategoryPath()).document()
        let model = Category(uuid: newDoc.documentID, state: data.state, isFixed: data.isFixed, name: data.name)
        newDoc.setData([
            "uuid" : model.uuid ?? newDoc.documentID,
            "state" : model.state,
            "isFixed" :model.isFixed,
            "name" : model.name
        ], merge: true)
        
    }
    
    //MARK: - Update
    func updateHistory(path: String, data: History) {
        
    }
    
    func updateCategory(path: String, data: Category) {
        
    }
    
    //MARK: - Delete
    func deleteHistory(path: String, data: History) {
        
    }
    
    func deleteCategory(path: String, data: Category) {
        
    }
        
}
