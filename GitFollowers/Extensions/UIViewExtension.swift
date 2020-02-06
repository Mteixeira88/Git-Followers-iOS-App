//
//  UIViewExtension.swift
//  GitFollowers
//
//  Created by Miguel Teixeira on 06/02/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { (view) in
            addSubview(view)
        }
    }
}
