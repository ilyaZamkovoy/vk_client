//
//  JSONParser.swift
//  vk_client
//
//  Created by Zamkovoy Ilya on 02/02/2017.
//  Copyright © 2017 Zamkovoy Ilya. All rights reserved.
//

import Foundation
import SwiftyVK

class JSONParser {
    
    class func parseNews(items: JSON, users: JSON, groups: JSON) -> News{
        
        let news = News()

        var postHasOnlyPhotos = true

        
            var k = 0
            var count = items["attachments"].count
            while count != 0{
                if items["attachments"].arrayValue[k]["type"].stringValue != "photo"{
                    postHasOnlyPhotos = false
                }
                k += 1
                count -= 1
            }
            
            if postHasOnlyPhotos == true{
                news.id = items["post_id"].intValue
                news.date = items["date"].doubleValue as NSNumber!
                news.ownerApiId = items["source_id"].stringValue
                
                if items["attachments"].arrayValue[0]["type"].stringValue == "photo"{
                    news.photo = items["attachments"].arrayValue[0]["photo"]["photo_604"].stringValue
                }
                
                news.text = items["text"].stringValue
                var id = news.ownerApiId
                
                var chars = id?.characters.map { String($0) }
                if chars?[0] == "-"{
                    id?.remove(at: (id?.startIndex)!)
                    let group = Group()
                    for j in 0...(groups.count - 1){
                        let number = groups[j]["id"].stringValue
                        if id == number{
                            group.id = groups[j]["id"].intValue
                            group.name = groups[j]["name"].stringValue
                            group.photo = groups[j]["photo_100"].stringValue
                            news.group = group
                        }
                    }
                } else if chars?[0] != "-"{
                    let user = User()
                    for j in 0...(users.count - 1){
                        let number = users[j]["id"].stringValue
                        
                        if id == number{
                            user.id = users[j]["id"].intValue
                            user.name = "\(users[j]["first_name"].stringValue) \(users[j]["last_name"].stringValue)"
                            user.photo = users[j]["photo_100"].stringValue
                            news.user = user
                        }
                    }
                }
        }
        return news
    }
}
