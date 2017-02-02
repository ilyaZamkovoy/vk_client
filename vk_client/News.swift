//
//  News.swift
//  vk_client
//
//  Created by Zamkovoy Ilya on 05/01/2017.
//  Copyright © 2017 Zamkovoy Ilya. All rights reserved.
//

import Foundation

class News {

    var id: Int!
    var text: String!
    var date: Double!
    var photo: String!
    var ownerApiId: String!
    var index: Int?
    
    var user: User!
    var group: Group!
    
    var finalDate: String {
        let date = NSDate(timeIntervalSince1970: self.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateInFormat = dateFormatter.string(from: date as Date)
        return dateInFormat
    }
    
    var finalText: String {
        if self.text.isEmpty{
            return ""
        } else {
            return self.text
        }
    }
    
    var finalOwner: Owner {
        if self.user != nil {
            return self.user
        } else {
            return self.group
        }
    }
    
}
