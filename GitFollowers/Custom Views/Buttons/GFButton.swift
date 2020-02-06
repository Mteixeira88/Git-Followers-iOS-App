//
//  GFButton.swift
//  GitFollowers
//
//  Created by Miguel Teixeira on 02/01/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        set(backgroundColor: backgroundColor, title: title)
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
    
    private func configure() {
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        // Always add "translatesAutoresizingMaskIntoConstraints" to new Views to allow the constraints to work
        translatesAutoresizingMaskIntoConstraints = false
    }

}
