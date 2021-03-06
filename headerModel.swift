//
//  headerModel.swift
//  PrettyMessage
//
//  Created by Emil Shpeklord on 05.05.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class sectionHeader: UICollectionReusableView {
    
    static let reuseId = "header"
    
    let title = UILabel()
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        custom()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func custom() {
        title.textColor = UIColor(named: "textColor")
        title.font = UIFont(name: "Helvetica Neue", size: 30)
        title.isHighlighted = true
        title.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitleColor(UIColor(named: "ButtonColor"), for: .normal)
        button.setTitle("Все", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 17)
        button.isUserInteractionEnabled = true
        button.contentHorizontalAlignment = .right
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        addSubview(button)
        addSubview(title)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: centerXAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
            title.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.85),
            
            button.leadingAnchor.constraint(equalTo: title.trailingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.85),
            button.widthAnchor.constraint(equalTo: widthAnchor, constant: 0.1)
            ])
    }
    
}
