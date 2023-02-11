//
//  HistoryTableViewCell.swift
//  MoneyHole
//
//  Created by LeeHsss on 2023/02/02.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    static let cellId = "HistoryCell"
    
    let categoryLabel = UILabel()
    let noteLabel = UILabel()
    let priceLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func layout() {
        self.addSubview(self.categoryLabel)
        self.addSubview(self.noteLabel)
        self.addSubview(self.priceLabel)
        
        self.categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.categoryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.categoryLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2).isActive = true
        self.categoryLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.categoryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.categoryLabel.textAlignment = .left
        
        self.noteLabel.translatesAutoresizingMaskIntoConstraints = false
        self.noteLabel.leadingAnchor.constraint(equalTo: self.categoryLabel.trailingAnchor, constant: 0).isActive = true
        self.noteLabel.trailingAnchor.constraint(equalTo: self.priceLabel.leadingAnchor, constant: 0).isActive = true
        self.noteLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.noteLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.noteLabel.textAlignment = .left
        
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.priceLabel.leadingAnchor.constraint(equalTo: self.noteLabel.trailingAnchor, constant: 0).isActive = true
        self.priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        self.priceLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.priceLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.priceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.priceLabel.textAlignment = .right
    }
    
    func setHistory(history: History) {
        
        if history.state == 1 {
            self.noteLabel.textColor = .tintColor
            self.priceLabel.textColor = .tintColor
        } else {
            self.noteLabel.textColor = .red
            self.priceLabel.textColor = .red
        }
        self.categoryLabel.text = "Test"
        self.noteLabel.text = history.note
        self.priceLabel.text = history.price.currency
        
    }
}
