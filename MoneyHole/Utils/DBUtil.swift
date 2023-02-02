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
    func getData4Histories(date: Date, completion: @escaping ([History]) -> Void) {
        var histories: [History] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        guard let year = dateComponents.year else { return }
        guard let month = dateComponents.month else { return }
        
        let dateString = formatter.string(from: date)
        
        let query = DBUtil.shared.database.collection("History/\(year)/\(year)-\(month)")
            .whereField("date", isEqualTo: dateString)
        
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
    func getData4Categories(state: Int) -> Observable<[Category]> {
        return Observable.never()
    }
    
    //MARK: - Insert
    // 입,출 내역 입력
    func insertData4History(path: String, data: History) {
        
    }
    
    // 카테고리 추가
    func insertData4Category(path: String, data: Category) {
        
    }
    
    //MARK: - Update
    func updateData4History(path: String, data: History) {
        
    }
    
    func updateData4Category(path: String, data: Category) {
        
    }
    
    //MARK: - Delete
    func deleteData4History(path: String, data: History) {
        
    }
    
    func deleteData4Category(path: String, data: Category) {
        
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
