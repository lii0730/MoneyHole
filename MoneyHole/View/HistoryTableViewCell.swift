//
//  HistoryTableViewCell.swift
//  MoneyHole
//
//  Created by LeeHsss on 2023/02/02.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    static let cellId = "HistoryCell"
    
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
        self.addSubview(self.noteLabel)
        self.addSubview(self.priceLabel)
        
        self.noteLabel.translatesAutoresizingMaskIntoConstraints = false
        self.noteLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.noteLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.noteLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.noteLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.priceLabel.leadingAnchor.constraint(equalTo: self.noteLabel.trailingAnchor, constant: 10).isActive = true
        self.priceLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.priceLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.priceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func setHistory(history: History) {
        
        if history.state == 1 {
            self.noteLabel.textColor = .blue
            self.priceLabel.textColor = .blue
        } else {
            self.noteLabel.textColor = .red
            self.priceLabel.textColor = .red
        }
        
        self.noteLabel.text = history.note
        self.priceLabel.text = "\(history.price)"
    }
}
