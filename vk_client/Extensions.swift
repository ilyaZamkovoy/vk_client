//
//  Extensions.swift
//  vk_client
//
//  Created by Zamkovoy Ilya on 01/02/2017.
//  Copyright © 2017 Zamkovoy Ilya. All rights reserved.
//

import Foundation

extension UITableViewCell {
    static func nib() -> UINib {
        let nib = UINib(nibName: nibName(), bundle: nil)
        return nib
    }
    
    static func nibName() -> String {
        return String.init(describing: self.self)
    }
    
    static func cellIdentifier() -> String {
        return String.init(describing: self.self)
    }
}
