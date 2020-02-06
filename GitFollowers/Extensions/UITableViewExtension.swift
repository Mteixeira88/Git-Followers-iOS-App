//
//  UITableViewExtension.swift
//  GitFollowers
//
//  Created by Miguel Teixeira on 06/02/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
