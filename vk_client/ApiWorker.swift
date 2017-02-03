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
                    var news = News()
                    if response["items"].arrayValue[i]["attachments"] != nil{
                        news = JSONParser.parseNews(items: response["items"].arrayValue[i], users: response["profiles"], groups: response["groups"])
                        if news.id != nil{
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
        let controlNews = newsArray[0]
        
        VK.API.custom(method: "newsfeed.get").send(
            onSuccess:{ response in
                var i = 0
                
                var check = false
                while check != true{
                    if controlNews.id != response["items"].arrayValue[i]["post_id"].intValue{
                        print(controlNews.id)
                        print(response["items"].arrayValue[i]["post_id"].intValue)
                        var news = News()
                        if response["items"].arrayValue[i]["attachments"] != nil{
                            news = JSONParser.parseNews(items: response["items"].arrayValue[i], users: response["profiles"],    groups: response["groups"])
                            if news.id != nil{
                                newsArr.insert(news, at: 0)
                            }
                        }
                        print(newsArr.count)
                    } else {
                        check = true
                    }
                    i += 1;
                }
                callback(newsArr)
        },
            onError: {error in print(" fail \n \(error)")}
        )
    }
    
    class func getOlderNews(newsArray: [News], callback: @escaping ([News]) -> Void){
        var newsArr = newsArray
        
        var timeInterval = NSDate().timeIntervalSince1970
        timeInterval -= 7200
        
        VK.API.custom(method: "newsfeed.get", parameters: [VK.Arg.endTime : "\(timeInterval)"]).send(
            onSuccess: { response in
                var i = response["items"].count - 1
                let controlNews = newsArray[newsArray.count - 1]
                var check = true
                while check == true{
                    if controlNews.id != response["items"].arrayValue[i]["post_id"].intValue{
                        print("\(controlNews.id) id of control news")
                        print("\(response["items"].arrayValue[i]["post_id"].intValue) id of the next element")
                        var news = News()
                        if response["items"].arrayValue[i]["attachments"] != nil{
                            news = JSONParser.parseNews(items: response["items"].arrayValue[i], users: response["profiles"], groups: response["groups"])
                            if news.id != nil{
                                newsArr.append(news)
                            }
                            print("\(newsArr.count) count of final array")
                        }
                    } else {
                        check = false
                    }
                    i -= 1;
                    if i == 0 {
                        check = false
                    }
                }
                callback(newsArr)
        },
            onError: { error in print("fail \n \(error)")}
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
