//
//  ApiWorker.swift
//  vk_client
//
//  Created by Zamkovoy Ilya on 01/01/2017.
//  Copyright © 2017 Zamkovoy Ilya. All rights reserved.
//
import Foundation
import SwiftyVK


final class APIWorker {

    
    class func authorize() {
        VK.logIn()
        print("SwiftyVK: authorize")
    }
    
    class func logout() {
        VK.logOut()
        print("SwiftyVK: LogOut")
    }
    
    class func getNews(callback: @escaping ([News]) -> Void){
        var newsArray = [News]()
        
        VK.API.custom(method: "newsfeed.get").send(
            onSuccess:{ response in
                
                var i = 0;
                
                while i != response["items"].count{
                    let news = News()
                    var finalCheck = true
                    
                    if response["items"].arrayValue[i]["attachments"] != nil{
                        var k = 0
                        var count = response["items"].arrayValue[i]["attachments"].count
                        while count != 0{
                            if response["items"].arrayValue[i]["attachments"].arrayValue[k]["type"].stringValue != "photo"{
                                finalCheck = false
                            }
                            k += 1
                            count -= 1
                        }
                        
                        if finalCheck == true{
                            news.id = response["items"].arrayValue[i]["post_id"].intValue
                            news.date = response["items"].arrayValue[i]["date"].doubleValue
                            news.ownerApiId = response["items"].arrayValue[i]["source_id"].stringValue
                            
                            if response["items"].arrayValue[i]["attachments"].arrayValue[0]["type"].stringValue == "photo"{
                                news.photo = response["items"].arrayValue[i]["attachments"].arrayValue[0]["photo"]["photo_604"].stringValue
                            }
                            
                            news.text = response["items"].arrayValue[i]["text"].stringValue
                            var id = news.ownerApiId
                            
                            var groups = response["groups"].array
                            var users = response["profiles"].array
                            
                            var chars = id?.characters.map { String($0) }
                            if chars?[0] == "-"{
                                id?.remove(at: (id?.startIndex)!)
                                let group = Group()
                                for j in 0...((groups?.count)! - 1){
                                    let number = groups![j]["id"].intValue as NSNumber!
                                    if id == number?.stringValue{
                                        group.id = groups![j]["id"].intValue
                                        group.name = groups![j]["name"].stringValue
                                        group.photo = groups![j]["photo_100"].stringValue
                                        news.group = group
                                    }
                                }
                            } else if chars?[0] != "-"{
                                let user = User()
                                for j in 0...((users?.count)! - 1){
                                    let number = users?[j]["id"].intValue as NSNumber!
                                    
                                    if id == number?.stringValue{
                                        user.id = users?[j]["id"].intValue
                                        user.first_name = users?[j]["first_name"].stringValue
                                        user.last_name = users?[j]["last_name"].stringValue
                                        user.photo = users?[j]["photo_100"].stringValue
                                        news.user = user
                                    }
                                }
                                
                            }
                            newsArray.append(news)
                        }
                    }
                    i += 1;
                }
                callback(newsArray)
        },
            onError: {error in print(" fail \n \(error)")}
        )
        }
    
    class func refresh(newsArray: [News], callback: @escaping ([News]) -> Void){
        var newsArr = newsArray
        
        VK.API.custom(method: "newsfeed.get").send(
            onSuccess:{ response in

                var i = 0
                let controlNews = newsArr[0]
                var finalCheck = true
                var check = false
                while check != true{
                    
                    let news = News()
                    if response["items"].arrayValue[i]["attachments"] != nil{
                        if controlNews.id != response["items"].arrayValue[i]["post_id"].intValue{
                            var k = 0
                            var count = response["items"].arrayValue[i]["attachments"].count
                            while count != 0{
                                if response["items"].arrayValue[i]["attachments"].arrayValue[k]["type"].stringValue != "photo"{
                                    finalCheck = false
                                }
                                k += 1
                                count -= 1
                            }
                            if finalCheck == true{
                                news.id = response["items"].arrayValue[i]["post_id"].intValue
                                news.date = response["items"].arrayValue[i]["date"].doubleValue
                                news.ownerApiId = response["items"].arrayValue[i]["source_id"].stringValue
                                
                                if response["items"].arrayValue[i]["attachments"].arrayValue[0]["type"].stringValue == "photo"{
                                    news.photo = response["items"].arrayValue[i]["attachments"].arrayValue[0]["photo"]["photo_604"].stringValue
                                }
                                
                                news.text = response["items"].arrayValue[i]["text"].stringValue
                                
                                var id = news.ownerApiId
                                
                                var groups = response["groups"].array
                                var users = response["profiles"].array
                                
                                var chars = id?.characters.map { String($0) }
                                if chars?[0] == "-"{
                                    id?.remove(at: (id?.startIndex)!)
                                    let group = Group()
                                    for j in 0...((groups?.count)! - 1){
                                        let number = groups![j]["id"].intValue as NSNumber!
                                        if id == number?.stringValue{
                                            group.id = groups![j]["id"].intValue
                                            group.name = groups![j]["name"].stringValue
                                            group.photo = groups![j]["photo_100"].stringValue
                                            news.group = group
                                        }
                                    }
                                } else if chars?[0] != "-"{
                                    let user = User()
                                    for j in 0...((users?.count)! - 1){
                                        let number = users?[j]["id"].intValue as NSNumber!
                                        
                                        if id == number?.stringValue{
                                            user.id = users?[j]["id"].intValue
                                            user.first_name = users?[j]["first_name"].stringValue
                                            user.last_name = users?[j]["last_name"].stringValue
                                            user.photo = users?[j]["photo_100"].stringValue
                                            news.user = user
                                        }
                                    }
                                    
                                }
                                print(news.text)
                                newsArr.insert(news, at: 0)
                            }
                        } else {
                            check = true
                        }
                    }
                    i += 1;
                }
                callback(newsArr)
        },
            onError: {error in print(" fail \n \(error)")}
        )
    }
    
    
    class func captcha() {
        VK.API.custom(method: "captcha.force").send(
            onSuccess: {response in print("SwiftyVK: captcha.force success \n \(response)")},
            onError: {error in print("SwiftyVK: captcha.force fail \n \(error)")}
        )
    }
    
    
    
    class func validation() {
        VK.API.custom(method: "account.testValidation").send(
            onSuccess: {response in print("SwiftyVK: account.testValidation success \n \(response)")},
            onError: {error in print("SwiftyVK: account.testValidation fail \n \(error)")}
        )
    }
    
    
    
    class func usersGet() {
        VK.API.Users.get([VK.Arg.userId : "1"]).send(
            onSuccess: {response in print("SwiftyVK: users.get success \n \(response)")},
            onError: {error in print("SwiftyVK: users.get fail \n \(error)")}
        )
    }
    
    
    
    class func friendsGet() {
        VK.API.Friends.get([.count : "1", .fields : "city,domain"]).send(
            onSuccess: {response in print("SwiftyVK: friends.get success \n \(response)")},
            onError: {error in print("SwiftyVK: friends.get fail \n \(error)")}
        )
    }
    
    
    
    class func uploadPhoto() {
        let data = try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "testImage", ofType: "jpg")!))
        let media = Media(imageData: data, type: .JPG)
        VK.API.Upload.Photo.toWall.toUser(media, userId: "4680178").send(
            onSuccess: {response in print("SwiftyVK: friendsGet success \n \(response)")},
            onError: {error in print("SwiftyVK: friendsGet fail \n \(error)")},
            onProgress: {done, total in print("send \(done) of \(total)")}
        )
    }
}
