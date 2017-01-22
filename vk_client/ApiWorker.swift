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
        VK.logOut()
        print("SwiftyVK: LogOut")
        VK.logIn()
        print("SwiftyVK: authorize")
    }
    
    
    
    class func logout() {
        VK.logOut()
        print("SwiftyVK: LogOut")
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
