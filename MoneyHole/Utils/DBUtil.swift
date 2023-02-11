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
        
        let query = self.database.collection("History/\(date.year)/\(date.yearMonth)")
            .whereField("date", isEqualTo: date.dateString)
        
        query.getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            
            for doc in docs {
                
                guard let uuid = doc.get("uuid") as? String else { return }
                guard let note = doc.get("note") as? String else { return }
                guard let price = doc.get("price") as? Int else { return }
                guard let state = doc.get("state") as? Int else { return }
                guard let isFixed = doc.get("isFixed") as? Bool else { return }
                guard let date = doc.get("date") as? String else { return }
                
                let history = History(uuid: uuid, note: note, price: price, isFixed: isFixed, state: state, date: date)
                histories.append(history)
            }
            
            completion(histories)
        }
        
    }
        
    // 입, 출 상태에 카테고리 목록 조회
    func getCategories(state: Int, completion: @escaping ([Category]) -> Void) {
        var categories: [Category] = []
        
        let query = self.database.collection("Category")
            .whereField("state", isEqualTo: state)
        
        query.getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            
            for doc in docs {
                
                guard let uuid = doc.get("uuid") as? String else { return }
                guard let state = doc.get("state") as? Int else { return }
                guard let name = doc.get("name") as? String else { return }
                
                let category = Category(uuid: uuid, state: state, name: name)
                categories.append(category)
            }
            
            completion(categories)
        }
    }
    
    /// state: 1 이면 해당 월에 총 수입 조회
    /// state: 2 이면 해당 월에 총 지출 조회
    func getTotalMonthly(date: Date, completion: @escaping (Int, Int) -> Void) {
        var incomeTotal: Int = 0
        var spendTotal: Int = 0
        
        let query = self.database.collection("History/\(date.year)/\(date.yearMonth)")
        
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
    func insertHistory(path: String, data: History) {
        let newDoc = self.database.collection(path).document()
        let model = History(uuid: newDoc.documentID, note: data.note, price: data.price, isFixed: data.isFixed, state: data.state, date: data.date)
        newDoc.setData([
            "uuid" : model.uuid ?? newDoc.documentID,
            "note" : model.note,
            "price" : model.price,
            "isFixed" : model.isFixed,
            "state" : model.state,
            "date" : model.date
        ], merge: true)
    }
    
    // 카테고리 추가
    func insertCategory(path: String, data: Category) {
        let newDoc = self.database.collection(path).document()
        let model = Category(uuid: newDoc.documentID, state: data.state, name: data.name)
        newDoc.setData([
            "uuid" : model.uuid ?? newDoc.documentID,
            "state" : model.state,
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
extension DBUtil {
    func writeData(path: String, date: String) {
        let newDoc = DBUtil.shared.database.collection(path).document()
        let model = History(uuid: newDoc.documentID, note: "식비", price: 15000, isFixed: false, state: 1, date: date)
        newDoc.setData([
            "uuid" : model.uuid,
            "note" : model.note,
            "price" : model.price,
            "isFixed" : model.isFixed,
            "state" : model.state,
            "date" : model.date
        ], merge: true)
        
    }
    
    func writeData2(path: String) {
        let newDoc = DBUtil.shared.database.collection(path).document()
        let model = Category(uuid: newDoc.documentID, state: 1, name: "월급")
        newDoc.setData([
            "uuid" : model.uuid,
            "state" : model.state,
            "name" : model.name
        ], merge: true)
    }
    
    func readData() {
        let query = DBUtil.shared.database.collection("History/2023/2023-2").whereField("date", isEqualTo: "2023-02-01")
        query.getDocuments { snapshot, error in
            let docs = snapshot!.documents
            
            
            var histories: [History] = []
            for doc in docs {
                
                guard let uuid = doc.get("uuid") as? String else { return }
                guard let note = doc.get("note") as? String else { return }
                guard let price = doc.get("price") as? Int else { return }
                guard let state = doc.get("state") as? Int else { return }
                guard let isFixed = doc.get("isFixed") as? Bool else { return }
                guard let date = doc.get("date") as? String else { return }
                
                let history = History(uuid: uuid, note: note, price: price, isFixed: isFixed, state: state, date: date)
                histories.append(history)
                
            }
            
            print(histories)
        }
    }
}
